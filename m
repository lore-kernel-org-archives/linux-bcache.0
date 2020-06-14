From: colyli@suse.de
Subject: [PATCH 4/4] bcache: pr_info() format clean up in bcache_device_init()
Date: Mon, 15 Jun 2020 00:53:33 +0800
Message-ID: <20200614165333.124999-5-colyli@suse.de>
References: <20200614165333.124999-1-colyli@suse.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200614165333.124999-1-colyli@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
List-Id: linux-bcache@vger.kernel.org

From: Coly Li <colyli@suse.de>

scripts/checkpatch.pl reports following warning for patch
("bcache: check and adjust logical block size for backing devices"),
    WARNING: quoted string split across lines
    #146: FILE: drivers/md/bcache/super.c:896:
    +  pr_info("%s: sb/logical block size (%u) greater than page size "
    +	       "(%lu) falling back to device logical block size (%u)",

There are two things to fix up,
- The kernel message print should be in a single line.
- pr_info() won't automatically add new line since v5.8, a '\n' should
  be added.

This patch just does the above cleanup in bcache_device_init().

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index a6e79083010a..2014016f9a60 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -893,8 +893,7 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 		 * This should only happen with BCACHE_SB_VERSION_BDEV.
 		 * Block/page size is checked for BCACHE_SB_VERSION_CDEV.
 		 */
-		pr_info("%s: sb/logical block size (%u) greater than page size "
-			"(%lu) falling back to device logical block size (%u)",
+		pr_info("%s: sb/logical block size (%u) greater than page size (%lu) falling back to device logical block size (%u)\n",
 			d->disk->disk_name, q->limits.logical_block_size,
 			PAGE_SIZE, bdev_logical_block_size(cached_bdev));
 
-- 
2.25.0
