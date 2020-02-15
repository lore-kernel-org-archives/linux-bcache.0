From: Coly Li <colyli@suse.de>
Subject: [RFC PATCH 0/3] bcache: accelerate device registration speed
Date: Sat, 15 Feb 2020 16:28:55 +0800
Message-ID: <20200215082858.128025-1-colyli@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
List-Id: linux-bcache@vger.kernel.org

Hi folks,

This series is an effort to accelerate bcache device registration
speed. With this series the registration speed can be x3 ~ 7x times
faster in my tests.

Since Linux v5.6-rc1, the bcache code may survive more than 24+ horus
on my testing machine (Lenovo SR650, 48 Cores, both NVMe SSDs as
cache device and cached device). Before Linux v5.3, bcache code may
only survive around 40 minutes then deadlock detected. After Linux v5.3,
bcache code may survive 12+ hours then out-of-memory happens and whole
system huang. Now in my testing bcache can survive from 24+ hours high
randome write I/Os, and generate a very large internal btree. After a
reboot, registring a single cached device and cache device may take
55 minutes on my testing machine, this is too long time IMHO.

I don't realize such problem because bcache could not work for so long
time before. After look into the bcache registration code, I realize
the bcache registration time is consumed by 3 steps,
1) Check btree nodes
   To check each key of all the btree nodes are valid and good.
2) Journal replay
   Replay all valid journal entries and insert them back to btree.
3) Count dirty sectors
   For a specific bcache device, iterate all btree keys and count
   dirty sectors (or stripes) for it.

The step 2) is strictly linear order, no chance to speed up. But the
step 1) and 3) accesses btree nodes in read-only more, they can be
speed up by parallelized threads. This series try to create multiple
threads to check btrees and count dirty sectors, from my testing
it can speed up x3 ~ x7 times for bcache registration.

It will be helpful if you may test the patches and feed back me the
result or problem. Currently I target these patchs for next merge
window of Linux v5.7.

Thanks in advance.

Coly Li
---

Coly Li (3):
  bcache: move macro btree() and btree_root() into btree.h
  bcache: make bch_btree_check() to be multiple threads
  bcache: make bch_sectors_dirty_init() to be multiple threads

 drivers/md/bcache/btree.c     | 229 ++++++++++++++++++++++++++++++------------
 drivers/md/bcache/btree.h     |  88 ++++++++++++++++
 drivers/md/bcache/writeback.c | 156 +++++++++++++++++++++++++++-
 drivers/md/bcache/writeback.h |  19 ++++
 4 files changed, 427 insertions(+), 65 deletions(-)

-- 
2.16.4
