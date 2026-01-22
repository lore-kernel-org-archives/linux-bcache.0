Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3806C47DD54;
	Thu, 22 Jan 2026 06:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769063719; cv=none; b=IfPuAeX1X9xSMUmEJ3VIeFxX9q5P95Mqf5MWJ1Jy+4ao0D9DKdRqmVRFJB5YR85RLFZ1/XRyWShWHZg6d9wRJ6bFvjeQWt2gl0oC0f21Y/w/64DCwGRZYIWTgW62qSbB4QQLaKIYKj5d63RZXzHNZ9beJmFHem7IjOVkIodvZQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769063719; c=relaxed/simple;
	bh=m44RS9SrVEt/LjiAtA8k63VhMzxooSB34IYfukX8u38=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eLtVZLjrz9iCatGkRrdHapeO+ZvqlkxVwvlbsTfPx3y+hOtWzUHaKQXJdI+lsy2gSYC3D2HlDWDcFJ1GtsL+I5aVJyzvYfkeCmYlz84mFkTFko4SkRmT++TJ8TnKCNU79y/HznIzJziC4sHnVnYcmeqJLfg+8Hswp/eWRrixdP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EwrjH8BY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EwrjH8BY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3Z0ujzZnmIraMpDI7QKGAzYss31OsHiX1K+hu/bMNvw=; b=EwrjH8BY/pnyq1UzQWnJ7rihyk
	PN527YeXNZCeo+94ya5JgA9k48otPPUKEKvrZ01UjCZBbA8dm1qZybnxPM412yNf7HbQ1TkrE+dcp
	3drwzvrkvXWGXATIjSrx/yy+j4bezPHZfKi5DJr8LoK7lblM0hzHXfq93gRMVM+fLATrMcvdIIu7L
	n6OkyQngwCZsiswV+//L4aRN1juSaByd/7b4S5bq8mtHl01RxPHpGMnQnyhfT61T8+IaQxy6uyT5Q
	pbytOq/N3F375rJ9mfeArgiu9fcEh0OjL8fJE0NVEPJESj6GFjIejYe9eguIp8JSum370eEgKtYmK
	bP7I36+w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vioHg-00000006VRU-29hg;
	Thu, 22 Jan 2026 06:35:12 +0000
Date: Wed, 21 Jan 2026 22:35:12 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Daniel Wagner <dwagner@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>,
	Stephen Zhang <starzhangzsd@gmail.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Coly Li <colyli@fnnas.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org
Subject: Re: [PATCH blktests] bcache: add bcache/001
Message-ID: <aXHFIM-8HrO-8cCO@infradead.org>
References: <20260120-bcache-v1-1-59bf0b2d4140@suse.de>
 <aXCGseCNoaX8rQ83@infradead.org>
 <512c18ed-feed-416d-9de6-c9183da98efc@flourine.local>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512c18ed-feed-416d-9de6-c9183da98efc@flourine.local>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jan 21, 2026 at 01:48:27PM +0100, Daniel Wagner wrote:
> Sure, I'll update the documentation.
> 
> On this note, It took me a while to understand that using
> TEST_DEVS="/dev/nvme0n1 /dev/vdb /dev/vdc" is not populating the
> TEST_DEV_ARRAY array.
> 
> Commit 653ace845911 ("check, new: introduce test_device_array()")
> explains why:
> 
>     As to the test target devices defined in TEST_DEVS variable, blktests
>     assumes that each test case with test_device() function is run for each
>     single device defined in TEST_DEVS. On the other hand, it is suggested
>     to support a test case for not a single device but multiple devices.
> 
> Maybe we could add a default config with all options listed and
> documented but commented out.

The default config would be useful for sure.

But I also thing the TEST_DEVS vs TEST_DEV_ARRAY thing is weird, and the
fact that you need to declare the array for multiple tests doesn't help.

IMHO having a TEST_DEV_ARRAY should imply that normal single device tests
pick the first one from it if not explicit TEST_DEVS is set, and tests
using multiple devices can grab as many as they support from it.  That
would mirror what SCRATCH_DEV_POOL does in xfstests, which works very
well.

I'd love to help with this, but I'm not sure my bash abilities are
enough for this :(
