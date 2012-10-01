From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: problem w/ read caching..
Date: Mon, 1 Oct 2012 14:14:58 -0700
Message-ID: <20121001211458.GC26488@google.com>
References: <CAPKZHbV3n7O+VRVNS-C2oDVSpO_VdirMDUOuwwWKaA5ZOUEG_g@mail.gmail.com>
 <CAH+dOxLKJKRLU2+0hD0LVmTC68SnFpFrTE63+QegaGPs5BOSMg@mail.gmail.com>
 <loom.20120928T010314-562@post.gmane.org>
 <20120928185949.GA7062@google.com>
 <loom.20121001T211315-779@post.gmane.org>
 <20121001193806.GA26488@google.com>
 <loom.20121001T220412-225@post.gmane.org>
 <20121001203706.GB26488@google.com>
 <loom.20121001T223817-249@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <loom.20121001T223817-249-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Brad Walker <bwalker-WlSugiYO8JFBDgjK7y7TUQ@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Mon, Oct 01, 2012 at 08:56:21PM +0000, Brad Walker wrote:
> Kent Overstreet <koverstreet@...> writes:
> 
> > 
> > On Mon, Oct 01, 2012 at 08:05:14PM +0000, Brad Walker wrote:
> > > Kent Overstreet <koverstreet@...> writes:
> > > 
> > > > 
> > > > What about cache_bypass_hits, cache_bypass_misses?
> > > > 
> > > 
> > > cache_bypass_hits = 0
> > > cache_bypass_misses = 0
> > 
> > I should've just asked you for all the stats - what about
> > cache_miss_collision?

So cache_miss_collisions, cache_read_races are 0...

----

I was just browsing around the code, and I bet I know what it is -
btree_insert_check_key() is failing because the btree node is full.

The way the code works is on cache miss, we can't just blindly insert
that data into the cache because if a write happens to the same location
after the cache miss but before the data from the cache miss gets
inserted, we'd overwrite the write with stale data.

So btree_insert_check_key() inserts a fake key atomically with the cache
miss - we don't need that key to be persisted so we can skip
journalling and all the normal btree insert code, which is how we can
insert this fake key atomically.

Then, on when we go to insert the real key that points to the data from
the cache miss, we check if the fake key we inserted is still present
and fail the insert if it's not.

It's cmpxchg(), but for the btree.

Anyways... since we're skipping all the normal btree_insert() code,
btree_insert_check_key() can't split the btree node if it's full - if
the btree node is full it just fails it.

This'd be perfectly fine in any normal workload where you've got some
mix of reads and writes... if the btree node is full, a write will come
along to split it.

But the synthetic workload is a bit of a pathological case here :)

But, we should confirm this really is what's going on...  Can you apply
this patch and rerun to test my theory? See if the number of times the
printk fires lines up with the number of cache misses.


diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 4102267..d5c5313 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1875,9 +1875,13 @@ bool bch_btree_insert_check_key(struct btree *b, struct btree_op *op,
 	rw_unlock(false, b);
 	rw_lock(true, b, b->level);
 
+	if (should_split(b)) {
+		printk(KERN_DEBUG "bcache: bch_btree_insert_check_key() failed because btree node full\n");
+		goto out;
+	}
+
 	if (b->key.ptr[0] != btree_ptr ||
-	    b->seq != seq + 1 ||
-	    should_split(b))
+	    b->seq != seq + 1)
 		goto out;
 
 	op->replace = KEY(op->inode, bio_end(bio), bio_sectors(bio));
