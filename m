From: Coly Li <colyli@suse.de>
Subject: [PATCH v1 05/10] bcache: stop dc->writeback_rate_update if cache set is stopping
Date: Wed,  3 Jan 2018 22:03:20 +0800
Message-ID: <20180103140325.63175-6-colyli@suse.de>
References: <20180103140325.63175-1-colyli@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180103140325.63175-1-colyli@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, mlyle@lyle.org, tang.junhui@zte.com.cn, Coly Li <colyli@suse.de>
List-Id: linux-bcache@vger.kernel.org

struct delayed_work writeback_rate_update in struct cache_dev is a delayed
worker to call function update_writeback_rate() in period (the interval is
defined by dc->writeback_rate_update_seconds).

When a metadate I/O error happens on cache device, bcache error handling
routine bch_cache_set_error() will call bch_cache_set_unregister() to
retire whole cache set. On the unregister code path, cached_dev_free()
calls cancel_delayed_work_sync(&dc->writeback_rate_update) to stop this
delayed work.

dc->writeback_rate_update is a special delayed work from others in bcache.
In its routine update_writeback_rate(), this delayed work is re-armed
after a piece of time. That means when cancel_delayed_work_sync() returns,
this delayed work can still be executed after several seconds defined by
dc->writeback_rate_update_seconds.

The problem is, after cancel_delayed_work_sync() returns, the cache set
unregister code path will eventually release memory of struct cache set.
Then the delayed work is scheduled to run, and inside its routine
update_writeback_rate() that already released cache set NULL pointer will
be accessed. Now a NULL pointer deference panic is triggered.

In order to avoid the above problem, this patch checks cache set flags in
delayed work routine update_writeback_rate(). If flag CACHE_SET_STOPPING
is set, this routine will quit without re-arm the delayed work. Then the
NULL pointer deference panic won't happen after cache set is released.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/writeback.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 0789a9e18337..745d9b2a326f 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -91,6 +91,11 @@ static void update_writeback_rate(struct work_struct *work)
 	struct cached_dev *dc = container_of(to_delayed_work(work),
 					     struct cached_dev,
 					     writeback_rate_update);
+	struct cache_set *c = dc->disk.c;
+
+	/* quit directly if cache set is stopping */
+	if (test_bit(CACHE_SET_STOPPING, &c->flags))
+		return;
 
 	down_read(&dc->writeback_lock);
 
@@ -100,6 +105,10 @@ static void update_writeback_rate(struct work_struct *work)
 
 	up_read(&dc->writeback_lock);
 
+	/* do not schedule delayed work if cache set is stopping */
+	if (test_bit(CACHE_SET_STOPPING, &c->flags))
+		return;
+
 	schedule_delayed_work(&dc->writeback_rate_update,
 			      dc->writeback_rate_update_seconds * HZ);
 }
-- 
2.15.1
