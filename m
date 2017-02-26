From: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [linux-next] bcache: Remove duplicate inclusion of blkdev.h
Date: Sun, 26 Feb 2017 15:02:30 +0900
Message-ID: <20170226060230.11555-1-standby24x7@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, kent.overstreet@gmail.com, shli@kernel.org, linux-bcache@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
List-Id: linux-bcache@vger.kernel.org

This patch remove duplicate inclusion of blkdev.h in util.h.
Confirm compile successfully after remove the line.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/md/bcache/util.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
index cf2cbc211d83..03af094d0202 100644
--- a/drivers/md/bcache/util.h
+++ b/drivers/md/bcache/util.h
@@ -4,7 +4,6 @@
 
 #include <linux/blkdev.h>
 #include <linux/errno.h>
-#include <linux/blkdev.h>
 #include <linux/kernel.h>
 #include <linux/llist.h>
 #include <linux/ratelimit.h>
-- 
2.12.0
