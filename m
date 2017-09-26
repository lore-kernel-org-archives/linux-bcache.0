From: Coly Li <colyli@suse.de>
Subject: [PATCH 1/1] bcache: use llist_for_each_entry_safe() in __closure_wake_up()
Date: Tue, 26 Sep 2017 17:54:12 +0800
Message-ID: <20170926095412.74028-2-colyli@suse.de>
References: <20170926095412.74028-1-colyli@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170926095412.74028-1-colyli@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Cc: Coly Li <colyli@suse.de>
List-Id: linux-bcache@vger.kernel.org

Commit 09b3efec ("bcache: Don't reinvent the wheel but use existing llist
API") replaces the following while loop by llist_for_each_entry(),

-
-	while (reverse) {
-		cl = container_of(reverse, struct closure, list);
-		reverse = llist_next(reverse);
-
+	llist_for_each_entry(cl, reverse, list) {
 		closure_set_waiting(cl, 0);
 		closure_sub(cl, CLOSURE_WAITING + 1);
 	}

This modification introduces a potential race by iterating a corrupted
list. Here is how it happens.

In the above modification, closure_sub() may wake up a process which is
waiting on reverse list. If this process decides to wait again by calling
closure_wait(), its cl->list will be added to another wait list. Then
when llist_for_each_entry() continues to iterate next node, it will travel
on another new wait list which is added in closure_wait(), not the
original reverse list in __closure_wake_up(). It is more probably to
happen on UP machine because the waked up process may preempt the process
which wakes up it.

Use llist_for_each_entry_safe() will fix the issue, the safe version fetch
next node before waking up a process. Then the copy of next node will make
sure list iteration stays on original reverse list.

Signed-off-by: Coly Li <colyli@suse.de>
Reported-by: Michael Lyle <mlyle@lyle.org>
Reviewed-by: Byungchul Park <byungchul.park@lge.com>
---
 drivers/md/bcache/closure.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/closure.c b/drivers/md/bcache/closure.c
index 7d5286b05036..1841d0359bac 100644
--- a/drivers/md/bcache/closure.c
+++ b/drivers/md/bcache/closure.c
@@ -64,7 +64,7 @@ EXPORT_SYMBOL(closure_put);
 void __closure_wake_up(struct closure_waitlist *wait_list)
 {
 	struct llist_node *list;
-	struct closure *cl;
+	struct closure *cl, *t;
 	struct llist_node *reverse = NULL;
 
 	list = llist_del_all(&wait_list->list);
@@ -73,7 +73,7 @@ void __closure_wake_up(struct closure_waitlist *wait_list)
 	reverse = llist_reverse_order(list);
 
 	/* Then do the wakeups */
-	llist_for_each_entry(cl, reverse, list) {
+	llist_for_each_entry_safe(cl, t, reverse, list) {
 		closure_set_waiting(cl, 0);
 		closure_sub(cl, CLOSURE_WAITING + 1);
 	}
-- 
2.13.5
