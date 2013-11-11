From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: [GIT PULL] bcache for 3.13
Date: Sun, 10 Nov 2013 22:44:02 -0800
Message-ID: <20131111064401.GD20624@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Jens - here's the bcache pull, on top of your for-3.13/drivers branch:

The following changes since commit f7cb20f03dc6dff1b19942cf3dda6d154c86f29b:

  floppy: Correct documentation of driver options when used as a module. (2013-11-08 09:10:31 -0700)

are available in the git repository at:

  git://evilpiepirate.org/~kent/linux-bcache.git bcache-for-3.13

for you to fetch changes up to c86949486d41d9e7d7681fc72923555114fd702f:

  bcache: defensively handle format strings (2013-11-10 21:56:43 -0800)

----------------------------------------------------------------
Kees Cook (1):
      bcache: defensively handle format strings

Kent Overstreet (52):
      bcache: Fix dirty_data accounting
      bcache: Fix a journalling performance bug
      bcache: Fix a lockdep splat
      bcache: Use blkdev_issue_discard()
      bcache: Add on error panic/unregister setting
      bcache: Stripe size isn't necessarily a power of two
      bcache: Remove unnecessary check in should_split()
      bcache: Explicitly track btree node's parent
      bcache: Add btree_insert_node()
      bcache: Insert multiple keys at a time
      bcache: Convert btree_insert_check_key() to btree_insert_node()
      bcache: Add explicit keylist arg to btree_insert()
      bcache: Clean up keylist code
      bcache: Refactor request_write()
      bcache: Refactor read request code a bit
      bcache: Refactor journalling flow control
      bcache: Move keylist out of btree_op
      bcache: Convert try_wait to wait_queue_head_t
      bcache: Convert bucket_wait to wait_queue_head_t
      bcache: Convert gc to a kthread
      bcache: Convert writeback to a kthread
      bcache: Add btree_map() functions
      bcache: Move some stuff to btree.c
      bcache: Convert bch_btree_read_async() to bch_btree_map_keys()
      bcache: Clean up cache_lookup_fn
      bcache: Prune struct btree_op
      bcache: Kill op->cl
      bcache: Drop some closure stuff
      bcache: Kill op->replace
      bcache: Don't use op->insert_collision
      bcache: Convert bch_btree_insert() to bch_btree_map_leaf_nodes()
      bcache: Break up struct search
      bcache: Move sector allocator to alloc.c
      bcache: Pull on disk data structures out into a separate header
      bcache: Fix bch_ptr_bad()
      bcache: Debug code improvements
      bcache: Don't bother with bucket refcount for btree node allocations
      bcache: bch_(btree|extent)_ptr_invalid()
      bcache: PRECEDING_KEY()
      bcache: Add btree_node_write_sync()
      bcache: Add make_btree_freeing_key()
      bcache: Incremental gc
      bcache: Avoid deadlocking in garbage collection
      bcache: Kill bch_next_recurse_key()
      bcache: Kill sequential_merge option
      bcache: Move spinlock into struct time_stats
      bcache: Have btree_split() insert into parent directly
      bcache: Better full stripe scanning
      bcache: Fix sysfs splat on shutdown with flash only devs
      bcache: Use ida for bcache block dev minor
      bcache: Delete some slower inline asm
      bcache: Bypass torture test

 drivers/md/bcache/Kconfig     |   11 +-
 drivers/md/bcache/alloc.c     |  383 ++++++-----
 drivers/md/bcache/bcache.h    |  327 +---------
 drivers/md/bcache/bset.c      |  289 ++++-----
 drivers/md/bcache/bset.h      |   93 +--
 drivers/md/bcache/btree.c     | 1396 ++++++++++++++++++++++-------------------
 drivers/md/bcache/btree.h     |  195 ++----
 drivers/md/bcache/closure.c   |  103 +--
 drivers/md/bcache/closure.h   |  183 +-----
 drivers/md/bcache/debug.c     |  185 +++---
 drivers/md/bcache/debug.h     |   50 +-
 drivers/md/bcache/journal.c   |  293 +++++----
 drivers/md/bcache/journal.h   |   52 +-
 drivers/md/bcache/movinggc.c  |   87 ++-
 drivers/md/bcache/request.c   | 1102 ++++++++++++++++----------------
 drivers/md/bcache/request.h   |   43 +-
 drivers/md/bcache/stats.c     |   26 +-
 drivers/md/bcache/stats.h     |   13 +-
 drivers/md/bcache/super.c     |  190 +++---
 drivers/md/bcache/sysfs.c     |   42 +-
 drivers/md/bcache/trace.c     |    1 -
 drivers/md/bcache/util.c      |   12 +-
 drivers/md/bcache/util.h      |   15 +-
 drivers/md/bcache/writeback.c |  455 +++++++-------
 drivers/md/bcache/writeback.h |   46 +-
 include/trace/events/bcache.h |   47 +-
 include/uapi/linux/bcache.h   |  373 +++++++++++
 27 files changed, 2997 insertions(+), 3015 deletions(-)
 create mode 100644 include/uapi/linux/bcache.h
