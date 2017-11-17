From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bio: ensure __bio_clone_fast copies bi_partno
Date: Fri, 17 Nov 2017 19:04:23 +0800
Message-ID: <3eb93352-a565-97ec-7c08-0c08cb2020aa@suse.de>
References: <20171117074725.22536-1-mlyle@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59159 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751154AbdKQLEb (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 17 Nov 2017 06:04:31 -0500
In-Reply-To: <20171117074725.22536-1-mlyle@lyle.org>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org

On 17/11/2017 3:47 PM, Michael Lyle wrote:
> A new field was introduced in 74d46992e0d9dee7f1f376de0d56d31614c8a17a,
> bi_partno, instead of using bdev->bd_contains and encoding the partition
> information in the bi_bdev field.  __bio_clone_fast was changed to copy
> the disk information, but not the partition information.  At minimum,
> this regressed bcache and caused data corruption.
> 

Hi Michael,

Thanks for the fix, it looks good to me.

> Signed-off-by: Michael Lyle <mlyle@lyle.org>
> Fixes: 74d46992e0d9dee7f1f376de0d56d31614c8a17a
> Reported-by: Pavel Goran <via-bcache@pvgoran.name>
> Reported-by: Campbell Steven <casteven@gmail.com>

Reviewed-by: Coly Li <colyli@suse.de>

Coly Li

> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: <stable@vger.kernel.org>
> ---
>  block/bio.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 101c2a9b5481..33fa6b4af312 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -597,6 +597,7 @@ void __bio_clone_fast(struct bio *bio, struct bio *bio_src)
>  	 * so we don't set nor calculate new physical/hw segment counts here
>  	 */
>  	bio->bi_disk = bio_src->bi_disk;
> +	bio->bi_partno = bio_src->bi_partno;
>  	bio_set_flag(bio, BIO_CLONED);
>  	bio->bi_opf = bio_src->bi_opf;
>  	bio->bi_write_hint = bio_src->bi_write_hint;
> 
