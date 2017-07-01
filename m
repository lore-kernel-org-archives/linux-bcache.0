From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: [PATCH 05/19] bcache: fix calling ida_simple_remove() with incorrect
 minor
Date: Sat, 1 Jul 2017 19:25:38 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1707011923340.17052@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-block@vger.kernel.org
Cc: linux-bcache@vger.kernel.org, hch@infradead.org, axboe@kernel.dk, Tang Junhui <tang.junhui@zte.com.cn>, stable@vger.kernel.org, Stefan Bader <stefan.bader@canonical.com>
List-Id: linux-bcache@vger.kernel.org

From: Tang Junhui <tang.junhui@zte.com.cn>

bcache called ida_simple_remove() with minor which have multiplied by
BCACHE_MINORS, it would cause minor wrong release and leakage.

In addition, when adding partition support to bcache, the name assignment
was not updated, resulting in numbers jumping (bcache0, bcache16,
bcache32...). This has been fixed implicitly by the rework.

Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
Reviewed-by: Coly Li <colyli@suse.de>
Reviewed-by: Eric Wheeler <bcache@linux.ewheeler.net>
Cc: stable@vger.kernel.org # 4.10
Cc: Stefan Bader <stefan.bader@canonical.com>
Fixes: b8c0d91 (bcache: partition support: add 16 minors per bcacheN device)
BugLink: https://bugs.launchpad.net/bugs/1667078
---
 drivers/md/bcache/super.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 9a2c190..48b8c20 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -58,7 +58,10 @@ static wait_queue_head_t unregister_wait;
 struct workqueue_struct *bcache_wq;
 
 #define BTREE_MAX_PAGES		(256 * 1024 / PAGE_SIZE)
-#define BCACHE_MINORS		16 /* partition support */
+#define BCACHE_MINORS_BITS                4 /* bcache partition support */
+#define BCACHE_MINORS                     (1 << BCACHE_MINORS_BITS)
+#define BCACHE_TO_IDA_MINORS(first_minor) ((first_minor) >> BCACHE_MINORS_BITS)
+#define IDA_TO_BCACHE_MINORS(minor)       ((minor) << BCACHE_MINORS_BITS)
 
 /* Superblock */
 
@@ -734,7 +737,8 @@ static void bcache_device_free(struct bcache_device *d)
 	if (d->disk && d->disk->queue)
 		blk_cleanup_queue(d->disk->queue);
 	if (d->disk) {
-		ida_simple_remove(&bcache_minor, d->disk->first_minor);
+		ida_simple_remove(&bcache_minor,
+			BCACHE_TO_IDA_MINORS(d->disk->first_minor));
 		put_disk(d->disk);
 	}
 
@@ -776,11 +780,11 @@ static int bcache_device_init(struct bcache_device *d, unsigned block_size,
 	if (!d->full_dirty_stripes)
 		return -ENOMEM;
 
-	minor = ida_simple_get(&bcache_minor, 0, MINORMASK + 1, GFP_KERNEL);
+	minor = ida_simple_get(&bcache_minor, 0,
+		BCACHE_TO_IDA_MINORS(MINORMASK) + 1, GFP_KERNEL);
 	if (minor < 0)
 		return minor;
 
-	minor *= BCACHE_MINORS;
 
 	if (!(d->bio_split = bioset_create(4, offsetof(struct bbio, bio),
 					   BIOSET_NEED_BVECS |
@@ -794,7 +798,7 @@ static int bcache_device_init(struct bcache_device *d, unsigned block_size,
 	snprintf(d->disk->disk_name, DISK_NAME_LEN, "bcache%i", minor);
 
 	d->disk->major		= bcache_major;
-	d->disk->first_minor	= minor;
+	d->disk->first_minor	= IDA_TO_BCACHE_MINORS(minor);
 	d->disk->fops		= &bcache_ops;
 	d->disk->private_data	= d;
 
-- 
1.8.3.1
