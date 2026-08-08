Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0A23AB291
	for <linux-bcache@vger.kernel.org>; Sat,  8 Aug 2026 04:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786161982; cv=none; b=k49JeGKQn0SRnBbr+7x3daoEWXFLMZGFDlSthr88/cprsCm+Frhr8x8JxFL6iGZ+l/ER7Z8AISc6rAmtq3nL45z63n6avfI80LvIkI2aHJ3robw/2b7MItYWDbgZ7dNbgsi7A72cE9iq5Npf1+LzT3trK2Wzxh8U7hqB4yReNeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786161982; c=relaxed/simple;
	bh=xA+Anu1G01kalxTG8fE/ijwz0xdzhG/T7miN8n1j8/Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OCjGy+ew8tS///MbEloZS3UVmQlDXMeBtfTJ2HqxkWIeNUZtJjQK4kUCfumrhKWmfYITPsIJWHkdTADIUmMKnkEwSlFKGXOq6HNF3mffj3a/XIIMfrBFJu8xL4GPQV14EdDw2TEJPR8eTHXZzAUkSt1xPyXkmqR3Do6FexoMU8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ankitkap.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fY5zmUgL; arc=none smtp.client-ip=209.85.214.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ankitkap.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fY5zmUgL"
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2d004f13426so3792795ad.3
        for <linux-bcache@vger.kernel.org>; Fri, 07 Aug 2026 21:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786161980; x=1786766780; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cp2CV40UiAeLycXOv282ow6mV6SoZ8nWxaGYowz7qXM=;
        b=fY5zmUgLOWZo3V6GvY3eBSCrhds82RzCJQDYAds0393xSRU/cA9sv6zI5sF+Cg1/7C
         HK3BAl1d79RLha36volF9XRK/pIgCnZcA87/x+2sO/f2ZpEls8jUwKy3KmeON6r1XNVj
         ZQ7XtNzBaLCi8waIGTmZ5J978Yh3r1ASMJC7P3D45GfpGRBFHpf4/aoLsw5UE0YpVMZf
         +z4wXsv+ILTvf78t4FZrNVy73mpSvZNPQeKXU1B0fHQBk3B3N+getQZ0laI2dcEDN97t
         Tjuu7t1BQaxO8C3+LhTO9ZBlctihLYupWrQeXLWhd4uruh4nHMqgxR14HysVe03cD6HK
         ExVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786161980; x=1786766780;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cp2CV40UiAeLycXOv282ow6mV6SoZ8nWxaGYowz7qXM=;
        b=OpzAulGDmlkqn+Ub2xGmeMItWYYpLGe5AGZEm5Jm2/5ut8NUmcYF1fJEM9d/wl88W1
         O7JTOL4XjuGMUNQHOaIwiBoXREU4u6A08bsXODbbPGtwu+4Pos+M1gxMep3QeyusmuXU
         QqeAbIo91NC3Gq7Kk77b4Ufx2ZveYqYBNAjLX8HIJ4zTkO0rptsyQ0OV1DD9q0u/BWCc
         jzpAhEUKcVlyR5hT7pC6tphvKiGRspvd9mO1iDJ/gPUc7pFuvZdfqZQULL6BOJiwpH4Y
         J1ekulVgt9ZTwSgnzu+zU4V6P9uvGDjOwIG84XjOiON8QcR7iW3TQrdySf1Wy+pm13hn
         2j/Q==
X-Forwarded-Encrypted: i=1; AHgh+Ro1M/3xqRr5eCvhbBTclZH33pqz61Qqj1t1eQtrFOVpjDv9Axo8fE9Q4HMluyFIV0Zlz6amRsNFS9I1W98=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqyiFqCdoPkGwYATCQTQIffWpysha9UoegUySfgeNSOKqa9Ip+
	esLVlKTLL4S+dxBVaWoTcWBQEcPXIVjlHknHrc86zI41EKOa5ENX+MQ8RQS/V1tvc1zK7XJP1sl
	TNSrbeXs79OqpGg==
X-Received: from plas19.prod.google.com ([2002:a17:903:2013:b0:2d0:34d:e973])
 (user=ankitkap job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e84b:b0:2c9:b396:1a55 with SMTP id d9443c01a7336-2d0ca76a3bamr304649095ad.12.1786161979362;
 Fri, 07 Aug 2026 21:06:19 -0700 (PDT)
Date: Sat,  8 Aug 2026 04:05:49 +0000
In-Reply-To: <20260808040549.2778125-1-ankitkap@google.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260808040549.2778125-1-ankitkap@google.com>
X-Mailer: git-send-email 2.55.0.679.g6767b8d81c-goog
Message-ID: <20260808040549.2778125-3-ankitkap@google.com>
Subject: [PATCH v3 2/2] bcache: inspect active bypass writes lock-free via RCU
From: Ankit Kapoor <ankitkap@google.com>
To: Coly Li <colyli@fygo.io>, linux-bcache@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>, linux-kernel@vger.kernel.org, 
	Ankit Kapoor <ankitkap@google.com>
Content-Type: text/plain; charset="UTF-8"

Checking for active bypass writes on the cache miss read path currently
requires acquiring page-level spinlocks across the target sector range.
While contention is low under normal operation, acquiring a lock in the
latency-sensitive read path introduces unnecessary overhead.

Optimize the read path by using RCU to inspect active bypass write
counters lock-free. Writers continue to use page-level spinlocks to
synchronize counter updates and allocations, while readers inspect the
tracking array under rcu_read_lock().

Suggested-by: Coly Li <colyli@fygo.io>
Signed-off-by: Ankit Kapoor <ankitkap@google.com>
---
 drivers/md/bcache/bcache.h  | 14 +++++++--
 drivers/md/bcache/request.c | 58 +++++++++++++++++++++++++------------
 drivers/md/bcache/super.c   |  9 ++++--
 3 files changed, 56 insertions(+), 25 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 2e50526a52fc..2ecff48d8902 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -299,10 +299,18 @@ enum stop_on_failure {
 	BCH_CACHED_DEV_STOP_MODE_MAX,
 };
 
+extern struct kmem_cache *bch_bypass_cache;
+
+struct bch_bypass_counts {
+	struct rcu_head		rcu;
+	struct cached_dev	*dc;
+	u32			counts[PAGE_SIZE / sizeof(u32)];
+};
+
 struct bch_bypass_page {
-	u32		*counts;
-	unsigned int	active;
-	spinlock_t	lock;
+	struct bch_bypass_counts __rcu *counts;
+	unsigned int		active;
+	spinlock_t		lock;
 };
 
 struct cached_dev {
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index bfd28b68f499..9221db669050 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -24,6 +24,7 @@
 #define CUTOFF_CACHE_READA	90
 
 struct kmem_cache *bch_search_cache;
+struct kmem_cache *bch_bypass_cache;
 
 static CLOSURE_CALLBACK(bch_data_insert_start);
 
@@ -852,22 +853,28 @@ static void bch_bypass_write_start(struct cached_dev *dc, sector_t sector, unsig
 		unsigned long pg_idx = bypass_chunk_to_page(chunk);
 		unsigned long pg_off = bypass_chunk_to_offset(chunk);
 		struct bch_bypass_page *pg = &dc->bypass_pages[pg_idx];
-		u32 *new_counts;
-		u32 *dup_counts = NULL;
+		struct bch_bypass_counts *new_counts;
+		struct bch_bypass_counts *dup_counts = NULL;
+		struct bch_bypass_counts *counts;
 		unsigned long flags;
 
 		spin_lock_irqsave(&pg->lock, flags);
-		if (!pg->counts) {
+		counts = rcu_dereference_protected(pg->counts, lockdep_is_held(&pg->lock));
+		if (!counts) {
 			spin_unlock_irqrestore(&pg->lock, flags);
 			new_counts = mempool_alloc(&dc->bypass_mempool, GFP_NOIO);
-			memset(new_counts, 0, PAGE_SIZE);
+			memset(new_counts->counts, 0, PAGE_SIZE);
+			new_counts->dc = dc;
 			spin_lock_irqsave(&pg->lock, flags);
-			if (pg->counts)
+			counts = rcu_dereference_protected(pg->counts, lockdep_is_held(&pg->lock));
+			if (counts) {
 				dup_counts = new_counts;
-			else
-				pg->counts = new_counts;
+			} else {
+				counts = new_counts;
+				rcu_assign_pointer(pg->counts, counts);
+			}
 		}
-		pg->counts[pg_off]++;
+		WRITE_ONCE(counts->counts[pg_off], counts->counts[pg_off] + 1);
 		pg->active++;
 		spin_unlock_irqrestore(&pg->lock, flags);
 
@@ -876,6 +883,13 @@ static void bch_bypass_write_start(struct cached_dev *dc, sector_t sector, unsig
 	}
 }
 
+static void bch_bypass_counts_free_rcu(struct rcu_head *rcu)
+{
+	struct bch_bypass_counts *counts = container_of(rcu, struct bch_bypass_counts, rcu);
+
+	mempool_free(counts, &counts->dc->bypass_mempool);
+}
+
 static void bch_bypass_write_end(struct cached_dev *dc, sector_t sector, unsigned int sectors)
 {
 	unsigned long start_chunk = sector_to_bypass_chunk(sector);
@@ -890,25 +904,27 @@ static void bch_bypass_write_end(struct cached_dev *dc, sector_t sector, unsigne
 		unsigned long pg_idx = bypass_chunk_to_page(chunk);
 		unsigned long pg_off = bypass_chunk_to_offset(chunk);
 		struct bch_bypass_page *pg = &dc->bypass_pages[pg_idx];
-		u32 *counts = NULL;
+		struct bch_bypass_counts *counts = NULL;
+		struct bch_bypass_counts *current_counts;
 		unsigned long flags;
 
 		spin_lock_irqsave(&pg->lock, flags);
-		if (WARN_ON_ONCE(!pg->counts || !pg->counts[pg_off])) {
+		current_counts = rcu_dereference_protected(pg->counts, lockdep_is_held(&pg->lock));
+		if (WARN_ON_ONCE(!current_counts || !current_counts->counts[pg_off])) {
 			spin_unlock_irqrestore(&pg->lock, flags);
 			continue;
 		}
 
-		pg->counts[pg_off]--;
+		WRITE_ONCE(current_counts->counts[pg_off], current_counts->counts[pg_off] - 1);
 		pg->active--;
 		if (!pg->active) {
-			counts = pg->counts;
-			pg->counts = NULL;
+			counts = current_counts;
+			rcu_assign_pointer(pg->counts, NULL);
 		}
 		spin_unlock_irqrestore(&pg->lock, flags);
 
 		if (counts)
-			mempool_free(counts, &dc->bypass_mempool);
+			call_rcu(&counts->rcu, bch_bypass_counts_free_rcu);
 	}
 }
 
@@ -924,20 +940,19 @@ static bool bch_has_active_bypass_writes(struct cached_dev *dc, sector_t sector,
 	if (WARN_ON_ONCE(end_pg_idx >= dc->bypass_num_pages))
 		return false;
 
+	rcu_read_lock();
 	for (chunk = start_chunk; chunk <= end_chunk; chunk++) {
 		unsigned long pg_idx = bypass_chunk_to_page(chunk);
 		unsigned long pg_off = bypass_chunk_to_offset(chunk);
 		struct bch_bypass_page *pg = &dc->bypass_pages[pg_idx];
-		unsigned long flags;
+		struct bch_bypass_counts *current_counts = rcu_dereference(pg->counts);
 
-		spin_lock_irqsave(&pg->lock, flags);
-		if (pg->counts && pg->counts[pg_off] > 0) {
+		if (current_counts && READ_ONCE(current_counts->counts[pg_off]) > 0) {
 			has_active = true;
-			spin_unlock_irqrestore(&pg->lock, flags);
 			break;
 		}
-		spin_unlock_irqrestore(&pg->lock, flags);
 	}
+	rcu_read_unlock();
 
 	return has_active;
 }
@@ -1458,6 +1473,7 @@ void bch_flash_dev_request_init(struct bcache_device *d)
 
 void bch_request_exit(void)
 {
+	kmem_cache_destroy(bch_bypass_cache);
 	kmem_cache_destroy(bch_search_cache);
 }
 
@@ -1467,5 +1483,9 @@ int __init bch_request_init(void)
 	if (!bch_search_cache)
 		return -ENOMEM;
 
+	bch_bypass_cache = KMEM_CACHE(bch_bypass_counts, 0);
+	if (!bch_bypass_cache)
+		return -ENOMEM;
+
 	return 0;
 }
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index b994483511de..75aa6bb2e00b 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1350,9 +1350,12 @@ void bch_cached_dev_release(struct kobject *kobj)
 		unsigned long i;
 
 		for (i = 0; i < dc->bypass_num_pages; i++) {
-			if (dc->bypass_pages[i].counts)
-				mempool_free(dc->bypass_pages[i].counts, &dc->bypass_mempool);
+			struct bch_bypass_counts *counts =
+				rcu_dereference_protected(dc->bypass_pages[i].counts, 1);
+			if (counts)
+				mempool_free(counts, &dc->bypass_mempool);
 		}
+		rcu_barrier();
 		kvfree(dc->bypass_pages);
 		mempool_exit(&dc->bypass_mempool);
 	}
@@ -1433,7 +1436,7 @@ static int bch_cached_dev_bypass_init(struct cached_dev *dc, sector_t sectors)
 	for (i = 0; i < dc->bypass_num_pages; i++)
 		spin_lock_init(&dc->bypass_pages[i].lock);
 
-	if (mempool_init_kmalloc_pool(&dc->bypass_mempool, 16, PAGE_SIZE)) {
+	if (mempool_init_slab_pool(&dc->bypass_mempool, 16, bch_bypass_cache)) {
 		kvfree(dc->bypass_pages);
 		dc->bypass_pages = NULL;
 		return -ENOMEM;
-- 
2.55.0.679.g6767b8d81c-goog

