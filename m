From: bcache@lists.ewheeler.net
Subject: [PATCH 06/19] bcache: explicitly destory mutex while exiting
Date: Fri, 30 Jun 2017 13:42:55 -0700
Message-ID: <1498855388-16990-6-git-send-email-bcache@lists.ewheeler.net>
References: <20170629134510.GA32385@infradead.org>
 <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org
Cc: linux-bcache@vger.kernel.org, hch@infradead.org, axboe@kernel.dk, Liang Chen <liangchen.linux@gmail.com>, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

From: Liang Chen <liangchen.linux@gmail.com>

mutex_destroy does nothing most of time, but it's better to call
it to make the code future proof and it also has some meaning
for like mutex debug.

Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
Reviewed-by: Eric Wheeler <bcache@linux.ewheeler.net>
Cc: stable@vger.kernel.org
---
 drivers/md/bcache/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 48b8c20..1f84791 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2089,6 +2089,7 @@ static void bcache_exit(void)
 	if (bcache_major)
 		unregister_blkdev(bcache_major, "bcache");
 	unregister_reboot_notifier(&reboot);
+	mutex_destroy(&bch_register_lock);
 }
 
 static int __init bcache_init(void)
@@ -2106,6 +2107,7 @@ static int __init bcache_init(void)
 
 	bcache_major = register_blkdev(0, "bcache");
 	if (bcache_major < 0) {
+		mutex_destroy(&bch_register_lock);
 		unregister_reboot_notifier(&reboot);
 		return bcache_major;
 	}
-- 
1.8.3.1
