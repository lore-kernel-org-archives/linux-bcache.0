Return-Path: <SRS0=hDdM=BE=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43ABAC433F2
	for <linux-bcache@archiver.kernel.org>; Sat, 25 Jul 2020 12:02:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28BF2206C1
	for <linux-bcache@archiver.kernel.org>; Sat, 25 Jul 2020 12:02:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbgGYMCv (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Sat, 25 Jul 2020 08:02:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:52154 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726583AbgGYMCv (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 25 Jul 2020 08:02:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CBE54AFBE;
        Sat, 25 Jul 2020 12:02:58 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 05/25] bcache: movinggc: Use struct_size() helper in kzalloc()
Date:   Sat, 25 Jul 2020 20:00:19 +0800
Message-Id: <20200725120039.91071-6-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200725120039.91071-1-colyli@suse.de>
References: <20200725120039.91071-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes.

This code was detected with the help of Coccinelle and, audited and
fixed manually.

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/movinggc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/movinggc.c b/drivers/md/bcache/movinggc.c
index 7891fb512736..b7dd2d75f58c 100644
--- a/drivers/md/bcache/movinggc.c
+++ b/drivers/md/bcache/movinggc.c
@@ -145,8 +145,8 @@ static void read_moving(struct cache_set *c)
 			continue;
 		}
 
-		io = kzalloc(sizeof(struct moving_io) + sizeof(struct bio_vec)
-			     * DIV_ROUND_UP(KEY_SIZE(&w->key), PAGE_SECTORS),
+		io = kzalloc(struct_size(io, bio.bio.bi_inline_vecs,
+					 DIV_ROUND_UP(KEY_SIZE(&w->key), PAGE_SECTORS)),
 			     GFP_KERNEL);
 		if (!io)
 			goto err;
-- 
2.26.2

