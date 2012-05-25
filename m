From: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 2/3] timerqueue: convert to generic rb tree code
Date: Fri, 25 May 2012 13:57:40 -0700
Message-ID: <1337979461-19654-3-git-send-email-koverstreet@google.com>
References: <1337979461-19654-1-git-send-email-koverstreet@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1337979461-19654-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk, paul.gortmaker@windriver.com
List-Id: linux-bcache@vger.kernel.org

Change-Id: Ib31c42c037203b7eb78515673475130db9fa6b0b

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 lib/timerqueue.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/lib/timerqueue.c b/lib/timerqueue.c
index a382e4a..3014abe 100644
--- a/lib/timerqueue.c
+++ b/lib/timerqueue.c
@@ -27,6 +27,14 @@
 #include <linux/rbtree.h>
 #include <linux/export.h>
 
+static int timerqueue_cmp(struct rb_node *l, struct rb_node *r)
+{
+	return clamp_t(int64_t,
+		       rb_entry(l, struct timerqueue_node, node)->expires.tv64 -
+		       rb_entry(r, struct timerqueue_node, node)->expires.tv64,
+		       -1, 1);
+}
+
 /**
  * timerqueue_add - Adds timer to timerqueue.
  *
@@ -38,23 +46,10 @@
  */
 void timerqueue_add(struct timerqueue_head *head, struct timerqueue_node *node)
 {
-	struct rb_node **p = &head->head.rb_node;
-	struct rb_node *parent = NULL;
-	struct timerqueue_node  *ptr;
-
 	/* Make sure we don't add nodes that are already added */
 	WARN_ON_ONCE(!RB_EMPTY_NODE(&node->node));
 
-	while (*p) {
-		parent = *p;
-		ptr = rb_entry(parent, struct timerqueue_node, node);
-		if (node->expires.tv64 < ptr->expires.tv64)
-			p = &(*p)->rb_left;
-		else
-			p = &(*p)->rb_right;
-	}
-	rb_link_node(&node->node, parent, p);
-	rb_insert_color(&node->node, &head->head);
+	rb_insert_allow_dup(&head->head, &node->node, timerqueue_cmp);
 
 	if (!head->next || node->expires.tv64 < head->next->expires.tv64)
 		head->next = node;
-- 
1.7.9.3.327.g2980b
