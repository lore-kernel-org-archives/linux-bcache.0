Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4541D3537DA
	for <linux-bcache@vger.kernel.org>; Wed, 18 Mar 2026 07:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773820383; cv=none; b=bpSun3TNZ/ggpanXj8jTKSy2Xs5LqY/HmgdIKgAZeTxcL+Ux0dF5t20og2DFjmXQjzsfpln3QB5ycvS+J1v+61cyKKILTybsnTkeZ2CP/y61KvhJkNiZdVGMYXgCzy+HKWEw0KrsvNpBGiPb9qxVcef0NeUIcY+BhZXj8jM/GPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773820383; c=relaxed/simple;
	bh=iUsNzNGlOUjgfwbj0hzM1wDqa3hF7+28cX07Ddu4Qjs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=qs2JPOgC+aTyxsuSwhPvqSAkzSeSXOJNI7JFUdiLNagt7cfQWW+PcO46SdtS95r4lvm3Qw3ZYIfqLMKK5b41aNCs/5snT786bbBCEFVjM9d8PLlXQkXZeBqNV1xzJnQ/WvBIpKzn9KVvQPApZOGgpj6affbK8nQSQK+jwmRf2m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D1lkGKIB; arc=none smtp.client-ip=74.125.82.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D1lkGKIB"
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-2bdcf5970cdso532978eec.0
        for <linux-bcache@vger.kernel.org>; Wed, 18 Mar 2026 00:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773820381; x=1774425181; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ScKc2Pflo1uvLlUk/jN8+wzFHf81p4mamY2h3zBpJ4g=;
        b=D1lkGKIBBqVDrRIajtPeurzr/0NWHU0iEEFHzR4n+oDJr7x198+OvGmLsZwKQbwnVc
         ZsmGIzq0foTHjuS+opYFsEJNZ9lr7ZjQXa7McLf/ZCJv2U7BIVMI41NyLFWNQOy3FtpT
         L2hwZjo91stZ1fuW+A3ypVQZ36yExPPmwHpeVH5yJq+7Zq8vnWaQ/rb9uL+TurUGg0+y
         Nb5nRaZTHQy85FvmXwhO5Et8aKYI1h2NvTrkSRRGIEqhywXT37WGSBuOF1o1IoKhUOV+
         bGQ71JYhypCHmj+3BMPnVUEUvPRRwU01Q4q3b/mM6yG03WnAXvcrgmPVQuAZ+3JtgUxb
         k6Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773820381; x=1774425181;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ScKc2Pflo1uvLlUk/jN8+wzFHf81p4mamY2h3zBpJ4g=;
        b=rWXKCLd3qvYtSyAme+ihVmy4B21P4rNWkxRrV2xu2/jGyyjwRdAinUlGJ6P1olleer
         57KrcT6PwHLsImpredZZbszpLZNBYJ1CVORzjbQVIKcZAAIu95upwKYUlHBGXZ24BpZM
         rpZFjFTjAJX2cuwBkxwVKAatQ2hvIA+8HHdLZs0UffFfePNWrCz+n3IJSwwBL8eyYgFc
         CuGCxaYFna2vIBuUv4YRjQLYumnxP7XtcCyoK+kiR2XSaf4QYsIHLZORbSJQFRgjOng/
         xGiPnrkn1GqnmRfbLZ5Lgf5N1NO0ZTpojJ5GjaSaRVEJ9nvNP8PIyeKuClDCOVuHZXYN
         zrCw==
X-Gm-Message-State: AOJu0YyFyukEx34LoiKmBfQ1VyjdPG9SeSv8Q5gvCxhpI/UOA+gy9GUx
	+P8mGsd3GqQVhQV66Z0GLMFu70zbp/htc9nlbrUsJa5/lCVEGJXyTl4z
X-Gm-Gg: ATEYQzw17lzEJtWa0rhF+Sxe1b6ynEiY8J6qndeqyuumWQ4gkZ/0cIHy1owvNUi/3Go
	qvJuWfILR8MrDs7qJrsCn9mvAsYBTOYlckt3o7Zg4Dp3lzMXtFAeUo0DVbkkMrDj4hdozAW7F4/
	qEJLgsdY6trbm4MMWmw7usG7lNBqz24fn1RXtki5YVZvsZsrJgUSz+e0RtY5xDhFSkE+DWm9DB7
	WMj9fpF3xCe0Q/rVyrOzHxBXYYpaMmB4bviE6aBPLJutGaVbZWWbC2MgxMKPz4lBU4jb+hxb8hG
	+azbEi7+hlXnwupLOQb+NNBOTdKcOKEXxuVMZUlwlPM4aS0I2tkIEwUJ1HFldFxOqUz1mu/1t4c
	3iSjNMPloxbNCI+lTYuoUzynpGm3pG9+rLyJYPj9Jn/brEyQ9z5+ZZGX1R4hA3yqYKZ4zIMtz0i
	z9cKo/EYay8kSnlORT
X-Received: by 2002:a05:7300:2214:b0:2be:17b1:e49f with SMTP id 5a478bee46e88-2c0d507c829mr2462388eec.4.1773820381066;
        Wed, 18 Mar 2026 00:53:01 -0700 (PDT)
Received: from wujing. ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2c0e53b5fa1sm3487280eec.10.2026.03.18.00.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 00:53:00 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Wed, 18 Mar 2026 15:52:46 +0800
Subject: [PATCH] bcache: convert bch_register_lock to rw_semaphore
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260318-wujing-bcache-v1-1-f0b9aaf3f81d@gmail.com>
X-B4-Tracking: v=1; b=H4sIAM5ZumkC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDY0ML3fLSrMy8dN2k5MTkjFTdVLOkZOOkFOO0NHNzJaCegqLUtMwKsHn
 RsbW1ABDZQJ5fAAAA
To: Coly Li <colyli@fnnas.com>, Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Qiliang Yuan <realwujing@gmail.com>
X-Mailer: b4 0.13.0

Refactor the global bch_register_lock from a mutex to an rw_semaphore to
resolve severe lock contention and hung tasks (State D) during large-scale
bcache device registration and concurrent sysfs access.

Representative call trace from logs:
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
[  243.173175]  sysfs_kf_write+0x4c/0x5c
[  243.177735]  kernfs_fop_write_iter+0x130/0x1c0
[  243.183077]  new_sync_write+0xec/0x18c
[  243.187724]  vfs_write+0x214/0x2ac
[  243.192022]  ksys_write+0x70/0xfc
[  243.196234]  __arm64_sys_write+0x24/0x30
[  243.201057]  invoke_syscall+0x50/0x11c
[  243.205705]  el0_svc_common.constprop.0+0x158/0x164
[  243.211483]  do_el0_svc+0x2c/0x9c
[  243.215696]  el0_svc+0x20/0x30
[  243.219648]  el0_sync_handler+0xb0/0xb4
[  243.224384]  el0_sync+0x160/0x180

This addresses the long-standing issue where a single slow bcache device
initialization could block the entire system's bcache management path.

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
---
 drivers/md/bcache/bcache.h  |  2 +-
 drivers/md/bcache/request.c | 18 +++++-----
 drivers/md/bcache/super.c   | 85 +++++++++++++++++++++++++--------------------
 drivers/md/bcache/sysfs.c   | 82 ++++++++++++++++++++++++++++++++++++++++---
 drivers/md/bcache/sysfs.h   |  8 ++---
 5 files changed, 139 insertions(+), 56 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 8ccacba855475..7ab36987e945b 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -1003,7 +1003,7 @@ void bch_write_bdev_super(struct cached_dev *dc, struct closure *parent);
 extern struct workqueue_struct *bcache_wq;
 extern struct workqueue_struct *bch_journal_wq;
 extern struct workqueue_struct *bch_flush_wq;
-extern struct mutex bch_register_lock;
+extern struct rw_semaphore bch_register_lock;
 extern struct list_head bch_cache_sets;
 
 extern const struct kobj_type bch_cached_dev_ktype;
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 82fdea7dea7aa..3062ea2c6b312 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1149,15 +1149,15 @@ static void quit_max_writeback_rate(struct cache_set *c,
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
@@ -1174,7 +1174,7 @@ static void quit_max_writeback_rate(struct cache_set *c,
 			 */
 			atomic_long_set(&dc->writeback_rate.rate, 1);
 		}
-		mutex_unlock(&bch_register_lock);
+		up_write(&bch_register_lock);
 	} else
 		atomic_long_set(&this_dc->writeback_rate.rate, 1);
 }
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index c17d4517af22c..187069a7262b9 100644
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
@@ -1147,7 +1147,7 @@ static void cached_dev_detach_finish(struct work_struct *w)
 		dc->writeback_thread = NULL;
 	}
 
-	mutex_lock(&bch_register_lock);
+	down_write(&bch_register_lock);
 
 	bcache_device_detach(&dc->disk);
 	list_move(&dc->list, &uncached_devices);
@@ -1156,7 +1156,7 @@ static void cached_dev_detach_finish(struct work_struct *w)
 	clear_bit(BCACHE_DEV_DETACHING, &dc->disk.flags);
 	clear_bit(BCACHE_DEV_UNLINK_DONE, &dc->disk.flags);
 
-	mutex_unlock(&bch_register_lock);
+	up_write(&bch_register_lock);
 
 	pr_info("Caching disabled for %pg\n", dc->bdev);
 
@@ -1354,7 +1354,7 @@ static CLOSURE_CALLBACK(cached_dev_free)
 	if (!IS_ERR_OR_NULL(dc->status_update_thread))
 		kthread_stop(dc->status_update_thread);
 
-	mutex_lock(&bch_register_lock);
+	down_write(&bch_register_lock);
 
 	if (atomic_read(&dc->running)) {
 		bd_unlink_disk_holder(dc->bdev, dc->disk.disk);
@@ -1363,7 +1363,7 @@ static CLOSURE_CALLBACK(cached_dev_free)
 	bcache_device_free(&dc->disk);
 	list_del(&dc->list);
 
-	mutex_unlock(&bch_register_lock);
+	up_write(&bch_register_lock);
 
 	if (dc->sb_disk)
 		folio_put(virt_to_folio(dc->sb_disk));
@@ -1381,9 +1381,9 @@ static CLOSURE_CALLBACK(cached_dev_flush)
 	closure_type(dc, struct cached_dev, disk.cl);
 	struct bcache_device *d = &dc->disk;
 
-	mutex_lock(&bch_register_lock);
+	down_write(&bch_register_lock);
 	bcache_device_unlink(d);
-	mutex_unlock(&bch_register_lock);
+	up_write(&bch_register_lock);
 
 	bch_cache_accounting_destroy(&dc->accounting);
 	kobject_del(&d->kobj);
@@ -1496,12 +1496,12 @@ static CLOSURE_CALLBACK(flash_dev_free)
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
 
@@ -1509,9 +1509,9 @@ static CLOSURE_CALLBACK(flash_dev_flush)
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
@@ -1674,7 +1674,7 @@ static CLOSURE_CALLBACK(cache_set_free)
 	bch_btree_cache_free(c);
 	bch_journal_free(c);
 
-	mutex_lock(&bch_register_lock);
+	down_write(&bch_register_lock);
 	bch_bset_sort_state_free(&c->sort);
 	free_pages((unsigned long) c->uuids, ilog2(meta_bucket_pages(&c->cache->sb)));
 
@@ -1695,7 +1695,7 @@ static CLOSURE_CALLBACK(cache_set_free)
 	kfree(c->devices);
 
 	list_del(&c->list);
-	mutex_unlock(&bch_register_lock);
+	up_write(&bch_register_lock);
 
 	pr_info("Cache set %pU unregistered\n", c->set_uuid);
 	wake_up(&unregister_wait);
@@ -1813,7 +1813,7 @@ static CLOSURE_CALLBACK(__cache_set_unregister)
 	struct bcache_device *d;
 	size_t i;
 
-	mutex_lock(&bch_register_lock);
+	down_write(&bch_register_lock);
 
 	for (i = 0; i < c->devices_max_used; i++) {
 		d = c->devices[i];
@@ -1831,7 +1831,7 @@ static CLOSURE_CALLBACK(__cache_set_unregister)
 		}
 	}
 
-	mutex_unlock(&bch_register_lock);
+	up_write(&bch_register_lock);
 
 	continue_at(cl, cache_set_flush, system_percpu_wq);
 }
@@ -2029,8 +2029,12 @@ static int run_cache_set(struct cache_set *c)
 			goto err;
 
 		err = "error in recovery";
-		if (bch_btree_check(c))
+		downgrade_write(&bch_register_lock);
+		if (bch_btree_check(c)) {
+			up_read(&bch_register_lock);
+			down_write(&bch_register_lock);
 			goto err;
+		}
 
 		bch_journal_mark(c, &journal);
 		bch_initial_gc_finish(c);
@@ -2044,8 +2048,11 @@ static int run_cache_set(struct cache_set *c)
 		bch_journal_next(&c->journal);
 
 		err = "error starting allocator thread";
-		if (bch_cache_allocator_start(ca))
+		if (bch_cache_allocator_start(ca)) {
+			up_read(&bch_register_lock);
+			down_write(&bch_register_lock);
 			goto err;
+		}
 
 		/*
 		 * First place it's safe to allocate: btree_check() and
@@ -2061,8 +2068,14 @@ static int run_cache_set(struct cache_set *c)
 			__uuid_write(c);
 
 		err = "bcache: replay journal failed";
-		if (bch_journal_replay(c, &journal))
+		if (bch_journal_replay(c, &journal)) {
+			up_read(&bch_register_lock);
+			down_write(&bch_register_lock);
 			goto err;
+		}
+
+		up_read(&bch_register_lock);
+		down_write(&bch_register_lock);
 	} else {
 		unsigned int j;
 
@@ -2409,9 +2422,9 @@ static int register_cache(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
 		goto out;
 	}
 
-	mutex_lock(&bch_register_lock);
+	down_write(&bch_register_lock);
 	err = register_cache_set(ca);
-	mutex_unlock(&bch_register_lock);
+	up_write(&bch_register_lock);
 
 	if (err) {
 		ret = -ENODEV;
@@ -2486,11 +2499,11 @@ static void register_bdev_worker(struct work_struct *work)
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
@@ -2605,13 +2618,13 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
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
@@ -2644,9 +2657,9 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
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
@@ -2700,7 +2713,7 @@ static ssize_t bch_pending_bdevs_cleanup(struct kobject *k,
 	struct pdev *pdev, *tpdev;
 	struct cache_set *c, *tc;
 
-	mutex_lock(&bch_register_lock);
+	down_write(&bch_register_lock);
 	list_for_each_entry_safe(dc, tdc, &uncached_devices, list) {
 		pdev = kmalloc(sizeof(struct pdev), GFP_KERNEL);
 		if (!pdev)
@@ -2721,7 +2734,7 @@ static ssize_t bch_pending_bdevs_cleanup(struct kobject *k,
 			}
 		}
 	}
-	mutex_unlock(&bch_register_lock);
+	up_write(&bch_register_lock);
 
 	list_for_each_entry_safe(pdev, tpdev, &pending_devs, list) {
 		pr_info("delete pdev %p\n", pdev);
@@ -2748,7 +2761,7 @@ static int bcache_reboot(struct notifier_block *n, unsigned long code, void *x)
 		struct cache_set *c, *tc;
 		struct cached_dev *dc, *tdc;
 
-		mutex_lock(&bch_register_lock);
+		down_write(&bch_register_lock);
 
 		if (bcache_is_reboot)
 			goto out;
@@ -2765,7 +2778,7 @@ static int bcache_reboot(struct notifier_block *n, unsigned long code, void *x)
 		    list_empty(&uncached_devices))
 			goto out;
 
-		mutex_unlock(&bch_register_lock);
+		up_write(&bch_register_lock);
 
 		pr_info("Stopping all devices:\n");
 
@@ -2800,7 +2813,7 @@ static int bcache_reboot(struct notifier_block *n, unsigned long code, void *x)
 		while (1) {
 			long timeout = start + 10 * HZ - jiffies;
 
-			mutex_lock(&bch_register_lock);
+			down_write(&bch_register_lock);
 			stopped = list_empty(&bch_cache_sets) &&
 				list_empty(&uncached_devices);
 
@@ -2810,7 +2823,7 @@ static int bcache_reboot(struct notifier_block *n, unsigned long code, void *x)
 			prepare_to_wait(&unregister_wait, &wait,
 					TASK_UNINTERRUPTIBLE);
 
-			mutex_unlock(&bch_register_lock);
+			up_write(&bch_register_lock);
 			schedule_timeout(timeout);
 		}
 
@@ -2821,7 +2834,7 @@ static int bcache_reboot(struct notifier_block *n, unsigned long code, void *x)
 		else
 			pr_notice("Timeout waiting for devices to be closed\n");
 out:
-		mutex_unlock(&bch_register_lock);
+		up_write(&bch_register_lock);
 	}
 
 	return NOTIFY_DONE;
@@ -2849,7 +2862,6 @@ static void bcache_exit(void)
 	if (bcache_major)
 		unregister_blkdev(bcache_major, "bcache");
 	unregister_reboot_notifier(&reboot);
-	mutex_destroy(&bch_register_lock);
 }
 
 /* Check and fixup module parameters */
@@ -2889,15 +2901,14 @@ static int __init bcache_init(void)
 
 	check_module_parameters();
 
-	mutex_init(&bch_register_lock);
+	init_rwsem(&bch_register_lock);
 	init_waitqueue_head(&unregister_wait);
 	register_reboot_notifier(&reboot);
 
 	bcache_major = register_blkdev(0, "bcache");
 	if (bcache_major < 0) {
 		unregister_reboot_notifier(&reboot);
-		mutex_destroy(&bch_register_lock);
-		return bcache_major;
+			return bcache_major;
 	}
 
 	if (bch_btree_init())
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 72f38e5b6f5c7..29da507798cd5 100644
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
@@ -457,12 +476,24 @@ STORE(bch_cached_dev)
 {
 	struct cached_dev *dc = container_of(kobj, struct cached_dev,
 					     disk.kobj);
+	bool write = false;
 
 	/* no user space access if system is rebooting */
 	if (bcache_is_reboot)
 		return -EBUSY;
 
-	mutex_lock(&bch_register_lock);
+	if (attr == &sysfs_attach ||
+	    attr == &sysfs_detach ||
+	    attr == &sysfs_stop ||
+	    attr == &sysfs_label ||
+	    attr == &sysfs_cache_mode)
+		write = true;
+
+	if (write)
+		down_write(&bch_register_lock);
+	else
+		down_read(&bch_register_lock);
+
 	size = __cached_dev_store(kobj, attr, buf, size);
 
 	if (attr == &sysfs_writeback_running) {
@@ -495,7 +526,11 @@ STORE(bch_cached_dev)
 			schedule_delayed_work(&dc->writeback_rate_update,
 				      dc->writeback_rate_update_seconds * HZ);
 
-	mutex_unlock(&bch_register_lock);
+	if (write)
+		up_write(&bch_register_lock);
+	else
+		up_read(&bch_register_lock);
+
 	return size;
 }
 
@@ -806,7 +841,16 @@ SHOW(__bch_cache_set)
 
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
@@ -927,7 +971,35 @@ STORE(__bch_cache_set)
 
 	return size;
 }
-STORE_LOCKED(bch_cache_set)
+STORE(bch_cache_set)
+{
+	bool write = false;
+	ssize_t ret;
+
+	/* no user space access if system is rebooting */
+	if (bcache_is_reboot)
+		return -EBUSY;
+
+	if (attr == &sysfs_unregister ||
+	    attr == &sysfs_stop ||
+	    attr == &sysfs_flash_vol_create ||
+	    attr == &sysfs_synchronous)
+		write = true;
+
+	if (write)
+		down_write(&bch_register_lock);
+	else
+		down_read(&bch_register_lock);
+
+	ret = __bch_cache_set_store(kobj, attr, buf, size);
+
+	if (write)
+		up_write(&bch_register_lock);
+	else
+		up_read(&bch_register_lock);
+
+	return ret;
+}
 
 SHOW(bch_cache_set_internal)
 {
diff --git a/drivers/md/bcache/sysfs.h b/drivers/md/bcache/sysfs.h
index 65b8bd975ab1e..d5beb997ac9af 100644
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
+	down_read(&bch_register_lock);					\
 	ret = __ ## fn ## _store(kobj, attr, buf, size);		\
-	mutex_unlock(&bch_register_lock);				\
+	up_read(&bch_register_lock);				\
 	return ret;							\
 }
 

---
base-commit: 0f61b1860cc3f52aef9036d7235ed1f017632193
change-id: 20260318-wujing-bcache-e6bc3bd3ff77

Best regards,
-- 
Qiliang Yuan <realwujing@gmail.com>

