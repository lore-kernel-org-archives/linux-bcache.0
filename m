From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: bcache hangs on writes, recovers after disabling discard on
 cache device
Date: Thu, 11 Jul 2013 18:15:54 -0700
Message-ID: <20130712011554.GA17799@kmo-pixel>
References: <51C891C9.4060809@modelnine.org>
 <alpine.DEB.2.02.1307111748130.26927@orbit.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1307111748130.26927-pfGh9vBu50j/PtFMR13I2A@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Juha Aatrokoski <jha-6fQLAAUwtFMxHbG02/KK1g@public.gmane.org>
Cc: Heiko Wundram <modelnine-EqIAFqbRPK3NLxjTenLetw@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Thu, Jul 11, 2013 at 05:58:17PM +0300, Juha Aatrokoski wrote:
> On Mon, 24 Jun 2013, Heiko Wundram wrote:
> 
> >In a rather old thread of mine (514C4FC1.6090804-EqIAFqbRPK3NLxjTenLetw@public.gmane.org), I
> >already stated a problem I was seeing back at the time, namely
> >that bcache seems to hang on writes to the SSD device after some
> >time, writing 50 MB/s continuously to the output device.
> ...
> >Disabling discard on the SSD device (by echo 0 >
> >/sys/fs/bcache/.../cache0/discard) makes the bcache device become
> >responsive again.
> 
> I can confirm this. On Monday I booted into kernel 3.8.13-gentoo
> with the current "bcache" branch patched onto it. Discard was on for
> the cache device, and today this 50MB/s hang occured. Disabling
> discard did indeed fix it.
> 
> I had CONFIG_BCACHE_CLOSURES_DEBUG=y in the kernel, and the contents
> of /sys/kernel/debug/bcache/bcache-UUID and
> /sys/kernel/debug/closures both before and after disabling discard
> can be found at the address below, in case they can help in
> determining where exactly the hang happens.

Can you give this patch a try? It's on top of the current
bcache-for-3.11 branch


From 265c5caff798b307bcaced08add46c91c3d4fdd1 Mon Sep 17 00:00:00 2001
From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Date: Thu, 11 Jul 2013 18:14:13 -0700
Subject: [PATCH] bcache: Use blkdev_issue_discard()


diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index e45f557..7a12dd1 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -63,13 +63,12 @@
 #include "bcache.h"
 #include "btree.h"
 
+#include <linux/blkdev.h>
 #include <linux/freezer.h>
 #include <linux/kthread.h>
 #include <linux/random.h>
 #include <trace/events/bcache.h>
 
-#define MAX_IN_FLIGHT_DISCARDS		8U
-
 /* Bucket heap / gen */
 
 uint8_t bch_inc_gen(struct cache *ca, struct bucket *b)
@@ -121,75 +120,6 @@ void bch_rescale_priorities(struct cache_set *c, int sectors)
 	mutex_unlock(&c->bucket_lock);
 }
 
-/* Discard/TRIM */
-
-struct discard {
-	struct list_head	list;
-	struct work_struct	work;
-	struct cache		*ca;
-	long			bucket;
-
-	struct bio		bio;
-	struct bio_vec		bv;
-};
-
-static void discard_finish(struct work_struct *w)
-{
-	struct discard *d = container_of(w, struct discard, work);
-	struct cache *ca = d->ca;
-	char buf[BDEVNAME_SIZE];
-
-	if (!test_bit(BIO_UPTODATE, &d->bio.bi_flags)) {
-		pr_notice("discard error on %s, disabling",
-			 bdevname(ca->bdev, buf));
-		d->ca->discard = 0;
-	}
-
-	mutex_lock(&ca->set->bucket_lock);
-
-	fifo_push(&ca->free, d->bucket);
-	list_add(&d->list, &ca->discards);
-	atomic_dec(&ca->discards_in_flight);
-
-	mutex_unlock(&ca->set->bucket_lock);
-
-	closure_wake_up(&ca->set->bucket_wait);
-	wake_up_process(ca->alloc_thread);
-
-	closure_put(&ca->set->cl);
-}
-
-static void discard_endio(struct bio *bio, int error)
-{
-	struct discard *d = container_of(bio, struct discard, bio);
-	schedule_work(&d->work);
-}
-
-static void do_discard(struct cache *ca, long bucket)
-{
-	struct discard *d = list_first_entry(&ca->discards,
-					     struct discard, list);
-
-	list_del(&d->list);
-	d->bucket = bucket;
-
-	atomic_inc(&ca->discards_in_flight);
-	closure_get(&ca->set->cl);
-
-	bio_init(&d->bio);
-
-	d->bio.bi_sector	= bucket_to_sector(ca->set, d->bucket);
-	d->bio.bi_bdev		= ca->bdev;
-	d->bio.bi_rw		= REQ_WRITE|REQ_DISCARD;
-	d->bio.bi_max_vecs	= 1;
-	d->bio.bi_io_vec	= d->bio.bi_inline_vecs;
-	d->bio.bi_size		= bucket_bytes(ca);
-	d->bio.bi_end_io	= discard_endio;
-	bio_set_prio(&d->bio, IOPRIO_PRIO_VALUE(IOPRIO_CLASS_IDLE, 0));
-
-	submit_bio(0, &d->bio);
-}
-
 /* Allocation */
 
 static inline bool can_inc_bucket_gen(struct bucket *b)
@@ -398,16 +328,15 @@ static int bch_allocator_thread(void *arg)
 			else
 				break;
 
-			allocator_wait(ca, (int) fifo_free(&ca->free) >
-				       atomic_read(&ca->discards_in_flight));
+			if (ca->discard)
+				blkdev_issue_discard(ca->bdev,
+					bucket_to_sector(ca->set, bucket),
+					ca->sb.block_size, GFP_KERNEL, 0);
 
-			if (ca->discard) {
-				allocator_wait(ca, !list_empty(&ca->discards));
-				do_discard(ca, bucket);
-			} else {
-				fifo_push(&ca->free, bucket);
-				closure_wake_up(&ca->set->bucket_wait);
-			}
+			allocator_wait(ca, !fifo_full(&ca->free));
+
+			fifo_push(&ca->free, bucket);
+			closure_wake_up(&ca->set->bucket_wait);
 		}
 
 		/*
@@ -556,22 +485,8 @@ int bch_cache_allocator_start(struct cache *ca)
 	return 0;
 }
 
-void bch_cache_allocator_exit(struct cache *ca)
-{
-	struct discard *d;
-
-	while (!list_empty(&ca->discards)) {
-		d = list_first_entry(&ca->discards, struct discard, list);
-		cancel_work_sync(&d->work);
-		list_del(&d->list);
-		kfree(d);
-	}
-}
-
 int bch_cache_allocator_init(struct cache *ca)
 {
-	unsigned i;
-
 	/*
 	 * Reserve:
 	 * Prio/gen writes first
@@ -589,15 +504,5 @@ int bch_cache_allocator_init(struct cache *ca)
 	ca->watermark[WATERMARK_NONE] = ca->free.size / 2 +
 		ca->watermark[WATERMARK_MOVINGGC];
 
-	for (i = 0; i < MAX_IN_FLIGHT_DISCARDS; i++) {
-		struct discard *d = kzalloc(sizeof(*d), GFP_KERNEL);
-		if (!d)
-			return -ENOMEM;
-
-		d->ca = ca;
-		INIT_WORK(&d->work, discard_finish);
-		list_add(&d->list, &ca->discards);
-	}
-
 	return 0;
 }
diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index b39f6f0..8ef4148 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -621,15 +621,6 @@ struct cache {
 
 	bool			discard; /* Get rid of? */
 
-	/*
-	 * We preallocate structs for issuing discards to buckets, and keep them
-	 * on this list when they're not in use; do_discard() issues discards
-	 * whenever there's work to do and is called by free_some_buckets() and
-	 * when a discard finishes.
-	 */
-	atomic_t		discards_in_flight;
-	struct list_head	discards;
-
 	struct journal_device	journal;
 
 	/* The rest of this all shows up in sysfs */
@@ -1223,7 +1214,6 @@ int bch_btree_cache_alloc(struct cache_set *);
 void bch_moving_init_cache_set(struct cache_set *);
 
 int bch_cache_allocator_start(struct cache *ca);
-void bch_cache_allocator_exit(struct cache *ca);
 int bch_cache_allocator_init(struct cache *ca);
 
 void bch_debug_exit(void);
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 547c4c5..fd37342 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1725,8 +1725,6 @@ void bch_cache_release(struct kobject *kobj)
 	if (ca->set)
 		ca->set->cache[ca->sb.nr_this_dev] = NULL;
 
-	bch_cache_allocator_exit(ca);
-
 	bio_split_pool_free(&ca->bio_split_hook);
 
 	free_pages((unsigned long) ca->disk_buckets, ilog2(bucket_pages(ca)));
@@ -1758,8 +1756,6 @@ static int cache_alloc(struct cache_sb *sb, struct cache *ca)
 	__module_get(THIS_MODULE);
 	kobject_init(&ca->kobj, &bch_cache_ktype);
 
-	INIT_LIST_HEAD(&ca->discards);
-
 	bio_init(&ca->journal.bio);
 	ca->journal.bio.bi_max_vecs = 8;
 	ca->journal.bio.bi_io_vec = ca->journal.bio.bi_inline_vecs;
