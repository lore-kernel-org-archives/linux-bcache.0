From: Mark Hills <mark-UrrBsZIrrsb10XsdtD+oqA@public.gmane.org>
Subject: [PATCH 7/7] Don't require latency_warn_ms from bcache_util.o
Date: Sat, 10 Sep 2011 14:45:39 +0100
Message-ID: <1315662339-3115-7-git-send-email-mark@pogo.org.uk>
References: <1109101110320.2733@stax.localdomain>
 <1315662339-3115-1-git-send-email-mark@pogo.org.uk>
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1315662339-3115-1-git-send-email-mark-UrrBsZIrrsb10XsdtD+oqA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

When building as a module, we can't see this variable. This removes
useful debugging; probably some restructuring would be better here.

I'm not clear on the responsibilities of bcache.c, vs. bcache_util.c,
there seem to be references in both directions.
---
 block/bcache_util.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/block/bcache_util.c b/block/bcache_util.c
index b014e8c..11a81c0 100644
--- a/block/bcache_util.c
+++ b/block/bcache_util.c
@@ -378,8 +378,6 @@ void closure_put(struct closure *c, struct workqueue_struct *wq)
 	bool sleeping;
 	int r;
 again:
-	pr_latency(c->wait_time, "%pf", c->fn);
-
 	sleeping = test_bit(__CLOSURE_SLEEPING, &c->flags);
 	r = atomic_dec_return(&c->remaining);
 	smp_mb__after_atomic_dec();
-- 
1.7.4.4
