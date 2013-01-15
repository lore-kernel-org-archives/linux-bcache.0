From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/4] Revert "rw_semaphore: remove up/down_read_non_owner"
Date: Tue, 15 Jan 2013 13:25:39 -0800
Message-ID: <1358285142-10576-1-git-send-email-koverstreet@google.com>
References: <20130114223202.GV26407@google.com>
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130114223202.GV26407-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

This reverts commit 11b80f459adaf91a712f95e7734a17655a36bf30.

Bcache needs rw semaphores for cache coherency in writeback mode -
writes have to take a read lock on a per cache device rw sem, and
release it when the bio completes.

But since this is for bios it's naturally not in the context of the
process that originally took the lock.

Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
CC: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
CC: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/linux/rwsem.h | 10 ++++++++++
 kernel/rwsem.c        | 16 ++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 54bd7cd..ddfe46d 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -125,9 +125,19 @@ extern void downgrade_write(struct rw_semaphore *sem);
  */
 extern void down_read_nested(struct rw_semaphore *sem, int subclass);
 extern void down_write_nested(struct rw_semaphore *sem, int subclass);
+/*
+ * Take/release a lock when not the owner will release it.
+ *
+ * [ This API should be avoided as much as possible - the
+ *   proper abstraction for this case is completions. ]
+ */
+extern void down_read_non_owner(struct rw_semaphore *sem);
+extern void up_read_non_owner(struct rw_semaphore *sem);
 #else
 # define down_read_nested(sem, subclass)		down_read(sem)
 # define down_write_nested(sem, subclass)	down_write(sem)
+# define down_read_non_owner(sem)		down_read(sem)
+# define up_read_non_owner(sem)			up_read(sem)
 #endif
 
 #endif /* _LINUX_RWSEM_H */
diff --git a/kernel/rwsem.c b/kernel/rwsem.c
index 6850f53..78b7915 100644
--- a/kernel/rwsem.c
+++ b/kernel/rwsem.c
@@ -116,6 +116,15 @@ void down_read_nested(struct rw_semaphore *sem, int subclass)
 
 EXPORT_SYMBOL(down_read_nested);
 
+void down_read_non_owner(struct rw_semaphore *sem)
+{
+	might_sleep();
+
+	__down_read(sem);
+}
+
+EXPORT_SYMBOL(down_read_non_owner);
+
 void down_write_nested(struct rw_semaphore *sem, int subclass)
 {
 	might_sleep();
@@ -126,6 +135,13 @@ void down_write_nested(struct rw_semaphore *sem, int subclass)
 
 EXPORT_SYMBOL(down_write_nested);
 
+void up_read_non_owner(struct rw_semaphore *sem)
+{
+	__up_read(sem);
+}
+
+EXPORT_SYMBOL(up_read_non_owner);
+
 #endif
 
 
-- 
1.7.12
