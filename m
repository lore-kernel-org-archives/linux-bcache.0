Return-Path: <SRS0=fFEs=76=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B449C433E0
	for <linux-bcache@archiver.kernel.org>; Wed, 17 Jun 2020 22:22:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2957220882
	for <linux-bcache@archiver.kernel.org>; Wed, 17 Jun 2020 22:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592432536;
	bh=IXfRB1ln79N+EByGvcDZLtyLTc8uIB4owydFsSPvdn4=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=TtNprYty9h4OTtJ5KY+hL1dWsqzv8PcIPGJnpR9iXPgaH405GIYteTxgGtx33CTym
	 7j7DTP8+uI+PZiSv+fNNEa4rsqHLwnTQ1o1xNjAOh9W5W6bOGQliIVSl5PwTys/H+K
	 NF/DPDF7QSL7tg0oZmnFkAqQDGZFJnXKwLT+m8Og=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgFQWWN (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Wed, 17 Jun 2020 18:22:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:58544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726909AbgFQWWN (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 17 Jun 2020 18:22:13 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6DF02083B;
        Wed, 17 Jun 2020 22:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592432533;
        bh=IXfRB1ln79N+EByGvcDZLtyLTc8uIB4owydFsSPvdn4=;
        h=Date:From:To:Cc:Subject:From;
        b=uQ/seVr9NqlnoEZpYrrDnKyihLCV1NpDqkPfISGAoZYQOTULsJr86NzD2lqElXJ7T
         2Zum6blhRm7Y1SwcwF+vGdvbCjkqpQpOnrtSCdSNI5lgm/cCnzT8DhJXg8sI4G9oaN
         UgcFLJ7dfXMXROnRC88wxorAfsDSYFZELCBNot38=
Date:   Wed, 17 Jun 2020 17:27:33 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] bcache: Use struct_size() in kzalloc()
Message-ID: <20200617222733.GA24156@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org
Message-ID: <20200617222733.T21i78o_hQNE7saFlGIRKooGk6DL6iwZyxo9jiLll10@z>

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes.

This code was detected with the help of Coccinelle and, audited and
fixed manually.

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/md/bcache/writeback.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 1cf1e5016cb9..c0db3c860179 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -459,10 +459,8 @@ static void read_dirty(struct cached_dev *dc)
 		for (i = 0; i < nk; i++) {
 			w = keys[i];
 
-			io = kzalloc(sizeof(struct dirty_io) +
-				     sizeof(struct bio_vec) *
-				     DIV_ROUND_UP(KEY_SIZE(&w->key),
-						  PAGE_SECTORS),
+			io = kzalloc(struct_size(io, bio.bi_inline_vecs,
+						DIV_ROUND_UP(KEY_SIZE(&w->key), PAGE_SECTORS)),
 				     GFP_KERNEL);
 			if (!io)
 				goto err;
-- 
2.27.0

