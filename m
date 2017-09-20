From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCHv2] bcache: option for allow stale data on read failure
Date: Tue, 19 Sep 2017 23:59:57 -0700
Message-ID: <CAJ+L6qeLMsCAVsdNkertg2BzwVHcq4ZZ==E8gojo9O2cutWrVQ@mail.gmail.com>
References: <20170919222433.24336-1-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170919222433.24336-1-colyli@suse.de>
Sender: stable-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Nix <nix@esperi.org.uk>, Kai Krakow <hurikhan77@gmail.com>, Eric Wheeler <bcache@lists.ewheeler.net>, Junhui Tang <tang.junhui@zte.com.cn>, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

Coly--

It's an interesting changeset.

I am not positive if it will work in practice-- the most likely
objects to be cached are filesystem metadata.  Won't most filesystems
fall apart if some of their data structures revert back to an earlier
point of time?

Mike

On Tue, Sep 19, 2017 at 3:24 PM, Coly Li <colyli@suse.de> wrote:
> When bcache does read I/Os, for example in writeback or writethrough mode,
> if a read request on cache device is failed, bcache will try to recovery
> the request by reading from cached device. If the data on cached device is
> not synced with cache device, then requester will get a stale data.
>
> For critical storage system like database, providing stale data from
> recovery may result an application level data corruption, which is
> unacceptible. But for some other situation like multi-media stream cache,
> continuous service may be more important and it is acceptible to fetch
> a chunk of stale data.
>
> This patch tries to solve the above conflict by adding a sysfs option
>         /sys/block/bcache<idx>/bcache/allow_stale_data_on_failure
> which is defaultly cleared (to 0) as disabled. Now people can make choices
> for different situations.
>
> With this patch, for a failed read request in writeback or writethrough
> mode, recovery a recoverable read request only happens in one of the
> following conditions,
>  - dc->has_dirty is zero. It means all data on cache device is synced to
>    cached device, the recoveried data is up-to-date.
>  - dc->has_dirty is non-zero, and dc->allow_stale_data_on_failure is set
>    to 1. It means there is dirty data not synced to cached device yet, but
>    option allow_stale_data_on_failure is set, receiving stale data is
>    explicitly acceptible for requester.
>
> For other cache modes in bcache, read request will never hit
> cached_dev_read_error(), they don't need this patch.
>
> Please note, because cache mode can be switched arbitrarily in run time, a
> writethrough mode might be switched from a writeback mode. Therefore
> checking dc->has_data in writethrough mode still makes sense.
>
> Changelog:
> v2: rename sysfs entry from allow_stale_data_on_failure  to
>     allow_stale_data_on_failure, and fix the confusing commit log.
> v1: initial patch posted.
>
> Signed-off-by: Coly Li <colyli@suse.de>
> Reported-by: Arne Wolf <awolf@lenovo.com>
> Cc: Nix <nix@esperi.org.uk>
> Cc: Kai Krakow <hurikhan77@gmail.com>
> Cc: Eric Wheeler <bcache@lists.ewheeler.net>
> Cc: Junhui Tang <tang.junhui@zte.com.cn>
> Cc: stable@vger.kernel.org
> ---
>  drivers/md/bcache/bcache.h  |  1 +
>  drivers/md/bcache/request.c | 14 +++++++++++++-
>  drivers/md/bcache/sysfs.c   |  4 ++++
>  3 files changed, 18 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index dee542fff68e..f26b174f409a 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -356,6 +356,7 @@ struct cached_dev {
>         unsigned                partial_stripes_expensive:1;
>         unsigned                writeback_metadata:1;
>         unsigned                writeback_running:1;
> +       unsigned                allow_stale_data_on_failure:1;
>         unsigned char           writeback_percent;
>         unsigned                writeback_delay;
>
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 019b3df9f1c6..becbc0959ca2 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -702,8 +702,20 @@ static void cached_dev_read_error(struct closure *cl)
>  {
>         struct search *s = container_of(cl, struct search, cl);
>         struct bio *bio = &s->bio.bio;
> +       struct cached_dev *dc = container_of(s->d, struct cached_dev, disk);
> +       int recovery_stale_data = dc ? dc->allow_stale_data_on_failure : 0;
>
> -       if (s->recoverable) {
> +       /*
> +        * If dc->has_dirty is non-zero and the recovering data is on cache
> +        * device, then recover from cached device will return a stale data
> +        * to requester. But in some cases people accept stale data to avoid
> +        * a -EIO. So I/O error recovery only happens when,
> +        * - No dirty data on cache device.
> +        * - Cached device is dirty but sysfs allow_stale_data_on_failure is
> +        *   explicitly set (to 1) to accept stale data from recovery.
> +        */
> +       if (s->recoverable &&
> +           (!atomic_read(&dc->has_dirty) || recovery_stale_data)) {
>                 /* Retry from the backing device: */
>                 trace_bcache_read_retry(s->orig_bio);
>
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index f90f13616980..8603756005a8 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -106,6 +106,7 @@ rw_attribute(cache_replacement_policy);
>  rw_attribute(btree_shrinker_disabled);
>  rw_attribute(copy_gc_enabled);
>  rw_attribute(size);
> +rw_attribute(allow_stale_data_on_failure);
>
>  SHOW(__bch_cached_dev)
>  {
> @@ -125,6 +126,7 @@ SHOW(__bch_cached_dev)
>         var_printf(bypass_torture_test, "%i");
>         var_printf(writeback_metadata,  "%i");
>         var_printf(writeback_running,   "%i");
> +       var_printf(allow_stale_data_on_failure,"%i");
>         var_print(writeback_delay);
>         var_print(writeback_percent);
>         sysfs_hprint(writeback_rate,    dc->writeback_rate.rate << 9);
> @@ -201,6 +203,7 @@ STORE(__cached_dev)
>  #define d_strtoi_h(var)                sysfs_hatoi(var, dc->var)
>
>         sysfs_strtoul(data_csum,        dc->disk.data_csum);
> +       d_strtoul(allow_stale_data_on_failure);
>         d_strtoul(verify);
>         d_strtoul(bypass_torture_test);
>         d_strtoul(writeback_metadata);
> @@ -335,6 +338,7 @@ static struct attribute *bch_cached_dev_files[] = {
>         &sysfs_verify,
>         &sysfs_bypass_torture_test,
>  #endif
> +       &sysfs_allow_stale_data_on_failure,
>         NULL
>  };
>  KTYPE(bch_cached_dev);
> --
> 2.13.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
