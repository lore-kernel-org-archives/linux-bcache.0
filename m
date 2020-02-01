From: Coly Li <colyli@suse.de>
Subject: [PATCH 0/5] bcache patches for Linux v5.6-rc1
Date: Sat,  1 Feb 2020 22:42:30 +0800
Message-ID: <20200201144235.94110-1-colyli@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
List-Id: linux-bcache@vger.kernel.org

Hi Jens,

Here are the bcache patches for Linux v5.6-rc1. All the patches are
tested and survived my I/O pressure tests for 24+ hours intotal.

Please take them. Thank you in advance.

Coly Li
---

Coly Li (5):
  bcache: fix memory corruption in bch_cache_accounting_clear()
  bcache: explicity type cast in bset_bkey_last()
  bcache: add readahead cache policy options via sysfs interface
  bcache: fix incorrect data type usage in btree_flush_write()
  bcache: check return value of prio_read()

 drivers/md/bcache/bcache.h  |  3 +++
 drivers/md/bcache/bset.h    |  3 ++-
 drivers/md/bcache/journal.c |  3 ++-
 drivers/md/bcache/request.c | 17 ++++++++++++-----
 drivers/md/bcache/stats.c   | 10 +++++++---
 drivers/md/bcache/super.c   | 21 ++++++++++++++++-----
 drivers/md/bcache/sysfs.c   | 22 ++++++++++++++++++++++
 7 files changed, 64 insertions(+), 15 deletions(-)

-- 
2.16.4
