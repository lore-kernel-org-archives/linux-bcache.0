From: Michael Lyle <mlyle@lyle.org>
Subject: [PATCH 02/15] bcache: check ca->alloc_thread initialized before wake up it
Date: Fri, 13 Oct 2017 16:35:29 -0700
Message-ID: <20171013233542.20938-3-mlyle@lyle.org>
References: <20171013233542.20938-1-mlyle@lyle.org>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171013233542.20938-1-mlyle@lyle.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Cc: axboe@fb.com, Coly Li <colyli@suse.de>, Kent Overstreet <kent.overstreet@gmail.com>, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

From: Coly Li <colyli@suse.de>

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
Reviewed-by: Michael Lyle <mlyle@lyle.org>
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
2.11.0
