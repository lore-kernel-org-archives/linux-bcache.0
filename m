From: Coly Li <colyli@suse.de>
Subject: [PATCH] [RFC] gfs2: add flag REQ_PRIO for metadata read ahead
Date: Tue, 11 Jul 2017 11:09:02 +0800
Message-ID: <20170711030902.13391-1-colyli@suse.de>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49029 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755114AbdGKDJP (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 10 Jul 2017 23:09:15 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: cluster-devel@redhat.com
Cc: swhiteho@redhat.com, rpeterso@redhat.com, linux-bcache@vger.kernel.org, Coly Li <colyli@suse.de>

When gfs2 does metadata read ahead, currently flags (REQ_RAHEAD | REQ_META)
are used to submit bio. Flag REQ_META is just a hint for block trace, not
for block layer code to handle a bio as metadata request.

When doing read ahead for metadata, A REQ_PRIO flag on the metadata bio
is very informative to block layer code. For example, if bcache is used as
a I/O cache for gfs2, it will be possible for bcache code to cache the
pre-fetched metadata blocks on cache device as well, which may be
probably to improve metadata I/O performance if the following requests
hit the cache.

This patch adds REQ_PRIO flag when submitting a metadata readahead bio.
A meta data read ahead bio may come from I/O requests for bitmap,
directoriesmeta or other general metadata request.

Signed-off-by: Coly Li <colyli@suse.de>
---
 fs/gfs2/bmap.c    | 5 +++--
 fs/gfs2/dir.c     | 4 +++-
 fs/gfs2/meta_io.c | 4 +++-
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 9fa3aef9a5b3..fa3ea29f39cf 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -291,8 +291,9 @@ static void gfs2_metapath_ra(struct gfs2_glock *gl,
 		if (trylock_buffer(rabh)) {
 			if (!buffer_uptodate(rabh)) {
 				rabh->b_end_io = end_buffer_read_sync;
-				submit_bh(REQ_OP_READ, REQ_RAHEAD | REQ_META,
-						rabh);
+				submit_bh(REQ_OP_READ,
+					  REQ_RAHEAD | REQ_META | REQ_PRIO,
+					  rabh);
 				continue;
 			}
 			unlock_buffer(rabh);
diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index db427658ccd9..0741e4018f8c 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -1514,7 +1514,9 @@ static void gfs2_dir_readahead(struct inode *inode, unsigned hsize, u32 index,
 				continue;
 			}
 			bh->b_end_io = end_buffer_read_sync;
-			submit_bh(REQ_OP_READ, REQ_RAHEAD | REQ_META, bh);
+			submit_bh(REQ_OP_READ,
+				  REQ_RAHEAD | REQ_META | REQ_PRIO,
+				  bh);
 			continue;
 		}
 		brelse(bh);
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index fabe1614f879..6103d1c816ef 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -461,7 +461,9 @@ struct buffer_head *gfs2_meta_ra(struct gfs2_glock *gl, u64 dblock, u32 extlen)
 		bh = gfs2_getbuf(gl, dblock, CREATE);
 
 		if (!buffer_uptodate(bh) && !buffer_locked(bh))
-			ll_rw_block(REQ_OP_READ, REQ_RAHEAD | REQ_META, 1, &bh);
+			ll_rw_block(REQ_OP_READ,
+				    REQ_RAHEAD | REQ_META | REQ_PRIO,
+				    1, &bh);
 		brelse(bh);
 		dblock++;
 		extlen--;
-- 
2.12.0
