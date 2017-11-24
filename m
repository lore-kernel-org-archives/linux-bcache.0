From: Michael Lyle <mlyle@lyle.org>
Subject: [PATCH 1/4] bcache: add a comment in journal bucket reading
Date: Fri, 24 Nov 2017 15:14:24 -0800
Message-ID: <20171124231427.9563-2-mlyle@lyle.org>
References: <20171124231427.9563-1-mlyle@lyle.org>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171124231427.9563-1-mlyle@lyle.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Cc: axboe@kernel.dk, Tang Junhui <tang.junhui@zte.com.cn>, Michael Lyle <mlyle@lyle.org>
List-Id: linux-bcache@vger.kernel.org

From: Tang Junhui <tang.junhui@zte.com.cn>

Journal bucket is a circular buffer, the bucket
can be like YYYNNNYY, which means the first valid journal in
the 7th bucket, and the latest valid journal in third bucket, in
this case, if we do not try we the zero index first, We
may get a valid journal in the 7th bucket, then we call
find_next_bit(bitmap,ca->sb.njournal_buckets, l + 1) to get the
first invalid bucket after the 7th bucket, because all these
buckets is valid, so no bit 1 in bitmap, thus find_next_bit()
function would return with ca->sb.njournal_buckets (8). So, after
that, bcache only read journal in 7th and 8the bucket,
the first to the third buckets are lost.

So, it is important to let developer know that, we need to try
the zero index at first in the hash-search, and avoid any breaks
in future's code modification.

[ML: Fixed whitespace & formatting & file permissions]

Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
Signed-off-by: Michael Lyle <mlyle@lyle.org>
Reviewed-by: Michael Lyle <mlyle@lyle.org>
---
 drivers/md/bcache/journal.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 02a98ddb592d..5018c56ebb67 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -170,6 +170,11 @@ int bch_journal_read(struct cache_set *c, struct list_head *list)
 		 * find a sequence of buckets with valid journal entries
 		 */
 		for (i = 0; i < ca->sb.njournal_buckets; i++) {
+			/*
+			 * We must try the index l with ZERO first for
+			 * correctness due to the scenario that the journal
+			 * bucket is circular buffer which might have wrapped
+			 */
 			l = (i * 2654435769U) % ca->sb.njournal_buckets;
 
 			if (test_bit(l, bitmap))
-- 
2.14.1
