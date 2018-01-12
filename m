From: Pavel Vazharov <freakpv@gmail.com>
Subject: [PATCH] bcache: io.c: Fix check against error_limit in case of io errors
Date: Fri, 12 Jan 2018 16:07:31 +0200
Message-ID: <1515766051-13380-1-git-send-email-freakpv@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: mlyle@lyle.org, kent.overstreet@gmail.com
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, Pavel Vazharov <freakpv@gmail.com>
List-Id: linux-bcache@vger.kernel.org

The actual sysfs io_error_limit value is left shifted IO_ERROR_SHIFT
times before it is stored in the error_limit.
This fixes the un-registering of the cache set when the io_errors reach
the error_limit value.

Signed-off-by: Pavel Vazharov <freakpv@gmail.com>
---
 drivers/md/bcache/io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
index fac97ec..1ef6ae2 100644
--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -93,7 +93,7 @@ void bch_count_io_errors(struct cache *ca, blk_status_t error, const char *m)
 						    &ca->io_errors);
 		errors >>= IO_ERROR_SHIFT;
 
-		if (errors < ca->set->error_limit)
+		if (errors < (ca->set->error_limit >> IO_ERROR_SHIFT))
 			pr_err("%s: IO error on %s, recovering",
 			       bdevname(ca->bdev, buf), m);
 		else
-- 
2.7.4
