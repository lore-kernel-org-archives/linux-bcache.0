Return-Path: <SRS0=SjEI=A2=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB8B2C433E1
	for <linux-bcache@archiver.kernel.org>; Wed, 15 Jul 2020 14:30:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C96B205CB
	for <linux-bcache@archiver.kernel.org>; Wed, 15 Jul 2020 14:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbgGOOaY (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Wed, 15 Jul 2020 10:30:24 -0400
Received: from [195.135.220.15] ([195.135.220.15]:59324 "EHLO mx2.suse.de"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1728030AbgGOOaY (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 15 Jul 2020 10:30:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 871C5AF34;
        Wed, 15 Jul 2020 14:30:25 +0000 (UTC)
From:   colyli@suse.de
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH v3 00/16] bcache: extend bucket size to 32bit width
Date:   Wed, 15 Jul 2020 22:29:59 +0800
Message-Id: <20200715143015.14957-1-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Coly Li <colyli@suse.de>

This patch series is an effort to extent bucket_size from 16bit to
32bit width. This is the code base for next step to use zoned device as
cache device.

In this series, these changes should be noticed,
- Increase the super block version to
        BCACHE_SB_VERSION_CDEV_WITH_FEATURES 5
        BCACHE_SB_VERSION_BDEV_WITH_FEATURES 6
- The new version adds 3 new members,
        __le64          feature_compat;
        __le64          feature_incompat;
        __le64          feature_ro_compat;
  If new feature added will change the on-disk format, just setting the
  feature set bits, no need to upstream super block version.
- The in-memory struct cache_sb does not exactly map the on-disk struct
  cache_sb_disk.
- Add 32bit bucket_size_hi in struct cache_sb_disk,
        __le32          bucket_size_hi;
  In theory bucket_size can be extended to 48bit, but now 32bit width is
  big enough.
- Other changes to follow the large bucket size.

The changes are mostly on cache device, except the super block update
there is no change about the backing device.

Any code review comments or suggestion is welcome. Thanks in advance. 

Coly Li
---
Changelog:
v3: Update with Hannes' comments of v2 series code review.
v2: several bug fixes, and add sysfs file to display cache set feature
    sets information.
v1: initial RFC version.

Coly Li (16):
  bcache: add read_super_common() to read major part of super block
  bcache: add more accurate error information in read_super_common()
  bcache: disassemble the big if() checks in bch_cache_set_alloc()
  bcache: fix super block seq numbers comparision in
    register_cache_set()
  bcache: increase super block version for cache device and backing
    device
  bcache: move bucket related code into read_super_common()
  bcache: struct cache_sb is only for in-memory super block now
  bcache: introduce meta_bucket_pages() related helper routines
  bcache: handle c->uuids properly for bucket size > 8MB
  bcache: handle cache prio_buckets and disk_buckets properly for bucket
    size > 8MB
  bcache: handle cache set verify_ondisk properly for bucket size > 8MB
  bcache: handle btree node memory allocation properly for bucket size >
    8MB
  bcache: add bucket_size_hi into struct cache_sb_disk for large bucket
  bcache: add sysfs file to display feature sets information of cache
    set
  bcache: avoid extra memory allocation from mempool c->fill_iter
  bcache: avoid extra memory consumption in struct bbio for large bucket
    size

 drivers/md/bcache/Makefile   |   2 +-
 drivers/md/bcache/alloc.c    |   2 +-
 drivers/md/bcache/bcache.h   |  29 +++-
 drivers/md/bcache/btree.c    |  12 +-
 drivers/md/bcache/features.c |  70 ++++++++++
 drivers/md/bcache/features.h |  84 +++++++++++
 drivers/md/bcache/io.c       |   2 +-
 drivers/md/bcache/movinggc.c |   4 +-
 drivers/md/bcache/super.c    | 261 ++++++++++++++++++++++++-----------
 drivers/md/bcache/sysfs.c    |   6 +
 include/uapi/linux/bcache.h  |  38 +++--
 11 files changed, 407 insertions(+), 103 deletions(-)
 create mode 100644 drivers/md/bcache/features.c
 create mode 100644 drivers/md/bcache/features.h

-- 
2.26.2

