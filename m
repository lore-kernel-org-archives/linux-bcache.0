Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A492BD11
	for <linux-bcache@vger.kernel.org>; Wed, 25 Mar 2026 08:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774428500; cv=none; b=VXcJ0f5YMZ9PTaq4V7BN0OPcXciptXt5T5b+veMva07e8fMYQxdi3KHIgJsKFpr3jmRcsIKnLYVFEElDnVsnH1ILfX1y4FGFLoUotfhkSzRtIjDt8HM65cXDQUaCwq8UWicC9Nd+lwiixXOAFC8jmYc7V7f7Byp4P4Tg+4whUFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774428500; c=relaxed/simple;
	bh=XUVx1xeo4SFNhKNWdYTxN0+Mf2obkWVxornHBvQSJTI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Z9rz22RogdLF8h9EBfsw3LEIdBkZKDSE/Zrdl+HGhXETxMsCsMwIcU05Rm16W/++zSRHEDaZcDBIOixYI5GsMQ5DdriVIqPvTW3O1qu2ng9OR1b8iUEE2rDdmscEwYNP0CEjd8mwYk0/wfbYmSVG4YwBEEEnVh2VBSJ7aTH0CIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JmxGSI2x; arc=none smtp.client-ip=74.125.82.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JmxGSI2x"
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-2b4520f6b32so2529398eec.0
        for <linux-bcache@vger.kernel.org>; Wed, 25 Mar 2026 01:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774428498; x=1775033298; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pCV2a29dfVldwv7bi81qovPTg2VlX7D/eaP95M01BGQ=;
        b=JmxGSI2xm4CevuIEWolTte+kGHSuCRkR6swJkXmzjtKMkLg1jaspOTXIJPYKGx48go
         VPkqCJcs8Ope8QVV5FRMAytyVJwSJ8lOl+iBeVSbzh0WHWh0b4oVXSMqYYxrZNEkDxiK
         NNXaLm16AoRXMKSJIaO/eq2tm/3/0cIhai+ykv0/bW0CuUGn1MyH+AI7L98yAguMeVig
         LV6iTUPa/6MaJ5TmLmcrvppgiXUzJBic9y7YEHbRRLGlx0uNmT7qg2axyHnXWFRm9yAl
         J9rEBLR6sHUZoQNnnG3JA0h/Q+4MiPBA5AdhpVFYWK8QPcHCdXJy6TK4esZqZNL5499Z
         ViBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774428498; x=1775033298;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pCV2a29dfVldwv7bi81qovPTg2VlX7D/eaP95M01BGQ=;
        b=h+Np7tZ2+DveEp0DB9rnYaolJrEHJRpsHbevrcABOv9GZCrbRtB0RwoX3UwujbwAj6
         Z2mvZ1/huNTMY5+TdFRPT5yDTkeUoUmaSBTUvLRVxKWwG68h9oH0AUk8fBxc5a50zB82
         Ce9wMvlZrfPh3xy7/R45zJefvHuzcfrxTWUI0GuaRgMyNVSKPuybDy/BGiJSXI9bQi8C
         7WMZIjiM2LZugLSKnqHt5c3QWQQGbT1rY0mTKP6UCXjFfYoNuYBbH+QPvGOZ8LNHJir0
         DD8j2gwjlAFj9mBAieUrycDeiFfT+Qj3G0DEOqCwoNXHGv0IVAOXKfwP1HZ6k7m6IA0K
         bb4A==
X-Gm-Message-State: AOJu0YxNqUVrAPtbbA0zwGGTLLdq/BwRP9A5E9Po87mXzEVIFeel83VC
	E8t3cUtdNd09vhJ4nKUrrPVjwH8xvYkLUWi+0GiKWjN4xgHoG/7v3y5m/xg75OKe
X-Gm-Gg: ATEYQzzhiYXAgAWZEhNWjp8fRKjfhLJaM9XxTlNSGcVHZoerybg0Q5VWdrO1POgd903
	oHoXSgmj9u9mECoZuARJTe/0PTGb3JSa3ClnAhYiIlN6/eco+GjCvh1BSOk+/5whfrBbpPvs0+O
	nW9/h3soBxBAxMKGvP93HXGULgi/ZBfRUrahM0IOypJvSz0+I8uJT4t4EtazoK3xCsihQ+B3B1R
	XugPZXU3AcUwo413qA1osbG9oGPJnn79FQlHYtLH1+koVAY5qMzKtiqbO1KSNSdHmC3ZKaqGkAA
	Sjf6DNL8/N8+c4ZOwWS7U/4aZQgqAklLhBnPKJza8P1aiJAXmACbAOSVDaNiSmZnLNW7ZP1yxD3
	fpM1TWQS2hlC8d6VuLK4Pri5oM8CWzgkuyun7PJIFOEb5qEApx3kmuATfiHMFER/cH8CxNnjGXm
	3quY2zBG5sIRWt9nDf
X-Received: by 2002:a05:7300:ad09:b0:2be:ca4:e13f with SMTP id 5a478bee46e88-2c15d429fe9mr1323773eec.23.1774428497521;
        Wed, 25 Mar 2026 01:48:17 -0700 (PDT)
Received: from wujing. ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2c168a9ce46sm11470eec.31.2026.03.25.01.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 01:48:17 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Wed, 25 Mar 2026 16:48:09 +0800
Subject: [PATCH v2] bcache: convert bch_register_lock to rw_semaphore
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260325-wujing-bcache-v2-1-5cf105281977@gmail.com>
X-B4-Tracking: v=1; b=H4sIAEihw2kC/3XMSw7CIBSF4a00dywGStJWR+7DdMDjAtdY2oCip
 unexc4d/ic53woZE2GGc7NCwkKZ5lijPTRggooeGdna0PK241IM7PW8UfRMG2UCMuy0kdpK5/o
 e6mdJ6Oi9e9exdqD8mNNn54v4rf+kIphgjuuTUk66QdiLnxTdj2aeYNy27QsEH9DiqgAAAA==
To: Coly Li <colyli@fnnas.com>, Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Qiliang Yuan <realwujing@gmail.com>
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

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
---
Changes in v2:
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
- Link to v1: https://lore.kernel.org/r/20260318-wujing-bcache-v1-1-f0b9aaf3f81d@gmail.com
---
 drivers/md/bcache/bcache.h  |  2 +-
 drivers/md/bcache/request.c | 18 ++++++-------
 drivers/md/bcache/super.c   | 64 +++++++++++++++++++++----------------------
 drivers/md/bcache/sysfs.c   | 66 ++++++++++++++++++++++++++++++++++++++++-----
 drivers/md/bcache/sysfs.h   |  8 +++---
 5 files changed, 105 insertions(+), 53 deletions(-)

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
index c17d4517af22c..4979b3d16030c 100644
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
@@ -2409,9 +2409,9 @@ static int register_cache(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
 		goto out;
 	}
 
-	mutex_lock(&bch_register_lock);
+	down_write(&bch_register_lock);
 	err = register_cache_set(ca);
-	mutex_unlock(&bch_register_lock);
+	up_write(&bch_register_lock);
 
 	if (err) {
 		ret = -ENODEV;
@@ -2486,11 +2486,11 @@ static void register_bdev_worker(struct work_struct *work)
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
@@ -2605,13 +2605,13 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
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
@@ -2644,9 +2644,9 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
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
@@ -2700,7 +2700,7 @@ static ssize_t bch_pending_bdevs_cleanup(struct kobject *k,
 	struct pdev *pdev, *tpdev;
 	struct cache_set *c, *tc;
 
-	mutex_lock(&bch_register_lock);
+	down_write(&bch_register_lock);
 	list_for_each_entry_safe(dc, tdc, &uncached_devices, list) {
 		pdev = kmalloc(sizeof(struct pdev), GFP_KERNEL);
 		if (!pdev)
@@ -2721,7 +2721,7 @@ static ssize_t bch_pending_bdevs_cleanup(struct kobject *k,
 			}
 		}
 	}
-	mutex_unlock(&bch_register_lock);
+	up_write(&bch_register_lock);
 
 	list_for_each_entry_safe(pdev, tpdev, &pending_devs, list) {
 		pr_info("delete pdev %p\n", pdev);
@@ -2748,7 +2748,7 @@ static int bcache_reboot(struct notifier_block *n, unsigned long code, void *x)
 		struct cache_set *c, *tc;
 		struct cached_dev *dc, *tdc;
 
-		mutex_lock(&bch_register_lock);
+		down_write(&bch_register_lock);
 
 		if (bcache_is_reboot)
 			goto out;
@@ -2765,7 +2765,7 @@ static int bcache_reboot(struct notifier_block *n, unsigned long code, void *x)
 		    list_empty(&uncached_devices))
 			goto out;
 
-		mutex_unlock(&bch_register_lock);
+		up_write(&bch_register_lock);
 
 		pr_info("Stopping all devices:\n");
 
@@ -2800,7 +2800,7 @@ static int bcache_reboot(struct notifier_block *n, unsigned long code, void *x)
 		while (1) {
 			long timeout = start + 10 * HZ - jiffies;
 
-			mutex_lock(&bch_register_lock);
+			down_write(&bch_register_lock);
 			stopped = list_empty(&bch_cache_sets) &&
 				list_empty(&uncached_devices);
 
@@ -2810,7 +2810,7 @@ static int bcache_reboot(struct notifier_block *n, unsigned long code, void *x)
 			prepare_to_wait(&unregister_wait, &wait,
 					TASK_UNINTERRUPTIBLE);
 
-			mutex_unlock(&bch_register_lock);
+			up_write(&bch_register_lock);
 			schedule_timeout(timeout);
 		}
 
@@ -2821,7 +2821,7 @@ static int bcache_reboot(struct notifier_block *n, unsigned long code, void *x)
 		else
 			pr_notice("Timeout waiting for devices to be closed\n");
 out:
-		mutex_unlock(&bch_register_lock);
+		up_write(&bch_register_lock);
 	}
 
 	return NOTIFY_DONE;
@@ -2849,7 +2849,6 @@ static void bcache_exit(void)
 	if (bcache_major)
 		unregister_blkdev(bcache_major, "bcache");
 	unregister_reboot_notifier(&reboot);
-	mutex_destroy(&bch_register_lock);
 }
 
 /* Check and fixup module parameters */
@@ -2889,14 +2888,13 @@ static int __init bcache_init(void)
 
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
index 72f38e5b6f5c7..9f7ca5f738f48 100644
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
base-commit: 0f61b1860cc3f52aef9036d7235ed1f017632193
change-id: 20260318-wujing-bcache-e6bc3bd3ff77

Best regards,
-- 
Qiliang Yuan <realwujing@gmail.com>

