Received: from lf-2-36.ptr.blmpb.com (lf-2-36.ptr.blmpb.com [101.36.218.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E47713C918
	for <linux-bcache@vger.kernel.org>; Thu,  5 Mar 2026 14:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.36.218.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772721194; cv=none; b=tiVNJRm1/6CKb3mT9SLE1r4CkXKwA6cH5/Xys5J90C75QRxuFPyd1mdIuiSV0YIh0QEZhYJW/yvCpsxLq4hEPq8el/OIyzo+7OlZRJLgN4a9Jl1KGdxslTzK/n0yg25tfLFL8V3HkRbNjEVPxxGne+Q0DaOMX1A3rrBDsGgzBiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772721194; c=relaxed/simple;
	bh=95qaNlQMJOP4pN9jLzHKErKpVpxXUhS6M/jbWeKMUN4=;
	h=Message-Id:Content-Type:References:Subject:Date:
	 Content-Disposition:To:Cc:From:Mime-Version:In-Reply-To; b=ktQToz2MnCkZ+U2Qz+X0Kngintf0IVPigQk53mPAnRHzBCZ+y5QqsdfE+jTIqIwHTeC5SRb4WP35Thlmkdif6TwUkyhkPnzoqhbreN5aOFWxnitgz5p840x+3TraJdkirSaYcFcfELmb0K1trGFp80wfn6syEwKl1C57wdmZiF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=AAxZ2sSH; arc=none smtp.client-ip=101.36.218.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="AAxZ2sSH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1772721137;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=fd+yf1MWzvARKFw8KBfrfEqR9xVpjfuoaal13vgTb08=;
 b=AAxZ2sSHWBbHI7bgo9b94IGyL9gbbFmnG2NRpr2rPRJHORW19c5D9fIVDKQmGT+SjHgHkT
 w9rTBRmAS7+aci8rWfM7wYOKLGRQnzJMIbXjN+AEn3+iu+I8HP9VaOkhlBNy7Miepdvy7t
 UiAagZ3L9669d9b9HdLl1d1kt7+OIufueeiBMmVyqxYcOF+mkzjmceodm2A5nCl4vYTDYe
 7qxP0ynSnam8VDnptEWPT0qLpJKADLMTFSAzRSAWnag2HxtiNXwEtRZAXpHePZpqV95Tky
 JhYfI8ghcEjCDB0EnM4Ax0kFdpMCCpE3TAh5Jm2IXeFDMhOo+zyImudtdQaCYA==
Message-Id: <aamTA2F84tiDbmF3@studio.local>
Content-Type: text/plain; charset=UTF-8
References: <20260304190424.291743-1-agruenba@redhat.com> <20260304190424.291743-5-agruenba@redhat.com>
Received: from studio.local ([120.245.64.174]) by smtp.feishu.cn with ESMTPS; Thu, 05 Mar 2026 22:32:14 +0800
X-Lms-Return-Path: <lba+269a993ef+73a982+vger.kernel.org+colyli@fnnas.com>
Subject: Re: [PATCH 4/4] bio: use bio_io_error more often
Date: Thu, 5 Mar 2026 22:32:13 +0800
Content-Disposition: inline
To: "Andreas Gruenbacher" <agruenba@redhat.com>
Cc: "Jens Axboe" <axboe@kernel.dk>, <linux-block@vger.kernel.org>, 
	<drbd-dev@lists.linbit.com>, <linux-bcache@vger.kernel.org>, 
	<dm-devel@lists.linux.dev>, <linux-f2fs-devel@lists.sourceforge.net>, 
	<linux-kernel@vger.kernel.org>, "Christoph Hellwig" <hch@lst.de>
From: "Coly Li" <colyli@fnnas.com>
X-Original-From: Coly Li <colyli@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <20260304190424.291743-5-agruenba@redhat.com>
Content-Transfer-Encoding: 7bit

On Wed, Mar 04, 2026 at 08:04:09PM +0800, Andreas Gruenbacher wrote:
> Instead of setting bio->bi_status to BLK_STS_IOERR and calling
> bio_endio(bio), use the shorthand bio_io_error(bio).
> 
> Created with Coccinelle using the following semantic patch:
> 
> @@
> struct bio *bio;
> @@
> - bio->bi_status = BLK_STS_IOERR;
> - bio_endio(bio);
> + bio_io_error(bio);
> 
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/fops.c                  | 3 +--
>  drivers/block/drbd/drbd_int.h | 3 +--
>  drivers/md/bcache/bcache.h    | 3 +--
>  drivers/md/bcache/request.c   | 6 ++----
>  drivers/md/dm-mpath.c         | 3 +--
>  drivers/md/dm-writecache.c    | 3 +--
>  fs/f2fs/segment.c             | 3 +--
>  7 files changed, 8 insertions(+), 16 deletions(-)
> 

[snipped]

>  
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index ec9ff9715081..e0c9d9eef0a0 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -947,8 +947,7 @@ static inline void closure_bio_submit(struct cache_set *c,
>  {
>  	closure_get(cl);
>  	if (unlikely(test_bit(CACHE_SET_IO_DISABLE, &c->flags))) {
> -		bio->bi_status = BLK_STS_IOERR;
> -		bio_endio(bio);
> +		bio_io_error(bio);
>  		return;
>  	}
>  	submit_bio_noacct(bio);
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 3fa3b13a410f..0f6fa0a2920b 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -1178,8 +1178,7 @@ void cached_dev_submit_bio(struct bio *bio)
>  
>  	if (unlikely((d->c && test_bit(CACHE_SET_IO_DISABLE, &d->c->flags)) ||
>  		     dc->io_disable)) {
> -		bio->bi_status = BLK_STS_IOERR;
> -		bio_endio(bio);
> +		bio_io_error(bio);
>  		return;
>  	}
>  
> @@ -1283,8 +1282,7 @@ void flash_dev_submit_bio(struct bio *bio)
>  	struct bcache_device *d = bio->bi_bdev->bd_disk->private_data;
>  
>  	if (unlikely(d->c && test_bit(CACHE_SET_IO_DISABLE, &d->c->flags))) {
> -		bio->bi_status = BLK_STS_IOERR;
> -		bio_endio(bio);
> +		bio_io_error(bio);
>  		return;
>  	}
>  

For bcache part, I feel current hard code is explict and clear.
The bio_io_error() wrapper is not so directly understood. This is just
my opinion, not a strong objection. 

Thanks.

Coly Li


[snipped]
