From: Coly Li <colyli@suse.de>
Subject: [PATCH 10/12] bcache: silence static checker warning
Date: Wed,  6 Sep 2017 14:26:00 +0800
Message-ID: <20170906062602.50497-11-colyli@suse.de>
References: <20170906062602.50497-1-colyli@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170906062602.50497-1-colyli@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk
Cc: bcache@lists.ewheeler.net, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: linux-bcache@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

In olden times, closure_return() used to have a hidden return built in.
We removed the hidden return but forgot to add a new return here.  If
"c" were NULL we would oops on the next line, but fortunately "c" is
never NULL.  Let's just remove the if statement.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 253918972335..c5deec621fdd 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1376,9 +1376,6 @@ static void cache_set_flush(struct closure *cl)
 	struct btree *b;
 	unsigned i;
 
-	if (!c)
-		closure_return(cl);
-
 	bch_cache_accounting_destroy(&c->accounting);
 
 	kobject_put(&c->internal);
-- 
2.13.5
