Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14527420898
	for <linux-bcache@vger.kernel.org>; Mon,  6 Jul 2026 13:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783343085; cv=none; b=Q1qxxrF6J4DHpow8wcVC6rMdCavfAogdC/32LG5YrlpROhju6ydJ3JxhmywUCCIrh2Cifz3fvOmFV0+OBePCgRF0Q1FUNHMfIEFs+fQUBoci70zXJ21CzGiyZalKRf49R0/wKWpHXh7WP123IpbBory/UZ5TvzeP1kz/eFje7jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783343085; c=relaxed/simple;
	bh=GL6Ug8R9aswjNDEdEAUZRfjsj3BHSQAUKEh1DaYXfk8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=nqW1XrL9RAEtp2UiK7ixpJ311sbQJJ7wBCKCJ/gKDsg3YNVxeoj5HBvBvXhn2xpPZX1y9CXZToH6iapzzya7y4KHPBnPJE+5rkyXcjuTUY1A5jLnf+1N7B7YEBaU6zCc6WqkVnejHvVYLv5NE01VA7BGZdc+k6l13BbqyZYv/rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mM70m4BY; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mM70m4BY"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-847a483e344so2436214b3a.0
        for <linux-bcache@vger.kernel.org>; Mon, 06 Jul 2026 06:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783343082; x=1783947882; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mcEN1eGtxAxqcI4LDOOMOKU/80Ta5pWXTrgc6ilbpMI=;
        b=mM70m4BYaxLu2Cx8T6EZKunx9dFYdezRjVJFllR3ToKgugodTgjkB5/ZhMpHCTi7+V
         kGUHVnaAafV+yycPtJ3TpPUPdmwSX8yduOb/0nL6l6IHt3xRHi6XkZRkJZ8OQnIgCJuU
         G5fbnxLiduF/h17hlRa+i9lm+Lm4sLowaXxJnXkywsoY6fj1YqW5v7fqyYmbNsASukxl
         paieDEfFxA+hBqmZuML5xwvDUTvcaOsQNwuh4fbm2wN9UMF07cxNxFKA23dXuPPyucA3
         8mOp8s5IbX54jOPo9N48tKG041QzCYALguTQs3gu58+Dpxv0JJEi9MIXqRsVyoNRZlbD
         ETdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783343082; x=1783947882;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mcEN1eGtxAxqcI4LDOOMOKU/80Ta5pWXTrgc6ilbpMI=;
        b=WP7GRTkoiJD3fWBjKCEuFZEkwNuyYMxlQTjaEt6j7SM/++mYb+PExO+aU9T55qfmUM
         WQhx6O0ErMd4d9tjugKLTks/xUJKrklxmDAOrzxBDCcfy1ZkuU2g1lCmDCNalpqKzTbm
         xT5Lvff00cuWryvSYBkkhf38sm6cASjB9w7tJtQqKrJ6vXRDvzwOz6sXTF96ImI2VRW7
         gXSJx1HJT+gGppE2zeyzKtFSa7pUe/IBU4ARhPt0qLz4lq2zskcHrT2KsVWIY4YuED0M
         nL8XtuqsXvMeCRwf+9Ebm+Nczo4U8lB61duaeAa4u8X8X0QlkuOTpUy+JbE1DwR2vU58
         xSTw==
X-Forwarded-Encrypted: i=1; AHgh+RpLR/vq5+yZt7z9eLIUnz89yvGtRrDvyIj04jmetltWIxg4oiOQ4e+X2TRD46dU4fqyu7u/tpvvs+lO3wI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfunTO0J4a2/QrUSdUumGDd+WaSZDjskledlJVWN+MzTwnqNpn
	385JMYbywdqMWacTCAiVkNTpUX3OZ+BlubqX9NPwXBhzCaPBSht1oZCM
X-Gm-Gg: AfdE7cmIwrPhVjIdX3ueQMV1m36WV9h+ZosU7Fe0AtQY2Oxr4EHvkhm59mrSWTCkBfv
	gNF7R6RM7+ibnHTSXDfDGLKta/VuzxmLEC4aSAw9bk8khBRESUweM9GymsKnM9H8kHJuoAgPwJX
	Z1cVgXFOnx9U0Z8eeRnDtL/HnaArRlrDrSa2ZMN26l0zZLbd/cE4Z4IVpIJeIhloG8RbpQbJ4yM
	ImJK39keY4beBqRt5d2p27in0dwDELXYAn0RjRHsNzT98j+/amCGIC29+B+ce7obaL699BCz1fO
	ajTzJK232TXda5lRNMQOOEhQFTmtu6NRGYRbD8xdFCPiAMRuMVs+RxQeloFpNu8YrhbuPFTkcWo
	rodzdhgE6qnUFrcpkAGr2dx+2pRxVcpt8kf1PItVwckMf3mp9hL5RJcNF+4iqQxLJWaPyZtDC5k
	5X+PMn56WSfsV1bp1ZvrLGiA==
X-Received: by 2002:a05:6a00:3d4c:b0:845:ebe6:417d with SMTP id d2e1a72fcca58-84826227057mr491361b3a.24.1783343082170;
        Mon, 06 Jul 2026 06:04:42 -0700 (PDT)
Received: from [127.0.1.1] ([138.199.21.246])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6d4dbdesm3788790b3a.31.2026.07.06.06.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 06:04:41 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Mon, 06 Jul 2026 21:04:38 +0800
Subject: [PATCH RESEND v2] bcache: convert bch_register_lock to
 rw_semaphore
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260706-feat-bcache-v2-1-70a4b6e246c0@gmail.com>
X-B4-Tracking: v=1; b=H4sIAOWnS2oC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyjHQUlJIzE
 vPSU3UzU4B8JSMDIzMDcwMz3bTUxBLdpOTE5IxUXWODVEszk0RD85QUIyWgjoKi1LTMCrBp0Up
 BrsGufi5KsbW1ADeaRXVlAAAA
To: Coly Li <colyli@fygo.io>, Kent Overstreet <kent.overstreet@linux.dev>
Cc: Coly Li <colyli@fnnas.com>, linux-bcache@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Qiliang Yuan <yuanql9@chinatelecom.cn>, 
 Jing Wu <realwujing@gmail.com>
X-Mailer: b4 0.13.0

Refactor the global bch_register_lock from a mutex to an rw_semaphore to
reduce lock contention and hung tasks (State D) during large-scale bcache
device registration and concurrent sysfs access.

The core change converts the mutex to an rw_semaphore with the following
locking strategy:
- Read lock (down_read): sysfs show (read) operations that only inspect
  state. These can now run concurrently with each other.
- Write lock (down_write): all sysfs store (write) operations, device
  registration/unregistration, attach/detach, reboot, and other paths
  that modify bcache state. These retain exclusive access.

This approach allows concurrent sysfs reads (the most frequent
operations) while maintaining exclusive access for state modifications.

Representative call trace from production logs:
[  243.082130] INFO: task bcache_cache_se:3496 blocked for more than 121 seconds.
[  243.130817] Call trace:
[  243.134161]  __switch_to+0x7c/0xbc
[  243.138461]  __schedule+0x338/0x6f0
[  243.142847]  schedule+0x50/0xe0
[  243.146884]  schedule_preempt_disabled+0x18/0x24
[  243.152400]  __mutex_lock.constprop.0+0x1d4/0x5ec
[  243.158002]  __mutex_lock_slowpath+0x1c/0x30
[  243.163170]  mutex_lock+0x50/0x60
[  243.167397]  bch_cache_set_store+0x40/0x80 [bcache]

Co-developed-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
Signed-off-by: Jing Wu <realwujing@gmail.com>
---
Refactor the global bch_register_lock from a mutex to an rw_semaphore to
reduce lock contention and hung tasks (State D) during large-scale bcache
device registration and concurrent sysfs access.

No code changes since v2. Resending for review since v2 has not received
any feedback yet; v2 already addressed the regression Coly pointed out
in v1 (race window in run_cache_set() between up_read()/down_write()).
---
V1 -> V2:
- Remove downgrade_write()/up_read()/down_write() lock manipulation in
  run_cache_set() to eliminate race window during partial initialization
  that could lead to use-after-free if unregister is triggered between
  up_read() and down_write(). Keep write lock held throughout instead.
  (Coly)
- Simplify all sysfs store wrappers to unconditionally use down_write()
  instead of per-attribute read/write lock selection, which was fragile
  and could miss newly added attributes.
- Fix STORE_LOCKED macro to use down_write()/up_write() for store
  operations (was incorrectly using down_read()/up_read()).
- Expand bch_flash_dev store from STORE_LOCKED macro to explicit
  wrapper with down_write() and bcache_is_reboot check.
- Fix whitespace indentation in bcache_init() error path.
- Note on KABI: bch_register_lock is a module-internal global variable
  with no EXPORT_SYMBOL in the entire bcache driver. Changing its type
  from struct mutex to struct rw_semaphore does not affect the kernel
  ABI, as the symbol is never exported to other modules.

v1: https://lore.kernel.org/r/20260318-wujing-bcache-v1-1-f0b9aaf3f81d@gmail.com
---
 drivers/md/bcache/bcache.h  |  2 +-
 drivers/md/bcache/request.c | 18 ++++++-------
 drivers/md/bcache/super.c   | 64 +++++++++++++++++++++----------------------
 drivers/md/bcache/sysfs.c   | 66 ++++++++++++++++++++++++++++++++++++++++-----
 drivers/md/bcache/sysfs.h   |  8 +++---
 5 files changed, 105 insertions(+), 53 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index ec9ff97150812..544f514376016 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -1012,7 +1012,7 @@ void bch_write_bdev_super(struct cached_dev *dc, struct closure *parent);
 extern struct workqueue_struct *bcache_wq;
 extern struct workqueue_struct *bch_journal_wq;
 extern struct workqueue_struct *bch_flush_wq;
-extern struct mutex bch_register_lock;
+extern struct rw_semaphore bch_register_lock;
 extern struct list_head bch_cache_sets;
 
 extern const struct kobj_type bch_cached_dev_ktype;
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 3fa3b13a410f4..b39c127c4751b 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1135,15 +1135,15 @@ static void quit_max_writeback_rate(struct cache_set *c,
 	struct cached_dev *dc;
 
 	/*
-	 * mutex bch_register_lock may compete with other parallel requesters,
-	 * or attach/detach operations on other backing device. Waiting to
-	 * the mutex lock may increase I/O request latency for seconds or more.
-	 * To avoid such situation, if mutext_trylock() failed, only writeback
-	 * rate of current cached device is set to 1, and __update_write_back()
-	 * will decide writeback rate of other cached devices (remember now
-	 * c->idle_counter is 0 already).
+	 * rw_semaphore bch_register_lock may compete with other parallel
+	 * requesters, or attach/detach operations on other backing device.
+	 * Waiting to the semaphore lock may increase I/O request latency
+	 * for seconds or more. To avoid such situation, if down_write_trylock()
+	 * failed, only writeback rate of current cached device is set to 1,
+	 * and __update_write_back() will decide writeback rate of other
+	 * cached devices (remember now c->idle_counter is 0 already).
 	 */
-	if (mutex_trylock(&bch_register_lock)) {
+	if (down_write_trylock(&bch_register_lock)) {
 		for (i = 0; i < c->devices_max_used; i++) {
 			if (!c->devices[i])
 				continue;
@@ -1160,7 +1160,7 @@ static void quit_max_writeback_rate(struct cache_set *c,
 			 */
 			atomic_long_set(&dc->writeback_rate.rate, 1);
 		}
-		mutex_unlock(&bch_register_lock);
+		up_write(&bch_register_lock);
 	} else
 		atomic_long_set(&this_dc->writeback_rate.rate, 1);
 }
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 97d9adb0bf96b..87cbb0750ca8b 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -40,7 +40,7 @@ static const char invalid_uuid[] = {
 };
 
 static struct kobject *bcache_kobj;
-struct mutex bch_register_lock;
+struct rw_semaphore bch_register_lock;
 bool bcache_is_reboot;
 LIST_HEAD(bch_cache_sets);
 static LIST_HEAD(uncached_devices);
@@ -1155,7 +1155,7 @@ static void cached_dev_detach_finish(struct work_struct *w)
 		dc->writeback_thread = NULL;
 	}
 
-	mutex_lock(&bch_register_lock);
+	down_write(&bch_register_lock);
 
 	bcache_device_detach(&dc->disk);
 	list_move(&dc->list, &uncached_devices);
@@ -1164,7 +1164,7 @@ static void cached_dev_detach_finish(struct work_struct *w)
 	clear_bit(BCACHE_DEV_DETACHING, &dc->disk.flags);
 	clear_bit(BCACHE_DEV_UNLINK_DONE, &dc->disk.flags);
 
-	mutex_unlock(&bch_register_lock);
+	up_write(&bch_register_lock);
 
 	pr_info("Caching disabled for %pg\n", dc->bdev);
 
@@ -1362,7 +1362,7 @@ static CLOSURE_CALLBACK(cached_dev_free)
 	if (!IS_ERR_OR_NULL(dc->status_update_thread))
 		kthread_stop(dc->status_update_thread);
 
-	mutex_lock(&bch_register_lock);
+	down_write(&bch_register_lock);
 
 	if (atomic_read(&dc->running)) {
 		bd_unlink_disk_holder(dc->bdev, dc->disk.disk);
@@ -1371,7 +1371,7 @@ static CLOSURE_CALLBACK(cached_dev_free)
 	bcache_device_free(&dc->disk);
 	list_del(&dc->list);
 
-	mutex_unlock(&bch_register_lock);
+	up_write(&bch_register_lock);
 
 	/*
 	 * Wait for any pending sb_write to complete before free.
@@ -1397,9 +1397,9 @@ static CLOSURE_CALLBACK(cached_dev_flush)
 	closure_type(dc, struct cached_dev, disk.cl);
 	struct bcache_device *d = &dc->disk;
 
-	mutex_lock(&bch_register_lock);
+	down_write(&bch_register_lock);
 	bcache_device_unlink(d);
-	mutex_unlock(&bch_register_lock);
+	up_write(&bch_register_lock);
 
 	bch_cache_accounting_destroy(&dc->accounting);
 	kobject_del(&d->kobj);
@@ -1512,12 +1512,12 @@ static CLOSURE_CALLBACK(flash_dev_free)
 {
 	closure_type(d, struct bcache_device, cl);
 
-	mutex_lock(&bch_register_lock);
+	down_write(&bch_register_lock);
 	atomic_long_sub(bcache_dev_sectors_dirty(d),
 			&d->c->flash_dev_dirty_sectors);
 	del_gendisk(d->disk);
 	bcache_device_free(d);
-	mutex_unlock(&bch_register_lock);
+	up_write(&bch_register_lock);
 	kobject_put(&d->kobj);
 }
 
@@ -1525,9 +1525,9 @@ static CLOSURE_CALLBACK(flash_dev_flush)
 {
 	closure_type(d, struct bcache_device, cl);
 
-	mutex_lock(&bch_register_lock);
+	down_write(&bch_register_lock);
 	bcache_device_unlink(d);
-	mutex_unlock(&bch_register_lock);
+	up_write(&bch_register_lock);
 	kobject_del(&d->kobj);
 	continue_at(cl, flash_dev_free, system_percpu_wq);
 }
@@ -1689,7 +1689,7 @@ static CLOSURE_CALLBACK(cache_set_free)
 	bch_btree_cache_free(c);
 	bch_journal_free(c);
 
-	mutex_lock(&bch_register_lock);
+	down_write(&bch_register_lock);
 	bch_bset_sort_state_free(&c->sort);
 	free_pages((unsigned long) c->uuids, ilog2(meta_bucket_pages(&c->cache->sb)));
 
@@ -1710,7 +1710,7 @@ static CLOSURE_CALLBACK(cache_set_free)
 	kfree(c->devices);
 
 	list_del(&c->list);
-	mutex_unlock(&bch_register_lock);
+	up_write(&bch_register_lock);
 
 	pr_info("Cache set %pU unregistered\n", c->set_uuid);
 	wake_up(&unregister_wait);
@@ -1828,7 +1828,7 @@ static CLOSURE_CALLBACK(__cache_set_unregister)
 	struct bcache_device *d;
 	size_t i;
 
-	mutex_lock(&bch_register_lock);
+	down_write(&bch_register_lock);
 
 	for (i = 0; i < c->devices_max_used; i++) {
 		d = c->devices[i];
@@ -1846,7 +1846,7 @@ static CLOSURE_CALLBACK(__cache_set_unregister)
 		}
 	}
 
-	mutex_unlock(&bch_register_lock);
+	up_write(&bch_register_lock);
 
 	continue_at(cl, cache_set_flush, system_percpu_wq);
 }
@@ -2424,9 +2424,9 @@ static int register_cache(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
 		goto out;
 	}
 
-	mutex_lock(&bch_register_lock);
+	down_write(&bch_register_lock);
 	err = register_cache_set(ca);
-	mutex_unlock(&bch_register_lock);
+	up_write(&bch_register_lock);
 
 	if (err) {
 		ret = -ENODEV;
@@ -2501,11 +2501,11 @@ static void register_bdev_worker(struct work_struct *work)
 	struct async_reg_args *args =
 		container_of(work, struct async_reg_args, reg_work.work);
 
-	mutex_lock(&bch_register_lock);
+	down_write(&bch_register_lock);
 	if (register_bdev(args->sb, args->sb_disk, args->bdev_file,
 			  args->holder) < 0)
 		fail = true;
-	mutex_unlock(&bch_register_lock);
+	up_write(&bch_register_lock);
 
 	if (fail)
 		pr_info("error %s: fail to register backing device\n",
@@ -2620,13 +2620,13 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 		if (ret == -EBUSY) {
 			dev_t dev;
 
-			mutex_lock(&bch_register_lock);
+			down_write(&bch_register_lock);
 			if (lookup_bdev(strim(path), &dev) == 0 &&
 			    bch_is_open(dev))
 				err = "device already registered";
 			else
 				err = "device busy";
-			mutex_unlock(&bch_register_lock);
+			up_write(&bch_register_lock);
 			if (attr == &ksysfs_register_quiet) {
 				quiet = true;
 				ret = size;
@@ -2659,9 +2659,9 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 	}
 
 	if (SB_IS_BDEV(sb)) {
-		mutex_lock(&bch_register_lock);
+		down_write(&bch_register_lock);
 		ret = register_bdev(sb, sb_disk, bdev_file, holder);
-		mutex_unlock(&bch_register_lock);
+		up_write(&bch_register_lock);
 		/* blkdev_put() will be called in cached_dev_free() */
 		if (ret < 0)
 			goto out_free_sb;
@@ -2715,7 +2715,7 @@ static ssize_t bch_pending_bdevs_cleanup(struct kobject *k,
 	struct pdev *pdev, *tpdev;
 	struct cache_set *c, *tc;
 
-	mutex_lock(&bch_register_lock);
+	down_write(&bch_register_lock);
 	list_for_each_entry_safe(dc, tdc, &uncached_devices, list) {
 		pdev = kmalloc_obj(struct pdev);
 		if (!pdev)
@@ -2736,7 +2736,7 @@ static ssize_t bch_pending_bdevs_cleanup(struct kobject *k,
 			}
 		}
 	}
-	mutex_unlock(&bch_register_lock);
+	up_write(&bch_register_lock);
 
 	list_for_each_entry_safe(pdev, tpdev, &pending_devs, list) {
 		pr_info("delete pdev %p\n", pdev);
@@ -2763,7 +2763,7 @@ static int bcache_reboot(struct notifier_block *n, unsigned long code, void *x)
 		struct cache_set *c, *tc;
 		struct cached_dev *dc, *tdc;
 
-		mutex_lock(&bch_register_lock);
+		down_write(&bch_register_lock);
 
 		if (bcache_is_reboot)
 			goto out;
@@ -2780,7 +2780,7 @@ static int bcache_reboot(struct notifier_block *n, unsigned long code, void *x)
 		    list_empty(&uncached_devices))
 			goto out;
 
-		mutex_unlock(&bch_register_lock);
+		up_write(&bch_register_lock);
 
 		pr_info("Stopping all devices:\n");
 
@@ -2815,7 +2815,7 @@ static int bcache_reboot(struct notifier_block *n, unsigned long code, void *x)
 		while (1) {
 			long timeout = start + 10 * HZ - jiffies;
 
-			mutex_lock(&bch_register_lock);
+			down_write(&bch_register_lock);
 			stopped = list_empty(&bch_cache_sets) &&
 				list_empty(&uncached_devices);
 
@@ -2825,7 +2825,7 @@ static int bcache_reboot(struct notifier_block *n, unsigned long code, void *x)
 			prepare_to_wait(&unregister_wait, &wait,
 					TASK_UNINTERRUPTIBLE);
 
-			mutex_unlock(&bch_register_lock);
+			up_write(&bch_register_lock);
 			schedule_timeout(timeout);
 		}
 
@@ -2836,7 +2836,7 @@ static int bcache_reboot(struct notifier_block *n, unsigned long code, void *x)
 		else
 			pr_notice("Timeout waiting for devices to be closed\n");
 out:
-		mutex_unlock(&bch_register_lock);
+		up_write(&bch_register_lock);
 	}
 
 	return NOTIFY_DONE;
@@ -2864,7 +2864,6 @@ static void bcache_exit(void)
 	if (bcache_major)
 		unregister_blkdev(bcache_major, "bcache");
 	unregister_reboot_notifier(&reboot);
-	mutex_destroy(&bch_register_lock);
 }
 
 /* Check and fixup module parameters */
@@ -2904,14 +2903,13 @@ static int __init bcache_init(void)
 
 	check_module_parameters();
 
-	mutex_init(&bch_register_lock);
+	init_rwsem(&bch_register_lock);
 	init_waitqueue_head(&unregister_wait);
 	register_reboot_notifier(&reboot);
 
 	bcache_major = register_blkdev(0, "bcache");
 	if (bcache_major < 0) {
 		unregister_reboot_notifier(&reboot);
-		mutex_destroy(&bch_register_lock);
 		return bcache_major;
 	}
 
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index cfac56caa8047..553c15667a2d4 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -285,7 +285,26 @@ SHOW(__bch_cached_dev)
 #undef var
 	return 0;
 }
-SHOW_LOCKED(bch_cached_dev)
+SHOW(bch_cached_dev)
+{
+	struct cached_dev *dc = container_of(kobj, struct cached_dev,
+					     disk.kobj);
+	ssize_t ret;
+
+	/*
+	 * Statistics attributes like dirty_data read atomic variables and
+	 * can be shown without holding the global bch_register_lock.
+	 */
+	if (attr == &sysfs_dirty_data ||
+	    attr == &sysfs_writeback_rate_debug)
+		return __bch_cached_dev_show(kobj, attr, buf);
+
+	down_read(&bch_register_lock);
+	ret = __bch_cached_dev_show(kobj, attr, buf);
+	up_read(&bch_register_lock);
+
+	return ret;
+}
 
 STORE(__cached_dev)
 {
@@ -462,7 +481,8 @@ STORE(bch_cached_dev)
 	if (bcache_is_reboot)
 		return -EBUSY;
 
-	mutex_lock(&bch_register_lock);
+	down_write(&bch_register_lock);
+
 	size = __cached_dev_store(kobj, attr, buf, size);
 
 	if (attr == &sysfs_writeback_running) {
@@ -495,7 +515,8 @@ STORE(bch_cached_dev)
 			schedule_delayed_work(&dc->writeback_rate_update,
 				      dc->writeback_rate_update_seconds * HZ);
 
-	mutex_unlock(&bch_register_lock);
+	up_write(&bch_register_lock);
+
 	return size;
 }
 
@@ -598,7 +619,18 @@ STORE(__bch_flash_dev)
 
 	return size;
 }
-STORE_LOCKED(bch_flash_dev)
+STORE(bch_flash_dev)
+{
+	/* no user space access if system is rebooting */
+	if (bcache_is_reboot)
+		return -EBUSY;
+
+	down_write(&bch_register_lock);
+	size = __bch_flash_dev_store(kobj, attr, buf, size);
+	up_write(&bch_register_lock);
+
+	return size;
+}
 
 static struct attribute *bch_flash_dev_attrs[] = {
 	&sysfs_unregister,
@@ -806,7 +838,16 @@ SHOW(__bch_cache_set)
 
 	return 0;
 }
-SHOW_LOCKED(bch_cache_set)
+SHOW(bch_cache_set)
+{
+	ssize_t ret;
+
+	down_read(&bch_register_lock);
+	ret = __bch_cache_set_show(kobj, attr, buf);
+	up_read(&bch_register_lock);
+
+	return ret;
+}
 
 STORE(__bch_cache_set)
 {
@@ -927,7 +968,20 @@ STORE(__bch_cache_set)
 
 	return size;
 }
-STORE_LOCKED(bch_cache_set)
+STORE(bch_cache_set)
+{
+	ssize_t ret;
+
+	/* no user space access if system is rebooting */
+	if (bcache_is_reboot)
+		return -EBUSY;
+
+	down_write(&bch_register_lock);
+	ret = __bch_cache_set_store(kobj, attr, buf, size);
+	up_write(&bch_register_lock);
+
+	return ret;
+}
 
 SHOW(bch_cache_set_internal)
 {
diff --git a/drivers/md/bcache/sysfs.h b/drivers/md/bcache/sysfs.h
index 65b8bd975ab1e..d897325677d57 100644
--- a/drivers/md/bcache/sysfs.h
+++ b/drivers/md/bcache/sysfs.h
@@ -24,9 +24,9 @@ static ssize_t fn ## _store(struct kobject *kobj, struct attribute *attr,\
 SHOW(fn)								\
 {									\
 	ssize_t ret;							\
-	mutex_lock(&bch_register_lock);					\
+	down_read(&bch_register_lock);					\
 	ret = __ ## fn ## _show(kobj, attr, buf);			\
-	mutex_unlock(&bch_register_lock);				\
+	up_read(&bch_register_lock);				\
 	return ret;							\
 }
 
@@ -34,9 +34,9 @@ SHOW(fn)								\
 STORE(fn)								\
 {									\
 	ssize_t ret;							\
-	mutex_lock(&bch_register_lock);					\
+	down_write(&bch_register_lock);					\
 	ret = __ ## fn ## _store(kobj, attr, buf, size);		\
-	mutex_unlock(&bch_register_lock);				\
+	up_write(&bch_register_lock);				\
 	return ret;							\
 }
 

---
base-commit: 502d801f0ab03e4f32f9a33d203154ce84887921
change-id: 20260706-feat-bcache-30e964a17dd2

Best regards,
-- 
Jing Wu <realwujing@gmail.com>

