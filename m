From: Coly Li <colyli@suse.de>
Subject: [RFC PATCH 0/4] bcache-tools: changes for large bucket size
Date: Mon,  6 Jul 2020 00:04:36 +0800
Message-ID: <20200705160440.5801-1-colyli@suse.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
List-Id: linux-bcache@vger.kernel.org

These are user space tools changes necessary for bcache large bucket
size. When setting bucket size with '-u' larger than 16MB for cache
device, BCACHE_SB_VERSION_CDEV_WITH_FEATURES will be set automatically.
Otherwise, the new added members in super block won't be touched.

Coly Li
---
Coly Li (4):
  bcache-tools: comments offset for members of struct cache_sb
  struct_offset: print offset of each member of the on-disk data
    structure
  bcache-tools: The new super block version
    BCACHE_SB_VERSION_BDEV_WITH_FEATURES
  bcache-tools: add large_bucket incompat feature

 Makefile        |   6 +-
 bcache.h        | 153 ++++++++++++++++++++++++++++++++++++++----------
 features.c      |  24 ++++++++
 lib.c           |  24 ++++++++
 lib.h           |   2 +
 make.c          |  36 ++++++++----
 struct_offset.c |  63 ++++++++++++++++++++
 7 files changed, 265 insertions(+), 43 deletions(-)
 create mode 100644 features.c
 create mode 100644 struct_offset.c

-- 
2.26.2
