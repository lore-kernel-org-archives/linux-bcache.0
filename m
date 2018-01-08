From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v1 10/10] bcache: stop all attached bcache devices for a
 retired cache set
Date: Mon, 8 Jan 2018 08:31:43 +0100
Message-ID: <edd0cdd7-6ef9-9269-eaf2-1c8ec97840fc@suse.de>
References: <20180103140325.63175-1-colyli@suse.de>
 <20180103140325.63175-11-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38977 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755788AbeAHHbp (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 8 Jan 2018 02:31:45 -0500
In-Reply-To: <20180103140325.63175-11-colyli@suse.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, mlyle@lyle.org, tang.junhui@zte.com.cn

On 01/03/2018 03:03 PM, Coly Li wrote:
> When there are too many I/O errors on cache device, current bcache code
> will retire the whole cache set, and detach all bcache devices. But the
> detached bcache devices are not stopped, which is problematic when bcache
> is in writeback mode.
> 
> If the retired cache set has dirty data of backing devices, continue
> writing to bcache device will write to backing device directly. If the
> LBA of write request has a dirty version cached on cache device, next time
> when the cache device is re-registered and backing device re-attached to
> it again, the stale dirty data on cache device will be written to backing
> device, and overwrite latest directly written data. This situation causes
> a quite data corruption.
> 
> This patch checkes whether cache_set->io_disable is true in
> __cache_set_unregister(). If cache_set->io_disable is true, it means cache
> set is unregistering by too many I/O errors, then all attached bcache
> devices will be stopped as well. If cache_set->io_disable is not true, it
> means __cache_set_unregister() is triggered by writing 1 to sysfs file
> /sys/fs/bcache/<UUID>/bcache/stop. This is an exception because users do
> it explicitly, this patch keeps existing behavior and does not stop any
> bcache device.
> 
> Even the failed cache device has no dirty data, stopping bcache device is
> still a desired behavior by many Ceph and data base users. Then their
> application will report I/O errors due to disappeared bcache device, and
> operation people will know the cache device is broken or disconnected.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>  drivers/md/bcache/super.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 49d6fedf89c3..20a7a6959506 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1458,6 +1458,14 @@ static void __cache_set_unregister(struct closure *cl)
>  				dc = container_of(c->devices[i],
>  						  struct cached_dev, disk);
>  				bch_cached_dev_detach(dc);
> +				/*
> +				 * If we come here by too many I/O errors,
> +				 * bcache device should be stopped too, to
> +				 * keep data consistency on cache and
> +				 * backing devices.
> +				 */
> +				if (c->io_disable)
> +					bcache_device_stop(c->devices[i]);
>  			} else {
>  				bcache_device_stop(c->devices[i]);
>  			}
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
