From: Liang Chen <liangchen.linux@gmail.com>
Subject: [PATCH] bcache: release the allocated id, not its multiple of BCACHE_MINORS
Date: Fri, 23 Jun 2017 15:15:11 +0800
Message-ID: <1498202111-30469-1-git-send-email-liangchen.linux@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, colyli@suse.de, bcache@linux.ewheeler.net, Liang Chen <liangchen.linux@gmail.com>
List-Id: linux-bcache@vger.kernel.org

The id passed to ida_simple_remove has to be the one originally
allocated with ida_simple_get, not the one after multipling by
BCACHE_MINORS.

Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
---
 drivers/md/bcache/super.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index e57353e..9f64477 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -734,7 +734,8 @@ static void bcache_device_free(struct bcache_device *d)
 	if (d->disk && d->disk->queue)
 		blk_cleanup_queue(d->disk->queue);
 	if (d->disk) {
-		ida_simple_remove(&bcache_minor, d->disk->first_minor);
+		ida_simple_remove(&bcache_minor,
+				d->disk->first_minor / BCACHE_MINORS);
 		put_disk(d->disk);
 	}
 
@@ -784,7 +785,7 @@ static int bcache_device_init(struct bcache_device *d, unsigned block_size,
 
 	if (!(d->bio_split = bioset_create(4, offsetof(struct bbio, bio))) ||
 	    !(d->disk = alloc_disk(BCACHE_MINORS))) {
-		ida_simple_remove(&bcache_minor, minor);
+		ida_simple_remove(&bcache_minor, minor / BCACHE_MINORS);
 		return -ENOMEM;
 	}
 
-- 
1.8.3.1
