Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D0823EAAF
	for <linux-bcache@vger.kernel.org>; Fri, 17 Jul 2026 00:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784249482; cv=none; b=EM1rEl5OmRhOuTpFmgZJ+UZyGOoE7k6AKgnHB4YCz4A/JWGK24OYeBtyeYoIMOb5nGSX+aXY2SMVDhsJ/1lNliJguLPG7Xn54OK6QfRUbqPkPFBsAOTdR4cr9d1xUNlPfBBGHGdXozBqGCvk2d4eLZpUwTmUIjIbhaoLs7sub/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784249482; c=relaxed/simple;
	bh=x3m/htLsP4Xl6tkAFtxz/ZNQfmQHMUnscKQfqn5RVHk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JKRbm+loHHVS2Ul5Qgd+bfGxXjfAY+rnJb4axQ6iFlHhSDzXn9hVsX/CpbOb5DpzwImI2NaKcJYrA08VIKsQqoR5bUTq/5OTtny9fyJ7rT5cwf2dvclOsxgzG6kk/fs8nCkgk7ZddRiZX4khE91ufdecWVLoroz/RdYmXK2A79o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--robertpang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S6nhsKMA; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--robertpang.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S6nhsKMA"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c8952346bb9so6218707a12.2
        for <linux-bcache@vger.kernel.org>; Thu, 16 Jul 2026 17:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784249480; x=1784854280; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ev6dCaGMd2PG8/f+hrXXrN8UMzqD5iaeXfaZiYQj5DA=;
        b=S6nhsKMAEjzBZUMyZQ5f+MLzBMZ+PQ0xdyQWnYPORzpBLI/49uC+812VeW5CWmLBUW
         M7Euz1vdrCLmM0gLoRiI3dC2JPXNMFgpGtYPRD+mWSARxdz9h+uF96KSz0uAunHUhwxN
         fYwlCRPg6B5Jkgnxmsmi0/UHFZ1uODz/8aASmv8qw9J9Vhgv/ibfKahGxqrMfbQKtbXo
         9pTqMRTnHuAcbyhgCpPpJcyn+xVmmfLX1gmxpaEbBV68gzRm9JDMdpHlMZFcPFokiMW2
         YIr09GXxdujZDOPYksmgA742efy/vTP/4iN8gm0ppTaeiuti50hMLRYMhu2qYAOCxr0a
         cqpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784249480; x=1784854280;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ev6dCaGMd2PG8/f+hrXXrN8UMzqD5iaeXfaZiYQj5DA=;
        b=ZfU7OB3hKR6fScmm5PbOnmo6qUhABe/KKexA8mFd1UDbZjraYG+NszgUxldFNqvrb8
         qva8ddCsVYX6p3yV4/8YZagU+opZE+hS1HhMN5uz8uxDYOgAV0tBfgSsz8a9BdtxFm5q
         tg2Hf3nD+69ciPgyDa0r5qtqAinottFlVmhzmL0rC+YKLMMn/7wsOJYn9TBbIoFzoGB8
         /3aiJjb3Xj+yC9QJCx6gBVZ0B17om0bG6b9SdUNbO4eFzMZjRleKzDXhUu7UF+/mJCWX
         jQKSJFr2jFj6oLCrG8O7080cV/g9+3cOPSfBmibNdjHWRpNfFXUzuEoXZQeLEuIx+KJz
         CZvQ==
X-Gm-Message-State: AOJu0YzCRsghN74mgunrNDFUEDVcTeegIwsQGx8tH3d9s6+6QSUlW5cK
	4yUI0k9vwKdxLqTF7txDCz8Y0T59M9TWP7AWhhMw1vzdMvE2Ncrc9tJ0OMLEMCxSlHUQDG6Jvo8
	vkMk9W8LfTbdXnKjmQPOw4Q==
X-Received: from dlbbu38.prod.google.com ([2002:a05:7022:2226:b0:13c:dac9:9116])
 (user=robertpang job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:1713:b0:3c3:8651:b302 with SMTP id adf61e73a8af0-3c3ad7ac447mr241161637.28.1784249479389;
 Thu, 16 Jul 2026 17:51:19 -0700 (PDT)
Date: Thu, 16 Jul 2026 17:50:39 -0700
In-Reply-To: <20251113053630.54218-6-colyli@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113053630.54218-6-colyli@fnnas.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260717005039.1953649-1-robertpang@google.com>
Subject: Re: [PATCH 5/9] bcache: reduce gc latency by processing less nodes
 and sleep less time
From: Robert Pang <robertpang@google.com>
To: colyli@fygo.io
Cc: linux-bcache@vger.kernel.org, mingzhe.zou@easystack.cn, 
	robertpang@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Coly,

I was reviewing this patch again and noticed that btree_gc_min_nodes() reads the
atomic counter 'search_inflight'. This counter is incremented and decremented by
clients issuing front-side I/O. In this scenario, should we add a memory barrier
(such as `smp_mb__before_atomic`) prior to `atomic_read()`? 

My concern is that if btree_gc_min_nodes() is inlined in the caller
btree_gc_recurse(), the compiler might hoist the `atomic_read()` outside of the
while loop where btree_gc_min_nodes() is inlined, preventing us from fetching the
latest counter value. Adding the barrier would guarantee we read the updated
value.

What are your thoughts on this?

Best regards,
Robert Pang
