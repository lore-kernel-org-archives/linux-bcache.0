Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2A6318EFF
	for <linux-bcache@vger.kernel.org>; Mon,  6 Jul 2026 14:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783346946; cv=none; b=NbI3Oa7oen6h6TCZOvodZ6bw7OjMir8vpnfmRg98gXDBzsH2dFRlkPfa9yT6SyQAze56+olqVdY/9/5aa4Cael+1zoDJ65Cbmj0tH1DNlrysnSrimh6Sv6hvt3B09ZyCQgAQubDCIwQGs0Fu5kNGutYNyF+gMCkiqfg0UZiNifo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783346946; c=relaxed/simple;
	bh=dHIDYY16yK0c0oiH+WqbgHDeGRphdraOF0F7fWvhpgE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=qjylqe5y2rMAWe2eL+GXvOgSlKqo1rW9hcbsDIR+YOJcp4+dLc2XaFW1zeIHRyLOpwEvHp+He2O9pbz0U8IT8sR+ND56Lw8W6Uah2BLfv6SSVvVfAM2ajXIzbxuWYcMVFwKzVYrm4DPe+7tqg4SpylpB/LlkqFmdiXzwePr0vTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LtyceFit; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LtyceFit"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-c96d2bebca3so1711409a12.3
        for <linux-bcache@vger.kernel.org>; Mon, 06 Jul 2026 07:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783346944; x=1783951744; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=amUUiLW9lLTBT3hYsQOJn65PNGSQF/YHzS0Y6oDM4gw=;
        b=LtyceFit1Ju+J+LTYwoZEZwH9QJZayhcWCtR1kdD1CAZKanZ4WvZIsQiySfCLTCLlj
         EuviWggK81kXPzKnf/FPfF7hHesN+TFQIhCeCkEYWdt10hcU1pey70x6WcfZT3d4ght7
         FzZuECPl4uVeXEP+CbCTlLXg+wDmnodpkz655ihWe6Avqj0FoNEBSU7se9EtVek5FTzl
         njhncKbYQE/CMfSxF+zyCTagmGGABJajQClVcbsf21+K8vXOe96AjZ47nLtWtySnOiVf
         74nVluVFLz4q3DlD99QZZQ053IQeecmOT368Ny+P6HpI3heu6JlDiGXupSm5dQvfrJWM
         y+tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783346944; x=1783951744;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=amUUiLW9lLTBT3hYsQOJn65PNGSQF/YHzS0Y6oDM4gw=;
        b=IF9OEunN4EI4HwqBX0MxkST9aMwVGwpW+P+0wTmsSxfTh+lg/m2EqlbqfWHqFQ+cAM
         +VraRhAPRDbkRsQM7x17UqSgtgvFHCvzy0MB2+CMX+1Sa38NcCQ5x3VS/UW0fIFNUgZO
         VAKHac3T3KaRgGyJpYzpOACuSqDYYi4DHGLzzJk6EJhlnHPvoz7VibXoD2ezBefsxIa2
         Q8VdZbbegXFQGM1gf+BnVhfXTuFo3532AAkYL64/KMilzxDUL2vDKd/GLyRg4SfBaN1r
         MF4w0H3kabLzhD7TE0HJ6Z/SBmnnbpfVYLIL+rXCJKk+e8mkopWgwNFhpj37NaJwoNMK
         ghNA==
X-Forwarded-Encrypted: i=1; AHgh+Roes09OxCWQdkO6R88OhWS/JhEfZdfGSl/vMGu0Oq3bCfM9c6No5PCq1TkWvgZg+g/5x1hxMP1xQBy4NYo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3i0lOoLiQPDuZXpIDXhJojfOSxcPi94uTa6d0qEdiFEt8aCIT
	Z+wtiESuFj6vL+xF4sBcoWcr1gF2JiOlAHwgLs44TmbpzScGDNfNLk58
X-Gm-Gg: AfdE7cl9Q3H4d8PmvRhd/HSFGeiKb3HiQg0B/5iG6e4JCU5ltoZk0tEuIdGYUvD5ZPM
	H/fAx0qBR0RBNQNBtzXvpFXIR4uD9vjgufKRnm/LYjx2oY5oSHjfifN5zc3De+wB79Sk64tnfTY
	gezAd3uMLT2KJjAGN4myn0kkvIGrWekSbqZ+wA0EBuEYpdjAXdX1nNrd5ekskHJ2inCJk8eRmVY
	fzcfWJmZaw6JCDakWoY3wfx7QkruMEtEw3byes2CyrrArlFW17ipmcRcNkXHWMuSbeseoC0nL1L
	70iDfsfEA6hy68JscozWVFdp6bdrNpS5aGXFYDuKWA0wxYQWNAxmfaGHPTegmtFrS6kUrJnhwvl
	JQnvzM3rIl7dER++RjUV3Ji8J+D60+VtX6qqRpNNLvcjoGJkGOPTBML46XlMbIZsrrFsytJb9Nl
	cN8aqp3bYe0bo=
X-Received: by 2002:a05:6a21:6e92:b0:3bf:7110:9949 with SMTP id adf61e73a8af0-3c08ed704c5mr955930637.6.1783346944150;
        Mon, 06 Jul 2026 07:09:04 -0700 (PDT)
Received: from [127.0.1.1] ([138.199.21.246])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c9e8eb0ee85sm6045485a12.3.2026.07.06.07.09.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 07:09:03 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Mon, 06 Jul 2026 22:08:59 +0800
Subject: [PATCH v3] bcache: avoid holding bch_register_lock across
 cache_set recovery
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260706-feat-bcache-v3-1-8824683656ca@gmail.com>
X-B4-Tracking: v=1; b=H4sIAPq2S2oC/23MQQ6DIBCF4auYWXcaRAJpV72HcYE4yiRVGjCkj
 eHupa67/F/yvgMSRaYE9+aASJkTh61Gd2nAebsthDzVBimkFkZonMnuODrrPGEn6KaVbc00Sai
 PV6SZ36fWD7U9pz3Ez4ln+Vv/O1lii0ZYNWqSSjvxWFbLz6sLKwyllC9yjRZupgAAAA==
To: Coly Li <colyli@fygo.io>, Kent Overstreet <kent.overstreet@linux.dev>
Cc: Coly Li <colyli@fnnas.com>, linux-bcache@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Qiliang Yuan <yuanql9@chinatelecom.cn>, 
 Jing Wu <realwujing@gmail.com>
X-Mailer: b4 0.13.0

Large-scale bcache device registration and concurrent sysfs access can
hang unrelated tasks for a long time, e.g.:

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

register_cache() holds bch_register_lock for the entire duration of
register_cache_set(), which calls run_cache_set() to do journal replay,
btree check and allocator start for a newly registered cache device.
Every sysfs show/store on any cache_set or cached_dev in the system
takes the same global bch_register_lock, so an unrelated device's
sysfs access blocks for as long as the new device's recovery takes.

Converting bch_register_lock to a rw_semaphore does not fix this:
register_cache() still holds the lock (as a writer) for the whole
register_cache_set() call, and sysfs store paths still need exclusive
access, so a store on an unrelated device still blocks for the same
duration. Downgrading the lock to a reader during recovery was tried,
but the cache_set's kobjects and its bch_cache_sets list entry are
already published before recovery starts, so a concurrent unregister
could hit the cache_set while it is only partially initialized.

Fix this at the root instead of changing the lock type: keep
bch_register_lock a mutex, and only hold it for the actual bookkeeping
that needs it, not for the multi-second recovery. Split registering a
brand new cache_set into two phases. Recovery (journal replay, btree
check, allocator start) runs on a cache_set that is linked into
bch_cache_sets and marked CACHE_SET_REGISTERING, but not yet added to
sysfs, without holding bch_register_lock at all: nothing else can
reach it through a kobject that does not exist yet, and the
REGISTERING flag keeps bch_cached_dev_attach() from attaching a
backing device to it before it is ready. Publishing (adding the
kobjects, attaching pending backing/flash devices) runs under
bch_register_lock afterwards, and is no more expensive than what
register_bdev_worker() already does under the same lock today.

Registering the new cache_set into bch_cache_sets and marking it
CACHE_SET_REGISTERING happens in the same critical section as
bch_cache_set_alloc(), which already sets c->cache, so the existing
duplicate-uuid check keeps working unchanged: a second registration
for the same uuid still sees c->cache set and is rejected, instead of
racing to recover the same uuid twice. __uuid_write()'s
lockdep_assert_held() is relaxed to also accept a cache_set that is
still CACHE_SET_REGISTERING, since it is called from the unlocked
recovery path on the fresh-cache branch. The per-cache sysfs show/store
handlers refuse to touch cache_set state while CACHE_SET_REGISTERING
is set, since that state is still being written by recovery.

Attaching an additional cache device to an already-published cache_set
(the pre-existing "found" case in register_cache_set(), when a cache
device is re-attached to a cache_set that lost its device earlier) is
left untouched: that cache_set is already reachable through sysfs, so
it keeps running recovery and publishing as one operation under
bch_register_lock, exactly as before.

Co-developed-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
Signed-off-by: Jing Wu <realwujing@gmail.com>
---
register_cache() holds the global bch_register_lock for the entire
duration of registering a new cache_set, including journal replay,
btree check and allocator start. Every sysfs show/store on any other
cache_set or cached_dev in the system needs the same lock, so a single
slow cache_set registration blocks unrelated sysfs access for as long
as recovery takes (see the call trace in the commit message).

v1/v2 tried to fix this by converting bch_register_lock from a mutex
to a rw_semaphore so sysfs reads could proceed concurrently. Coly
pointed out this does not actually help the reported hang (store paths
still need exclusive access for the same duration), raised a KABI
concern about changing the global's type, and found a real regression
in v1's downgrade_write()/up_read()/down_write() dance around
bch_btree_check().

v3 drops the lock-type change entirely and fixes the actual problem:
bch_register_lock stays a mutex, and registering a brand new cache_set
is split so the expensive recovery runs without holding it at all, on
a cache_set that is provisionally linked into bch_cache_sets (for
duplicate-uuid detection) but not yet visible in sysfs or attachable.
Publishing (kobjects, attaching pending devices) still runs under the
mutex afterwards, at the same cost register_bdev_worker() already pays
under the same lock today. Full design rationale is in the commit
message.
---
V2 -> V3:
- Drop the bch_register_lock mutex -> rw_semaphore conversion entirely
  (addresses Coly's KABI concern by not touching the lock's type at
  all).
- Root-cause fix instead: split registering a brand new cache_set into
  an unlocked recovery phase (journal replay, btree check, allocator
  start) and a locked publish phase (kobject_add, attach pending
  devices), so bch_register_lock is only held for the cheap
  bookkeeping, not the multi-second recovery that caused the reported
  hang.
- Add CACHE_SET_REGISTERING flag: the cache_set is linked into
  bch_cache_sets immediately (so duplicate-uuid detection and
  bcache_reboot() still see it) but kept out of sysfs and out of
  bch_cached_dev_attach()'s reach until recovery finishes.
- Relax __uuid_write()'s lockdep_assert_held() to also accept a
  CACHE_SET_REGISTERING cache_set, since it is called from the
  unlocked recovery path.
- Gate the per-cache sysfs show/store handlers so they refuse to touch
  cache_set state while CACHE_SET_REGISTERING is set.
- Leave the "found:" case (attaching an additional cache device to an
  already-published cache_set) fully serialized under
  bch_register_lock, unchanged from v1/v2.

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

v2: https://lore.kernel.org/r/20260706-feat-bcache-v2-1-70a4b6e246c0@gmail.com
v1: https://lore.kernel.org/r/20260318-wujing-bcache-v1-1-f0b9aaf3f81d@gmail.com
---
 drivers/md/bcache/bcache.h |   9 +++
 drivers/md/bcache/super.c  | 145 +++++++++++++++++++++++++++++++++++++++------
 drivers/md/bcache/sysfs.c  |  16 +++++
 3 files changed, 153 insertions(+), 17 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index ec9ff97150812..6763ac1c886ed 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -507,11 +507,20 @@ struct gc_stat {
  * CACHE_SET_IO_DISABLE is set when bcache is stopping the whold cache set, all
  * external and internal I/O should be denied when this flag is set.
  *
+ * CACHE_SET_REGISTERING is set while a freshly allocated cache set is running
+ * its recovery path (journal replay, btree check, allocator start) without
+ * holding bch_register_lock. The cache set is already linked into
+ * bch_cache_sets at this point (so duplicate-uuid detection and reboot
+ * bookkeeping can see it), but its kobjects are not added to sysfs yet, so
+ * it is not reachable from userspace or from cache-set lookups that attach
+ * backing devices. Cleared once the cache set is fully published.
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
index 97d9adb0bf96b..0146961a061f1 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -503,7 +503,14 @@ static int __uuid_write(struct cache_set *c)
 	unsigned int size;
 
 	closure_init_stack(&cl);
-	lockdep_assert_held(&bch_register_lock);
+	/*
+	 * Called either with bch_register_lock held, or from
+	 * bch_cache_set_recover() on a cache_set that is still
+	 * CACHE_SET_REGISTERING and therefore not yet reachable by any
+	 * other thread.
+	 */
+	if (!test_bit(CACHE_SET_REGISTERING, &c->flags))
+		lockdep_assert_held(&bch_register_lock);
 
 	if (bch_bucket_alloc_set(c, RESERVE_BTREE, &k.key, true))
 		return 1;
@@ -1215,6 +1222,12 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
 		return -EINVAL;
 	}
 
+	if (test_bit(CACHE_SET_REGISTERING, &c->flags)) {
+		pr_err("Can't attach %pg: cache set is still registering\n",
+		       dc->bdev);
+		return -EINVAL;
+	}
+
 	if (dc->sb.block_size < c->cache->sb.block_size) {
 		/* Will die */
 		pr_err("Couldn't attach %pg: block size less than set's block size\n",
@@ -1983,10 +1996,23 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 	return NULL;
 }
 
-static int run_cache_set(struct cache_set *c)
+/*
+ * Recover a cache_set from disk (journal replay, btree check, allocator
+ * start) or initialize a brand new one. This is the expensive, I/O-bound
+ * part of bringing a cache_set up.
+ *
+ * For a freshly allocated cache_set, this is called without
+ * bch_register_lock held: the cache_set is marked CACHE_SET_REGISTERING
+ * and is not yet reachable via c->kobj/sysfs or via any attach lookup (see
+ * bch_cached_dev_attach()'s CACHE_SET_REGISTERING check), so nothing else
+ * can observe it while it is only partially recovered. No failure path may
+ * exist below after bch_gc_thread_start(), since cache_set_flush()'s
+ * teardown assumes the gc thread is either fully started or
+ * IS_ERR_OR_NULL.
+ */
+static int bch_cache_set_recover(struct cache_set *c)
 {
 	const char *err = "cannot allocate memory";
-	struct cached_dev *dc, *t;
 	struct cache *ca = c->cache;
 	struct closure cl;
 	LIST_HEAD(journal);
@@ -2137,13 +2163,6 @@ static int run_cache_set(struct cache_set *c)
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
@@ -2159,23 +2178,114 @@ static int run_cache_set(struct cache_set *c)
 	return -EIO;
 }
 
+/*
+ * Publish a recovered cache_set: attach pending backing/flash devices and
+ * mark it running. Must be called with bch_register_lock held. Unlike
+ * bch_cache_set_recover(), nothing here can fail.
+ */
+static void bch_cache_set_attach_devices(struct cache_set *c)
+{
+	struct cached_dev *dc, *t;
+
+	lockdep_assert_held(&bch_register_lock);
+
+	list_for_each_entry_safe(dc, t, &uncached_devices, list)
+		bch_cached_dev_attach(dc, c, NULL);
+
+	flash_devs_run(c);
+
+	bch_journal_space_reserve(&c->journal);
+	set_bit(CACHE_SET_RUNNING, &c->flags);
+}
+
+/*
+ * Recover and publish a cache_set as a single locked unit. Used only for
+ * attaching a cache device to an already-published cache_set (the "found:"
+ * case in register_cache_set()) — that cache_set is already reachable via
+ * bch_cache_sets/sysfs, so it must not go through the unlocked recovery
+ * path used for a brand new cache_set.
+ */
+static int run_cache_set(struct cache_set *c)
+{
+	int ret;
+
+	lockdep_assert_held(&bch_register_lock);
+
+	ret = bch_cache_set_recover(c);
+	if (ret)
+		return ret;
+
+	bch_cache_set_attach_devices(c);
+	return 0;
+}
+
+/*
+ * Register a cache device against a (possibly brand new) cache_set.
+ *
+ * A brand new cache_set only needs bch_register_lock for the cheap
+ * bookkeeping below (duplicate-uuid check, allocation, list linkage,
+ * kobject creation) — the expensive recovery in bch_cache_set_recover()
+ * runs unlocked on a cache_set marked CACHE_SET_REGISTERING, which keeps
+ * it out of sysfs and out of reach of cache-set lookups
+ * (bch_cached_dev_attach()) while still keeping it visible to duplicate
+ * detection and to bcache_reboot() via bch_cache_sets. This avoids
+ * blocking every other cache_set's/cached_dev's sysfs show/store for the
+ * whole recovery duration, which a plain lock-type change cannot fix,
+ * since the lock would still have to be held continuously across
+ * bch_cache_set_recover() for the same reason it does today.
+ *
+ * Attaching an additional cache device to an already-published cache_set
+ * (the "found:" case) is left fully serialized under bch_register_lock,
+ * exactly as before: that cache_set is already reachable via sysfs, so
+ * recovering it outside the lock would reintroduce the half-initialized
+ * -but-visible window this design avoids for the fresh case.
+ */
 static const char *register_cache_set(struct cache *ca)
 {
 	char buf[12];
 	const char *err = "cannot allocate memory";
 	struct cache_set *c;
+	bool fresh = false;
+
+	mutex_lock(&bch_register_lock);
 
 	list_for_each_entry(c, &bch_cache_sets, list)
 		if (!memcmp(c->set_uuid, ca->sb.set_uuid, 16)) {
-			if (c->cache)
+			if (c->cache) {
+				mutex_unlock(&bch_register_lock);
 				return "duplicate cache set member";
+			}
 
 			goto found;
 		}
 
 	c = bch_cache_set_alloc(&ca->sb);
-	if (!c)
+	if (!c) {
+		mutex_unlock(&bch_register_lock);
 		return err;
+	}
+
+	/*
+	 * Link the new cache_set into bch_cache_sets right away, marked
+	 * CACHE_SET_REGISTERING, before dropping the lock for recovery.
+	 * bch_cache_set_alloc() already set c->cache = ca above, so the
+	 * duplicate-uuid check above will correctly reject a second
+	 * concurrent registration for the same uuid while this one is
+	 * mid-recovery.
+	 */
+	set_bit(CACHE_SET_REGISTERING, &c->flags);
+	list_add(&c->list, &bch_cache_sets);
+	fresh = true;
+
+	mutex_unlock(&bch_register_lock);
+
+	err = "failed to recover cache set";
+	if (bch_cache_set_recover(c) < 0) {
+		mutex_lock(&bch_register_lock);
+		goto err;
+	}
+
+	mutex_lock(&bch_register_lock);
 
 	err = "error creating kobject";
 	if (kobject_add(&c->kobj, bcache_kobj, "%pU", c->set_uuid) ||
@@ -2186,8 +2296,7 @@ static const char *register_cache_set(struct cache *ca)
 		goto err;
 
 	bch_debug_init_cache_set(c);
-
-	list_add(&c->list, &bch_cache_sets);
+	clear_bit(CACHE_SET_REGISTERING, &c->flags);
 found:
 	sprintf(buf, "cache%i", ca->sb.nr_this_dev);
 	if (sysfs_create_link(&ca->kobj, &c->kobj, "set") ||
@@ -2199,11 +2308,15 @@ static const char *register_cache_set(struct cache *ca)
 	ca->set->cache = ca;
 
 	err = "failed to run cache set";
-	if (run_cache_set(c) < 0)
+	if (fresh)
+		bch_cache_set_attach_devices(c);
+	else if (run_cache_set(c) < 0)
 		goto err;
 
+	mutex_unlock(&bch_register_lock);
 	return NULL;
 err:
+	mutex_unlock(&bch_register_lock);
 	bch_cache_set_unregister(c);
 	return err;
 }
@@ -2424,9 +2537,7 @@ static int register_cache(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
 		goto out;
 	}
 
-	mutex_lock(&bch_register_lock);
 	err = register_cache_set(ca);
-	mutex_unlock(&bch_register_lock);
 
 	if (err) {
 		ret = -ENODEV;
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index cfac56caa8047..d3b3f807b3e48 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -1032,6 +1032,14 @@ SHOW(__bch_cache)
 {
 	struct cache *ca = container_of(kobj, struct cache, kobj);
 
+	/*
+	 * ca->set is still being recovered without bch_register_lock held
+	 * (see bch_cache_set_recover()); its bucket_lock and on-disk
+	 * superblock are not safe to touch yet.
+	 */
+	if (ca->set && test_bit(CACHE_SET_REGISTERING, &ca->set->flags))
+		return -EAGAIN;
+
 	sysfs_hprint(bucket_size,	bucket_bytes(ca));
 	sysfs_hprint(block_size,	block_bytes(ca));
 	sysfs_print(nbuckets,		ca->sb.nbuckets);
@@ -1140,6 +1148,14 @@ STORE(__bch_cache)
 	if (bcache_is_reboot)
 		return -EBUSY;
 
+	/*
+	 * ca->set is still being recovered without bch_register_lock held
+	 * (see bch_cache_set_recover()); its bucket_lock and on-disk
+	 * superblock are not safe to touch yet.
+	 */
+	if (ca->set && test_bit(CACHE_SET_REGISTERING, &ca->set->flags))
+		return -EAGAIN;
+
 	if (attr == &sysfs_cache_replacement_policy) {
 		v = __sysfs_match_string(cache_replacement_policies, -1, buf);
 		if (v < 0)

---
base-commit: 502d801f0ab03e4f32f9a33d203154ce84887921
change-id: 20260706-feat-bcache-30e964a17dd2

Best regards,
-- 
Jing Wu <realwujing@gmail.com>

