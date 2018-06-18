From: Florian Schmaus <flo@geekplace.eu>
Subject: [PATCH 2/3] bcache: do not assign in if condition in bcache_init()
Date: Mon, 18 Jun 2018 12:09:01 +0200
Message-ID: <20180618100902.4015-3-flo@geekplace.eu>
References: <20180618100902.4015-1-flo@geekplace.eu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180618100902.4015-1-flo@geekplace.eu>
Sender: linux-kernel-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org
Cc: Florian Schmaus <flo@geekplace.eu>, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

Fixes an error condition reported by checkpatch.pl which is caused by
assigning a variable in an if condition.

Signed-off-by: Florian Schmaus <flo@geekplace.eu>
---
 drivers/md/bcache/super.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index db7177d422e5..f09f4f046315 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2328,9 +2328,15 @@ static int __init bcache_init(void)
 		return bcache_major;
 	}
 
-	if (!(bcache_wq = alloc_workqueue("bcache", WQ_MEM_RECLAIM, 0)) ||
-	    !(bcache_kobj = kobject_create_and_add("bcache", fs_kobj)) ||
-	    bch_request_init() ||
+	bcache_wq = alloc_workqueue("bcache", WQ_MEM_RECLAIM, 0);
+	if (!bcache_wq)
+		goto err;
+
+	bcache_kobj = kobject_create_and_add("bcache", fs_kobj);
+	if (!bcache_kobj)
+		goto err;
+
+	if (bch_request_init() ||
 	    bch_debug_init(bcache_kobj) || closure_debug_init() ||
 	    sysfs_create_files(bcache_kobj, files))
 		goto err;
-- 
2.16.4
