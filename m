From: Jiri Kosina <jikos@kernel.org>
Subject: [PATCH] bcache: bch_allocator_thread() is not freezable
Date: Tue, 19 Apr 2016 14:34:37 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1604191433580.27368@cbobk.fhfr.pm>
References: <alpine.LNX.2.00.1604191421130.27368@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49856 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802AbcDSMek (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 19 Apr 2016 08:34:40 -0400
In-Reply-To: <alpine.LNX.2.00.1604191421130.27368@cbobk.fhfr.pm>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org

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
