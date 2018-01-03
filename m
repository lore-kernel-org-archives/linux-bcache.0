From: Coly Li <colyli@suse.de>
Subject: [PATCH v1 00/10] cache device failure handling improvement
Date: Wed,  3 Jan 2018 22:03:15 +0800
Message-ID: <20180103140325.63175-1-colyli@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, mlyle@lyle.org, tang.junhui@zte.com.cn, Coly Li <colyli@suse.de>
List-Id: linux-bcache@vger.kernel.org

Hi maintainers and folks,

This patch set tries to improve cache device failure handling. A basic
idea to handle failed cache device is,
- Unregister cache set
- Detach all backing devices attached to this cache set
- Stop all bcache devices linked to this cache set
The above process is named 'cache set retire' by me. The result of cache
set retire is, cache set and bcache devices are all removed, following
I/O requests will get failed immediately to notift upper layer or user
space coce that the cache device is failed or disconnected.

The first 8 patches of this patch set is to fix existing bugs in bcache,
the last 2 patches do the real improvement. Order of applying these patches
is important, if the last 2 patches are applied firstly, kernel panic or
process hang will be observed. Therefore I suggest to apply the first 8
fixes, then apply the last 2 patches.

The patch set is tested with writethrough, writeback, writearound mode,
read/write/readwrite workloads, so far it works as expected. IMHO the
cache set retire logic is complicated, I need your help to review the
patches, any question is warmly wlecome.

Coly Li (10):
  bcache: exit bch_writeback_thread() with proper task state
  bcache: set task properly in allocator_wait()
  bcache: reduce cache_set devices iteration by devices_max_used
  bcache: fix cached_dev->count usage for bch_cache_set_error()
  bcache: stop dc->writeback_rate_update if cache set is stopping
  bcache: stop dc->writeback_rate_update, dc->writeback_thread earlier
  bcache: set error_limit correctly
  bcache: fix misleading error message in bch_count_io_errors()
  bcache: add io_disable to struct cache_set
  bcache: stop all attached bcache devices for a retired cache set

 drivers/md/bcache/alloc.c     |  5 ++---
 drivers/md/bcache/bcache.h    | 19 +++++++++++++++-
 drivers/md/bcache/btree.c     |  8 ++++---
 drivers/md/bcache/io.c        | 15 ++++++++-----
 drivers/md/bcache/journal.c   |  4 ++--
 drivers/md/bcache/request.c   | 26 ++++++++++++++++------
 drivers/md/bcache/super.c     | 51 +++++++++++++++++++++++++++++++++++--------
 drivers/md/bcache/sysfs.c     |  8 +++++--
 drivers/md/bcache/util.h      |  6 -----
 drivers/md/bcache/writeback.c | 51 +++++++++++++++++++++++++++++++++----------
 drivers/md/bcache/writeback.h |  4 +---
 11 files changed, 144 insertions(+), 53 deletions(-)

Thanks in advance.

Coly Li
