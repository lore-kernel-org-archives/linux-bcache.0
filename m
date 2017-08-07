From: Byungchul Park <byungchul.park@lge.com>
Subject: [RESEND PATCH] bcache: Don't reinvent the wheel but use existing llist API
Date: Mon,  7 Aug 2017 17:38:41 +0900
Message-ID: <1502095121-14337-1-git-send-email-byungchul.park@lge.com>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from LGEAMRELO13.lge.com ([156.147.23.53]:37855 "EHLO
        lgeamrelo13.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752331AbdHGIjy (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 7 Aug 2017 04:39:54 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: kent.overstreet@gmail.com, shli@kernel.org
Cc: linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@lge.com

Although llist provides proper APIs, they are not used. Make them used.

Signed-off-by: Byungchul Park <byungchul.park@lge.com>
---
 drivers/md/bcache/closure.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/md/bcache/closure.c b/drivers/md/bcache/closure.c
index 864e673..1841d03 100644
--- a/drivers/md/bcache/closure.c
+++ b/drivers/md/bcache/closure.c
@@ -64,27 +64,16 @@ void closure_put(struct closure *cl)
 void __closure_wake_up(struct closure_waitlist *wait_list)
 {
 	struct llist_node *list;
-	struct closure *cl;
+	struct closure *cl, *t;
 	struct llist_node *reverse = NULL;
 
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
+	llist_for_each_entry_safe(cl, t, reverse, list) {
 		closure_set_waiting(cl, 0);
 		closure_sub(cl, CLOSURE_WAITING + 1);
 	}
-- 
1.9.1
