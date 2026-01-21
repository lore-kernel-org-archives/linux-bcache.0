Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9519AD24
	for <linux-bcache@vger.kernel.org>; Wed, 21 Jan 2026 22:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769035738; cv=none; b=vFtVENRqtT+cGrIaQe7lY/68cSC78EplGuGhIbid7vPghLX/c/GbXHcsy/ha5y42VBkjlMG/qGmMa4PcRR69S4ahunnd8G6E2BxdBU85h5PkDEdCR6JB8DIS7JhhAXkR6QAcSV8wmBmjDpiYNeT1nR8l8txHT5wPgeVNaZG3kXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769035738; c=relaxed/simple;
	bh=SSjXbL4+oo4vp83rOFLq/qYMP2X6VWR5fHPw9EFiTnE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n2XohNbMVmSXBhTaSGjh+qpCkypwL0+GQLdDTn4MBv+vEBVNDpXdEF+BpC7eAm1yejDgV5Yd2HzjzYi9tWxV3QEKDy5v9adqruGNCPHsaagNSo3w9nexoLCDUhRR3b2mMn6JgQO94uHAD3HCGyXg3MuN7ePSapN1WcxybsquizM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CSF2HI9a; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CSF2HI9a"
Date: Wed, 21 Jan 2026 17:48:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769035733;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Huaz6R3y/VFsdmhHaP0WAc62IdMmZubIUEYw5/WDZg=;
	b=CSF2HI9adF0qPZKAFpmrZEiaTnVIiY+OCrRGNnZx1dVO8S+J9FExWG6wWZ01GKss8Fz7yi
	f1+oKTY2hpOmgnHD2+6TCi4l1FrZKZcHLWZ42ZPxBcQxlVthA89LMaqgQLkef77CkkbNQY
	Qorii4h3NLN53FkAO9RIx6jgYDmu54E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Coly Li <colyli@fnnas.com>
Cc: Jens Axboe <axboe@kernel.dk>, Stephen Zhang <starzhangzsd@gmail.com>, 
	Sasha Levin <sashal@kernel.org>, Christoph Hellwig <hch@infradead.org>, 
	linux-bcache@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	zhangshida <zhangshida@kylinos.cn>
Subject: Re: Fwd: [PATCH v2] bcache: use bio cloning for detached device
 requests
Message-ID: <aXFW-HM9S8zjKDWy@moria.home.lan>
References: <20260120023535.9109-1-zhangshida@kylinos.cn>
 <CANubcdXsWsdueYf_aN9FSm+hnE-rpXx_hHhwP9_Z1ni1YGEH9Q@mail.gmail.com>
 <aW-DHlpo4dzKRB8K@studio.local>
 <322136ff-95f6-49f6-9126-05845f25b4e8@kernel.dk>
 <aXAoi9wTa7VWUiPj@studio.local>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aXAoi9wTa7VWUiPj@studio.local>
X-Migadu-Flow: FLOW_OUT

On Wed, Jan 21, 2026 at 09:34:01AM +0800, Coly Li wrote:
> On Tue, Jan 20, 2026 at 08:01:52AM +0800, Jens Axboe wrote:
> > On 1/20/26 7:46 AM, Coly Li wrote:
> > >> @@ -949,6 +950,11 @@ static int bcache_device_init(struct
> > >> bcache_device *d, unsigned int block_size,
> > >>                         BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
> > >>                 goto out_ida_remove;
> > >>
> > >> +       if (bioset_init(&d->bio_detach, 4,
> > > 					^^^^^-> I feel 4 might be a bit small
> > > here. bio_detached set is for normal IO when backing device is not
> > > attached to a cache device. I would suggest to set the pool size to
> > > 128 or 256.
> > 
> > Absolutely not, 4 is more than plenty. The pool elements are only ever
> > used if allocations fail, to guarantee forward progress. Setting aside
> > 128 or 256 for that case is utterly wasteful, you only need a couple. 4
> > is a good number, if anything it should be smaller (2).
> 
> Hi Jens,
> 
> Thanks for the information. Please correct me if I am wrong for the following
> text,
> - If the backing is a normal SSD raid0, the IOPS without attached cache device
> might be more than thousands. In this case, I assume 128 or 256 might be more
> tolerant.
> - I see what ‘4’ means, just not sure/comfortable when memory pressure is high.
> And reserving 128/256 will occupy around 0.5~1MB memory, I feel such extra
> memory is acceptable in bcache use case.
> 
> Don't get me wrong, I totally trust you. If '4' works well enough for high
> memory pressure condition for detached bcache device, it is cool.

I'd actually be in favor of raising it. mm isn't getting any better at
reclaim latency under load - I've been seeing regresisons in that area -
and considering that mm doesn't have its own reserves for allocations
critical for reclaim, code in reclaim paths probably should.

"How often it's used" on a well behaving system in a benchmark scenario
is not relevant, the relevant thing to look at would be allocation
latency in OOM scenarios.

time_stats that bcache/bcachefs have is quite useful here. We recently
saw btree node allocation buffers taking > 10 seconds to allocate, so
this is a real issue.

Memory for bios is a drop in the bucket compared to the btree node
cache, so the amount of memory is not something to overly sweat here.
