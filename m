From: Coly Li <colyli@suse.de>
Subject: [PATCH 04/15] bcache: fix ioctl in flash device
Date: Mon,  8 Oct 2018 20:41:10 +0800
Message-ID: <20181008124121.20192-5-colyli@suse.de>
References: <20181008124121.20192-1-colyli@suse.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20181008124121.20192-1-colyli@suse.de>
Sender: stable-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Tang Junhui <tang.junhui.linux@gmail.com>, stable@vger.kernel.org, Coly Li <colyli@suse.de>
List-Id: linux-bcache@vger.kernel.org

From: Tang Junhui <tang.junhui.linux@gmail.com>

When doing ioctl in flash device, it will call ioctl_dev() in super.c,
then we should not to get cached device since flash only device has
no backend device. This patch just move the jugement dc->io_disable
to cached_dev_ioctl() to make ioctl in flash device correctly.

Fixes: 0f0709e6bfc3c ("bcache: stop bcache device when backing device is offline")
Signed-off-by: Tang Junhui <tang.junhui.linux@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/request.c | 3 +++
 drivers/md/bcache/super.c   | 4 ----
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index ee15fb039fd0..3bf35914bb57 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1218,6 +1218,9 @@ static int cached_dev_ioctl(struct bcache_device *d, fmode_t mode,
 {
 	struct cached_dev *dc = container_of(d, struct cached_dev, disk);
 
+	if (dc->io_disable)
+		return -EIO;
+
 	return __blkdev_driver_ioctl(dc->bdev, mode, cmd, arg);
 }
 
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 448e531e8c2d..a99af19d2f91 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -647,10 +647,6 @@ static int ioctl_dev(struct block_device *b, fmode_t mode,
 		     unsigned int cmd, unsigned long arg)
 {
 	struct bcache_device *d = b->bd_disk->private_data;
-	struct cached_dev *dc = container_of(d, struct cached_dev, disk);
-
-	if (dc->io_disable)
-		return -EIO;
 
 	return d->ioctl(d, mode, cmd, arg);
 }
-- 
2.19.0
