From: tang.junhui@zte.com.cn
Subject: [PATCH] bcache: correct journal bucket reading
Date: Wed, 1 Nov 2017 14:56:12 +0800
Message-ID: <1509519372-9999-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: colyli@suse.de, mlyle@lyle.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn
List-Id: linux-bcache@vger.kernel.org

From: Tang Junhui <tang.junhui@zte.com.cn>

There are 3 steps to read out all journal buckets.
1) Try to get a valid journal bucket by golden ratio hash or
falling back to linear search. For an example, NNNYYYNN, each
character represents a bucket, Y represents a valid journal
bucket, and N is not. After step 1, we may get the 5th bucket
as a valid journal bucket, and the 7th bucket as an invalid
bucket.
2) Try to get the latest valid journal bucket by Binary search.
After this steps, in NNNYYYNN, we can get the 6th as the latest
valid bucket.
3) Read the journal form tail to front in the 6th bucket.

But actually, since the journal bucket is a ring, the bucket
can be like YYYNNNYY, which means the first valid journal in
the 7th bucket, and the last valid journal in third bucket, in
this case, we may get a valid journal in the 7th bucket by step
1, but in step 2 we call find_next_bit(bitmap,
ca->sb.njournal_buckets, l + 1) to find the first invalid bucket
after the 7th bucket, because all these buckets is valid, so no
bit 1 in bitmap, thus find_next_bit() function would return with
ca->sb.njournal_buckets (8). So, in step 3), bcache only read
journal in 7th bucket, the journal in 8th bucket and the first
to the third buckets are lost.

Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
---
 drivers/md/bcache/journal.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)
 mode change 100644 => 100755 drivers/md/bcache/journal.c

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
old mode 100644
new mode 100755
index 0352d05..8a549fb
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -199,14 +199,17 @@ int bch_journal_read(struct cache_set *c, struct list_head *list)
 		/* Binary search */
 		m = l;
 		r = find_next_bit(bitmap, ca->sb.njournal_buckets, l + 1);
-		pr_debug("starting binary search, l %u r %u", l, r);
+		if (r == ca->sb.njournal_buckets && 
+		    !test_bit(r, bitmap))
+			r = ca->sb.njournal_buckets + find_next_bit(bitmap, ca->sb.njournal_buckets, 0);
+		pr_debug("starting binary search, l %u r %u", l, r % ca->sb.njournal_buckets);
 
 		while (l + 1 < r) {
 			seq = list_entry(list->prev, struct journal_replay,
 					 list)->j.seq;
 
 			m = (l + r) >> 1;
-			read_bucket(m);
+			read_bucket(m % ca->sb.njournal_buckets);
 
 			if (seq != list_entry(list->prev, struct journal_replay,
 					      list)->j.seq)
@@ -219,6 +222,7 @@ int bch_journal_read(struct cache_set *c, struct list_head *list)
 		 * Read buckets in reverse order until we stop finding more
 		 * journal entries
 		 */
+		m = m % ca->sb.njournal_buckets;
 		pr_debug("finishing up: m %u njournal_buckets %u",
 			 m, ca->sb.njournal_buckets);
 		l = m;
-- 
1.8.3.1
