From: Coly Li <colyli@suse.de>
Subject: [PATCH 0/1] bcache: 2nd wave patch for Linux v5.7-rc1
Date: Wed, 25 Mar 2020 09:30:56 +0800
Message-ID: <20200325013057.114340-1-colyli@suse.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
List-Id: linux-bcache@vger.kernel.org

Hi Jens,

This patch fixes a compiling problem reported by the kernel test
robot. Please take it for the Linux v5.7-rc1 patches.

Thanks.

Coly Li
---

Coly Li (1):
  bcache: remove dupplicated declaration from btree.h

 drivers/md/bcache/btree.h | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

-- 
2.25.0
