From: Coly Li <colyli@suse.de>
Subject: [RFC] bcache: fix a circular dead locking with dc->writeback_lock and bch_register_lock
Date: Sat, 18 Nov 2017 16:14:15 +0800
Message-ID: <20171118081415.49669-1-colyli@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
List-Id: linux-bcache@vger.kernel.org

When bcache is in writeback mode, and with heavy write I/O, a warning by
lockdep check reports a potential circular locking issue,

[   58.084940] ======================================================
[   58.084941] WARNING: possible circular locking dependency detected
[   58.084942] 4.14.0-1-default+ #3 Tainted: G        W
[   58.084943] ------------------------------------------------------
[   58.084944] kworker/0:3/1140 is trying to acquire lock:
[   58.084945]  (&bch_register_lock){+.+.}, at: [<ffffffffa069a29b>] update_writeback_rate+0x8b/0x290 [bcache]
[   58.084958]
               but task is already holding lock:
[   58.084958]  (&dc->writeback_lock){++++}, at: [<ffffffffa069a22f>] update_writeback_rate+0x1f/0x290 [bcache]
[   58.084966]
               which lock already depends on the new lock.

[   58.084966]
               the existing dependency chain (in reverse order) is:
[   58.084967]
               -> #1 (&dc->writeback_lock){++++}:
[   58.084972]        down_write+0x51/0xb0
[   58.084978]        bch_cached_dev_attach+0x239/0x500 [bcache]
[   58.084983]        run_cache_set+0x683/0x880 [bcache]
[   58.084987]        register_bcache+0xec7/0x1450 [bcache]
[   58.084990]        kernfs_fop_write+0x10e/0x1a0
[   58.084994]        __vfs_write+0x23/0x150
[   58.084995]        vfs_write+0xc2/0x1c0
[   58.084996]        SyS_write+0x45/0xa0
[   58.084997]        entry_SYSCALL_64_fastpath+0x23/0x9a
[   58.084998]
               -> #0 (&bch_register_lock){+.+.}:
[   58.085002]        lock_acquire+0xd4/0x220
[   58.085003]        __mutex_lock+0x70/0x950
[   58.085009]        update_writeback_rate+0x8b/0x290 [bcache]
[   58.085011]        process_one_work+0x1e5/0x5e0
[   58.085012]        worker_thread+0x4a/0x3f0
[   58.085014]        kthread+0x141/0x180
[   58.085015]        ret_from_fork+0x24/0x30
[   58.085015]
               other info that might help us debug this:

[   58.085015]  Possible unsafe locking scenario:

[   58.085016]        CPU0                    CPU1
[   58.085016]        ----                    ----
[   58.085016]   lock(&dc->writeback_lock);
[   58.085017]                                lock(&bch_register_lock);
[   58.085018]                                lock(&dc->writeback_lock);
[   58.085019]   lock(&bch_register_lock);
[   58.085019]
                *** DEADLOCK ***

This is a real circular locking issue, it may hold dc->writeback_lock
for long time, block btree related operations, introduce long latency
for front end I/O requests on cache device.

The code path of bch_cached_dev_attach() firstly aquires bch_register_lock
then acquires dc->writeback_lock. And code path of kworker function
update_writeback_rate() firstly acquires dc->writeback_lock then acquires
bch_register_lock.

In kworker function update_writeback_rate(), mutex dc->writeback_lock is
acquired before calling __update_writeback_rate(). After read the code
carefully it seems holding dc->writeback_lock in update_writeback_rate()
is unncessary. Let me explain why.

In __update_writeback_rate(), when bcache_flash_devs_sectors_dirty() is
called, mutex bch_register_lock is acquired to prevent bcache devices
changes (add/remove) from the cache set, which is necessary. But rested
global objects do not need writeback_lock protection.

Let's see each global objects referenced in __update_writeback_rate(),
- The following 3 objects are only read and always same value. They don't
  need to be protected by dc->writeback_lock.
	dc->disk.c
	c->nbuckets
	c->sb.bucket_size
- The following objects are only changed and referenced inside non re-
  entrancy function __update_writeback_rate(), then don't need to be
  protected by dc->writeback_lock.
	dc->writeback_rate_p_term_inverse
	dc->writeback_rate_integral
	dc->writeback_rate_update_seconds
	dc->writeback_rate_i_term_inverse
	dc->writeback_rate_minimum
	dc->writeback_rate_proportional
	dc->writeback_rate_integral_scaled
	dc->writeback_rate_change
	dc->writeback_rate_target
- dc->writeback_percent
  Only changed via sysfs interface in runtime, and it is a 8bit variable,
  it is safe to access without dc->writeback_lock.
- c->cached_dev_sectors
  This is a 64bit variable, updated in calc_cached_dev_sectors() and
  only read in __update_writeback_rate(). Change it into atomic64_t will
  be safe enough on both 32bit and 64bit hardware.
- bcache_dev_sectors_dirty()
  Inside this function, d->nr_stripes is a consistent number in run time,
  stripe_sectors_dirty on each stripe is atomic_t, they are updated in
  bcache_dev_sectors_dirty_add() and only read in function
  bcache_dev_sectors_dirty(). It is safe to access these varaibles without
  dc->writeback_lock. And if the bcache is removing from cache set, its
  cached device's writebackrate update kworker should be canceled firstly,
  so we don't need to worry about a NULL pointer dereference if bcache
  device is removed when bcache_dev_sectors_dirty() is executing.
- dc->writeback_rate.next
  writeback_rate.next is only read in __update_writeback_rate() and
  updated in bch_next_delay(). bch_next_delay() is referenced by
  writeback_delay()<-read_dirty()<-bch_writeback_thread(), while mutex
  dc->writeback_lock is not held. That is to say, current bcache code
  does not protect writeback_rate.next for concurrent access at all. For
  32bit hardware it might be problematic. This patch doesn't fix existing
  concurrent access issue on 32bit hardware, but not make things worse
  neither.
- dc->writeback_rate.rate
  writeback_rate.rate is only read in bch_next_delay() and updated in
  __update_writeback_rate(). Again its concurrent access is not protected
  by dc->writeback_lock, it is 32bit and only modified in one thread, so
  it is safe to use for now.

From the above analysis, kworker function update_writeback_rate() can work
properly without protection of dc->writeback_lock. The writeback rate
calculation might not be extremely accurate but good enough for writeback
I/O throttle.

By removing mutex dc->writeback_lock, we can avoid a deadlock. And further
more, avoid lock contention between kworker update_writeback_rate() and
btree operations on dc->writeback_lock, which means a potential better I/O
latency for front end I/O requests. Because in writeback mode, front end
I/O request also needs to acquire dc->writeback_lock for btree operations.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/bcache.h    | 2 +-
 drivers/md/bcache/super.c     | 2 +-
 drivers/md/bcache/writeback.c | 6 +-----
 3 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 843877e017e1..1b6964077100 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -489,7 +489,7 @@ struct cache_set {
 
 	struct bcache_device	**devices;
 	struct list_head	cached_devs;
-	uint64_t		cached_dev_sectors;
+	atomic64_t		cached_dev_sectors;
 	struct closure		caching;
 
 	struct closure		sb_write;
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index b4d28928dec5..879e1a135180 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -847,7 +847,7 @@ static void calc_cached_dev_sectors(struct cache_set *c)
 	list_for_each_entry(dc, &c->cached_devs, list)
 		sectors += bdev_sectors(dc->bdev);
 
-	c->cached_dev_sectors = sectors;
+	atomic64_set(&c->cached_dev_sectors, sectors);
 }
 
 void bch_cached_dev_run(struct cached_dev *dc)
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 56a37884ca8b..cec10e6345af 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -27,7 +27,7 @@ static void __update_writeback_rate(struct cached_dev *dc)
 	uint64_t cache_dirty_target =
 		div_u64(cache_sectors * dc->writeback_percent, 100);
 	int64_t target = div64_u64(cache_dirty_target * bdev_sectors(dc->bdev),
-				   c->cached_dev_sectors);
+				   atomic64_read(&c->cached_dev_sectors));
 
 	/*
 	 * PI controller:
@@ -92,14 +92,10 @@ static void update_writeback_rate(struct work_struct *work)
 					     struct cached_dev,
 					     writeback_rate_update);
 
-	down_read(&dc->writeback_lock);
-
 	if (atomic_read(&dc->has_dirty) &&
 	    dc->writeback_percent)
 		__update_writeback_rate(dc);
 
-	up_read(&dc->writeback_lock);
-
 	schedule_delayed_work(&dc->writeback_rate_update,
 			      dc->writeback_rate_update_seconds * HZ);
 }
-- 
2.13.6
