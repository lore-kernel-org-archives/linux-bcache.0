Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793689462;
	b=IBkdMYSxFetHYw4hdL3I3HiDl0FvYdd47TT0SwvOCEAsnwjleu/ttMrdLDn/Le1Rs8Gt
	 4og8JR/AfO20l+/eqQ7pcXsRTGLAtI/1pGA4hB9gJii7cB7TSchE1gR0kRdj4xY3GY/gU
	 U6dz9D2hGBPkVn8HZBSI76OEBV5lxNVdkXvoCfMMCVZ+80mUMZcbt2aPSg82qHsJnynXL
	 yoO1mqJyqFrDNq1YKgcfZwweyCqvH+A6aD5R81BIvnlTxQlebz7kudj4Vevrzm+MfKE67
	 b57RpPLVR9Tuuz+nwq3NnO5ZHsbtI5TwfTbqbpVb4103YbQbXSW92J9a49VznGuZ+bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793689462;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=v3HVGrDn19qzJKOsOUSd0NNPtRrAAsxOMD2NnhVPCgo=;
	b=eYtVPgpsxF6imwXIon8XzuuEytj3paFDVHSWIHb6M8gh96l5eLfyeJEwKvotlgpjis/p
	 T9IzTYYLmYY8X2c/2oZKz6nprfPbPbICHt0rsXLYEfrMJ+yE4l9l6cjAZs5euef1T4QBv
	 WtmsPxSN9xCufDsXMjZrw6+2L2A7EnUj84wRFpkEcSJfDDu4vipvyJdlOV5rUCSPfwyMq
	 /X7NoWdEzgOhJYgeL4lFhynijNlkDshc3VaYZ/toPTbWol6wLlBs61dsHKA9GYGUopgYK
	 cPmePTsp19hIL1btE5QvqcJGe2CynBvS7IhodVViA47PLkVOkHmJ0wxpYMgarb2JcAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--robertpang.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=P3IPTl+R;
	arc=none smtp.remote-ip=74.125.82.198
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F22606A324
	for <linux-bcache@vger.kernel.org>; Tue,  3 Nov 2026 07:04:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A8F22606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--robertpang.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=P3IPTl+R
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-33713e5e6daso4640441eec.0
        for <linux-bcache@vger.kernel.org>; Mon, 02 Nov 2026 23:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793689461; x=1794294261; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=v3HVGrDn19qzJKOsOUSd0NNPtRrAAsxOMD2NnhVPCgo=;
        b=P3IPTl+RbNzVLTOKrXaQQZns1M7Zkhfj2OCkUUY9k5uIssjSECmBKFO11x14bYMJXW
         +6tpc8ksOZ7B2A41b0/UUh80ncD04oS0nTEEwmLlvoZAKsn5FLQy732N+X7TVQjXM7Cx
         gGgZuEC6HRpeEQb2AvwEsh0v3peWfOFRIUvwoNGgk0/V8EjDS4QgZ2G+13vy7Uu+FNYL
         tOipZ5c3pFoaOoeQuYSF/DeoFJdy5VIF5XO4tPFkmoHFYpM5SNsdWVW79BjZEUryo1TT
         jd7Uz2TKEJXbudVZE71wqbqjJBWi8lITCawdu5ToY/oCIA9pJVHIJ5mMxe2sMAi+l8Ub
         KGkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793689461; x=1794294261;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v3HVGrDn19qzJKOsOUSd0NNPtRrAAsxOMD2NnhVPCgo=;
        b=VKKpZNUvNnAMiiH4lRh8REAM0VTqv4iDm/JGzYRSn3962zUxpSnBI2q3Ib18Z9oThK
         0EmtEr18f+UEz2g2dS+IM6QNg4UVEqPq5GcUVN3UAmLUI1W5j3PdGcuv5H0+Lc/ZoTIp
         ZCdxqrhY4iP3JJ5uvnLcOnhPN9pNymMw4O2RkND6pEmAxFCZNz24pYjHSKpzq6l/X9np
         HJpvx0zg/oZQB9bUaH2omE1AqvjX9VwyFt/1V4aEEzZ2sLlT49ZQH6svJSjhWux5c03a
         LOvXBJtsFf3rZrTlYG+HWAMnSZ56fP3uROqXhkyDL/3/hyPUHBO3WwCMIqnLaTgQS8RN
         qPSg==
X-Gm-Message-State: APuU4Z90Lc99A0Iv0GVTTIjhcxZ2ZybwAFx0w6lurc06oA9EI2klw05J
	j04DT5SMuqHotdwjcGPR33b9n3aBypFVvlG311VkTtbwLsHh+mjZ0061HKTEIMQsoyPxa8vcrIa
	D8FuUm60++tqucE4O79ORxQ==
X-Received: from dldyr25-n2.prod.google.com ([2002:a05:701b:4519:20b0:195:cde8:ab41])
 (user=robertpang job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:1089:b0:14d:3c0c:79e9 with SMTP id a92af1059eb24-1ac5b027fccmr17755954c88.11.1793689460359;
 Mon, 02 Nov 2026 23:04:20 -0800 (PST)
Date: Mon,  2 Nov 2026 23:04:06 -0800
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Post: <mailto:linux-bcache@vger.kernel.org>
List-Help: <mailto:linux-bcache+help@vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-bcache+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.398.g882cbad275-goog
Message-ID: <20261103070407.1211071-1-robertpang@google.com>
Subject: [PATCH] bcache: fix available bucket accounting in bucket allocation
From: Robert Pang <robertpang@google.com>
To: colyli@fygo.io, kent.overstreet@linux.dev
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, 
	robertpang@google.com
Content-Type: text/plain; charset="UTF-8"

In bch_bucket_alloc(), a cache set's avail_nbuckets is decremented whenever a
bucket is allocated, assuming that the bucket becomes unavailable once
allocated. However, when a bucket is allocated but the GC mark is unset or
reclaimable, it is available still. This false counter decrement leads to an
inflated in-use measurement, which triggers cache bypasses once CUTOFF_CACHE_ADD
is reached, persisting until the next garbage collection cycle.

Fix this by ensuring avail_nbuckets is only decremented when the allocated
bucket is already marked and not in the GC_MARK_RECLAIMABLE state.

Signed-off-by: Robert Pang <robertpang@google.com>
---
 drivers/md/bcache/alloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index 3ec240ec685d..2d0cb9b414ac 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -446,7 +446,8 @@ long bch_bucket_alloc(struct cache *ca, unsigned int reserve, bool wait)
 		b->prio = INITIAL_PRIO;
 	}
 
-	if (ca->set->avail_nbuckets > 0) {
+	if (ca->set->avail_nbuckets > 0 &&
+	    GC_MARK(b) && GC_MARK(b) != GC_MARK_RECLAIMABLE) {
 		ca->set->avail_nbuckets--;
 		bch_update_bucket_in_use(ca->set, &ca->set->gc_stats);
 	}
-- 
2.56.0.398.g882cbad275-goog

