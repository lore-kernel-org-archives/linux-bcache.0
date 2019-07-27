From: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Subject: [PATCH 2/3] bcache: use allocator reserves instead of watermarks
Date: Sat, 27 Jul 2019 18:19:58 +0800
Message-ID: <1564222799-10603-2-git-send-email-baiyaowei@cmss.chinamobile.com>
References: <1564222799-10603-1-git-send-email-baiyaowei@cmss.chinamobile.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1564222799-10603-1-git-send-email-baiyaowei@cmss.chinamobile.com>
Sender: linux-kernel-owner@vger.kernel.org
To: colyli@suse.de, kent.overstreet@gmail.com
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, baiyaowei@cmss.chinamobile.com
List-Id: linux-bcache@vger.kernel.org

Commit 78365411b344 ("bcache: Rework allocator reserves") introduced
allocator reserves and dropped watermarks, let's keep this consistent
to avoid confusing.

Signed-off-by: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
---
 drivers/md/bcache/alloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index c22c260..609df38 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -622,13 +622,13 @@ bool bch_alloc_sectors(struct cache_set *c,
 	spin_lock(&c->data_bucket_lock);
 
 	while (!(b = pick_data_bucket(c, k, write_point, &alloc.key))) {
-		unsigned int watermark = write_prio
+		unsigned int reserve = write_prio
 			? RESERVE_MOVINGGC
 			: RESERVE_NONE;
 
 		spin_unlock(&c->data_bucket_lock);
 
-		if (bch_bucket_alloc_set(c, watermark, &alloc.key, 1, wait))
+		if (bch_bucket_alloc_set(c, reserve, &alloc.key, 1, wait))
 			return false;
 
 		spin_lock(&c->data_bucket_lock);
-- 
1.8.3.1
