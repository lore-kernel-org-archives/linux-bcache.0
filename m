From: Coly Li <colyli@suse.de>
Subject: [PATCH] bcache: check ca->alloc_thread initialized before wake up it
Date: Wed, 20 Sep 2017 06:11:11 +0800
Message-ID: <20170919221111.18549-1-colyli@suse.de>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Cc: Coly Li <colyli@suse.de>, Kent Overstreet <kent.overstreet@gmail.com>, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

In bcache code, sysfs entries are created before all resources get
allocated, e.g. allocation thread of a cache set.

There is posibility for NULL pointer deference if a resource is accessed
but which is not initialized yet. Indeed Jorg Bornschein catches one on
cache set allocation thread and gets a kernel oops.

The reason for this bug is, when bch_bucket_alloc() is called during
cache set registration and attaching, ca->alloc_thread is not properly
allocated and initialized yet, call wake_up_process() on ca->alloc_thread
triggers NULL pointer deference failure. A simple and fast fix is, before 
waking up ca->alloc_thread, checking whether it is allocated, and only
wake up ca->alloc_thread when it is not NULL.

Signed-off-by: Coly Li <colyli@suse.de>
Reported-by: Jorg Bornschein <jb@capsec.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/md/bcache/alloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index cacbe2dbd5c3..e1a4205caa2e 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -406,7 +406,8 @@ long bch_bucket_alloc(struct cache *ca, unsigned reserve, bool wait)
 
 	finish_wait(&ca->set->bucket_wait, &w);
 out:
-	wake_up_process(ca->alloc_thread);
+	if (ca->alloc_thread)
+		wake_up_process(ca->alloc_thread);
 
 	trace_bcache_alloc(ca, reserve);
 
-- 
2.13.5
