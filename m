From: Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH] bcache: Fixed incorrect order of arguments to bio_alloc_bioset()
Date: Tue, 22 Oct 2013 15:35:50 -0700
Message-ID: <1382481353-4300-1-git-send-email-kmo@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, linux-bcache@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>
List-Id: linux-bcache@vger.kernel.org

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: linux-stable <stable@vger.kernel.org> # >= v3.10
---
 drivers/md/bcache/request.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index b6a74bc..2a7f0dd 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1000,7 +1000,7 @@ static void request_write(struct cached_dev *dc, struct search *s)
 
 		if (bio->bi_rw & REQ_FLUSH) {
 			/* Also need to send a flush to the backing device */
-			struct bio *flush = bio_alloc_bioset(0, GFP_NOIO,
+			struct bio *flush = bio_alloc_bioset(GFP_NOIO, 0,
 							     dc->disk.bio_split);
 
 			flush->bi_rw	= WRITE_FLUSH;
-- 
1.8.4.rc3
