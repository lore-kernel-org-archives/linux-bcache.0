From: colyli@suse.de
Subject: [PATCH 0/4] bcache: more fixes for v5.8-rc1
Date: Mon, 15 Jun 2020 00:53:29 +0800
Message-ID: <20200614165333.124999-1-colyli@suse.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
List-Id: linux-bcache@vger.kernel.org

From: Coly Li <colyli@suse.de>

Hi Jens,

Here are more following up fixes for bcache v5.8-rc1.

The two patches from me are minor clean up. Rested two patches
are important.

- Mauricio Faria de Oliveira contributes a fix for a potential
  kernel panic when users configures improper block size value
  to bcache backing device. This problem should be fixed as soon
  as possible IMHO.
- Zhiqiang Liu contributes a fix for a potential deadlock (even quite
  hard to trigger), which I want to have it as soon as possible.

Please take these patches for v5.8-rc1, or -rc2 if it is late for -rc1.

Thanks you in advance.

Coly Li
---

Coly Li (2):
  bcache: use delayed kworker fo asynchronous devices registration
  bcache: pr_info() format clean up in bcache_device_init()

Mauricio Faria de Oliveira (1):
  bcache: check and adjust logical block size for backing devices

Zhiqiang Liu (1):
  bcache: fix potential deadlock problem in btree_gc_coalesce

 drivers/md/bcache/btree.c |  8 ++++++--
 drivers/md/bcache/super.c | 35 ++++++++++++++++++++++++++---------
 2 files changed, 32 insertions(+), 11 deletions(-)

-- 
2.25.0
