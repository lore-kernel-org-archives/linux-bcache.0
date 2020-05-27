From: Coly Li <colyli@suse.de>
Subject: [PATCH v2 0/5] bcache patches for Linux-5.8
Date: Wed, 27 May 2020 12:01:50 +0800
Message-ID: <20200527040155.43690-1-colyli@suse.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
List-Id: linux-bcache@vger.kernel.org

Hi Jens,

This is the bcache patches for Linux v5.8.

Patches from Colin Ian King and Joe Perches are sent again for v5.8
merge windows. The first patch from me is to fix a refcount underflow
issue when stopping a pending backing device without created bcache
device. The last two patches from me is for an experiment sysfs
interface to register bcache devices in asynchronous way, to avoid
the udevd timeout issue which I tried before.

Please take them for v5.8, and thank you in advance.

Coly Li
---
Changelog:
v2: improve "bcache: fix refcount underflow in bcache_device_free()"
    to be cleaner by Jens' suggestion.
v1: first submission.

Colin Ian King (1):
  bcache: remove redundant variables i and n

Coly Li (3):
  bcache: fix refcount underflow in bcache_device_free()
  bcache: asynchronous devices registration
  bcache: configure the asynchronous registertion to be experimental

Joe Perches (1):
  bcache: Convert pr_<level> uses to a more typical style

 drivers/md/bcache/Kconfig     |   9 ++
 drivers/md/bcache/bcache.h    |   2 +-
 drivers/md/bcache/bset.c      |   6 +-
 drivers/md/bcache/btree.c     |  16 +--
 drivers/md/bcache/extents.c   |  12 +-
 drivers/md/bcache/io.c        |   8 +-
 drivers/md/bcache/journal.c   |  34 ++---
 drivers/md/bcache/request.c   |   6 +-
 drivers/md/bcache/super.c     | 232 +++++++++++++++++++++++++---------
 drivers/md/bcache/sysfs.c     |   8 +-
 drivers/md/bcache/writeback.c |   6 +-
 11 files changed, 226 insertions(+), 113 deletions(-)

-- 
2.25.0
