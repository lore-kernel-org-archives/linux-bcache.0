From: Phil Viana <phillip.l.viana-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] md: bcache: Fixed a spelling mistake with the word 'journaling' in a comment
Date: Thu, 30 May 2013 23:42:38 -0300
Message-ID: <1369968158-13820-1-git-send-email-phillip.l.viana@gmail.com>
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: neilb-l3A5Bk7waGM@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trivial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Phil Viana <phillip.l.viana-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

The word 'journaling' is spelt with a single 'l' throughout the Linux
source code, and this spelling is also found in the Oxford dictionary
and used in other projects in general.

Signed-off-by: Phil Viana <phillip.l.viana-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/md/bcache/bset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
index a0f190a..d33f5ad 100644
--- a/drivers/md/bcache/bset.c
+++ b/drivers/md/bcache/bset.c
@@ -31,7 +31,7 @@ int bch_keylist_realloc(struct keylist *l, int nptrs, struct cache_set *c)
 	unsigned newsize = oldsize + 2 + nptrs;
 	uint64_t *new;
 
-	/* The journalling code doesn't handle the case where the keys to insert
+	/* The journaling code doesn't handle the case where the keys to insert
 	 * is bigger than an empty write: If we just return -ENOMEM here,
 	 * bio_insert() and bio_invalidate() will insert the keys created so far
 	 * and finish the rest when the keylist is empty.
-- 
1.7.9.5
