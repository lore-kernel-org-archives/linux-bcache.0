Return-Path: <SRS0=hDdM=BE=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFF8BC433ED
	for <linux-bcache@archiver.kernel.org>; Sat, 25 Jul 2020 12:02:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97EAC206C1
	for <linux-bcache@archiver.kernel.org>; Sat, 25 Jul 2020 12:02:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgGYMCt (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Sat, 25 Jul 2020 08:02:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:52136 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726583AbgGYMCt (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 25 Jul 2020 08:02:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 36817B084;
        Sat, 25 Jul 2020 12:02:56 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        Xu Wang <vulab@iscas.ac.cn>, Coly Li <colyli@suse.de>
Subject: [PATCH 04/25] bcache: writeback: Remove unneeded variable i
Date:   Sat, 25 Jul 2020 20:00:18 +0800
Message-Id: <20200725120039.91071-5-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200725120039.91071-1-colyli@suse.de>
References: <20200725120039.91071-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Xu Wang <vulab@iscas.ac.cn>

Remove unneeded variable i in bch_dirty_init_thread().

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/writeback.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 1cf1e5016cb9..71801c086b82 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -825,10 +825,8 @@ static int bch_dirty_init_thread(void *arg)
 	struct btree_iter iter;
 	struct bkey *k, *p;
 	int cur_idx, prev_idx, skip_nr;
-	int i;
 
 	k = p = NULL;
-	i = 0;
 	cur_idx = prev_idx = 0;
 
 	bch_btree_iter_init(&c->root->keys, &iter, NULL);
-- 
2.26.2

