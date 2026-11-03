Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793689374;
	b=dhc+vk/U5cKdVyVd4N/eg5/G4LdlH37aryF/mYEakgXJZwkfxHjOzDiO86lo2moOr6/w
	 gvzXV3YaEVETa/hkIWzbmRILcPtaVWaZJB8CI40QKMh0GHrbF0dV4GnXauLdtTWX+MLqw
	 Ts/3dZbLoAdEdTzwTNuz0lf//6xGxIjg+OfQIpdfHQNNT2YlojWyMMfZc0h9fhXUk5BEE
	 uhI87Fqg+PUwuBtp8sx8SZB4YSSHCp2jO1HKrcXWPu/ucgVJEW1wxnGmjf2bhpJQkqact
	 CsWk0RgPmn2vuZP+y+KTRWNhh+t1u88hxY9QSUq3ESk42ZyLkq/idunLfqh2xV8vUpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793689374;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=+S+ywes3kNv+A4N1xLXPObOnn3wXaYCT7Uss5A1Oyco=;
	b=MFhPbkGqlEpMQJm5tTfj37BJVc6haxquJWHsOWM9AS0UUa1r/chi9m2Q7LX0kwrrVlmM
	 IGqMsTHmkU0spTOHlKGkfZkYwZJchWyLENZ+JClR5vpnlRu6ZuThi0Mm1j13Rc5PIFeHe
	 WYhY4GIq6xDa7MLy12PRZLStbXJOXs1y+Qz/gFNEazo/GIKt4hA8w+THeBqSc5jhkyA7I
	 mhSCBFN4ms2VzBBaqvNvYItl2vtDKPrK51q630Nd/EEXIsSevv9yX8ErP/ruaa5vCaz5l
	 iM8L5chcKgwL6FTTjRaqKgKCRw/LSxNq13aAvlaiSwvl3/WuauNXFbyzVPDMoRPZWDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--robertpang.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=VVcIHBxD;
	arc=none smtp.remote-ip=74.125.82.198
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BC6606A324
	for <linux-bcache@vger.kernel.org>; Tue,  3 Nov 2026 07:02:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2BC6606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--robertpang.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=VVcIHBxD
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-33c35f5ca6cso8574350eec.1
        for <linux-bcache@vger.kernel.org>; Mon, 02 Nov 2026 23:02:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793689373; x=1794294173; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+S+ywes3kNv+A4N1xLXPObOnn3wXaYCT7Uss5A1Oyco=;
        b=VVcIHBxD//nuQdmmieTW1uI1xXR08YG1gV8GEGsa87EHCArCEmwiJWnsVcdwJXNhNR
         k/mmg9VCEz5RSS2jCPNMzVEd6yb8Y0ouNKrs0RetxQmNfuEiRaTNcgspMvqFKRjQYj3V
         k4dMw4bvFxzw0jplQ94jIgJYrDtv7kifaWpJg/SViiJ20Rov3jb6sUhoE5EYsgbBcn5w
         HJA8153VvtimhGQ1Kxywx63tNLjKZQYFInJg+ShszNbAU+bo7LC9hdBKhNdhaj5SP9bp
         93Z6iMf2AsCqh0ZyjNxLn5lLZ0Ojk34ZC9EnntRcvWFpmfYmNzJi5mt1eeCgliLNx1V4
         +igg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793689373; x=1794294173;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+S+ywes3kNv+A4N1xLXPObOnn3wXaYCT7Uss5A1Oyco=;
        b=V+bSTOm8o+bv2xNdSV6uU24NXTr/9j/PRoWRYJdPHtGz2BZ3j/DLy7Abwi+ZwrWDjj
         jYJMg8PWcYcbhA62Jz5L1kVhEOcqwFaI2NMTe6iDLHmb7IGAxb+18sFcORLmTLs615wU
         wR4qjqZOdDE/3ek5PfFQ7dDRDGIz+iPcnARyY3BScLywlgv08Q7jIoIKDvKwvJf2McDT
         ep9mI5pX2ToqV0xxRr7eY6ngvGwCq67iT0Zq7nwt9hX2Ab1uUnw8MtgRO5NdkB2bBwuI
         QXMvsm8LLrz0y4FFFOv97mscX0GXcI2k/DSCVz5ZNOSPFODSXnMGfIy3Hqhj/uX9lQZE
         AAoA==
X-Gm-Message-State: APuU4Z9qD641UNRSyS7Z/lluoPH9mHkTkDOQc7XrWpalhzLku+VAelR8
	kpxuNOI2ugUxDm6ew25PiSdelOpeHxUwqabrPYupNTqXHbFQthH/Z3pcBCNk0cu6K1DOmxGJ0aX
	1yC0EYFLjxiAgTnbEVqr4WQ==
X-Received: from dycnl1.prod.google.com ([2002:a05:7300:d101:b0:35d:bc5b:d1b7])
 (user=robertpang job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7301:3581:b0:360:b8b4:840a with SMTP id 5a478bee46e88-36a5eee0ee1mr10548686eec.39.1793689372535;
 Mon, 02 Nov 2026 23:02:52 -0800 (PST)
Date: Mon,  2 Nov 2026 23:01:22 -0800
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
Message-ID: <20261103070122.1208383-1-robertpang@google.com>
Subject: [PATCH] bcache: allow more bucket reclaims during garbage collection
From: Robert Pang <robertpang@google.com>
To: colyli@fygo.io, kent.overstreet@linux.dev
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, 
	robertpang@google.com, dongsheng.yang@easystack.cn, mingzhe.zou@easystack.cn
Content-Type: text/plain; charset="UTF-8"

In patch a14a68b76954 ("bcache: allow allocator to invalidate bucket in gc"),
reclaimable buckets are added to the free list for the bucket allocator
at the start of a GC cycle.

However, once these buckets are allocated, they are no longer marked as
reclaimable until the GC cycle finishes. Under heavy loads and frequent cache
updates, all reclaimable buckets can be exhausted before the GC ends, causing
the allocator to wait and stalling incoming I/O.

Address this by allowing reclaimable buckets to be reclaimed during GC up to
the number of generations left before BUCKET_GC_GEN_MAX.

Signed-off-by: Robert Pang <robertpang@google.com>
---
 drivers/md/bcache/alloc.c  | 3 ++-
 drivers/md/bcache/bcache.h | 2 +-
 drivers/md/bcache/btree.c  | 5 +++--
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index 3ec240ec685d..959d753e7cf6 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -141,7 +141,8 @@ void __bch_invalidate_one_bucket(struct cache *ca, struct bucket *b)
 	bch_inc_gen(ca, b);
 	b->prio = INITIAL_PRIO;
 	atomic_inc(&b->pin);
-	b->reclaimable_in_gc = 0;
+	if (b->reclaimable_in_gc)
+		b->reclaimable_in_gc--;
 }
 
 static void bch_invalidate_one_bucket(struct cache *ca, struct bucket *b)
diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index ec9ff9715081..daae5ac5ffbc 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -200,7 +200,7 @@ struct bucket {
 	uint8_t		gen;
 	uint8_t		last_gc; /* Most out of date gen in the btree */
 	uint16_t	gc_mark; /* Bitfield used by GC. See below for field */
-	uint16_t	reclaimable_in_gc:1;
+	uint8_t		reclaimable_in_gc; /* no. of times reclaimable in GC */
 };
 
 /*
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 27a129d47d0a..fc167868c814 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1742,9 +1742,10 @@ static void btree_gc_start(struct cache_set *c)
 
 	ca = c->cache;
 	for_each_bucket(b, ca) {
-		b->last_gc = b->gen;
 		if (bch_can_invalidate_bucket(ca, b))
-			b->reclaimable_in_gc = 1;
+			b->reclaimable_in_gc =
+				BUCKET_GC_GEN_MAX - bucket_gc_gen(b);
+		b->last_gc = b->gen;
 		if (!atomic_read(&b->pin)) {
 			SET_GC_MARK(b, 0);
 			SET_GC_SECTORS_USED(b, 0);
-- 
2.56.0.398.g882cbad275-goog

