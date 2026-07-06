Received: from va-2-45.ptr.blmpb.com (va-2-45.ptr.blmpb.com [209.127.231.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70B13148C9
	for <linux-bcache@vger.kernel.org>; Mon,  6 Jul 2026 07:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783323594; cv=none; b=ltKZmv8/+TeFp1qsYqWuPUI5ghHFbbm2RARkgQ82r+w2RinWL2RqpdLO64suGb5mUin4IlgH1umd2eggy134AbWQTCakoR1lQO/pT8KZhqKDNScX7zsQ8GZwEWZKS6ksoIhBn4z5cAd5pFLmmucEvW4vfxh4IQk2gDVE2TfCvls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783323594; c=relaxed/simple;
	bh=CRMLUNFQQ04GP0Ey7H8KdBXNqVFU0ZW6gkHP5D8t+zg=;
	h=From:Message-Id:Subject:To:Cc:Date:Mime-Version:Content-Type:
	 In-Reply-To:Content-Disposition:References; b=A734zmwQHdghRmwNw1JZa6GnWATUaJrBZx2O20cWxKPf8Hc4pfH0gKZK2bxJXxQx/YHjXJeZVfOlY/JIkFCmokdU/jQaPQq+JEQM2rlJDyhPlmMGdF+sn1LjfNe8eC5O8D07QzfQh7N7m3DOVrrOG0MHgLLKGSuc4GxRGQK1AkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=Gjta5sDe; arc=none smtp.client-ip=209.127.231.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="Gjta5sDe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1783323582;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=nKTmYyJ5PuxV2bLbNWC5hVBj0w6SpjAMapE6aznAwqg=;
 b=Gjta5sDeLmbjG7TvMlrdMR128K1I6Srym11UNvi5giR1+MgHUehhZMYFOf9lox4OCDIOoB
 sEky0uNn+bGWtxO+JRzx9Ub0re8qkQ4dX4CAFeRx0tKi4+1dcqfHnJPelsLwBYzkkBQae7
 1QgkzDXyP9kzB9OI777iePpvH2WRyYVOfnLgct8uYmv1/o+KCbNHCfSllALIdiz+eFrKpt
 wUzelHukLXYoHckbmUSq1k7ELXcF9MmKB/oc1lKr9o+jfTHgeiImWsaVsocI4e9jB90eH0
 YBWFuvvqYMI62XoPHKJ7Yk8U4zfYvLD5UL70JoDt7Nl/cLOUY0WlZzQYfArRog==
From: "Coly Li" <colyli@fygo.io>
Message-Id: <aktYzuXWQ89EPM55@studio.local>
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 0/1] bcache: track active bypass writes to prevent stale cache reads
X-Original-From: Coly Li <colyli@fygo.io>
Received: from studio.local ([120.245.64.89]) by smtp.larksuite.com with ESMTPS; Mon, 06 Jul 2026 07:39:40 +0000
To: "Ankit Kapoor" <ankitkap@google.com>
Cc: <linux-bcache@vger.kernel.org>, <kent.overstreet@linux.dev>, 
	<linux-kernel@vger.kernel.org>
Date: Mon, 6 Jul 2026 15:39:38 +0800
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a4b5bbd+0c71f8+vger.kernel.org+colyli@fygo.io>
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20260617190152.3436375-1-ankitkap@google.com>
Content-Disposition: inline
References: <20260617103356.3287775-1-ankitkap@google.com> <20260617190152.3436375-1-ankitkap@google.com>

On Wed, Jun 17, 2026 at 07:01:52PM +0800, Ankit Kapoor wrote:
> Hi Coly,
> 
> A quick update on my cover letter questions: after thinking more about
> those edge cases, I realized my initial reasoning was flawed and
> could lead to the exact stale-data reads this patch aims to prevent.
> 
> kzalloc failures: Bypassing the counter increment on memory failure
> means the chunk is untracked. A subsequent read will incorrectly fail
> to bypass the cache, but worse, if a later write does get tracked, the
> decrements will become asymmetrical. I am wondering if a pre-allocated
> fallback pool could be a potential solution other than the hijack
> approach used by md-bitmap.
> 

Yes, you may consider to use a deciate mempool to alocate these refcounter
pages with GFP_NOIO. If I missed this point in replying your patch, please
add this into my review comments.


> u16 counters: I realized clamping at U16_MAX completely breaks the
> decrement path. If an I/O burst exceeds 65,535 writes, clamping loses
> the true count. The counter will drop to 0 prematurely while writes
> are still in flight, leaving a window for stale reads.
> 

Using u32 is good. For 100TB cache, the refcount pages may occupy around
100MB more or less memory. IMHO that's acceptable.

> To ensure absolute robustness, using u32 and a fallback memory pool
> seems necessary. I will hold off on sending a v3 so you can review
> the core page-lock tracking logic in v2 first and provide your
> suggestions on these two cases, but I wanted to correct my own
> reasoning before you spend time reviewing those specific questions.
> 

Yes, that's what I think of at this moment. Also you should think of
using RCU in bch_has_active_bypass_writes() to replace the spin_lock on
read path. I will explain that in the patch.

Thanks.

Coly Li
