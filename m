From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 07/10] bcache: comment on direct access to bvec table
Date: Fri,  8 Dec 2017 21:14:06 +0800
Message-ID: <20171208131409.11889-8-ming.lei@redhat.com>
References: <20171208131409.11889-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171208131409.11889-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Ming Lei <ming.lei@redhat.com>, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

All direct access to bvec table are safe even after multipage bvec is supported.

Cc: linux-bcache@vger.kernel.org
Acked-by: Coly Li <colyli@suse.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/md/bcache/btree.c | 1 +
 drivers/md/bcache/util.c  | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 11c5503d31dc..c09f3dd4bf07 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -432,6 +432,7 @@ static void do_btree_node_write(struct btree *b)
 
 		continue_at(cl, btree_node_write_done, NULL);
 	} else {
+		/* No problem for multipage bvec since the bio is just allocated */
 		b->bio->bi_vcnt = 0;
 		bch_bio_map(b->bio, i);
 
diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
index e548b8b51322..61813d230015 100644
--- a/drivers/md/bcache/util.c
+++ b/drivers/md/bcache/util.c
@@ -249,6 +249,13 @@ uint64_t bch_next_delay(struct bch_ratelimit *d, uint64_t done)
 		: 0;
 }
 
+/*
+ * Generally it isn't good to access .bi_io_vec and .bi_vcnt directly,
+ * the preferred way is bio_add_page, but in this case, bch_bio_map()
+ * supposes that the bvec table is empty, so it is safe to access
+ * .bi_vcnt & .bi_io_vec in this way even after multipage bvec is
+ * supported.
+ */
 void bch_bio_map(struct bio *bio, void *base)
 {
 	size_t size = bio->bi_iter.bi_size;
-- 
2.9.5
