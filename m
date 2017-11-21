From: Pavel Goran <via-bcache@pvgoran.name>
Subject: Re: [PATCH] bio: ensure __bio_clone_fast copies bi_partno
Date: Tue, 21 Nov 2017 22:38:15 +0700
Message-ID: <868491970.20171121223815@pvgoran.name>
References: <20171117074725.22536-1-mlyle@lyle.org>
Reply-To: Pavel Goran <via-bcache@pvgoran.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from vostok.pvgoran.name ([71.19.149.48]:42233 "EHLO
        vostok.pvgoran.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751228AbdKUPiU (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 21 Nov 2017 10:38:20 -0500
In-Reply-To: <20171117074725.22536-1-mlyle@lyle.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: linux-bcache@vger.kernel.org

Hello Michael,

Friday, November 17, 2017, 2:47:25 PM, you wrote:

> A new field was introduced in 74d46992e0d9dee7f1f376de0d56d31614c8a17a,
> bi_partno, instead of using bdev->bd_contains and encoding the partition
> information in the bi_bdev field.  __bio_clone_fast was changed to copy
> the disk information, but not the partition information.  At minimum,
> this regressed bcache and caused data corruption.

Thanks for the patch. It resolved the issue for me, I'm now running 4.14
without apparent problems.

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

> diff --git a/block/bio.c b/block/bio.c
> index 101c2a9b5481..33fa6b4af312 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -597,6 +597,7 @@ void __bio_clone_fast(struct bio *bio, struct bio *bio_src)
>          * so we don't set nor calculate new physical/hw segment counts here
>          */
>         bio->bi_disk = bio_src->bi_disk;
+       bio->>bi_partno = bio_src->bi_partno;
>         bio_set_flag(bio, BIO_CLONED);
>         bio->bi_opf = bio_src->bi_opf;
>         bio->bi_write_hint = bio_src->bi_write_hint;

Pavel Goran
  
