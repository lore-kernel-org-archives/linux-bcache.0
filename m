From: Coly Li <colyli@suse.de>
Subject: [PATCH 0/3] bcache patches for Linux v5.6-rc2
Date: Thu, 13 Feb 2020 22:12:04 +0800
Message-ID: <20200213141207.77219-1-colyli@suse.de>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50248 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730078AbgBMOMS (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 13 Feb 2020 09:12:18 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Coly Li <colyli@suse.de>

Hi Jens,

Here are 3 minor fixes Linux v5.6-rc2. The first 2 patches fix
kthread creating failure during bcache cache set starts up. The
last patch is a code clean up.

Please take them. Thanks in advance.

Coly Li
---
Coly Li (3):
  bcache: ignore pending signals when creating gc and allocator thread
  bcache: Revert "bcache: shrink btree node cache after
    bch_btree_check()"
  bcache: remove macro nr_to_fifo_front()

 drivers/md/bcache/alloc.c   | 18 ++++++++++++++++--
 drivers/md/bcache/btree.c   | 13 +++++++++++++
 drivers/md/bcache/journal.c |  7 ++-----
 drivers/md/bcache/super.c   | 17 -----------------
 4 files changed, 31 insertions(+), 24 deletions(-)

-- 
2.16.4
