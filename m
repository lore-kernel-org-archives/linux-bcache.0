From: Coly Li <i@coly.li>
Subject: Re: [PATCH] bcache: stop writeback thread after detaching
Date: Wed, 1 Nov 2017 19:55:18 +0800
Message-ID: <32ba916e-a7d4-b4c0-ea75-844bb34a3d86@coly.li>
References: <1509437651-24052-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:58330 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754608AbdKALz3 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 1 Nov 2017 07:55:29 -0400
In-Reply-To: <1509437651-24052-1-git-send-email-tang.junhui@zte.com.cn>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: colyli@suse.de, mlyle@lyle.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

On 2017/10/31 下午4:14, tang.junhui@zte.com.cn wrote:
> From: Tang Junhui <tang.junhui@zte.com.cn>
> 
> Currently, when a cached device detaching from cache, writeback thread is not stopped,
> and writeback_rate_update work is not canceled. For example, after bellow command:
> echo 1 >/sys/block/sdb/bcache/detach
> you can still see the writeback thread. Then you attach the device to the cache again,
> bcache will create another writeback thread, for example, after bellow command:
> echo  ba0fb5cd-658a-4533-9806-6ce166d883b9 > /sys/block/sdb/bcache/attach
> then you will see 2 writeback threads.
> This patch stops writeback thread and cancels writeback_rate_update work when cached
> device detaching from cache.
> 
> Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>

If the change can be inside bch_register_lock, it would (just) be more
comfortable. The code is correct, because attach/detach sysfs is created
after writeback_thread created and writeback_rate_update worker
initialized, even these resources are initialized within
bch_register_lock and released out of bch)register_lock in your patch,
there won't be any race. It's OK to me.

Reviewed-by: Coly Li <colyli@suse.de>

Thanks.

Coly Li

> ---
>  drivers/md/bcache/super.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>  mode change 100644 => 100755 drivers/md/bcache/super.c
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> old mode 100644
> new mode 100755
> index 8352fad..bf79892
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -891,6 +891,12 @@ static void cached_dev_detach_finish(struct work_struct *w)
>  	BUG_ON(!test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags));
>  	BUG_ON(atomic_read(&dc->count));
>  
> +	cancel_delayed_work_sync(&dc->writeback_rate_update);
> +	if (!IS_ERR_OR_NULL(dc->writeback_thread)) {
> +		kthread_stop(dc->writeback_thread);
> +		dc->writeback_thread = NULL;
> +	}
> +
>  	mutex_lock(&bch_register_lock);
>  
>  	memset(&dc->sb.set_uuid, 0, 16);
> 
