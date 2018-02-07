From: Michael Lyle <mlyle@lyle.org>
Subject: [PATCH 1/8] bcache: add journal statistic
Date: Wed,  7 Feb 2018 11:41:39 -0800
Message-ID: <20180207194146.5095-2-mlyle@lyle.org>
References: <20180207194146.5095-1-mlyle@lyle.org>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33770 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754049AbeBGTl6 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 7 Feb 2018 14:41:58 -0500
Received: by mail-pg0-f65.google.com with SMTP id u1so702799pgr.0
        for <linux-bcache@vger.kernel.org>; Wed, 07 Feb 2018 11:41:58 -0800 (PST)
In-Reply-To: <20180207194146.5095-1-mlyle@lyle.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Cc: axboe@fb.com, Tang Junhui <tang.junhui@zte.com.cn>

From: Tang Junhui <tang.junhui@zte.com.cn>

Sometimes, Journal takes up a lot of CPU, we need statistics
to know what's the journal is doing. So this patch provide
some journal statistics:
1) reclaim: how many times the journal try to reclaim resource,
   usually the journal bucket or/and the pin are exhausted.
2) flush_write: how many times the journal try to flush btree node
   to cache device, usually the journal bucket are exhausted.
3) retry_flush_write: how many times the journal retry to flush
   the next btree node, usually the previous tree node have been
   flushed by other thread.
we show these statistic by sysfs interface. Through these statistics
We can totally see the status of journal module when the CPU is too
high.

Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
Reviewed-by: Michael Lyle <mlyle@lyle.org>
---
 drivers/md/bcache/bcache.h  |  4 ++++
 drivers/md/bcache/journal.c |  5 +++++
 drivers/md/bcache/sysfs.c   | 15 +++++++++++++++
 3 files changed, 24 insertions(+)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 5e2d4e80198e..b98d7705acb6 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -658,6 +658,10 @@ struct cache_set {
 	atomic_long_t		writeback_keys_done;
 	atomic_long_t		writeback_keys_failed;
 
+	atomic_long_t		reclaim;
+	atomic_long_t		flush_write;
+	atomic_long_t		retry_flush_write;
+
 	enum			{
 		ON_ERROR_UNREGISTER,
 		ON_ERROR_PANIC,
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index a87165c1d8e5..f5296007a9d5 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -377,6 +377,8 @@ static void btree_flush_write(struct cache_set *c)
 	 */
 	struct btree *b, *best;
 	unsigned i;
+
+	atomic_long_inc(&c->flush_write);
 retry:
 	best = NULL;
 
@@ -397,6 +399,7 @@ static void btree_flush_write(struct cache_set *c)
 		if (!btree_current_write(b)->journal) {
 			mutex_unlock(&b->write_lock);
 			/* We raced */
+			atomic_long_inc(&c->retry_flush_write);
 			goto retry;
 		}
 
@@ -476,6 +479,8 @@ static void journal_reclaim(struct cache_set *c)
 	unsigned iter, n = 0;
 	atomic_t p;
 
+	atomic_long_inc(&c->reclaim);
+
 	while (!atomic_read(&fifo_front(&c->journal.pin)))
 		fifo_pop(&c->journal.pin, p);
 
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index b4184092c727..46e7a6b3e7c7 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -65,6 +65,9 @@ read_attribute(bset_tree_stats);
 
 read_attribute(state);
 read_attribute(cache_read_races);
+read_attribute(reclaim);
+read_attribute(flush_write);
+read_attribute(retry_flush_write);
 read_attribute(writeback_keys_done);
 read_attribute(writeback_keys_failed);
 read_attribute(io_errors);
@@ -545,6 +548,15 @@ SHOW(__bch_cache_set)
 	sysfs_print(cache_read_races,
 		    atomic_long_read(&c->cache_read_races));
 
+	sysfs_print(reclaim,
+		    atomic_long_read(&c->reclaim));
+
+	sysfs_print(flush_write,
+		    atomic_long_read(&c->flush_write));
+
+	sysfs_print(retry_flush_write,
+		    atomic_long_read(&c->retry_flush_write));
+
 	sysfs_print(writeback_keys_done,
 		    atomic_long_read(&c->writeback_keys_done));
 	sysfs_print(writeback_keys_failed,
@@ -731,6 +743,9 @@ static struct attribute *bch_cache_set_internal_files[] = {
 
 	&sysfs_bset_tree_stats,
 	&sysfs_cache_read_races,
+	&sysfs_reclaim,
+	&sysfs_flush_write,
+	&sysfs_retry_flush_write,
 	&sysfs_writeback_keys_done,
 	&sysfs_writeback_keys_failed,
 
-- 
2.14.1
