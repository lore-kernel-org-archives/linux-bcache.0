From: colyli@suse.de
Subject: [PATCH 13/17] bcache: print written and keys in trace_bcache_btree_write
Date: Fri, 24 Jan 2020 01:01:38 +0800
Message-ID: <20200123170142.98974-14-colyli@suse.de>
References: <20200123170142.98974-1-colyli@suse.de>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51832 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730037AbgAWRDE (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 23 Jan 2020 12:03:04 -0500
In-Reply-To: <20200123170142.98974-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Guoju Fang <fangguoju@gmail.com>, Coly Li <colyli@suse.de>

From: Guoju Fang <fangguoju@gmail.com>

It's useful to dump written block and keys on btree write, this patch
add them into trace_bcache_btree_write.

Signed-off-by: Guoju Fang <fangguoju@gmail.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 include/trace/events/bcache.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/bcache.h b/include/trace/events/bcache.h
index e4526f85c19d..0bddea663b3b 100644
--- a/include/trace/events/bcache.h
+++ b/include/trace/events/bcache.h
@@ -275,7 +275,8 @@ TRACE_EVENT(bcache_btree_write,
 		__entry->keys	= b->keys.set[b->keys.nsets].data->keys;
 	),
 
-	TP_printk("bucket %zu", __entry->bucket)
+	TP_printk("bucket %zu written block %u + %u",
+		__entry->bucket, __entry->block, __entry->keys)
 );
 
 DEFINE_EVENT(btree_node, bcache_btree_node_alloc,
-- 
2.16.4
