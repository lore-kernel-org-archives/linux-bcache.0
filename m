From: Coly Li <colyli@suse.de>
Subject: [PATCH v5 00/10] bcache: device failure handling improvement
Date: Tue,  6 Feb 2018 12:20:50 +0800
Message-ID: <20180206042100.65021-1-colyli@suse.de>
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
- Stop all the detached bcache devices (configurable)
- Stop all flash only volume on the cache set
The above process is named 'cache set retire' by me. The result of cache
set retire is, cache set and bcache devices are all removed, following
I/O requests will get failed immediately to notift upper layer or user
space coce that the cache device is failed or disconnected.
- Stop all the detached bcache devices (configurable)
- Stop all flash only volume on the cache set
The above process is named 'cache set retire' by me. The result of cache
set retire is, cache set and bcache devices are all removed
(configurable), following I/O requests will get failed immediately to
notify upper layer or user space coce that the cache device is failed or
disconnected.

There are 2 patches from v4 patch set is merged into bcache-for-next, they
are not in v5 patch set any more.

V5 patch set adds a new patch "bcache: add stop_when_cache_set_failed
option to backing device", which provides "auto"/"always" options to
configure whether or not to stop bcache device for a broken cache set. The
patch "bcache: stop all attached bcache devices for a retired cache set"
from v4 patch set is replaced by the above new added patch.

Most of the patches are reviewed by Hannes Reinecke and Junhui Tang. There
are still severl patches need to be reviewed,
- [PATCH v5 03/10] bcache: quit dc->writeback_thread when
  BCACHE_DEV_DETACHING is set
- [PATCH v5 06/10] bcache: add stop_when_cache_set_failed option to
   backing device 

Any comment, question and review are warmly welcome. Thanks in advance.

Changelog:
v5: replace patch "bcache: stop all attached bcache devices for a retired
    cache set" from v4 patch set by "bcache: add stop_when_cache_set_failed
    option to backing device" from v5 patch set. 
    fix issues from v4 patch set.
    improve kernel message format, remove redundant prefix string.
v4: add per-cached_dev option stop_attached_devs_on_fail to avoid stopping
    attached bcache device from a retiring cache set.
v3: fix detach issue find in v2 patch set.
v2: fixes all problems found in v1 review.
    add patches to handle backing device failure.
    add one more patch to set writeback_rate_update_seconds range.
    include a patch from Junhui Tang.
v1: the initial version, only handles cache device failure.

Coly Li


Coly Li (10):
  bcache: set writeback_rate_update_seconds in range [1, 60] seconds
  bcache: fix cached_dev->count usage for bch_cache_set_error()
  bcache: quit dc->writeback_thread when BCACHE_DEV_DETACHING is set
  bcache: stop dc->writeback_rate_update properly
  bcache: add CACHE_SET_IO_DISABLE to struct cache_set flags
  bcache: stop all attached bcache devices for a retired cache set
  bcache: add backing_request_endio() for bi_end_io of attached backing
    device I/O
  bcache: add io_disable to struct cached_dev
  bcache: stop bcache device when backing device is offline
  bcache: add stop_when_cache_set_failed option to backing device

Tang Junhui (1):
  bcache: fix inaccurate io state for detached bcache devices

 drivers/md/bcache/alloc.c     |   3 +-
 drivers/md/bcache/bcache.h    |  44 ++++++++-
 drivers/md/bcache/btree.c     |  10 +-
 drivers/md/bcache/io.c        |  16 +++-
 drivers/md/bcache/journal.c   |   4 +-
 drivers/md/bcache/request.c   | 185 +++++++++++++++++++++++++++++++------
 drivers/md/bcache/super.c     | 206 ++++++++++++++++++++++++++++++++++++++----
 drivers/md/bcache/sysfs.c     |  59 +++++++++++-
 drivers/md/bcache/util.h      |   6 --
 drivers/md/bcache/writeback.c |  94 ++++++++++++++++---
 drivers/md/bcache/writeback.h |   5 +-
 11 files changed, 551 insertions(+), 81 deletions(-)

-- 
2.16.1
