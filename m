From: Coly Li <colyli@suse.de>
Subject: [PATCH 5/5] bcache: check return value of prio_read()
Date: Sat,  1 Feb 2020 22:42:35 +0800
Message-ID: <20200201144235.94110-6-colyli@suse.de>
References: <20200201144235.94110-1-colyli@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200201144235.94110-1-colyli@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
List-Id: linux-bcache@vger.kernel.org

Now if prio_read() failed during starting a cache set, we can print
out error message in run_cache_set() and handle the failure properly.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 3dea1d5acd5c..2749daf09724 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -609,12 +609,13 @@ int bch_prio_write(struct cache *ca, bool wait)
 	return 0;
 }
 
-static void prio_read(struct cache *ca, uint64_t bucket)
+static int prio_read(struct cache *ca, uint64_t bucket)
 {
 	struct prio_set *p = ca->disk_buckets;
 	struct bucket_disk *d = p->data + prios_per_bucket(ca), *end = d;
 	struct bucket *b;
 	unsigned int bucket_nr = 0;
+	int ret = -EIO;
 
 	for (b = ca->buckets;
 	     b < ca->buckets + ca->sb.nbuckets;
@@ -627,11 +628,15 @@ static void prio_read(struct cache *ca, uint64_t bucket)
 			prio_io(ca, bucket, REQ_OP_READ, 0);
 
 			if (p->csum !=
-			    bch_crc64(&p->magic, bucket_bytes(ca) - 8))
+			    bch_crc64(&p->magic, bucket_bytes(ca) - 8)) {
 				pr_warn("bad csum reading priorities");
+				goto out;
+			}
 
-			if (p->magic != pset_magic(&ca->sb))
+			if (p->magic != pset_magic(&ca->sb)) {
 				pr_warn("bad magic reading priorities");
+				goto out;
+			}
 
 			bucket = p->next_bucket;
 			d = p->data;
@@ -640,6 +645,10 @@ static void prio_read(struct cache *ca, uint64_t bucket)
 		b->prio = le16_to_cpu(d->prio);
 		b->gen = b->last_gc = d->gen;
 	}
+
+	ret = 0;
+out:
+	return ret;
 }
 
 /* Bcache device */
@@ -1873,8 +1882,10 @@ static int run_cache_set(struct cache_set *c)
 		j = &list_entry(journal.prev, struct journal_replay, list)->j;
 
 		err = "IO error reading priorities";
-		for_each_cache(ca, c, i)
-			prio_read(ca, j->prio_bucket[ca->sb.nr_this_dev]);
+		for_each_cache(ca, c, i) {
+			if (prio_read(ca, j->prio_bucket[ca->sb.nr_this_dev]))
+				goto err;
+		}
 
 		/*
 		 * If prio_read() fails it'll call cache_set_error and we'll
-- 
2.16.4
