Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7337E330B22
	for <linux-bcache@vger.kernel.org>; Wed, 17 Jun 2026 19:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781722915; cv=none; b=L1Lw1/yelH12SKfF7tGQcBNEBzXsX9LAhHITmKdnVjHINuRjuCjWYDCCpcg1BN8XO6tZJKfMDLLTI/oAA7n56p0FIIv1Hh00OGFVlfv6gFHxdKKHO3LGOHbc6nj/QAhOf7MOln7CU1ZGyySTATVnef4pKS/p2EMMqxlBcMbJ01M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781722915; c=relaxed/simple;
	bh=IABYL+VwE3lhXy7KLq///40Cq/0FyvfVk32b7R+nTQY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jFzeb8u1WeAjn/Nya0/puBldUoSeOjsRqoEYDypjGaLBcyBg/KpyrKDIgDxy4bBE2FtjBOF2F+LFIpkVNdaMeAvcjOJw70f6fMNifzMOp63zd9n09kK8dlJWoZdzlfKbayNsjJ8bzwRHHga28gvgDaGW3E3FLf8QtT902su4Nh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ankitkap.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mPxzS4P9; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ankitkap.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mPxzS4P9"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2c6bf305403so1067975ad.2
        for <linux-bcache@vger.kernel.org>; Wed, 17 Jun 2026 12:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781722914; x=1782327714; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IABYL+VwE3lhXy7KLq///40Cq/0FyvfVk32b7R+nTQY=;
        b=mPxzS4P9obZaYAmHx2MZ80NIqfwuecUr1evrpo+0RXvRCTiARzhGqZNyKxbgAjt3QM
         +eEBsiMLXyoTJUh1MOr4Frd/HAnBct8Umv1FFxU7wxHxqncT400uiJCsrg/BeehT86Ss
         n00vOQ7c7YEhTQoz9oQ5rZYZreYQCnWalWGh+OaYff7WYFW3cy88QANe3Z4uMUeZUNHC
         D1cWD0ejsKZ5ktVgeePm819wawDtaIUvHZX6C9xYa/VTrYB1JDyAMEZlwlM8Iudrhsyk
         J3ELJrMIjF6J24JQN7AeN75xQZ3xJXMOuJA15i5atWdH5ZksNHE+C+2jfllqvUlKxiiK
         krjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781722914; x=1782327714;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IABYL+VwE3lhXy7KLq///40Cq/0FyvfVk32b7R+nTQY=;
        b=qlqqc1p6CKdyjG2n7ovzR2PPxmL0pki28C62EMhFStoGsgntsZUycaZJtKnw8nWQEf
         6WbJOTBg6rbLznlA6RhC8xQw5DJpizfTuJSJi1elVjyA0iwDRASci+JFWTwHEbbtXt9+
         oT5AhpYtNGdT8+of/5liOyVLH3UnYVPZ+xWHnpIH2BPtnM8K00Tx0BA0uOU61DZ70nBY
         alOJZm+w0tLaKTQzT6pgR+f6JtVJJh486sBQc8ulmWntcSd5xygPZmaEcczifCL/bOEq
         e+F7PnHX2axVed8ZVDvqdhGonzCOL/G7Ooqrl0F6g53rJKBUjz+gOXU9cG2VTjBzDunn
         Urbw==
X-Gm-Message-State: AOJu0YxnApvC4BKYjf1uFd+yXZhaCKG71wg9eRiLstkxAdvxheHm8+Z+
	/mb4AOl0F5C7USVXTWoBWiJUwY8bMxUP9mx2sZws/wXvr0MZkL7oCL3xd3/ZcStfaqgvjqKGKbv
	4S2KfLLfzw77XAw==
X-Received: from plae21.prod.google.com ([2002:a17:902:e0d5:b0:2bc:bb08:92dc])
 (user=ankitkap job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1b6f:b0:2bf:77b2:8b2d with SMTP id d9443c01a7336-2c6bc25ca62mr48771625ad.30.1781722913564;
 Wed, 17 Jun 2026 12:01:53 -0700 (PDT)
Date: Wed, 17 Jun 2026 19:01:52 +0000
In-Reply-To: <20260617103356.3287775-1-ankitkap@google.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260617103356.3287775-1-ankitkap@google.com>
X-Mailer: git-send-email 2.54.0.1189.g8c84645362-goog
Message-ID: <20260617190152.3436375-1-ankitkap@google.com>
Subject: Re: [PATCH v2 0/1] bcache: track active bypass writes to prevent
 stale cache reads
From: Ankit Kapoor <ankitkap@google.com>
To: colyli@fygo.io
Cc: linux-bcache@vger.kernel.org, kent.overstreet@linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Coly,

A quick update on my cover letter questions: after thinking more about
those edge cases, I realized my initial reasoning was flawed and
could lead to the exact stale-data reads this patch aims to prevent.

kzalloc failures: Bypassing the counter increment on memory failure
means the chunk is untracked. A subsequent read will incorrectly fail
to bypass the cache, but worse, if a later write does get tracked, the
decrements will become asymmetrical. I am wondering if a pre-allocated
fallback pool could be a potential solution other than the hijack
approach used by md-bitmap.

u16 counters: I realized clamping at U16_MAX completely breaks the
decrement path. If an I/O burst exceeds 65,535 writes, clamping loses
the true count. The counter will drop to 0 prematurely while writes
are still in flight, leaving a window for stale reads.

To ensure absolute robustness, using u32 and a fallback memory pool
seems necessary. I will hold off on sending a v3 so you can review
the core page-lock tracking logic in v2 first and provide your
suggestions on these two cases, but I wanted to correct my own
reasoning before you spend time reviewing those specific questions.

Thanks,
Ankit Kapoor
