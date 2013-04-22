From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH]bcache : limit the bio max sectors to make request bug in
 raid0
Date: Mon, 22 Apr 2013 14:46:01 -0700
Message-ID: <20130422214601.GC4704@localhost>
References: <516E50EB.6020902@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <516E50EB.6020902-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Balser <michael.balser-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On Wed, Apr 17, 2013 at 09:36:11AM +0200, Jack Wang wrote:
> We are using your bcache-testing branch.
> 
> From 20ad8cfb8047df2d09a5a960610f02c555a31a4f Mon Sep 17 00:00:00 2001
> From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> Date: Tue, 16 Apr 2013 14:59:04 +0200
> Subject: [PATCH] limit the max sectors in bcache to fix the make request bug
>  in raid10
> During test bcache with raid1+0, we saw a lot of complain as below:
> [ 2766.555172] md/raid0:md400: make_request bug: can't convert block
> across chunks or bigger than 512k 953328 144
> 
> when the using dd or fio with bigger blocksize like 512k, limited the
> bio_max_sectors resolve this issue.

The fix is wrong - it'll have the effect of limiting _every_ bio bcache
emits to a single page, which will be bad for performance.

I think I just found the problem though - looking at the raid0
merge_bvec_fn, when it's stacked on top of devices with their own
merge_bvec_fns, it reuses the bvm was passed to it and modifies the
bi_bdev and bi_sector. Ew.

Can you try this patch and see if it fixes it?

commit a09ded8edf9ed4009930713e101249084cbcea5c
Author: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Date:   Mon Apr 22 14:44:24 2013 -0700

    bcache: Fix merge_bvec_fn usage for when it modifies the bvm
    
    Stacked md devices reuse the bvm for the subordinate device, causing
    problems...
    
    Reported-by: Michael Balser <michael.balser-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
    Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
index 5304eaa..48efd4d 100644
--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -163,13 +163,6 @@ static unsigned bch_bio_max_sectors(struct bio *bio)
 	struct bio_vec *bv, *end = bio_iovec(bio) +
 		min_t(int, bio_segments(bio), max_segments);
 
-	struct bvec_merge_data bvm = {
-		.bi_bdev	= bio->bi_bdev,
-		.bi_sector	= bio->bi_sector,
-		.bi_size	= 0,
-		.bi_rw		= bio->bi_rw,
-	};
-
 	if (bio->bi_rw & REQ_DISCARD)
 		return min(ret, q->limits.max_discard_sectors);
 
@@ -178,12 +171,18 @@ static unsigned bch_bio_max_sectors(struct bio *bio)
 		ret = 0;
 
 		for (bv = bio_iovec(bio); bv < end; bv++) {
+			struct bvec_merge_data bvm = {
+				.bi_bdev	= bio->bi_bdev,
+				.bi_sector	= bio->bi_sector,
+				.bi_size	= ret << 9,
+				.bi_rw		= bio->bi_rw,
+			};
+
 			if (q->merge_bvec_fn &&
 			    q->merge_bvec_fn(q, &bvm, bv) < (int) bv->bv_len)
 				break;
 
-			ret		+= bv->bv_len >> 9;
-			bvm.bi_size	+= bv->bv_len;
+			ret += bv->bv_len >> 9;
 		}
 	}
 
