From: Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 09/11] bcache: Fix a shrinker deadlock
Date: Mon, 23 Sep 2013 23:17:34 -0700
Message-ID: <1380003456-19938-10-git-send-email-kmo@daterainc.com>
References: <1380003456-19938-1-git-send-email-kmo@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1380003456-19938-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Cc: axboe@kernel.dk, Kent Overstreet <kmo@daterainc.com>
List-Id: linux-bcache@vger.kernel.org

GFP_NOIO means we could be getting called recursively - mca_alloc() ->
mca_data_alloc() - definitely can't use mutex_lock(bucket_lock) then.
Whoops.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: linux-stable <stable@vger.kernel.org> # >= v3.10
---
 drivers/md/bcache/btree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 8fad840..f42fc7e 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -612,7 +612,7 @@ static unsigned long bch_mca_scan(struct shrinker *shrink,
 		return SHRINK_STOP;
 
 	/* Return -1 if we can't do anything right now */
-	if (sc->gfp_mask & __GFP_WAIT)
+	if (sc->gfp_mask & __GFP_IO)
 		mutex_lock(&c->bucket_lock);
 	else if (!mutex_trylock(&c->bucket_lock))
 		return -1;
-- 
1.8.4.rc3
