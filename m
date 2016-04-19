From: Jiri Kosina <jikos@kernel.org>
Subject: [PATCH] bcache: bch_gc_thread() is not freezable
Date: Tue, 19 Apr 2016 14:35:16 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1604191434420.27368@cbobk.fhfr.pm>
References: <alpine.LNX.2.00.1604191421130.27368@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1604191421130.27368@cbobk.fhfr.pm>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

bch_gc_thread() doesn't mark itself freezable, so calling try_to_freeze() 
in its context is just an expensive no-op.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/md/bcache/btree.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 22b9e34..eab505e 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -27,7 +27,6 @@
 
 #include <linux/slab.h>
 #include <linux/bitops.h>
-#include <linux/freezer.h>
 #include <linux/hash.h>
 #include <linux/kthread.h>
 #include <linux/prefetch.h>
@@ -1787,7 +1786,6 @@ again:
 
 		mutex_unlock(&c->bucket_lock);
 
-		try_to_freeze();
 		schedule();
 	}
 
-- 
Jiri Kosina
SUSE Labs
