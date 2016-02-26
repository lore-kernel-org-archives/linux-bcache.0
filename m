From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: BUG: drivers/md/bcache/writeback.c:237
Date: Fri, 26 Feb 2016 02:38:11 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1602252330290.3635@mail.ewheeler.net>
References: <20160224204530.GA13079@merlins.org> <alpine.LRH.2.11.1602250052530.2131@mail.ewheeler.net> <alpine.LRH.2.11.1602250612440.3635@mail.ewheeler.net> <alpine.LRH.2.11.1602250729570.3635@mail.ewheeler.net>
 <CAC8teKVFASYjf1U+Y3JHCXREC3WwfO=2GR+=-8kYcNh+ugsMxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([71.19.153.34]:40716 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751503AbcBZCiQ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 25 Feb 2016 21:38:16 -0500
In-Reply-To: <CAC8teKVFASYjf1U+Y3JHCXREC3WwfO=2GR+=-8kYcNh+ugsMxw@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Zhu Yanhai <zhu.yanhai@gmail.com>
Cc: Marc MERLIN <marc@merlins.org>, Kent Overstreet <kent.overstreet@gmail.com>, Christoph Nelles <evilazrael@evilazrael.de>, linux-bcache@vger.kernel.org

On Thu, 25 Feb 2016, Zhu Yanhai wrote:
> > If this happens at cache registration, is it a race between writeback
> > running too soon and the datastructures not being fully populated?
> >
> > Can anyone else comment here?
> 
> Hi Eric,
> I'm not sure why you think it's caused by some kthread park. 

Because of the backtrace in his photo, but I agree, this is definitely a 
BUG_ON in read_dirty(). 

> See bch_btree_gc_finish(), the buckets pointed by writeback_keys are
> marked as GC_MARK_DIRTY, to prevent them be reclaimed by the allocator
> in the next, so theoretically the keys won't be stale.

Interesting.  What does stale mean in this context?  

Sounds like this original problem was caused at shutdown and the bug we 
are working on is the result of that issue.  It would be nice to know what 
caused that if we see any future bug reports like this. 

Could this mean his on-SSD writeback cache (or controller writeback cache) 
didn't get the btree consistent on disk at shutdown---or that there was a 
bug at shutdown that prevented it?  Unfortunately we don't have a trace of 
the problem at shutdown.

> I guess there is some race between the device register path, the early
> stage GC and writeback. I think you won't see this BUG_ON after the
> whole system take off. 

Agreed.  Please comment on the patch below.  

> But once it happens the bucket with wrong generation get persistence in 
> SSD, which means you can't use the cache device any more.

Can you clarify the the "it" of when "it happens" ?  What is "it" that 
bumps the generation proximate to the BUG_ON in read_dirty()?

How does this mean you can't use the cache device?  Is it completely 
invalid?


Marc, 

Disclaimer: if you are comfortable forcing the writeback thread to proceed 
instead of BUG, then try this patch.  It may cause other problems, or it 
may not work at all.  If the cache is attached and corrupt, then its 
backing dev could become corrupt during writeback if bcache still thinks 
they are associated.

Here is how it works:

First, in super.c, I hold the writeback lock until initialization is 
complete on the referenced cached_dev *dc and release it when it should be 
safe to proceed; this should work because bch_writeback_thread downs 
writeback_lock at the top of its loop.

Next, in writeback.c's read_dirty(), I jump to some additional error 
handling instead of BUG_ON.  Except for debug output, it handles the early 
exit in the the same way as the out of memory path.

If you feel that it is safe to run this code, then I would be interested 
to know the result.  If it works, then I wonder which of the two patches 
solved the problem.  If the problem is persistent, then you should get the 
printk(KERN_WARNING) every time writeback runs.  OTOH, if it only printk's 
a few times, then it is an initial startup issue (but the locking should 
prevent that).

-Eric


====================================================================
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index a542b58..c0362a0 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1016,8 +1016,12 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c)
 	 */
 	atomic_set(&dc->count, 1);
 
-	if (bch_cached_dev_writeback_start(dc))
+	/* Block writeback thread, but spawn it */
+	down_write(&dc->writeback_lock);
+	if (bch_cached_dev_writeback_start(dc)) {
+		up_write(&dc->writeback_lock);
 		return -ENOMEM;
+	}
 
 	if (BDEV_STATE(&dc->sb) == BDEV_STATE_DIRTY) {
 		bch_sectors_dirty_init(dc);
@@ -1029,6 +1033,9 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c)
 	bch_cached_dev_run(dc);
 	bcache_device_link(&dc->disk, c, "bdev");
 
+	/* Allow the writeback thread to proceed */
+	up_write(&dc->writeback_lock);
+
 	pr_info("Caching %s as %s on set %pU",
 		bdevname(dc->bdev, buf), dc->disk.disk->disk_name,
 		dc->disk.c->sb.set_uuid);
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index ca38362..0fe5de0 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -234,7 +234,8 @@ static void read_dirty(struct cached_dev *dc)
 		if (!w)
 			break;
 
-		BUG_ON(ptr_stale(dc->disk.c, &w->key, 0));
+		if (ptr_stale(dc->disk.c, &w->key, 0))
+			goto err_ptr_stale;
 
 		if (KEY_START(&w->key) != dc->last_read ||
 		    jiffies_to_msecs(delay) > 50)
@@ -273,7 +274,13 @@ static void read_dirty(struct cached_dev *dc)
 	if (0) {
 err_free:
 		kfree(w->private);
+
+err_ptr_stale:
+		printk(KERN_WARNING "ptr_stale(dc->disk.c, &w->key, 0) in read_dirty() with dc->disk.flags=%lx\n",
+			dc->disk.flags);
+		dump_stack();
 err:
+
 		bch_keybuf_del(&dc->writeback_keys, w);
 	}
 
====================================================================
