From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 279/350] bcache: fix static checker warning in bcache_device_free()
Date: Tue, 10 Dec 2019 16:06:24 -0500
Message-ID: <20191210210735.9077-240-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Coly Li <colyli@suse.de>, Dan Carpenter <dan.carpenter@oracle.com>, Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

From: Coly Li <colyli@suse.de>

[ Upstream commit 2d8869518a525c9bce5f5268419df9dfbe3dfdeb ]

Commit cafe56359144 ("bcache: A block layer cache") leads to the
following static checker warning:

    ./drivers/md/bcache/super.c:770 bcache_device_free()
    warn: variable dereferenced before check 'd->disk' (see line 766)

drivers/md/bcache/super.c
   762  static void bcache_device_free(struct bcache_device *d)
   763  {
   764          lockdep_assert_held(&bch_register_lock);
   765
   766          pr_info("%s stopped", d->disk->disk_name);
                                      ^^^^^^^^^
Unchecked dereference.

   767
   768          if (d->c)
   769                  bcache_device_detach(d);
   770          if (d->disk && d->disk->flags & GENHD_FL_UP)
                    ^^^^^^^
Check too late.

   771                  del_gendisk(d->disk);
   772          if (d->disk && d->disk->queue)
   773                  blk_cleanup_queue(d->disk->queue);
   774          if (d->disk) {
   775                  ida_simple_remove(&bcache_device_idx,
   776                                    first_minor_to_idx(d->disk->first_minor));
   777                  put_disk(d->disk);
   778          }
   779

It is not 100% sure that the gendisk struct of bcache device will always
be there, the warning makes sense when there is problem in block core.

This patch tries to remove the static checking warning by checking
d->disk to avoid NULL pointer deferences.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/super.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 20ed838e9413b..d2654880b7b9e 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -761,20 +761,28 @@ static inline int idx_to_first_minor(int idx)
 
 static void bcache_device_free(struct bcache_device *d)
 {
+	struct gendisk *disk = d->disk;
+
 	lockdep_assert_held(&bch_register_lock);
 
-	pr_info("%s stopped", d->disk->disk_name);
+	if (disk)
+		pr_info("%s stopped", disk->disk_name);
+	else
+		pr_err("bcache device (NULL gendisk) stopped");
 
 	if (d->c)
 		bcache_device_detach(d);
-	if (d->disk && d->disk->flags & GENHD_FL_UP)
-		del_gendisk(d->disk);
-	if (d->disk && d->disk->queue)
-		blk_cleanup_queue(d->disk->queue);
-	if (d->disk) {
+
+	if (disk) {
+		if (disk->flags & GENHD_FL_UP)
+			del_gendisk(disk);
+
+		if (disk->queue)
+			blk_cleanup_queue(disk->queue);
+
 		ida_simple_remove(&bcache_device_idx,
-				  first_minor_to_idx(d->disk->first_minor));
-		put_disk(d->disk);
+				  first_minor_to_idx(disk->first_minor));
+		put_disk(disk);
 	}
 
 	bioset_exit(&d->bio_split);
-- 
2.20.1
