From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: [PATCH] bcache: Fix a null ptr deref regression
Date: Tue,  8 Oct 2013 15:29:55 -0700
Message-ID: <1381271401-29262-1-git-send-email-kmo@daterainc.com>
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cbay-SxHCd5+OuqTrt3ojHgZu+w@public.gmane.org
Cc: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

c0f04d8 was fixing a reported data corruption bug, but it seems some
last minute refactoring or rebasing introduced a null pointer deref.

Signed-off-by: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: linux-stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # >= v3.10
Reported-by: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/md/bcache/request.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 71eb233..b6a74bc 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -996,6 +996,7 @@ static void request_write(struct cached_dev *dc, struct search *s)
 		closure_bio_submit(bio, cl, s->d);
 	} else {
 		bch_writeback_add(dc);
+		s->op.cache_bio = bio;
 
 		if (bio->bi_rw & REQ_FLUSH) {
 			/* Also need to send a flush to the backing device */
@@ -1008,8 +1009,6 @@ static void request_write(struct cached_dev *dc, struct search *s)
 			flush->bi_private = cl;
 
 			closure_bio_submit(flush, cl, s->d);
-		} else {
-			s->op.cache_bio = bio;
 		}
 	}
 out:
-- 
1.8.4.rc3
