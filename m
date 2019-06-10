From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: [PATCH 06/12] fs: factor out d_mark_tmpfile()
Date: Mon, 10 Jun 2019 15:14:14 -0400
Message-ID: <20190610191420.27007-7-kent.overstreet@gmail.com>
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190610191420.27007-1-kent.overstreet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-bcache@vger.kernel.org

New helper for bcachefs - bcachefs doesn't want the
inode_dec_link_count() call that d_tmpfile does, it handles i_nlink on
its own atomically with other btree updates

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
---
 fs/dcache.c            | 10 ++++++++--
 include/linux/dcache.h |  1 +
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index aac41adf47..18edb4e5bc 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -3042,9 +3042,8 @@ void d_genocide(struct dentry *parent)
 
 EXPORT_SYMBOL(d_genocide);
 
-void d_tmpfile(struct dentry *dentry, struct inode *inode)
+void d_mark_tmpfile(struct dentry *dentry, struct inode *inode)
 {
-	inode_dec_link_count(inode);
 	BUG_ON(dentry->d_name.name != dentry->d_iname ||
 		!hlist_unhashed(&dentry->d_u.d_alias) ||
 		!d_unlinked(dentry));
@@ -3054,6 +3053,13 @@ void d_tmpfile(struct dentry *dentry, struct inode *inode)
 				(unsigned long long)inode->i_ino);
 	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dentry->d_parent->d_lock);
+}
+EXPORT_SYMBOL(d_mark_tmpfile);
+
+void d_tmpfile(struct dentry *dentry, struct inode *inode)
+{
+	inode_dec_link_count(inode);
+	d_mark_tmpfile(dentry, inode);
 	d_instantiate(dentry, inode);
 }
 EXPORT_SYMBOL(d_tmpfile);
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 60996e64c5..e0fe330162 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -255,6 +255,7 @@ extern struct dentry * d_make_root(struct inode *);
 /* <clickety>-<click> the ramfs-type tree */
 extern void d_genocide(struct dentry *);
 
+extern void d_mark_tmpfile(struct dentry *, struct inode *);
 extern void d_tmpfile(struct dentry *, struct inode *);
 
 extern struct dentry *d_find_alias(struct inode *);
-- 
2.20.1
