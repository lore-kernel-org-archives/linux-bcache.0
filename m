Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFB837EFFF
	for <linux-bcache@vger.kernel.org>; Thu, 21 May 2026 16:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779381573; cv=none; b=VeV6MP2TVCGKf9+zAsu66kbKb1+5vK+j+eo2Vn9SDCj150s3ZdGwhIybM5NRYjau+7kxadl6aFfGHkUzBLsLcsMluuWcRKQ9bBU33Efh/8RcKH1A6V04fI73TK8EsxiLwNSRyCZTBpJDooSv0gSGh8dAWezOwwPuIfIOK8xM0Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779381573; c=relaxed/simple;
	bh=MBtIizEY5hBHrVdP5dcquGtpPCEAARy19S1vIGYeF58=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oz4Jb1PmS0GiCX3nkp7uC2SACQVHEeIQ+6XoojSCqpOUOx7mT+cmr6xgZcZg1BWU3WM1BpVaFjPRteByL0sqKvxEU34koYbG5mQpi4KlKcT6HsGSpQvBcB7BTNoOv4UE32sb1pr7REg51VIHJkTr+0Xuw4BkSbbRRbzQp002AXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ankitkap.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ADYlbLr3; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ankitkap.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ADYlbLr3"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-83cecc22d5fso3252644b3a.2
        for <linux-bcache@vger.kernel.org>; Thu, 21 May 2026 09:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779381571; x=1779986371; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nvqpFMFuzA1qxFgCYFe2rXCT+v/H7QYEEF/3u4IhSNY=;
        b=ADYlbLr3ahCUNS6bsWCvQFvohJlhImtgfVq+dN/uMQU/2ZUBbyMRFlvm8QmIjJvkiw
         kM9NJVtFJl2LxE1AawRvGRH5Gzcsfb/Q9F8sSr72W+IUXOij1/XFrhKpxXi562c5vew/
         biF45kS/AvO/I8NMjWc1RZJY/AMoHWz6Kr9U8NPiaL7Q+HzZSl4m99JGxF+tiJkoCmmB
         KQjrXmxfVuvidhXzRY6iC/b/C3N1bjrtiRtI0HydTt9315WUWi3Ilq+1NAnLDmDXlKWs
         mcZuutdFHnWuYqP8UaHvdImSWaqsYWTA4mLeqrvOrb/iVrosOSEVZGSt6bIDCfaWL6ld
         Uahw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779381571; x=1779986371;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nvqpFMFuzA1qxFgCYFe2rXCT+v/H7QYEEF/3u4IhSNY=;
        b=Qad2FTrS7cnjWijEMiOR3KYBhXMSwinTR2gDUqsj1n+ppWriT9l78gEOqxg7Z1VVva
         82c80yNcZoy1K9uNz5RkuprzZotrPsWHaM7371Th4D2n7tx0ZoKOVmrNxFE0PyzA3Cc6
         ep+cnyT/hHABOgZOtuhkVDApgyQj2GC+687s2l5w5PyFF9lSDqfKlf91LbQJ2CnlryM5
         oaNJ2mxNe38Owcoy5xc3A6I2DBdqFXqBAOY6WBM7K3WuY340a1i6AHk5n8AhR33/ciNE
         OXM4ywoEiGjEq2blM9vs9khDqZd9BQFwvdhNblOetu5gJnk3clA2APBKkfTo4LLvTV7S
         UFuA==
X-Gm-Message-State: AOJu0YyDjMlKftH1FNXZrUr89PEKoC6a9x5uxVAXA/GbXPZXynku6mmG
	uXqWnmPbGvcZfqRbgRbr7ze/8DO9TeEqxwzt88WKtbmc7kmxt0hpcxdK0g7+QYIXNRk9aUBqf61
	9UOMTlMRmSZpGaQ==
X-Received: from pfbjw10.prod.google.com ([2002:a05:6a00:928a:b0:82f:86c3:55ba])
 (user=ankitkap job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2d06:b0:82c:225e:63c5 with SMTP id d2e1a72fcca58-8415f349f4fmr37456b3a.18.1779381571246;
 Thu, 21 May 2026 09:39:31 -0700 (PDT)
Date: Thu, 21 May 2026 16:39:25 +0000
In-Reply-To: <20260521163925.178264-1-ankitkap@google.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260521163925.178264-1-ankitkap@google.com>
X-Mailer: git-send-email 2.54.0.669.g59709faab0-goog
Message-ID: <20260521163925.178264-2-ankitkap@google.com>
Subject: [PATCH 1/1] bcache: fix stale data race between read cache miss and
 bypass write
From: Ankit Kapoor <ankitkap@google.com>
To: Coly Li <colyli@fnnas.com>, Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ankit Kapoor <ankitkap@google.com>
Content-Type: text/plain; charset="UTF-8"

A race condition exists between a read cache miss and a bypass write
due to either congestion or sequential bypass, that causes stale data
to be cached when the read cache miss runs concurrently with a bypass
write targeting the same sectors. If the read cache miss fetches data
from the backing device before the write to the backing device,
stale data populates the cache.

The root cause is that bcache currently executes btree key
invalidation in parallel with (or prior to) writing the actual data
payload to the backing device. Under this sequence, a concurrent
read path can register a cache miss and insert a placeholder key.
If the write's btree key invalidation completes before the read finishes
fetching old data from the backing device, the read's subsequent
key replacement will not detect a collision, allowing stale data
to persist in the cache.

Fix this by deferring the btree key invalidation until after the
backing device write completes successfully. Enforcing this
sequential execution ensures that a stale read is always detected
and invalidated.

Signed-off-by: Ankit Kapoor <ankitkap@google.com>
---
 drivers/md/bcache/request.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index af345dc6fde1..ef2cf55df3bb 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -978,6 +978,14 @@ static CLOSURE_CALLBACK(cached_dev_write_complete)
 	cached_dev_bio_complete(&cl->work);
 }
 
+static CLOSURE_CALLBACK(backing_device_bypass_write_complete)
+{
+	closure_type(s, struct search, cl);
+
+	closure_call(&s->iop.cl, bch_data_insert, NULL, cl);
+	continue_at(cl, cached_dev_write_complete, NULL);
+}
+
 static void cached_dev_write(struct cached_dev *dc, struct search *s)
 {
 	struct closure *cl = &s->cl;
@@ -1058,6 +1066,11 @@ static void cached_dev_write(struct cached_dev *dc, struct search *s)
 	}
 
 insert_data:
+	if (s->iop.bypass) {
+		continue_at(cl, backing_device_bypass_write_complete, NULL);
+		return;
+	}
+
 	closure_call(&s->iop.cl, bch_data_insert, NULL, cl);
 	continue_at(cl, cached_dev_write_complete, NULL);
 }
-- 
2.54.0.669.g59709faab0-goog

