From: Coly Li <colyli@suse.de>
Subject: [PATCH 0/2] bcache patches for Linux v5.7-rc5
Date: Mon,  4 May 2020 23:35:27 +0800
Message-ID: <20200504153529.2242-1-colyli@suse.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40174 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728381AbgEDPfk (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 4 May 2020 11:35:40 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Coly Li <colyli@suse.de>

Hi Jens,

These two patches are in my testing directory for weeks and it is
about time to submit them for Linux v5.7-rc5.

The first one from Colin helps to remove unncessary local variables.
And Joe contributes second patch to improve the kernel message format
by remove extra '\n' from existing pr_format() and adds the '\n' to
the location of printing kernel messages. 

Please them for v5.7.

Thank you in advance.

Coly Li
---

Colin Ian King (1):
  bcache: remove redundant variables i and n

Joe Perches (1):
  bcache: Convert pr_<level> uses to a more typical style

 drivers/md/bcache/bcache.h    |   2 +-
 drivers/md/bcache/bset.c      |   6 +-
 drivers/md/bcache/btree.c     |  16 ++---
 drivers/md/bcache/extents.c   |  12 ++--
 drivers/md/bcache/io.c        |   8 +--
 drivers/md/bcache/journal.c   |  34 +++++-----
 drivers/md/bcache/request.c   |   6 +-
 drivers/md/bcache/super.c     | 123 +++++++++++++++++-----------------
 drivers/md/bcache/sysfs.c     |   8 +--
 drivers/md/bcache/writeback.c |   6 +-
 10 files changed, 110 insertions(+), 111 deletions(-)

-- 
2.25.0
