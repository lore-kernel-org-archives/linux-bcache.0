Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963AA3D3337
	for <linux-bcache@vger.kernel.org>; Wed, 27 May 2026 13:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779889272; cv=none; b=fvY/UKtcnu8KYze4NNcJhQYew0dn/hS8Q5ohpfM0FeR0r8SakMNxkVf/0x1ZtRtCZ3LyDj6ml5kEl3Zk6lXlQLM5ryvJCN8K6znVO2yuzUg+L3mWFUGEvf6Mo3a/T2P7S7zT7f4Id/g7KnweiW9kHTU7pHRxteDCbSxwPZhe4P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779889272; c=relaxed/simple;
	bh=rQJJv7N66lUUbMhhv4z57f3MtCYWE0/McJaD1lx1jEs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hU2tQfbxmhWax3pqQUlzMoueQShDpau/d38AIBwfDhs80AdsQunCZT+yTROXls9X4datpJ2JcfqHfxxQdTPxjY10vhefuoagwirZ9UjOqisT04EyJVzAmgu6GOezC+jU+19UF3c7qFlsEiv7JelKFKC7lnzI1n8mgBE/8w7smo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ankitkap.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VshwHhmt; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ankitkap.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VshwHhmt"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-365e70c39d0so11419042a91.0
        for <linux-bcache@vger.kernel.org>; Wed, 27 May 2026 06:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779889271; x=1780494071; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=REAVp/okQ1dJOqeLwtvyQceNd4UDlED8Jr8DlKsue8g=;
        b=VshwHhmtMwONbBLSg8C+NzafVxjVGAsW1/CHR4evy+HL1U8xkgCu/hYJCORaLmr1H5
         aRzFPDAY3nYXn8SZp5Ef5a9+VIdDuFQjMOSSTtVdfT24nLzi114+CZUR8tRiRnYKbfco
         9aYsd6d1rEnztN1VCmvygtwxwCWdIbXxBS1RRrH6mwQLvnN3nFPbKo74qISlwVJjVVie
         BOG6Vy4eAUIS1i+G2QP8+v5MsDBtSrKU6c2ozMAVeFPGHQFaY6PGAtmjgMpPf+Ugvi9S
         g2l3iv4nW1TFz8SEasZrttfO2smVo8HTstIFzCcGsVkPMOjEeLxleg1weEISOl55jZ3Z
         1z0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779889271; x=1780494071;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=REAVp/okQ1dJOqeLwtvyQceNd4UDlED8Jr8DlKsue8g=;
        b=aoLlpXfZ6TX9JBElzd6ljdvvFLEb1PDw1UqAu6GCBOuiDSN+pIANYwO9C7rjVxgszJ
         DdEO9vW6+hKNWPc4NcjvZznMCxx1ruxFJi557y/vOOlvXZHUH3UlOuiC+H4GmYbvxUB6
         zRt2IGPogjY8JNEKeBMPuaU/0gIGdk4x6vSEOOsr9F409r+TmGLrmk7MsC1YzrssGXfF
         eBbIswGiRhmnMky+6siP7ERTzp7jeCo8SfmdLfktbxPGm+SYNaIEVK7C7HIKy1qJtUXL
         MLKF6wYuNzMng9gfyUztUB8KhpaYrIMj9kbJdkBtqvaVHyWgwlOHoR/IxelkJij/U17y
         eRAg==
X-Forwarded-Encrypted: i=1; AFNElJ++oMwkCPxLd5Jct0ANeLSrPKYurfWDRrYrT0/Ho9MVRaECVjzlTu6HoP5P7RXnT4CBiGHJKacZ0b0hqBY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZ+Q3IyqcdpNnY3hVNggkJvuY9oPzNmI6a9q3FPfk1kdkHvif1
	I7VwYm7tZ/0pKQ/CkdCU2juDCAE+qgwyGCgN3ODBTXYyHFOqf10MfJEcUkvrHvJjR4T3cnqQApx
	ITTcmITyvfEIlag==
X-Received: from pjbmv7.prod.google.com ([2002:a17:90b:1987:b0:36b:7325:f99b])
 (user=ankitkap job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:586e:b0:36b:71e6:3de3 with SMTP id 98e67ed59e1d1-36b71e63fb5mr326560a91.3.1779889270505;
 Wed, 27 May 2026 06:41:10 -0700 (PDT)
Date: Wed, 27 May 2026 13:41:08 +0000
In-Reply-To: <ahRNUlU60mx9ESd1@studio.local>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <ahRNUlU60mx9ESd1@studio.local>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260527134109.2659134-1-ankitkap@google.com>
Subject: Re: [PATCH 1/1] bcache: fix stale data race between read cache miss
 and bypass write
From: Ankit Kapoor <ankitkap@google.com>
To: colyli@fygo.io
Cc: ankitkap@google.com, kent.overstreet@linux.dev, 
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Coly,

Thank you for the feedback, for confirming the issue, and for the guidance.

> Hi Ankit,
> 
> Yes, I confirm this is an issue that must be solved. Nice catch!
> 
> On Thu, May 21, 2026 at 04:39:25PM +0800, Ankit Kapoor wrote:
>> A race condition exists between a read cache miss and a bypass write
>> due to either congestion or sequential bypass, that causes stale data
>> to be cached when the read cache miss runs concurrently with a bypass
>> write targeting the same sectors.
> 
> This patch fixes the stale data issue in run time, but if power failure
> happens inside the race window, after boot up again, the stale data
> still exists in cache for following read hits.
> 
> And your fix invalidate the key after on-disk bio completed, which makes
> such stale data window by power failure longer.

While I initially hoped that serializing the operations would suffice, I
completely agree with your point regarding the power-failure risk
which shall be addressed.

> To solve all the stale data race both for run time and power failure
> condition, could you please consider the following proposal.
> 
> Maintain a data structure to hold all invalidate range from by-pass
> write, record/insert the invalidation range before bch_data_insert(),
> and after cached_dev_write_complete(), clear/remove the invalidation
> range.
> 
> For a cache-miss read, if there is any invalidation range refcount
> exists, check all non-zero refcount ranges, if any range overlaps with
> the cache-miss read range, do NOT update the missing bkey back to btree
> and only read data from backing device.

I am now working on a new implementation to track the in-flight 
sectors currently being written, exactly as you suggested here.

> Here you need to design a efficient data structure both for performance
> and memory consumption. I would sugguest to maintain chunk refcounts
> which mapping multiple 32MB ranges on cache device (current max key size
> if I remember correctly) range. You may look at how md raid maintains
> the legacy bitmap refcount, hope that code can give you any hint.

Thanks, I will look into the md raid legacy bitmap reference implementation for
hints. In the meantime, could you please recommend any specific fio
configurations or workloads you prefer for evaluating the memory
overhead and performance impact of this change?

I will send a v2 patch series as soon as the tracking mechanism is ready
and thoroughly tested.

Best regards,
Ankit Kapoor
