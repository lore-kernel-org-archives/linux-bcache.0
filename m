From: Coly Li <colyli@suse.de>
Subject: [PATCH 1/2] bcache: remove redundant variables i and n
Date: Mon,  4 May 2020 23:35:28 +0800
Message-ID: <20200504153529.2242-2-colyli@suse.de>
References: <20200504153529.2242-1-colyli@suse.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40304 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728381AbgEDPfn (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 4 May 2020 11:35:43 -0400
In-Reply-To: <20200504153529.2242-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Colin Ian King <colin.king@canonical.com>, Coly Li <colyli@suse.de>

From: Colin Ian King <colin.king@canonical.com>

Variables i and n are being assigned but are never used. They are
redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/btree.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 72856e5f23a3..114d0d73d909 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1907,10 +1907,8 @@ static int bch_btree_check_thread(void *arg)
 	struct btree_iter iter;
 	struct bkey *k, *p;
 	int cur_idx, prev_idx, skip_nr;
-	int i, n;
 
 	k = p = NULL;
-	i = n = 0;
 	cur_idx = prev_idx = 0;
 	ret = 0;
 
-- 
2.25.0
