From: Jiri Kosina <jikos@kernel.org>
Subject: [PATCH 2/4] bcache: bch_allocator_thread() is not freezable
Date: Tue, 24 May 2016 16:38:15 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1605241635410.31937@cbobk.fhfr.pm>
References: <alpine.LNX.2.00.1605241634270.31937@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1605241634270.31937@cbobk.fhfr.pm>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, Eric Wheeler <bcache@lists.ewheeler.net>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

bch_allocator_thread() is calling try_to_freeze(), but that's just an 
expensive no-op given the fact that the thread is not marked freezable.

Bucket allocator has to be up and running to the very last stages of the 
suspend, as the bcache I/O that's in flight (think of writing an 
hibernation image to a swap device served by bcache).

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/md/bcache/alloc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index 8eeab72..ca4abe1 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -64,7 +64,6 @@
 #include "btree.h"
 
 #include <linux/blkdev.h>
-#include <linux/freezer.h>
 #include <linux/kthread.h>
 #include <linux/random.h>
 #include <trace/events/bcache.h>
@@ -288,7 +287,6 @@ do {									\
 		if (kthread_should_stop())				\
 			return 0;					\
 									\
-		try_to_freeze();					\
 		schedule();						\
 		mutex_lock(&(ca)->set->bucket_lock);			\
 	}								\

-- 
Jiri Kosina
SUSE Labs
