From: Coly Li <colyli@suse.de>
Subject: [PATCH v3 00/13] bcache: device failure handling improvement
Date: Sun, 14 Jan 2018 22:42:23 +0800
Message-ID: <20180114144236.28213-1-colyli@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
List-Id: linux-bcache@vger.kernel.org

Hi maintainers and folks,

This patch set tries to improve bcache device failure handling, includes
cache device and backing device failures.

The basic idea to handle failed cache device is,
- Unregister cache set
- Detach all backing devices which are attached to this cache set
- Stop all the detached bcache devices
- Stop all flash only volume on the cache set
The above process is named 'cache set retire' by me. The result of cache
set retire is, cache set and bcache devices are all removed, following
I/O requests will get failed immediately to notift upper layer or user
space coce that the cache device is failed or disconnected.

For failed backing device, there are two kinds of failures to handle,
- If device is disconnected, and kernel thread dc->status_update_thread
  finds it is offline for BACKING_DEV_OFFLINE_TIMEOUT (5) seconds, the
  kernel thread will set dc->io_disable and call bcache_device_stop() to
  stop and remove the bcache device from system.
- If device is alive but returns too many I/O errors, after errors number
  exceeds dc->error_limit, call bch_cached_dev_error() to set
  dc->io_disable and stop bcache device. Then the broken backing device
  and its bcache device will be removed from system.

The v3 patch set adds one more patch to fix the detach issue found in
v2 patch set.

A basic testing covered with writethrough, writeback, writearound mode, and
read/write/readwrite workloads, cache set or bcache device can be removed
by too many I/O errors or delete the device. For plugging out physical
disks, a kernel bug triggers rcu oops in __do_softirq() and locks up all
following accesses to the disconnected disk, this blocks my testing.

Open issues:
1, A kernel bug in __do_softirq() when plugging out hard disk with heavy
   I/O blocks my physical disk disconnection test. This is not problem
   introduced from this patch set, if any one knows this bug, please give
   me a hint.

Changelog:
v3: fix detach issue find in v2 patch set.
v2: fixes all problems found in v1 review.
    add patches to handle backing device failure.
    add one more patch to set writeback_rate_update_seconds range.
    include a patch from Junhui Tang.
v1: the initial version, only handles cache device failure.

Any comment, question and review are warmly welcome. Thanks in advance.

Coly Li
---

Coly Li (12):
  bcache: set writeback_rate_update_seconds in range [1, 60] seconds
  bcache: properly set task state in bch_writeback_thread()
  bcache: set task properly in allocator_wait()
  bcache: fix cached_dev->count usage for bch_cache_set_error()
  bcache: quit dc->writeback_thread when BCACHE_DEV_DETACHING is set
  bcache: stop dc->writeback_rate_update properly
  bcache: set error_limit correctly
  bcache: add CACHE_SET_IO_DISABLE to struct cache_set flags
  bcache: stop all attached bcache devices for a retired cache set
  bcache: add backing_request_endio() for bi_end_io of attached backing
    device I/O
  bcache: add io_disable to struct cached_dev
  bcache: stop bcache device when backing device is offline

Tang Junhui (1):
  bcache: fix inaccurate io state for detached bcache devices

 drivers/md/bcache/alloc.c     |   5 +-
 drivers/md/bcache/bcache.h    |  37 ++++++++-
 drivers/md/bcache/btree.c     |  10 ++-
 drivers/md/bcache/io.c        |  16 +++-
 drivers/md/bcache/journal.c   |   4 +-
 drivers/md/bcache/request.c   | 187 +++++++++++++++++++++++++++++++++++-------
 drivers/md/bcache/super.c     | 134 ++++++++++++++++++++++++++++--
 drivers/md/bcache/sysfs.c     |  45 +++++++++-
 drivers/md/bcache/util.h      |   6 --
 drivers/md/bcache/writeback.c |  99 ++++++++++++++++++----
 drivers/md/bcache/writeback.h |   5 +-
 11 files changed, 474 insertions(+), 74 deletions(-)

-- 
2.15.1
