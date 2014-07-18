From: Slava Pestov <sp@datera.io>
Subject: Re: [PATCH] bcache: block shutdown if cached_dev detaching still ongoing
Date: Fri, 18 Jul 2014 00:21:15 -0700
Message-ID: <CACHGV4L7CowQW3uwNeea-99hqoDVyBt61dfgf1xoeAc8M5ysGw@mail.gmail.com>
References: <1405267739-5063-1-git-send-email-samuel.huo@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-oa0-f54.google.com ([209.85.219.54]:52775 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932477AbaGRH3O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 18 Jul 2014 03:29:14 -0400
Received: by mail-oa0-f54.google.com with SMTP id n16so2554607oag.27
        for <linux-bcache@vger.kernel.org>; Fri, 18 Jul 2014 00:29:12 -0700 (PDT)
In-Reply-To: <1405267739-5063-1-git-send-email-samuel.huo@gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jianjian Huo <samuel.huo@gmail.com>
Cc: linux-bcache@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>

It seems like it would be simpler to eliminate the timeout altogether
and fix any cases where the shutdown path hangs. I'd like Kent to
chime in on this one.

On Sun, Jul 13, 2014 at 9:08 AM, Jianjian Huo <samuel.huo@gmail.com> wrote:
> Backing device detaching will write back dirty data and update super block when it's finished, but won't set any flag to superblock after detaching starts. If system shuts down before detaching finishs, later cache set would never know detaching ever started before; what's worse, if users think detaching is done after shutdown and remove SSD which still contains dirty data, user would have a difficult time to bring up backing device again.
>
> This patch will block bcache_reboot, if any cached_dev is still detaching, to guarantee detaching is done before shutdown. Another way will be adding a flag to superblock, then next bootup will continue unfinished detaching, but this won't solve the above worse case scenario.
>
> This patch has been verified ay my setup for several test cases. And below is the new screen printout during shutdown, in case writeback is still ongoing.
>
> bcache: bcache_reboot() Stopping all devices:
> bcache: bcache_reboot() Backing device detaching hasn't been finished yet, please wait.
> bcache: cached_dev_detach_finish() Caching disabled for loop1
> bcache: cache_set_free() Cache set 69f2e475-3afc-42bf-b94d-8beb40030f59 unregistered
> bcache: bcache_reboot() Timeout waiting for devices to be closed
> reboot: System halted
>
> Signed-off-by: Jianjian Huo <samuel.huo@gmail.com>
> ---
>  drivers/md/bcache/super.c |   29 +++++++++++++++++++++++++++--
>  1 file changed, 27 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 5a78df8..92dcbfd 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1981,6 +1981,22 @@ err:
>         goto out;
>  }
>
> +static bool should_block_reboot(void)
> +{
> +       struct cache_set *c, *tc;
> +       struct cached_dev *dc, *t;
> +
> +       lockdep_assert_held(&bch_register_lock);
> +
> +       /*block reboot if any cached_dev is detaching*/
> +       list_for_each_entry_safe(c, tc, &bch_cache_sets, list)
> +               list_for_each_entry_safe(dc, t, &c->cached_devs, list)
> +                       if (test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags))
> +                               return true;
> +
> +       return false;
> +}
> +
>  static int bcache_reboot(struct notifier_block *n, unsigned long code, void *x)
>  {
>         if (code == SYS_DOWN ||
> @@ -2010,18 +2026,27 @@ static int bcache_reboot(struct notifier_block *n, unsigned long code, void *x)
>                 /* What's a condition variable? */
>                 while (1) {
>                         long timeout = start + 2 * HZ - jiffies;
> +                       bool blocking =  false;
>
>                         stopped = list_empty(&bch_cache_sets) &&
>                                 list_empty(&uncached_devices);
>
> -                       if (timeout < 0 || stopped)
> +                       blocking = should_block_reboot();
> +
> +                       if ((timeout < 0 && !blocking) || stopped)
>                                 break;
>
>                         prepare_to_wait(&unregister_wait, &wait,
>                                         TASK_UNINTERRUPTIBLE);
>
>                         mutex_unlock(&bch_register_lock);
> -                       schedule_timeout(timeout);
> +                       if (blocking) {
> +                               pr_notice("Backing device detaching hasn't "
> +                                       "been finished yet, please wait.");
> +                               schedule();
> +                       } else {
> +                               schedule_timeout(timeout);
> +                       }
>                         mutex_lock(&bch_register_lock);
>                 }
>
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
