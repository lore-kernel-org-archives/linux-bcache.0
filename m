Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A79670810;
	Mon, 26 Jan 2026 12:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769431987; cv=none; b=plz1emQF2xoN7QK+0i6LpIDDdkYHjx8q0c4CtoI/OMSgtt0YvRzYTUBG8SK4TRZ9y0/aGg0AHXK1Udip/u9UmiGvyxuDFBR9Q39cfGoa+sUa3x2In0suQMZIa6lhmSUaa5MORkQAJXaeXxLXTiMmqiC4e4+GCnFJ139WnRHjcpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769431987; c=relaxed/simple;
	bh=IOzIk2rOffx+y4DUltKqEd/ofFYQj8G5NoYcdYRYseA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KsUDWYrGx+BUm+u7WlnjtxyrjS2114pbx9GrISSWBBuiWl5VVaqJWUwC1NtjmdP7bMmG4/35mVDesQBhjetCHnrIHgLUQ1w0SQdqGjNg3rmr3AVGsqQpgTEfX8vXsVo09xX0VUmmmIHSlbAyijQZkio5L8KDeyKf/4Rneh97wpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xnqWI5jn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xnqWI5jn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=ZJ3bUYh4udtYf9T5Bo308lpgjrJHwupmNJg7K4G7D2Y=; b=xnqWI5jnOCNTyupiS1kk6IWBEk
	ikqJFWxokvTe+UO1Or4FnXOzwTdZr652i22vAHBBYo/eaY9nCOBnEqq+6GCzOkrs4Ab1oxIMqiziq
	wel/UngkKEZJGgwhj6jZxGyDquto+prrcKhoeb9R9yqw3kaIN3fk8VTNFuGWT+rQqKrICmDgXB91P
	fU6sDcCIDPgrtnZnDfWe6Xcp65KEh1aFVMmK1Kpt+lnA2u2lrFkOO9Ox4MvBCbJz6So9nEf/28azw
	wf1oG+YxEgwAuLIlD58BWf6qMUYOEM1mWgl0kgJpV0YiWYejR3nYC099Ropk1mol+OIfBPcDG30kU
	pyWHANmQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vkM5S-0000000CZwP-1cLy;
	Mon, 26 Jan 2026 12:52:58 +0000
Date: Mon, 26 Jan 2026 04:52:58 -0800
From: Christoph Hellwig <hch@infradead.org>
To: zhangshida2026@163.com
Cc: colyli@fnnas.com, kent.overstreet@linux.dev, hch@infradead.org,
	axboe@kernel.dk, osandov@fb.com, bvanassche@acm.org,
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn, starzhangzsd@gmail.com
Subject: Re: [PATCH v2] bcache: fix I/O accounting leak in
 detached_dev_do_request
Message-ID: <aXdjqueZ8d8Se61A@infradead.org>
References: <20260126092854.971870-1-zhangshida2026@163.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260126092854.971870-1-zhangshida2026@163.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jan 26, 2026 at 05:28:54PM +0800, zhangshida2026@163.com wrote:
> From: Shida Zhang <zhangshida@kylinos.cn>
> 
> When a bcache device is in a detached state, iostat can show 100%
> utilization even after I/O workload completion.
> 
> This happens because the caller, cached_dev_make_request(), calls
> bio_start_io_acct() to begin accounting. However, if the bio hits an
> early exit path in detached_dev_do_request()—either due to an
> unsupported discard request or a bio_alloc_clone() failure—the
> corresponding bio_end_io_acct() is never called. This leaves the
> in-flight counter permanently incremented, causing the kernel to
> report the device as 100% busy.
> 
> Add the missing bio_end_io_acct() calls to these error/early-exit
> paths to ensure proper I/O accounting.
> 
> Fixes: d62e26b3ffd28 ("block: pass in queue to inflight accounting")

I don't think that is correct.  This was just a trivial calling
convention change.

From doing a quick git-blame chain this looks like the culprit:

bc082a55d25c837341709accaf11311c3a9af727
Author: Tang Junhui <tang.junhui@zte.com.cn>
Date:   Sun Mar 18 17:36:19 2018 -0700

    bcache: fix inaccurate io state for detached bcache devices


> +		bio_end_io_acct(orig_bio, start_time);
>  		bio_endio(orig_bio);
>  		return;
>  	}
> @@ -1114,6 +1115,7 @@ static void detached_dev_do_request(struct bcache_device *d,
>  	clone_bio = bio_alloc_clone(dc->bdev, orig_bio, GFP_NOIO,
>  				    &d->bio_detached);
>  	if (!clone_bio) {
> +		bio_end_io_acct(orig_bio, start_time);
>  		orig_bio->bi_status = BLK_STS_RESOURCE;
>  		bio_endio(orig_bio);
>  		return;

This is begging to use a goto label to share code, if it weren't for the
fact that bio_alloc_clone with GFP_NOIO will never return NULL because
both because the bio itself and the crypt or integrity information are
backed by mempool.

So this second copy of the code is actually dead and should be removed
in a prep patch before this one.  Sorry for not catching this earlier.
