From: Coly Li <i@coly.li>
Subject: Re: [PATCH 03/19] bcache: do not subtract sectors_to_gc for bypassed
 IO
Date: Sun, 2 Jul 2017 01:26:15 +0800
Message-ID: <3ae4c22f-ecab-e55a-c59b-d2f95a4b6624@coly.li>
References: <20170629134510.GA32385@infradead.org>
 <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
 <1498855388-16990-3-git-send-email-bcache@lists.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:51684 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751389AbdGAR0a (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 1 Jul 2017 13:26:30 -0400
In-Reply-To: <1498855388-16990-3-git-send-email-bcache@lists.ewheeler.net>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: bcache@lists.ewheeler.net, linux-block@vger.kernel.org
Cc: linux-bcache@vger.kernel.org, hch@infradead.org, axboe@kernel.dk, Tang Junhui <tang.junhui@zte.com.cn>, stable@vger.kernel.org

On 2017/7/1 上午4:42, bcache@lists.ewheeler.net wrote:
> From: Tang Junhui <tang.junhui@zte.com.cn>
> 
> Since bypassed IOs use no bucket, so do not subtract sectors_to_gc to
> trigger gc thread.
> 
> Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
> Reviewed-by: Eric Wheeler <bcache@linux.ewheeler.net>
> Cc: stable@vger.kernel.org

Acked-by: Coly Li <colyli@suse.de>

Thanks.

> ---
>  drivers/md/bcache/request.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 958072a..4b413db 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -196,12 +196,12 @@ static void bch_data_insert_start(struct closure *cl)
>  	struct data_insert_op *op = container_of(cl, struct data_insert_op, cl);
>  	struct bio *bio = op->bio, *n;
>  
> -	if (atomic_sub_return(bio_sectors(bio), &op->c->sectors_to_gc) < 0)
> -		wake_up_gc(op->c);
> -
>  	if (op->bypass)
>  		return bch_data_invalidate(cl);
>  
> +	if (atomic_sub_return(bio_sectors(bio), &op->c->sectors_to_gc) < 0)
> +		wake_up_gc(op->c);
> +
>  	/*
>  	 * Journal writes are marked REQ_PREFLUSH; if the original write was a
>  	 * flush, it'll wait on the journal write.
> 


-- 
Coly Li
