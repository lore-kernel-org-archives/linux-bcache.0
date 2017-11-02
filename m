From: tang.junhui@zte.com.cn
Subject: [PATCH] bcache: add a comment in journal bucket reading
Date: Thu, 2 Nov 2017 11:08:14 +0800
Message-ID: <1509592094-26115-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from out1.zte.com.cn ([202.103.147.172]:40542 "EHLO mxct.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933932AbdKBDIY (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 1 Nov 2017 23:08:24 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: colyli@suse.de, mlyle@lyle.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn

From: Tang Junhui <tang.junhui@zte.com.cn>

Journal bucket is a circular buffer, the bucket
can be like YYYNNNYY, which means the first valid journal in
the 7th bucket, and the latest valid journal in third bucket, in
this case, if we do not try we the zero index first, We
may get a valid journal in the 7th bucket, then we call
find_next_bit(bitmap,ca->sb.njournal_buckets, l + 1) to get the
first invalid bucket after the 7th bucket, because all these
buckets is valid, so no bit 1 in bitmap, thus find_next_bit()
function would return with ca->sb.njournal_buckets (8). So, after
that, bcache only read journal in 7th and 8the bucket,
the first to the third buckets are lost.

So, it is important to let developer know that, we need to try
the zero index at first in the hash-search, and avoid any breaks
in future's code modification.

Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
---
 drivers/md/bcache/journal.c | 5 +++++
 1 file changed, 5 insertions(+)
 mode change 100644 => 100755 drivers/md/bcache/journal.c

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
old mode 100644
new mode 100755
index 0352d05..4b6e651
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -169,6 +169,11 @@ int bch_journal_read(struct cache_set *c, struct list_head *list)
 		 * find a sequence of buckets with valid journal entries
 		 */
 		for (i = 0; i < ca->sb.njournal_buckets; i++) {
+			/*
+			 * We must try the index l with ZERO first for correctness due to  
+			 * exist scenario that the journal bucket is circular buffer which
+			 * maybe have wrapped
+			 */
 			l = (i * 2654435769U) % ca->sb.njournal_buckets;
 
 			if (test_bit(l, bitmap))
-- 
1.8.3.1
