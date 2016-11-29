From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [PATCH 1/2] bcache: Remove redundant set_capacity
Date: Tue, 29 Nov 2016 12:49:16 -0800 (PST)
Message-ID: <alpine.LRH.2.11.1611291246140.1914@mail.ewheeler.net>
References: <1480037969-45042-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:36048 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755402AbcK2UtW (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 29 Nov 2016 15:49:22 -0500
In-Reply-To: <1480037969-45042-1-git-send-email-wangyijing@huawei.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Yijing Wang <wangyijing@huawei.com>
Cc: axboe@fb.com, kent.overstreet@gmail.com, git@linux.ewheeler.net, colyli@suse.de, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 25 Nov 2016, Yijing Wang wrote:

> set_capacity() has been called in bcache_device_init(),
> remove the redundant one.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> ---
>  drivers/md/bcache/super.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 849ad44..b638a16 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1126,9 +1126,6 @@ static int cached_dev_init(struct cached_dev *dc, unsigned block_size)
>  	if (ret)
>  		return ret;
>  
> -	set_capacity(dc->disk.disk,
> -		     dc->bdev->bd_part->nr_sects - dc->sb.data_offset);
> -

It probably is a duplicate set_capacity, but has anyone tested bringing on 
a writeback volume, and late-attaching the cache volume with this patch 
applied?

Otherwise stated, is it possible to get the backing device attached 
without setting the capacity?

-Eric

>  	dc->disk.disk->queue->backing_dev_info.ra_pages =
>  		max(dc->disk.disk->queue->backing_dev_info.ra_pages,
>  		    q->backing_dev_info.ra_pages);
> -- 
> 2.5.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
