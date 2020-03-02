From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
Date: Mon, 2 Mar 2020 13:27:48 +0100
Message-ID: <20200302122748.GH4380@dhcp22.suse.cz>
References: <20200302093450.48016-1-colyli@suse.de>
 <20200302093450.48016-2-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200302093450.48016-2-colyli@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: axboe@kernel.dk, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, hare@suse.de, mkoutny@suse.com, Oleg Nesterov <oleg@redhat.com>
List-Id: linux-bcache@vger.kernel.org

[Cc Oleg]

On Mon 02-03-20 17:34:49, Coly Li wrote:
> When cache device and cached device are registered simuteneously and
> register_cache() firstly acquires bch_register_lock. register_bdev()
> has to wait before register_cache() finished, it might be a very long
> time.
> 
> If the registration is from udev rules in system boot up time, and
> registration is not completed before udev timeout (default 180s), the
> registration process will be killed by udevd. Then the following calls
> to kthread_run() or kthread_create() will fail due to the pending
> signal (they are implemented this way at this moment).
> 
> For boot time, this is not good, because it means a cache device with
> huge cached data will always fail in boot time, just because it
> spends too much time to check its internal meta data (btree and dirty
> sectors).
> 
> The failure for cache device registration is solved by previous
> patches, but failure due to timeout also exists in cached device
> registration. As the above text explains, cached device registration
> may also be timeout if it is blocked by a timeout cache device
> registration process. Then in the following code path,
>     bioset_init() <= bcache_device_init() <= cached_dev_init() <=
>     register_bdev() <= register_bcache()
> bioset_init() will fail because internally kthread_create() will fail
> for pending signal in the following code path,
>     bioset_init() => alloc_workqueue() => init_rescuer() =>
>     kthread_create()
> 
> Maybe fix kthread_create() and kthread_run() is better method, but at
> this moment a fast workaroudn is to flush pending signals before
> calling bioset_init() in bcache_device_init().

I cannot really comment on the bcache part because I am not familiar
with the code. It is quite surprising to see an initialization taking
that long though.

Anyway

> This patch calls flush_signals() in bcache_device_init() if there is
> pending signal for current process. It avoids bcache registration
> failure in system boot up time due to bcache udev rule timeout.

this sounds like a wrong way to address the issue. Killing the udev
worker is a userspace policy and the kernel shouldn't simply ignore it.
Is there any problem to simply increase the timeout on the system which
uses a large bcache?

Btw. Oleg, I have noticed quite a lot of flush_signals usage in the
drivers land and I have really hard time to understand their purpose.
What is the actual valid usage of this function? Should we somehow
document it?

> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>  drivers/md/bcache/super.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 0c3c5419c52b..e8bbd4f171ca 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -850,6 +850,18 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
>  	if (idx < 0)
>  		return idx;
>  
> +	/*
> +	 * There is a timeout in udevd, if the bcache device is registering
> +	 * by udev rules, and not completed in time, the udevd may kill the
> +	 * registration process. In this condition, there will be pending
> +	 * signal here and cause bioset_init() failed for internally creating
> +	 * its kthread. Here the registration should ignore the timeout and
> +	 * continue, it is safe to ignore the pending signal and avoid to
> +	 * fail bcache registration in boot up time.
> +	 */
> +	if (signal_pending(current))
> +		flush_signals(current);
> +
>  	if (bioset_init(&d->bio_split, 4, offsetof(struct bbio, bio),
>  			BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
>  		goto err;
> -- 
> 2.16.4

-- 
Michal Hocko
SUSE Labs
