From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 049/219] bcache: do not check if debug dentry is ERR or NULL explicitly on remove
Date: Fri, 22 Nov 2019 00:46:21 -0500
Message-ID: <20191122054911.1750-42-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Shenghui Wang <shhuiw@foxmail.com>, Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

From: Shenghui Wang <shhuiw@foxmail.com>

[ Upstream commit ae17102316550b4b230a283febe31b2a9ff30084 ]

debugfs_remove and debugfs_remove_recursive will check if the dentry
pointer is NULL or ERR, and will do nothing in that case.

Remove the check in cache_set_free and bch_debug_init.

Signed-off-by: Shenghui Wang <shhuiw@foxmail.com>
Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/debug.c | 3 +--
 drivers/md/bcache/super.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index 06da66b2488ae..8c53d874ada4a 100644
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -249,8 +249,7 @@ void bch_debug_init_cache_set(struct cache_set *c)
 
 void bch_debug_exit(void)
 {
-	if (!IS_ERR_OR_NULL(bcache_debug))
-		debugfs_remove_recursive(bcache_debug);
+	debugfs_remove_recursive(bcache_debug);
 }
 
 void __init bch_debug_init(struct kobject *kobj)
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 2321643974dab..3124399e2607a 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1485,8 +1485,7 @@ static void cache_set_free(struct closure *cl)
 	struct cache *ca;
 	unsigned int i;
 
-	if (!IS_ERR_OR_NULL(c->debug))
-		debugfs_remove(c->debug);
+	debugfs_remove(c->debug);
 
 	bch_open_buckets_free(c);
 	bch_btree_cache_free(c);
-- 
2.20.1
