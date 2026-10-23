Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792726855;
	b=jBz8n5YTv8nf4ARtrJMr8QdAzIxcbE7KxjtWzclf0GcIn1xd8XNzoYyUzHvgKXZaVkNi
	 EjGLMv7HSSdiIDcA8x9xNqujRFV3ykj255vszGWNn5O/vraD9uE44rbuHhC6uy0HpYR+t
	 MT/ml7ZKCAHvNVdjc7OkITJtWqZu9TJEHFHNdbBryNksyDNzIOaaytpMGEmw03JDnUxue
	 yTJFVcxqfR+Xf1U5L7DglbMIB+YTxHkMm0PZQ9fkH08lr1si3IK9jtS4Dp2qqKnDEhvCn
	 Rux2Y0V+OQUyJz3AhXE2PITZmBLZpF4Um+ApmNQffuT1GxU9kiPbV8uqg/vhKgM6jAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792726855;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:X-B4-Tracking:To:Cc:X-Mailer;
	bh=r84gnXzTqJKBeirbLqju8kxJzezP08DsjHOvlAIc1ig=;
	b=H4vcBnDnavos9QAWoTQbdGj9LZVcwCL69FweRfkS6QTeLO2VVwTJPZYzHGi5ji1wlsAJ
	 jWU+I9RLoOfWOteJmrE2iH2TCsmKnsmHPnOjuJH9jg6c8xKcGqgif6dNCMR715ycNqirv
	 6Fe4TJ0/2aPGRAQaxgP6mvKYevLDPi38fcflONORpLBcpiUWcMtWUkB8J1r5xXqyFEcTK
	 WSjL1VIb7k4Yr76m/awtSVbAso6vlzYxC01PmuCs2UGphBkXoA54SFfbrgNkf74RRJTk3
	 gm/OWpSgCQJNEjg1xFE+k+CG1e4cvQvRRbppCG/b/yL1Lurhjux32XbmE13qzJrG9Wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=a+BSs70C;
	arc=none smtp.remote-ip=74.125.82.54
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913F4606A31B
	for <linux-bcache@vger.kernel.org>; Fri, 23 Oct 2026 03:40:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 913F4606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=a+BSs70C
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-157fe9d771bso536077c88.0
        for <linux-bcache@vger.kernel.org>; Thu, 22 Oct 2026 20:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792726854; x=1793331654; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=r84gnXzTqJKBeirbLqju8kxJzezP08DsjHOvlAIc1ig=;
        b=a+BSs70CnSHtlqDxy4yOOq7jhBUmuczALQlXzPK6l0MDO2MuwJq2oQgIHgMgAp8gMg
         VHXgpNjCnNbmaxysLzr8ouqw/KoLtMHjl3+rHGuT8tNo4CLVnS3zqK8X3xCM+DjuTexv
         HUr46qjvgWgQXufgpyb87UYdbxx/U/QiBD4gkTw6JHNu+f2R4jP8C1jDhQNZHSrhms5+
         /nhlMx56GiuBMp78+uM94WbcDzf1uVrwufa0rgWXjfdBBNqCCcrrYQ24ZO/2BcVwI7NC
         JZ8TU/LPi3k69Vk3HATWDsh7/6QZ2IS0w9PL7OLpIJ+IfyzqpLVpVYgN5fr7VVFsS/um
         Ui3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792726854; x=1793331654;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=r84gnXzTqJKBeirbLqju8kxJzezP08DsjHOvlAIc1ig=;
        b=xTh0RxceFk4ThU3swdmlQ8FKEjBFkFpfkLWWFe7jNapRRhwPzXAPlFz+K1YAytLxc2
         x9apQQ0RXTJSqAEX08V5Rm3IuarHj9YIcD4L7H14C7D5/Mx69rdU27uHZ96PDCZsOjm7
         vaXSKiIlXsf8vEZbzS2op6vFo2Aw8StLHOwwi+RP9SO5DWJTK8lZyIONcyH8heX74BPf
         bpoEQ++Dl9YJhZCmFmcdkqkoi4kmTmqh9EPkv/Jt+eGdhtObrB+eXsdOvF145yjdimGn
         uUU5jSZlff9OvqMQw+hr4JZDFty7OuQr281RA8/Cg4CjOOxwtrs/61fy5xozGrAHm1zf
         MbsA==
X-Forwarded-Encrypted: i=1; AKwUvBz0I3II0JPanWk4RQLMZevcabPCuEf5bGf7lorjCcTMfkuLMjDjaUqz84nON9S68ogWF3HKDvdMPSGAr1E=@vger.kernel.org
X-Gm-Message-State: AFq9FYI6YbGJ33vlIiS05TDbqbb5FfF2RvXd+hVqwoaroVzKwOBOHaq4
	ckW1G9qw+Yq6MobavhnPeZG8+KZXlLb3uSIPZwwp9sqgAngjXnXCWij4
X-Gm-Gg: AYBFou1diLGCPjsuxwuaGbLHhemrHBVkJPmsZoAxvJNC8n3XnmAQ0VJv709y0Sij4ph
	BulPOlyND1Tn0XQdMK0Mnf4r0/p0x82PcUQu3QAs1CGbpJgt0xTDzCTfQTOv93yqiJdsz4p8qyx
	L/oradEL/RAzdTPnEhg5JE6FmcmEFCGbdBzKV1KtqDyD6fX1q6HnEKCfPBVl/5s/XBWQGTznc3V
	GQcf6IubuAxAINcFZAyU8XfO0bTOMM3tviFjYGWXSWf8zBJuZhSK1tyuM4pv0nuBy7UGB+WcIVt
	TPesByajFbjx9BQbBfDYarPvz8qarXCgBIdTcNj1P+GKbnm3Gd3D77IoK5Fs92lXVzPjAs2FOsh
	G3YAylU78vymuaVF37UGTtwNeqMNaiQtqjgSj7YBAu9J+6XPRM6xEdNAW8PXS9iCKea4X1nxJ3h
	+nBGk6hW1E/JZnh4OsbRAa/Ekx/Ijw00CJk9cX61+LWRKbbL85a6ZJKMlmiLcBFbXiM0cWWZkO6
	WXQhQ/z5kVtcxkYwhKZ88k/+0JGpsgDAVUL/3qaCbtWGO7TtzI=
X-Received: by 2002:a05:701b:4252:20b0:143:2719:566e with SMTP id a92af1059eb24-195c929683bmr1489574c88.42.1792726853488;
        Thu, 22 Oct 2026 20:40:53 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-195e9e9cbdcsm2513150c88.5.2026.10.22.20.40.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 20:40:53 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Fri, 23 Oct 2026 11:40:49 +0800
Subject: [PATCH v4] bcache: avoid holding bch_register_lock across
 cache_set recovery
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Post: <mailto:linux-bcache@vger.kernel.org>
List-Help: <mailto:linux-bcache+help@vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-bcache+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261023-feat-bcache-v4-1-a8fddd8eb2f3@gmail.com>
X-B4-Tracking: v=1; b=H4sIAEDX2moC/33MQQ6CMBCF4auQWVtT2jqgK+9hXAxlgCZCTUsaD
 eHuFlYujMv3ku9fIHJwHOFSLBA4uej8lIc5FGAHmnoWrs0blFQoK4miY5pFY8kOLLTkMxoqq7Z
 VkMUzcOdee+12z3twcfbhvceT2t7fnaREKSpJpkFWBq289iO5x9H6EbZO0n+szrauM6s1ntDSt
 13X9QM0zkoH4gAAAA==
To: Coly Li <colyli@fygo.io>, Kent Overstreet <kent.overstreet@linux.dev>
Cc: Coly Li <colyli@fnnas.com>, linux-bcache@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0

register_cache() holds bch_register_lock across register_cache_set(),
which recovers a cache set from disk (journal replay, btree check,
allocator start) before publishing it. The same global mutex serializes
every sysfs store on cache sets and cached devices, and every
register_bcache() call.

Recovery time grows with cache size and device health, so registering
one cache device stalls unrelated, already running devices. On a Ceph
OSD node with 12 cache sets on two NVMe drives, udev scripts writing
congested_read_threshold_us under /sys/fs/bcache/<uuid>/ and
sequential_cutoff under /sys/block/bcacheN/bcache/, and registration of
other cache devices, sit in D state for minutes. udevd kills and
retries those workers every 3 minutes, delaying OSD startup:

  INFO: task bcache_cache_se:3496 blocked for more than 121 seconds.
  Call trace:
   __mutex_lock.constprop.0+0x1d4/0x5ec
   mutex_lock+0x50/0x60
   bch_cache_set_store+0x40/0x80 [bcache]

Drop bch_register_lock in register_cache_set() while recovering a new
cache set, and take it again to add the kobjects and attach pending
devices. Keep the cache set on bch_cache_sets so that duplicate
registrations and bcache_reboot() still see it, and mark it
CACHE_SET_REGISTERING meanwhile: bch_cached_dev_attach() and the cache
sysfs files leave it alone, __uuid_write() does not expect the lock, and
__cache_set_unregister() waits for recovery, as bch_cache_set_error()
or bcache_reboot() may stop the cache set at any time. Do not publish a
cache set stopped that way. Take the cache kobject reference before
recovery, and skip kobject_del() in cache_set_flush() if the cache set
never reached sysfs. With a cache set recovering for about 15 seconds
behind dm-delay (200ms reads), each operation started 1 second into
recovery (3 runs):

                                    before (ms)    after (ms)
  write congested_read_threshold_us   13893-14489    37-42
  write sequential_cutoff             13889-14486    37-41
  register another cache device       13923-14510    131-150

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
Tested on a KASAN + lockdep kernel in a VM, with a cache set recovering
behind dm-delay:

- Switching the cache device to dm-error 1, 4, 6 or 9 seconds into
  recovery: v3 hits a KASAN slab-use-after-free in cache_set_flush()
  followed by a panic; v4 fails the registration and frees the cache
  set cleanly.
- kexec reboot 1 second into recovery: in v3, bcache_reboot() tears the
  cache set down while it is still being recovered (kernfs WARNs from
  cache_set_flush()); in v4 the teardown waits for recovery, the cache
  set is not published, and bcache_reboot() reports "All devices
  stopped". If recovery outlasts bcache_reboot()'s 10 second wait, it
  times out as it does for any slow cache set.
- Registering a copy of the recovering cache device is rejected as a
  duplicate cache set member right away.
---
V3 -> V4:
- Make __cache_set_unregister() wait for recovery, which
  bcache_reboot() or bch_cache_set_error() could otherwise tear down
  concurrently, and do not publish a cache set stopped meanwhile (Coly)
- Take the cache kobject reference before recovery and skip
  kobject_del() for a cache set never added to sysfs, fixing a
  use-after-free when recovery fails
- Keep run_cache_set() and drop the lock inside register_cache_set()
  instead of splitting recovery into new helpers
- Describe the blocked interfaces and their impact, and add before/after
  data to the commit message (Coly)
- Use one identity for From and Signed-off-by (Coly)
- Rebase onto v7.3-5024-g864c07de0c7d

V2 -> V3:
- Drop the mutex -> rw_semaphore conversion, which did not help stores
  and raised a KABI concern (Coly)
- Recover a new cache set without bch_register_lock and take the lock
  only to publish it
- Add CACHE_SET_REGISTERING to keep the cache set out of
  bch_cached_dev_attach() and the cache sysfs files during recovery
- Keep recovering an existing cache set under the lock

V1 -> V2:
- Hold the write lock throughout run_cache_set() instead of downgrading
  it, closing a window where unregister could hit a half-initialized
  cache set (Coly)
- Take the write lock in all sysfs store wrappers, including
  STORE_LOCKED and bch_flash_dev
- Fix whitespace in the bcache_init() error path
- bch_register_lock is not exported, so its type change does not affect
  KABI

v3: https://lore.kernel.org/r/20260706-feat-bcache-v3-1-8824683656ca@gmail.com
v2: https://lore.kernel.org/r/20260706-feat-bcache-v2-1-70a4b6e246c0@gmail.com
v1: https://lore.kernel.org/r/20260318-wujing-bcache-v1-1-f0b9aaf3f81d@gmail.com
---
 drivers/md/bcache/bcache.h |  4 +++
 drivers/md/bcache/super.c  | 64 +++++++++++++++++++++++++++++++++-------------
 drivers/md/bcache/sysfs.c  |  6 +++++
 3 files changed, 56 insertions(+), 18 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index ec9ff97150812..d293e93b8eadf 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -507,11 +507,15 @@ struct gc_stat {
  * CACHE_SET_IO_DISABLE is set when bcache is stopping the whold cache set, all
  * external and internal I/O should be denied when this flag is set.
  *
+ * CACHE_SET_REGISTERING is set while a new cache set is recovered without
+ * bch_register_lock, before it is added to sysfs.
+ *
  */
 #define CACHE_SET_UNREGISTERING		0
 #define	CACHE_SET_STOPPING		1
 #define	CACHE_SET_RUNNING		2
 #define CACHE_SET_IO_DISABLE		3
+#define CACHE_SET_REGISTERING		4
 
 struct cache_set {
 	struct closure		cl;
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 97d9adb0bf96b..c209c92b60e91 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -503,7 +503,8 @@ static int __uuid_write(struct cache_set *c)
 	unsigned int size;
 
 	closure_init_stack(&cl);
-	lockdep_assert_held(&bch_register_lock);
+	if (!test_bit(CACHE_SET_REGISTERING, &c->flags))
+		lockdep_assert_held(&bch_register_lock);
 
 	if (bch_bucket_alloc_set(c, RESERVE_BTREE, &k.key, true))
 		return 1;
@@ -1215,6 +1216,10 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
 		return -EINVAL;
 	}
 
+	/* Let register_cache_set() attach it once recovered */
+	if (test_bit(CACHE_SET_REGISTERING, &c->flags))
+		return -EBUSY;
+
 	if (dc->sb.block_size < c->cache->sb.block_size) {
 		/* Will die */
 		pr_err("Couldn't attach %pg: block size less than set's block size\n",
@@ -1728,7 +1733,8 @@ static CLOSURE_CALLBACK(cache_set_flush)
 	bch_cache_accounting_destroy(&c->accounting);
 
 	kobject_put(&c->internal);
-	kobject_del(&c->kobj);
+	if (c->kobj.state_in_sysfs)
+		kobject_del(&c->kobj);
 
 	if (!IS_ERR_OR_NULL(c->gc_thread))
 		kthread_stop(c->gc_thread);
@@ -1828,6 +1834,7 @@ static CLOSURE_CALLBACK(__cache_set_unregister)
 	struct bcache_device *d;
 	size_t i;
 
+	wait_on_bit(&c->flags, CACHE_SET_REGISTERING, TASK_UNINTERRUPTIBLE);
 	mutex_lock(&bch_register_lock);
 
 	for (i = 0; i < c->devices_max_used; i++) {
@@ -1986,7 +1993,6 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 static int run_cache_set(struct cache_set *c)
 {
 	const char *err = "cannot allocate memory";
-	struct cached_dev *dc, *t;
 	struct cache *ca = c->cache;
 	struct closure cl;
 	LIST_HEAD(journal);
@@ -2137,13 +2143,6 @@ static int run_cache_set(struct cache_set *c)
 	if (bch_has_feature_obso_large_bucket(&c->cache->sb))
 		pr_err("Detect obsoleted large bucket layout, all attached bcache device will be read-only\n");
 
-	list_for_each_entry_safe(dc, t, &uncached_devices, list)
-		bch_cached_dev_attach(dc, c, NULL);
-
-	flash_devs_run(c);
-
-	bch_journal_space_reserve(&c->journal);
-	set_bit(CACHE_SET_RUNNING, &c->flags);
 	return 0;
 err:
 	while (!list_empty(&journal)) {
@@ -2163,7 +2162,9 @@ static const char *register_cache_set(struct cache *ca)
 {
 	char buf[12];
 	const char *err = "cannot allocate memory";
+	struct cached_dev *dc, *t;
 	struct cache_set *c;
+	int ret;
 
 	list_for_each_entry(c, &bch_cache_sets, list)
 		if (!memcmp(c->set_uuid, ca->sb.set_uuid, 16)) {
@@ -2177,6 +2178,25 @@ static const char *register_cache_set(struct cache *ca)
 	if (!c)
 		return err;
 
+	/*
+	 * Drop bch_register_lock while recovering the new cache set, so that
+	 * sysfs and registration of other devices are not blocked meanwhile.
+	 * Keep it on bch_cache_sets for duplicate detection and
+	 * bcache_reboot().
+	 */
+	kobject_get(&ca->kobj);
+	set_bit(CACHE_SET_REGISTERING, &c->flags);
+	list_add(&c->list, &bch_cache_sets);
+	mutex_unlock(&bch_register_lock);
+
+	ret = run_cache_set(c);
+
+	mutex_lock(&bch_register_lock);
+	clear_and_wake_up_bit(CACHE_SET_REGISTERING, &c->flags);
+	err = "failed to run cache set";
+	if (ret < 0 || test_bit(CACHE_SET_STOPPING, &c->flags))
+		goto err;
+
 	err = "error creating kobject";
 	if (kobject_add(&c->kobj, bcache_kobj, "%pU", c->set_uuid) ||
 	    kobject_add(&c->internal, &c->kobj, "internal"))
@@ -2186,22 +2206,30 @@ static const char *register_cache_set(struct cache *ca)
 		goto err;
 
 	bch_debug_init_cache_set(c);
-
-	list_add(&c->list, &bch_cache_sets);
 found:
 	sprintf(buf, "cache%i", ca->sb.nr_this_dev);
 	if (sysfs_create_link(&ca->kobj, &c->kobj, "set") ||
 	    sysfs_create_link(&c->kobj, &ca->kobj, buf))
 		goto err;
 
-	kobject_get(&ca->kobj);
-	ca->set = c;
-	ca->set->cache = ca;
+	/* Recover an existing cache set locked, as it is already visible */
+	if (!c->cache) {
+		kobject_get(&ca->kobj);
+		ca->set = c;
+		ca->set->cache = ca;
 
-	err = "failed to run cache set";
-	if (run_cache_set(c) < 0)
-		goto err;
+		err = "failed to run cache set";
+		if (run_cache_set(c) < 0)
+			goto err;
+	}
+
+	list_for_each_entry_safe(dc, t, &uncached_devices, list)
+		bch_cached_dev_attach(dc, c, NULL);
 
+	flash_devs_run(c);
+
+	bch_journal_space_reserve(&c->journal);
+	set_bit(CACHE_SET_RUNNING, &c->flags);
 	return NULL;
 err:
 	bch_cache_set_unregister(c);
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index cfac56caa8047..af970f802dcf5 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -1032,6 +1032,9 @@ SHOW(__bch_cache)
 {
 	struct cache *ca = container_of(kobj, struct cache, kobj);
 
+	if (ca->set && test_bit(CACHE_SET_REGISTERING, &ca->set->flags))
+		return -EBUSY;
+
 	sysfs_hprint(bucket_size,	bucket_bytes(ca));
 	sysfs_hprint(block_size,	block_bytes(ca));
 	sysfs_print(nbuckets,		ca->sb.nbuckets);
@@ -1140,6 +1143,9 @@ STORE(__bch_cache)
 	if (bcache_is_reboot)
 		return -EBUSY;
 
+	if (ca->set && test_bit(CACHE_SET_REGISTERING, &ca->set->flags))
+		return -EBUSY;
+
 	if (attr == &sysfs_cache_replacement_policy) {
 		v = __sysfs_match_string(cache_replacement_policies, -1, buf);
 		if (v < 0)

---
base-commit: 864c07de0c7dcbca58b61625dfa2e461ae63b242
change-id: 20260706-feat-bcache-30e964a17dd2

Best regards,
-- 
Qiliang Yuan <odys.yuan@gmail.com>

