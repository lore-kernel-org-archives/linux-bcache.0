From: Wang Hai <wanghai38@huawei.com>
Subject: [PATCH] bcache: remove set but not used variable 'i'
Date: Mon, 6 Apr 2020 02:25:41 -0000 (UTC)
Message-ID: <1586259407-23673-1-git-send-email-wanghai38@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:12614 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726408AbgDFCZS (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 5 Apr 2020 22:25:18 -0400
Date: Tue, 7 Apr 2020 07:36:47 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: colyli@suse.de, kent.overstreet@gmail.com
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, wanghai38@huawei.com

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/md/bcache/btree.c: In function bch_btree_check_thread:
drivers/md/bcache/btree.c:1910:6: warning:
 variable ‘i’ set but not used [-Wunused-but-set-variable]

It's not used since commit 8e7102273f59 ("bcache: make bch_btree_check()
to be multithreaded"), so remove it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/md/bcache/btree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 72856e5..b962313 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1907,10 +1907,10 @@ static int bch_btree_check_thread(void *arg)
 	struct btree_iter iter;
 	struct bkey *k, *p;
 	int cur_idx, prev_idx, skip_nr;
-	int i, n;
+	int n;
 
 	k = p = NULL;
-	i = n = 0;
+	n = 0;
 	cur_idx = prev_idx = 0;
 	ret = 0;
 
-- 
1.8.3.1
