From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: [PATCH 11/12] closures: closure_wait_event()
Date: Mon, 10 Jun 2019 15:14:19 -0400
Message-ID: <20190610191420.27007-12-kent.overstreet@gmail.com>
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190610191420.27007-1-kent.overstreet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-bcache@vger.kernel.org

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
---
 include/linux/closure.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/include/linux/closure.h b/include/linux/closure.h
index 308e38028c..abacb91c35 100644
--- a/include/linux/closure.h
+++ b/include/linux/closure.h
@@ -379,4 +379,26 @@ static inline void closure_call(struct closure *cl, closure_fn fn,
 	continue_at_nobarrier(cl, fn, wq);
 }
 
+#define __closure_wait_event(waitlist, _cond)				\
+do {									\
+	struct closure cl;						\
+									\
+	closure_init_stack(&cl);					\
+									\
+	while (1) {							\
+		closure_wait(waitlist, &cl);				\
+		if (_cond)						\
+			break;						\
+		closure_sync(&cl);					\
+	}								\
+	closure_wake_up(waitlist);					\
+	closure_sync(&cl);						\
+} while (0)
+
+#define closure_wait_event(waitlist, _cond)				\
+do {									\
+	if (!(_cond))							\
+		__closure_wait_event(waitlist, _cond);			\
+} while (0)
+
 #endif /* _LINUX_CLOSURE_H */
-- 
2.20.1
