From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Data corruption with bcache in 3.11
Date: Thu, 19 Sep 2013 19:35:01 -0700
Message-ID: <20130920023501.GJ17891@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

If you were one of the users seeing data corruption in 3.11 but not any
of the 3.10 stable kernel, I think I just fixed it. It's now clearer why
it was only hitting some users, too...

I want to get confirmation from someone who was seeing it that it fixes
the issue, so please test the fix and let me know what happens. It's in
my bcache-data-corruption-fix branch, and the patch is below:

commit 97ad43a31a7ea3c23a4eb64b8e26aad3cf21ae8d
Author: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Date:   Thu Sep 19 19:10:24 2013 -0700

    block: Fix bio_copy_data()
    
    The memcpy() in bio_copy_data() was using the wrong offset vars, leading
    to data corruption in weird unusual setups.
    
    Signed-off-by: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
    Cc: linux-stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # >= v3.9

diff --git a/fs/bio.c b/fs/bio.c
index c5eae72..5e7507d 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -917,8 +917,8 @@ void bio_copy_data(struct bio *dst, struct bio *src)
 		src_p = kmap_atomic(src_bv->bv_page);
 		dst_p = kmap_atomic(dst_bv->bv_page);
 
-		memcpy(dst_p + dst_bv->bv_offset,
-		       src_p + src_bv->bv_offset,
+		memcpy(dst_p + dst_offset,
+		       src_p + src_offset,
 		       bytes);
 
 		kunmap_atomic(dst_p);
