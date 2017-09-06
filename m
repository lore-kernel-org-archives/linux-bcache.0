From: Coly Li <colyli@suse.de>
Subject: [PATCH 04/12] bcache: Don't reinvent the wheel but use existing llist API
Date: Wed,  6 Sep 2017 14:25:54 +0800
Message-ID: <20170906062602.50497-5-colyli@suse.de>
References: <20170906062602.50497-1-colyli@suse.de>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42288 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751698AbdIFG0q (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 6 Sep 2017 02:26:46 -0400
In-Reply-To: <20170906062602.50497-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk
Cc: bcache@lists.ewheeler.net, Byungchul Park <byungchul.park@lge.com>

From: Byungchul Park <byungchul.park@lge.com>

Although llist provides proper APIs, they are not used. Make them used.

Signed-off-by: Byungchul Park <byungchul.park@lge.com>
Acked-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/closure.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/md/bcache/closure.c b/drivers/md/bcache/closure.c
index 864e673aec39..7d5286b05036 100644
--- a/drivers/md/bcache/closure.c
+++ b/drivers/md/bcache/closure.c
@@ -70,21 +70,10 @@ void __closure_wake_up(struct closure_waitlist *wait_list)
 	list = llist_del_all(&wait_list->list);
 
 	/* We first reverse the list to preserve FIFO ordering and fairness */
-
-	while (list) {
-		struct llist_node *t = list;
-		list = llist_next(list);
-
-		t->next = reverse;
-		reverse = t;
-	}
+	reverse = llist_reverse_order(list);
 
 	/* Then do the wakeups */
-
-	while (reverse) {
-		cl = container_of(reverse, struct closure, list);
-		reverse = llist_next(reverse);
-
+	llist_for_each_entry(cl, reverse, list) {
 		closure_set_waiting(cl, 0);
 		closure_sub(cl, CLOSURE_WAITING + 1);
 	}
-- 
2.13.5
