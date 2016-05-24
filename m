From: Jiri Kosina <jikos@kernel.org>
Subject: [PATCH 1/4] bcache: bch_writeback_thread() is not freezable
Date: Tue, 24 May 2016 16:38:10 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1605241634270.31937@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, Eric Wheeler <bcache@lists.ewheeler.net>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

bch_writeback_thread() is calling try_to_freeze(), but that's just an 
expensive no-op given the fact that the thread is not marked freezable.

I/O helper kthreads, exactly such as the bcache writeback thread, actually 
shouldn't be freezable, because they are potentially necessary for 
finalizing the image write-out.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---

This is a resend of a series sent more than a month ago and pinged 
multiple time since then.

 drivers/md/bcache/writeback.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index b9346cd..6012367 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -12,7 +12,6 @@
 #include "writeback.h"
 
 #include <linux/delay.h>
-#include <linux/freezer.h>
 #include <linux/kthread.h>
 #include <trace/events/bcache.h>
 
@@ -228,7 +227,6 @@ static void read_dirty(struct cached_dev *dc)
 	 */
 
 	while (!kthread_should_stop()) {
-		try_to_freeze();
 
 		w = bch_keybuf_next(&dc->writeback_keys);
 		if (!w)
@@ -433,7 +431,6 @@ static int bch_writeback_thread(void *arg)
 			if (kthread_should_stop())
 				return 0;
 
-			try_to_freeze();
 			schedule();
 			continue;
 		}
-- 
Jiri Kosina
SUSE Labs
