From: Denis Bychkov <manover@gmail.com>
Subject: BCACHE stability patches
Date: Tue, 22 Dec 2015 04:13:43 -0500
Message-ID: <CAO2mnow-HG_0pnDVFGfU0e+hPXfT=zMTrdemwiv=pxgJ+m4o2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:34232 "EHLO
	mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbbLVJNp (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 22 Dec 2015 04:13:45 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, Vojtech Pavlik <vojtech@suse.com>, Jiri Kosina <jkosina@suse.com>

Hi,

There is a set of bcache stability patches elevating bcache stability
to production level. As far as I know, there is no single reported and
peer confirmed bug that is not solved by this set. Unfortunately, for
some reason, Kent does not have enough time and/or energy to review
them and send them upstream. Let's come up with a solution that would
allow to review all these patches (some of them written by Ken
himself, some of them produced by the community), review them and hand
them to the maintainer who is willing to apply them upstream. Without
that, bcache is just another half-assed unstable and buggy cache
layer.
These patches will allow people to start use bcache in production systems.
Please find the patch set attached. (The patches apply cleanly to 4.3
and 4.4 kernel series).

---
From: Zheng Liu <wenqing.lz@taobao.com>

In bcache_init() function it forgot to unregister reboot notifier if
bcache fails to unregister a block device.  This commit fixes this.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Tested-by: Joshua Schmid <jschmid@suse.com>
---
 drivers/md/bcache/super.c | 4 +++-
  1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2066,8 +2066,10 @@ static int __init bcache_init(void)
  closure_debug_init();

  bcache_major = register_blkdev(0, "bcache");
- if (bcache_major < 0)
+ if (bcache_major < 0) {
+ unregister_reboot_notifier(&reboot);
  return bcache_major;
+ }

  if (!(bcache_wq = create_workqueue("bcache")) ||
     !(bcache_kobj = kobject_create_and_add("bcache", fs_kobj)) ||
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: linux-bcache@vger.kernel.org
Cc: Zheng Liu <wenqing.lz@taobao.com>, Joshua Schmid
<jschmid@suse.com>, Zhu Yanhai <zhu.yanhai@gmail.com>, Kent Overstreet
<kmo@daterainc.com>
Subject: [PATCH v2] bcache: fix a livelock in btree lock
Date: Wed, 25 Feb 2015 20:32:09 +0800 (02/25/2015 04:32:09 AM)
From: Zheng Liu <wenqing.lz@taobao.com>

This commit tries to fix a livelock in bcache.  This livelock might
happen when we causes a huge number of cache misses simultaneously.

When we get a cache miss, bcache will execute the following path.

->cached_dev_make_request()
  ->cached_dev_read()
    ->cached_lookup()
      ->bch->btree_map_keys()
        ->btree_root()  <------------------------
          ->bch_btree_map_keys_recurse()        |
            ->cache_lookup_fn()                 |
              ->cached_dev_cache_miss()         |
                ->bch_btree_insert_check_key() -|
                  [If btree->seq is not equal to seq + 1, we should return
                   EINTR and traverse btree again.]

In bch_btree_insert_check_key() function we first need to check upgrade
flag (op->lock == -1), and when this flag is true we need to release
read btree->lock and try to take write btree->lock.  During taking and
releasing this write lock, btree->seq will be monotone increased in
order to prevent other threads modify this in cache miss (see btree.h:74).
But if there are some cache misses caused by some requested, we could
meet a livelock because btree->seq is always changed by others.  Thus no
one can make progress.

This commit will try to take write btree->lock if it encounters a race
when we traverse btree.  Although it sacrifice the scalability but we
can ensure that only one can modify the btree.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Tested-by: Joshua Schmid <jschmid@suse.com>
Cc: Joshua Schmid <jschmid@suse.com>
Cc: Zhu Yanhai <zhu.yanhai@gmail.com>
Cc: Kent Overstreet <kmo@daterainc.com>
---
changelog:
v2: fix a bug that stops all concurrency writes unconditionally.

 drivers/md/bcache/btree.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -2162,8 +2162,10 @@ int bch_btree_insert_check_key(struct bt
  rw_lock(true, b, b->level);

  if (b->key.ptr[0] != btree_ptr ||
-    b->seq != seq + 1)
+                   b->seq != seq + 1) {
+                       op->lock = b->level;
  goto out;
+               }
  }

  SET_KEY_PTRS(check_key, 1);

From: Joshua Schmid <jschmid@suse.com>
Subject: [PATCH] fix a leak in bch_cached_dev_run()
Newsgroups: gmane.linux.kernel.bcache.devel
Date: 2015-02-03 11:24:06 GMT (3 weeks, 2 days, 11 hours and 43 minutes ago)

From: Al Viro <viro@ZenIV.linux.org.uk>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Joshua Schmid <jschmid@suse.com>
---
 drivers/md/bcache/super.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -847,8 +847,11 @@ void bch_cached_dev_run(struct cached_de
  buf[SB_LABEL_SIZE] = '\0';
  env[2] = kasprintf(GFP_KERNEL, "CACHED_LABEL=%s", buf);

- if (atomic_xchg(&dc->running, 1))
+ if (atomic_xchg(&dc->running, 1)) {
+ kfree(env[1]);
+ kfree(env[2]);
  return;
+ }

  if (!d->c &&
     BDEV_STATE(&dc->sb) != BDEV_STATE_NONE) {
From: Denis Bychkov <manover@gmail.com>

Allows to use register, not register_quiet in udev to avoid "device_busy" error.
The initial patch proposed at https://lkml.org/lkml/2013/8/26/549 by
Gabriel de Perthuis
<g2p.code@gmail.com> does not unlock the mutex and hangs the kernel.

See http://thread.gmane.org/gmane.linux.kernel.bcache.devel/2594 for
the discussion.
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1936,6 +1936,8 @@ static ssize_t register_bcache(struct ko
  else
  err = "device busy";
  mutex_unlock(&bch_register_lock);
+ if (attr == &ksysfs_register_quiet)
+ goto out;
  }
  goto err;
  }
@@ -1974,8 +1976,7 @@ out:
 err_close:
  blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
 err:
- if (attr != &ksysfs_register_quiet)
- pr_info("error opening %s: %s", path, err);
+ pr_info("error opening %s: %s", path, err);
  ret = -EINVAL;
  goto out;
 }
From f0e6320a7874af434575f37a11ec6e4992cef790 Mon Sep 17 00:00:00 2001
From: Kent Overstreet <kmo@daterainc.com>
Date: Sat, 1 Nov 2014 13:44:47 -0700
Subject: [PATCH 1/5] bcache: Add a cond_resched() call to gc
Git-commit: f0e6320a7874af434575f37a11ec6e4992cef790
Patch-mainline: Submitted
References: bnc#910440

Change-id: Id4f18c533b80ddb40df94ed0bb5e2a236a4bc325
Signed-off-by: Takashi Iwai <tiwai@suse.de>

---
 drivers/md/bcache/btree.c | 1 +
  1 file changed, 1 insertion(+)

--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1741,6 +1741,7 @@ static void bch_btree_gc(struct cache_se
  do {
  ret = btree_root(gc_root, c, &op, &writes, &stats);
  closure_sync(&writes);
+ cond_resched();

  if (ret && ret != -EAGAIN)
  pr_warn("gc failed!");
From: Joshua Schmid <jschmid@suse.com>
Subject: [PATCH] bcache: [BUG] clear BCACHE_DEV_UNLINK_DONE flag when
attaching a backing device
Newsgroups: gmane.linux.kernel.bcache.devel
Date: 2015-02-03 11:18:01 GMT (3 weeks, 2 days, 11 hours and 45 minutes ago)

From: Zheng Liu <wenqing.lz@taobao.com>

This bug can be reproduced by the following script:

  #!/bin/bash

  bcache_sysfs="/sys/fs/bcache"

  function clear_cache()
  {
  if [ ! -e $bcache_sysfs ]; then
  echo "no bcache sysfs"
  exit
  fi

  cset_uuid=$(ls -l $bcache_sysfs|head -n 2|tail -n 1|awk '{print $9}')
  sudo sh -c "echo $cset_uuid > /sys/block/sdb/sdb1/bcache/detach"
  sleep 5
  sudo sh -c "echo $cset_uuid > /sys/block/sdb/sdb1/bcache/attach"
  }

  for ((i=0;i<10;i++)); do
  clear_cache
  done

The warning messages look like below:
[  275.948611] ------------[ cut here ]------------
[  275.963840] WARNING: at fs/sysfs/dir.c:512
sysfs_add_one+0xb8/0xd0() (Tainted: P        W
---------------   )
[  275.979253] Hardware name: Tecal RH2285
[  275.994106] sysfs: cannot create duplicate filename
'/devices/pci0000:00/0000:00:09.0/0000:08:00.0/host4/target4:2:1/4:2:1:0/block/sdb/sdb1/bcache/cache'
[  276.024105] Modules linked in: bcache tcp_diag inet_diag
ipmi_devintf ipmi_si ipmi_msghandler
bonding 8021q garp stp llc ipv6 ext3 jbd loop sg iomemory_vsl(P) bnx2
microcode serio_raw i2c_i801
i2c_core iTCO_wdt iTCO_vendor_support i7core_edac edac_core shpchp
ext4 jbd2 mbcache megaraid_sas
pata_acpi ata_generic ata_piix dm_mod [last unloaded: scsi_wait_scan]
[  276.072643] Pid: 2765, comm: sh Tainted: P        W
---------------    2.6.32 #1
[  276.089315] Call Trace:
[  276.105801]  [<ffffffff81070fe7>] ? warn_slowpath_common+0x87/0xc0
[  276.122650]  [<ffffffff810710d6>] ? warn_slowpath_fmt+0x46/0x50
[  276.139361]  [<ffffffff81205c08>] ? sysfs_add_one+0xb8/0xd0
[  276.156012]  [<ffffffff8120609b>] ? sysfs_do_create_link+0x12b/0x170
[  276.172682]  [<ffffffff81206113>] ? sysfs_create_link+0x13/0x20
[  276.189282]  [<ffffffffa03bda21>] ? bcache_device_link+0xc1/0x110 [bcache]
[  276.205993]  [<ffffffffa03bfa08>] ?
bch_cached_dev_attach+0x478/0x4f0 [bcache]
[  276.222794]  [<ffffffffa03c4a17>] ? bch_cached_dev_store+0x627/0x780 [bcache]
[  276.239680]  [<ffffffff8116783a>] ? alloc_pages_current+0xaa/0x110
[  276.256594]  [<ffffffff81203b15>] ? sysfs_write_file+0xe5/0x170
[  276.273364]  [<ffffffff811887b8>] ? vfs_write+0xb8/0x1a0
[  276.290133]  [<ffffffff811890b1>] ? sys_write+0x51/0x90
[  276.306368]  [<ffffffff8100c072>] ? system_call_fastpath+0x16/0x1b
[  276.322301] ---[ end trace 9f5d4fcdd0c3edfb ]---
[  276.338241] ------------[ cut here ]------------
[  276.354109] WARNING: at /home/wenqing.lz/bcache/bcache/super.c:720
bcache_device_link+0xdf/0x110 [bcache]() (Tainted: P        W
---------------   )
[  276.386017] Hardware name: Tecal RH2285
[  276.401430] Couldn't create device <-> cache set symlinks
[  276.401759] Modules linked in: bcache tcp_diag inet_diag
ipmi_devintf ipmi_si ipmi_msghandler
bonding 8021q garp stp llc ipv6 ext3 jbd loop sg iomemory_vsl(P) bnx2
microcode serio_raw i2c_i801
i2c_core iTCO_wdt iTCO_vendor_support i7core_edac edac_core shpchp
ext4 jbd2 mbcache megaraid_sas
pata_acpi ata_generic ata_piix dm_mod [last unloaded: scsi_wait_scan]
[  276.465477] Pid: 2765, comm: sh Tainted: P        W
---------------    2.6.32 #1
[  276.482169] Call Trace:
[  276.498610]  [<ffffffff81070fe7>] ? warn_slowpath_common+0x87/0xc0
[  276.515405]  [<ffffffff810710d6>] ? warn_slowpath_fmt+0x46/0x50
[  276.532059]  [<ffffffffa03bda3f>] ? bcache_device_link+0xdf/0x110 [bcache]
[  276.548808]  [<ffffffffa03bfa08>] ?
bch_cached_dev_attach+0x478/0x4f0 [bcache]
[  276.565569]  [<ffffffffa03c4a17>] ? bch_cached_dev_store+0x627/0x780 [bcache]
[  276.582418]  [<ffffffff8116783a>] ? alloc_pages_current+0xaa/0x110
[  276.599341]  [<ffffffff81203b15>] ? sysfs_write_file+0xe5/0x170
[  276.616142]  [<ffffffff811887b8>] ? vfs_write+0xb8/0x1a0
[  276.632607]  [<ffffffff811890b1>] ? sys_write+0x51/0x90
[  276.648671]  [<ffffffff8100c072>] ? system_call_fastpath+0x16/0x1b
[  276.664756] ---[ end trace 9f5d4fcdd0c3edfc ]---

We forget to clear BCACHE_DEV_UNLINK_DONE flag in bcache_device_attach()
function when we attach a backing device first time.  After detaching this
backing device, this flag will be true and sysfs_remove_link() isn't called in
bcache_device_unlink().  Then when we attach this backing device again,
sysfs_create_link() will return EEXIST error in bcache_device_link().

So the fix is trival and we clear this flag in bcache_device_link().

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Tested-by: Joshua Schmid <jschmid@suse.com>
---
 drivers/md/bcache/super.c | 2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -685,6 +685,8 @@ static void bcache_device_link(struct bc
  WARN(sysfs_create_link(&d->kobj, &c->kobj, "cache") ||
      sysfs_create_link(&c->kobj, &d->kobj, d->name),
      "Couldn't create device <-> cache set symlinks");
+
+ clear_bit(BCACHE_DEV_UNLINK_DONE, &d->flags);
 }

 static void bcache_device_detach(struct bcache_device *d)
---
From e949c64fa6acbdaab999410250855a6a4fc6bad1 Mon Sep 17 00:00:00 2001
From: Stefan Bader <stefan.bader@canonical.com>
Date: Mon, 18 Aug 2014 20:00:13 +0200
Subject: [PATCH] bcache: prevent crash on changing writeback_running

commit a664d0f05a2e ("bcache: fix crash on shutdown in passthrough mode")

added a safeguard in the shutdown case. At least while not being
attached it is also possible to trigger a kernel bug by writing into
writeback_running. This change  adds the same check before trying to
wake up the thread for that case.

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/md/bcache/writeback.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)
--- a/drivers/md/bcache/writeback.h
+++ b/drivers/md/bcache/writeback.h
@@ -63,7 +63,8 @@ static inline bool should_writeback(stru

 static inline void bch_writeback_queue(struct cached_dev *dc)
 {
- wake_up_process(dc->writeback_thread);
+ if (!IS_ERR_OR_NULL(dc->writeback_thread))
+ wake_up_process(dc->writeback_thread);
 }

 static inline void bch_writeback_add(struct cached_dev *dc)
Subject: [PATCH] bcache: Change refill_dirty() to always scan entire
disk if necessary

Previously, it would only scan the entire disk if it was starting from the very
start of the disk - i.e. if the previous scan got to the end.

This was broken by refill_full_stripes(), which updates last_scanned so that
refill_dirty was never triggering the searched_from_start path.

But if we change refill_dirty() to always scan the entire disk if necessary,
regardless of what last_scanned was, the code gets cleaner and we fix that bug
too.

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
---
 drivers/md/bcache/writeback.c | 37 ++++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -323,6 +323,10 @@ void bcache_dev_sectors_dirty_add(struct

 static bool dirty_pred(struct keybuf *buf, struct bkey *k)
 {
+ struct cached_dev *dc = container_of(buf, struct cached_dev, writeback_keys);
+
+ BUG_ON(KEY_INODE(k) != dc->disk.id);
+
  return KEY_DIRTY(k);
 }

@@ -372,11 +376,24 @@ next:
  }
 }

+/*
+ * Returns true if we scanned the entire disk
+ */
 static bool refill_dirty(struct cached_dev *dc)
 {
  struct keybuf *buf = &dc->writeback_keys;
+ struct bkey start = KEY(dc->disk.id, 0, 0);
  struct bkey end = KEY(dc->disk.id, MAX_KEY_OFFSET, 0);
- bool searched_from_start = false;
+ struct bkey start_pos;
+
+ /*
+ * make sure keybuf pos is inside the range for this disk - at bringup
+ * we might not be attached yet so this disk's inode nr isn't
+ * initialized then
+ */
+ if (bkey_cmp(&buf->last_scanned, &start) < 0 ||
+    bkey_cmp(&buf->last_scanned, &end) > 0)
+ buf->last_scanned = start;

  if (dc->partial_stripes_expensive) {
  refill_full_stripes(dc);
@@ -384,14 +401,20 @@ static bool refill_dirty(struct cached_d
  return false;
  }

- if (bkey_cmp(&buf->last_scanned, &end) >= 0) {
- buf->last_scanned = KEY(dc->disk.id, 0, 0);
- searched_from_start = true;
- }
-
+ start_pos = buf->last_scanned;
  bch_refill_keybuf(dc->disk.c, buf, &end, dirty_pred);

- return bkey_cmp(&buf->last_scanned, &end) >= 0 && searched_from_start;
+ if (bkey_cmp(&buf->last_scanned, &end) < 0)
+ return false;
+
+ /*
+ * If we get to the end start scanning again from the beginning, and
+ * only scan up to where we initially started scanning from:
+ */
+ buf->last_scanned = start;
+ bch_refill_keybuf(dc->disk.c, buf, &start_pos, dirty_pred);
+
+ return bkey_cmp(&buf->last_scanned, &start_pos) >= 0;
 }

 static int bch_writeback_thread(void *arg)
---

-- 

Denis
