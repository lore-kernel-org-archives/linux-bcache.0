From: Mark Hills <mark-UrrBsZIrrsb10XsdtD+oqA@public.gmane.org>
Subject: [PATCH 3/7] Break fuzz test to allow building as module
Date: Sat, 10 Sep 2011 14:45:35 +0100
Message-ID: <1315662339-3115-3-git-send-email-mark@pogo.org.uk>
References: <1109101110320.2733@stax.localdomain>
 <1315662339-3115-1-git-send-email-mark@pogo.org.uk>
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1315662339-3115-1-git-send-email-mark-UrrBsZIrrsb10XsdtD+oqA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

get_random_int() is not available, and is required when
CONFIG_BCACHE_DEBUG is used.
---
 block/bcache.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/bcache.c b/block/bcache.c
index faaf75e..9a1ab79 100644
--- a/block/bcache.c
+++ b/block/bcache.c
@@ -6255,7 +6255,7 @@ static ssize_t btree_fuzz(struct kobject *k, struct kobj_attribute *a,
 			struct bset *i = write_block(b);
 			struct bkey *k = op.keys.top;
 
-			k->key = get_random_int();
+			k->key = 0; /* FIXME */
 
 			op.insert_type = k->key & 1
 				? INSERT_WRITE
-- 
1.7.4.4
