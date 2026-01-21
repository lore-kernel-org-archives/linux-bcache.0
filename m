Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913A547276C;
	Wed, 21 Jan 2026 07:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768982204; cv=none; b=qzJtbI0DH8qaq54ySE+ywC/7yDyJyO9v3Ys8HUoaNdqAxN3UZtsWAKStQpAVJmWL+G16yBorsc6zwOzVyvCuDlqg5g0DUTqZ/aLyRbwzFNtqio8ZhLfPAnF3aCNmoM/18g2l8Ryy32e39DlYBqMtBR/yqSv3GmLA6GS4/zMQ8DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768982204; c=relaxed/simple;
	bh=3tdT7H5minWqJafwZ8Pzkf65NEQHzXEdT7f5dBr/uUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bkvhDBD6HNWHLKuCQgaOx5Zwv1EFpUI89YFuYUNzO97TzF2hE+FVCV1NpjS1d6K4sFtl4rSR74MLl4T57Au3bGGtMrnlqp8PsQpHbdLLBzoh9Bw8BNdUmDRW+cTTxJImHIjFXMdZXcPAXCDwC/DTI1hNFissliyIznfHB0EPH7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bngXLiGd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bngXLiGd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=eb8zrFVcSmjOnjHX6WPZzoZuQeNQ7hDYmD9WPipjs5k=; b=bngXLiGdueoyDqYGKZ1Ebi6y4Y
	mMbUXJBcY+d9p8G8FS2YykK5j7bI1SL/1C1usBA6Z3GpOEdYXfjRqr6zqNi0nZnua8GCQ+kSfFMeV
	G93NnTi265GD4GWB3UmugT0GWKT3BKDNQXrfop3+JRr8SGU0XJ1aYDl5DilmzcX4i/YWL1YlgB/Zx
	ktV85A0vIuX0OW1A8QLvg6thiWKVQ4rYgPWpQw2wZMAPTJuvwP7aG9rxFRPrM9X9rqRPHRBC9N9fQ
	bMkcjPKt93vYvzmyrMAAuJQ8iI+aAEMzyqzbAMGYsm1bX9sw+RZ8yOmR8uG/b1oOCRvdfhSxxxuB8
	tPGMNE+A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1viT4r-000000052x9-0ASv;
	Wed, 21 Jan 2026 07:56:33 +0000
Date: Tue, 20 Jan 2026 23:56:33 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Daniel Wagner <dwagner@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>,
	Stephen Zhang <starzhangzsd@gmail.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Coly Li <colyli@fnnas.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org
Subject: Re: [PATCH blktests] bcache: add bcache/001
Message-ID: <aXCGseCNoaX8rQ83@infradead.org>
References: <20260120-bcache-v1-1-59bf0b2d4140@suse.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120-bcache-v1-1-59bf0b2d4140@suse.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jan 20, 2026 at 02:28:18PM +0100, Daniel Wagner wrote:
> So far we are missing tests for bcache. Besides a relative simple
> setup/teardown tests add also the corresponding infrastructure. More
> tests are to be expected to depend on this.
> 
> _create_bcache/_remove_bcache are tracking the resources and if anything
> is missing it will complain.

Not really an expert on bcache, and not that much in blktests either,
but having some testing for bcache readabily available is fantastic!

> Note: to run this tests blktests TEST_CASE_DEV_ARRAY needs to be set:
> 
>   # cat config
>   TEST_CASE_DEV_ARRAY[bcache/*]="/dev/nvme0n1 /dev/vdb /dev/vdc"

Can you add a blurb to Documentation/running-tests.md about this?

I also wonder if we could have a generic TEST_CASE_DEV_ARRAY that
would just work for all tests needing multiple devices?

