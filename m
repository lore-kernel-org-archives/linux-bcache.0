From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 050/219] bcache: do not mark writeback_running too early
Date: Fri, 22 Nov 2019 00:46:22 -0500
Message-ID: <20191122054911.1750-43-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Shenghui Wang <shhuiw@foxmail.com>, Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

From: Shenghui Wang <shhuiw@foxmail.com>

[ Upstream commit 79b791466e525c98f6aeee9acf5726e7b27f4231 ]

A fresh backing device is not attached to any cache_set, and
has no writeback kthread created until first attached to some
cache_set.

But bch_cached_dev_writeback_init run
"
	dc->writeback_running		= true;
	WARN_ON(test_and_clear_bit(BCACHE_DEV_WB_RUNNING,
			&dc->disk.flags));
"
for any newly formatted backing devices.

For a fresh standalone backing device, we can get something like
following even if no writeback kthread created:
------------------------
/sys/block/bcache0/bcache# cat writeback_running
1
/sys/block/bcache0/bcache# cat writeback_rate_debug
rate:		512.0k/sec
dirty:		0.0k
target:		0.0k
proportional:	0.0k
integral:	0.0k
change:		0.0k/sec
next io:	-15427384ms

The none ZERO fields are misleading as no alive writeback kthread yet.

Set dc->writeback_running false as no writeback thread created in
bch_cached_dev_writeback_init().

We have writeback thread created and woken up in bch_cached_dev_writeback
_start(). Set dc->writeback_running true before bch_writeback_queue()
called, as a writeback thread will check if dc->writeback_running is true
before writing back dirty data, and hung if false detected.

After the change, we can get the following output for a fresh standalone
backing device:
-----------------------
/sys/block/bcache0/bcache$ cat writeback_running
0
/sys/block/bcache0/bcache# cat writeback_rate_debug
rate:		0.0k/sec
dirty:		0.0k
target:		0.0k
proportional:	0.0k
integral:	0.0k
change:		0.0k/sec
next io:	0ms

v1 -> v2:
  Set dc->writeback_running before bch_writeback_queue() called,

Signed-off-by: Shenghui Wang <shhuiw@foxmail.com>
Signed-off-by: Coly Li <colyli@suse.de>

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/writeback.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index ba5395fd386d5..b5fc3c6c7178e 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -781,7 +781,7 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc)
 	bch_keybuf_init(&dc->writeback_keys);
 
 	dc->writeback_metadata		= true;
-	dc->writeback_running		= true;
+	dc->writeback_running		= false;
 	dc->writeback_percent		= 10;
 	dc->writeback_delay		= 30;
 	atomic_long_set(&dc->writeback_rate.rate, 1024);
@@ -810,6 +810,7 @@ int bch_cached_dev_writeback_start(struct cached_dev *dc)
 		destroy_workqueue(dc->writeback_write_wq);
 		return PTR_ERR(dc->writeback_thread);
 	}
+	dc->writeback_running = true;
 
 	WARN_ON(test_and_set_bit(BCACHE_DEV_WB_RUNNING, &dc->disk.flags));
 	schedule_delayed_work(&dc->writeback_rate_update,
-- 
2.20.1
