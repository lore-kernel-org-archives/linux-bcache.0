From: Pavel Vazharov <freakpv@gmail.com>
Subject: [PATCH] bcache: btree.c: Fix GC thread exit in case of cache device failure and unregister
Date: Fri, 12 Jan 2018 17:24:50 +0200
Message-ID: <1515770690-18562-1-git-send-email-freakpv@gmail.com>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35233 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934002AbeALPZo (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 12 Jan 2018 10:25:44 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: mlyle@lyle.org, kent.overstreet@gmail.com
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, Pavel Vazharov <freakpv@gmail.com>

There was a possibility for infinite do-while loop inside the GC thread
function in case of total failure of the caching device. I was able to
reproduce it 3 times simulating disappearing of the caching device via
'echo 1 > /sys/block/<dev>/device/delete'. In that case the btree_root
starts to return non zero and non -EAGAIN result, 'gc failed' message
start to fill the kernel log and the do-while becomes infinite loop
occupying single CPU core at 100%.
There is already a logic which unregisters the cache_set (or panics) in
case of io errors and thus we exit the loop here if the unregistering
procedure has already started.

Signed-off-by: Pavel Vazharov <freakpv@gmail.com>
---
 drivers/md/bcache/btree.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 81e8dc3..a672081 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1748,8 +1748,12 @@ static void bch_btree_gc(struct cache_set *c)
 		closure_sync(&writes);
 		cond_resched();
 
-		if (ret && ret != -EAGAIN)
-			pr_warn("gc failed!");
+		if (ret && ret != -EAGAIN) {
+			if (test_bit(CACHE_SET_UNREGISTERING, &c->flags))
+				break;
+			else
+				pr_warn("gc failed!");
+		}
 	} while (ret);
 
 	bch_btree_gc_finish(c);
-- 
2.7.4
