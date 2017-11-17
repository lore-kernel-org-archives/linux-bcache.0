From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] bio: ensure __bio_clone_fast copies bi_partno
Date: Fri, 17 Nov 2017 19:34:25 +0800
Message-ID: <20171117113424.GA10693@ming.t460p>
References: <20171117074725.22536-1-mlyle@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171117074725.22536-1-mlyle@lyle.org>
Sender: linux-block-owner@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On Thu, Nov 16, 2017 at 11:47:25PM -0800, Michael Lyle wrote:
> A new field was introduced in 74d46992e0d9dee7f1f376de0d56d31614c8a17a,
> bi_partno, instead of using bdev->bd_contains and encoding the partition
> information in the bi_bdev field.  __bio_clone_fast was changed to copy
> the disk information, but not the partition information.  At minimum,
> this regressed bcache and caused data corruption.
> 
> Signed-off-by: Michael Lyle <mlyle@lyle.org>
> Fixes: 74d46992e0d9dee7f1f376de0d56d31614c8a17a
> Reported-by: Pavel Goran <via-bcache@pvgoran.name>
> Reported-by: Campbell Steven <casteven@gmail.com>
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

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming
