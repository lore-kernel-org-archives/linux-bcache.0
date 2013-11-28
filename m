From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] bcache: fix sparse non static symbol warning
Date: Thu, 28 Nov 2013 10:31:35 +0800
Message-ID: <CAPgLHd-qv+6z4PBMAUoe8tvTkUFTMhPE1Wv-2dzr9FvEzqZMaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:63976 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561Ab3K1Cbg (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 27 Nov 2013 21:31:36 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: kmo@daterainc.com, neilb@suse.de
Cc: yongjun_wei@trendmicro.com.cn, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fixes the following sparse warning:

drivers/md/bcache/btree.c:2220:5: warning:
 symbol 'btree_insert_fn' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/md/bcache/btree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index b62f379..2a46036 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -2217,7 +2217,7 @@ struct btree_insert_op {
 	struct bkey	*replace_key;
 };
 
-int btree_insert_fn(struct btree_op *b_op, struct btree *b)
+static int btree_insert_fn(struct btree_op *b_op, struct btree *b)
 {
 	struct btree_insert_op *op = container_of(b_op,
 					struct btree_insert_op, op);
