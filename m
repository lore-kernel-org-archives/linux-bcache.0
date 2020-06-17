Return-Path: <SRS0=fFEs=76=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36558C433E1
	for <linux-bcache@archiver.kernel.org>; Wed, 17 Jun 2020 22:28:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1338A20882
	for <linux-bcache@archiver.kernel.org>; Wed, 17 Jun 2020 22:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592432905;
	bh=Yi1d/v3osmCvvEbYDr4tUwBfCO+aS4MR9X1Q7k5l7xw=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=Za22ubLL9K5+xQ8uIOEY1Jie8BTJIjFV3wg03KVWzXuSaz66zooJWlXT2asMCywjk
	 sNTzB3DALKkscY5SAS0ywOIXIHlaCgPmnfrKsuttS/TfzrP4j4wxVtNkKCY101FZws
	 HdZ11qapdKsUtdWAAhXC8JYcSHd2fgsdz1+rbnzA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgFQW2V (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Wed, 17 Jun 2020 18:28:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727029AbgFQW2K (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 17 Jun 2020 18:28:10 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E377D20CC7;
        Wed, 17 Jun 2020 22:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592432890;
        bh=Yi1d/v3osmCvvEbYDr4tUwBfCO+aS4MR9X1Q7k5l7xw=;
        h=Date:From:To:Cc:Subject:From;
        b=fhC5H38PP/JsLixrTUYswOir0BG0Zco4b1+efQ+/WhGHyobawbdtuWPkdiU5MR3dg
         3L/Hl2UTmqUeaYDMzRLcVBjOLgOMSKhcqfRJLbUf8Rvhh1z7kgUfaM7P/1tL6AN/pD
         GQHFFNtUal3xNjaiGejO1TE+3axNV9/8rX8dmsbg=
Date:   Wed, 17 Jun 2020 17:33:31 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] bcache: movinggc: Use struct_size() helper in kzalloc()
Message-ID: <20200617223331.GA25794@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org
Message-ID: <20200617223331.USzA0k2xIf7JSj-t0uOVMKzKiHTGmpHZaqgSgvUSSJ0@z>

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes.

This code was detected with the help of Coccinelle and, audited and
fixed manually.

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
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
2.27.0

