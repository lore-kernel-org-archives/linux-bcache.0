From: Phil Viana <phillip.l.viana-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] md: bcache: Fixed a typo with the word 'arithmetic'
Date: Mon,  3 Jun 2013 09:51:42 -0300
Message-ID: <1370263902-14360-1-git-send-email-phillip.l.viana@gmail.com>
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: neilb-l3A5Bk7waGM@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Phil Viana <phillip.l.viana-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

The word 'arithmetic' was typed as 'arithmatic'

Signed-off-by: Phil Viana <phillip.l.viana-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/md/bcache/bset.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
index d33f5ad..8822ed2 100644
--- a/drivers/md/bcache/bset.c
+++ b/drivers/md/bcache/bset.c
@@ -403,7 +403,7 @@ void inorder_test(void)
 #endif
 
 /*
- * Cacheline/offset <-> bkey pointer arithmatic:
+ * Cacheline/offset <-> bkey pointer arithmetic:
  *
  * t->tree is a binary search tree in an array; each node corresponds to a key
  * in one cacheline in t->set (BSET_CACHELINE bytes).
@@ -412,7 +412,7 @@ void inorder_test(void)
  * the binary tree points to; to_inorder() gives us the cacheline, and then
  * bkey_float->m gives us the offset within that cacheline, in units of 8 bytes.
  *
- * cacheline_to_bkey() and friends abstract out all the pointer arithmatic to
+ * cacheline_to_bkey() and friends abstract out all the pointer arithmetic to
  * make this work.
  *
  * To construct the bfloat for an arbitrary key we need to know what the key
-- 
1.7.9.5
