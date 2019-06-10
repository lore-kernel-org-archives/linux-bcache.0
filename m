From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: [PATCH 05/12] fs: insert_inode_locked2()
Date: Mon, 10 Jun 2019 15:14:13 -0400
Message-ID: <20190610191420.27007-6-kent.overstreet@gmail.com>
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190610191420.27007-1-kent.overstreet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-bcache@vger.kernel.org

New helper for bcachefs, so that when we race inserting an inode we can
atomically grab a ref to the inode already in the inode cache.

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
---
 fs/inode.c         | 40 ++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |  1 +
 2 files changed, 41 insertions(+)

diff --git a/fs/inode.c b/fs/inode.c
index 8881dc551f..cc44f345e0 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1479,6 +1479,46 @@ int insert_inode_locked(struct inode *inode)
 }
 EXPORT_SYMBOL(insert_inode_locked);
 
+struct inode *insert_inode_locked2(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+	ino_t ino = inode->i_ino;
+	struct hlist_head *head = inode_hashtable + hash(sb, ino);
+
+	while (1) {
+		struct inode *old = NULL;
+		spin_lock(&inode_hash_lock);
+		hlist_for_each_entry(old, head, i_hash) {
+			if (old->i_ino != ino)
+				continue;
+			if (old->i_sb != sb)
+				continue;
+			spin_lock(&old->i_lock);
+			if (old->i_state & (I_FREEING|I_WILL_FREE)) {
+				spin_unlock(&old->i_lock);
+				continue;
+			}
+			break;
+		}
+		if (likely(!old)) {
+			spin_lock(&inode->i_lock);
+			inode->i_state |= I_NEW | I_CREATING;
+			hlist_add_head(&inode->i_hash, head);
+			spin_unlock(&inode->i_lock);
+			spin_unlock(&inode_hash_lock);
+			return NULL;
+		}
+		__iget(old);
+		spin_unlock(&old->i_lock);
+		spin_unlock(&inode_hash_lock);
+		wait_on_inode(old);
+		if (unlikely(!inode_unhashed(old)))
+			return old;
+		iput(old);
+	}
+}
+EXPORT_SYMBOL(insert_inode_locked2);
+
 int insert_inode_locked4(struct inode *inode, unsigned long hashval,
 		int (*test)(struct inode *, void *), void *data)
 {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index a88d994751..d5d12d6981 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3010,6 +3010,7 @@ extern struct inode *find_inode_nowait(struct super_block *,
 				       void *data);
 extern int insert_inode_locked4(struct inode *, unsigned long, int (*test)(struct inode *, void *), void *);
 extern int insert_inode_locked(struct inode *);
+extern struct inode *insert_inode_locked2(struct inode *);
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 extern void lockdep_annotate_inode_mutex_key(struct inode *inode);
 #else
-- 
2.20.1
