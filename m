From: Coly Li <colyli@suse.de>
Subject: [PATCH 0/7] bcache patches for Linux v5.7-rc1
Date: Sun, 22 Mar 2020 14:02:58 +0800
Message-ID: <20200322060305.70637-1-colyli@suse.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48956 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725881AbgCVGEf (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 22 Mar 2020 02:04:35 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Coly Li <colyli@suse.de>

Hi Jens,

These are bcache patches for Linux v5.7-rc1.

The major change is to make bcache btree check and dirty secrtors
counting being multithreaded, then the registration time can be
much less. My first four patches are for this purpose.

Davidlohr Bueso contributes a patch to optimize barrier usage for
atomic operations. By his inspiration I also compose a patch for
the rested locations to change.

Takashi Iwai contributes a helpful patch to avoid potential
buffer overflow in bcache sysfs code path.

Please take them, and thank you in advance.

Coly Li
---

Coly Li (5):
  bcache: move macro btree() and btree_root() into btree.h
  bcache: add bcache_ prefix to btree_root() and btree() macros
  bcache: make bch_btree_check() to be multithreaded
  bcache: make bch_sectors_dirty_init() to be multithreaded
  bcache: optimize barrier usage for atomic operations

Davidlohr Bueso (1):
  bcache: optimize barrier usage for Rmw atomic bitops

Takashi Iwai (1):
  bcache: Use scnprintf() for avoiding potential buffer overflow

 drivers/md/bcache/btree.c     | 242 ++++++++++++++++++++++++----------
 drivers/md/bcache/btree.h     |  88 +++++++++++++
 drivers/md/bcache/sysfs.c     |   2 +-
 drivers/md/bcache/writeback.c | 164 ++++++++++++++++++++++-
 drivers/md/bcache/writeback.h |  19 +++
 5 files changed, 440 insertions(+), 75 deletions(-)

-- 
2.25.0
