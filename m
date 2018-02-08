From: Coly Li <colyli@suse.de>
Subject: [PATCH v6 0/9] bcache: device failure handling improvement
Date: Thu,  8 Feb 2018 23:44:54 +0800
Message-ID: <20180208154503.92463-1-colyli@suse.de>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47599 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752266AbeBHPpQ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 8 Feb 2018 10:45:16 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, Coly Li <colyli@suse.de>

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

one patch from v5 patch set is merged into bcache-for-next, which is not
in v6 patch set any longer. The changes of v6 patch set are only for typo
fix, which were pointed out by Nix, Michael and other developers.

So far all patches have peer review, thank you all, bcache developers! 

Changelog:
v6: fix typo and mistaken spelling.
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
---

Coly Li (8):
  bcache: fix cached_dev->count usage for bch_cache_set_error()
  bcache: quit dc->writeback_thread when BCACHE_DEV_DETACHING is set
  bcache: stop dc->writeback_rate_update properly
  bcache: add CACHE_SET_IO_DISABLE to struct cache_set flags
  bcache: add stop_when_cache_set_failed option to backing device
  bcache: add backing_request_endio() for bi_end_io of attached backing
    device I/O
  bcache: add io_disable to struct cached_dev
  bcache: stop bcache device when backing device is offline

Tang Junhui (1):
  bcache: fix inaccurate io state for detached bcache devices

 drivers/md/bcache/alloc.c     |   3 +-
 drivers/md/bcache/bcache.h    |  44 ++++++++-
 drivers/md/bcache/btree.c     |  10 ++-
 drivers/md/bcache/io.c        |  16 +++-
 drivers/md/bcache/journal.c   |   4 +-
 drivers/md/bcache/request.c   | 185 ++++++++++++++++++++++++++++++++------
 drivers/md/bcache/super.c     | 205 ++++++++++++++++++++++++++++++++++++++----
 drivers/md/bcache/sysfs.c     |  55 +++++++++++-
 drivers/md/bcache/util.h      |   6 --
 drivers/md/bcache/writeback.c |  92 ++++++++++++++++---
 drivers/md/bcache/writeback.h |   2 -
 11 files changed, 543 insertions(+), 79 deletions(-)

-- 
2.16.1
