Return-Path: <SRS0=q/iw=7W=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D6CFC433E1
	for <linux-bcache@archiver.kernel.org>; Tue,  9 Jun 2020 00:57:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CC8320737
	for <linux-bcache@archiver.kernel.org>; Tue,  9 Jun 2020 00:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591664277;
	bh=SWWGoQsVVAyjX/AN81bixPfF8lDzZ/UMYuq0YgzmvUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=tUnL0LZvlRiU7btIUD3NqSnxMXN5oxquzautr03AheqD8brc4hVTkfKCthpI4Xz2w
	 0rSEE6NPF1rb0xrE7Oo6sF3YzAUaoiFI9MiQIm4TIlDg1PkmwRnV6QejKiUk6AgdJn
	 lzT94fqW8B1EsUkUn0fol6u7jYTecIfYAZLTZ7o8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730520AbgFIA5c (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Mon, 8 Jun 2020 20:57:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728262AbgFHXIu (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 8 Jun 2020 19:08:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10950208C7;
        Mon,  8 Jun 2020 23:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657729;
        bh=SWWGoQsVVAyjX/AN81bixPfF8lDzZ/UMYuq0YgzmvUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AQ6VfoPodepn32on6YldBsZakXGLZ2rsGgt+KUpcALeqGTla3c5h7X27iXe1pRgX9
         IUAdDgHjyhtv0B7Q/S0VHWx6gNfoaACjo47k9SuR8TE+dK5fT9TtywEPDdCU5x5jkp
         WHCHsT4To1unWZq44INcFyBVd3Ev/KOIw67IkCB0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 121/274] bcache: remove a duplicate ->make_request_fn assignment
Date:   Mon,  8 Jun 2020 19:03:34 -0400
Message-ID: <20200608230607.3361041-121-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org
Message-ID: <20200608230334.goMVdcSB_zzFBPATmJP8zu4iK7AedKDqdwPxis77GhE@z>

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit a91b2014fc31dc6eaa02ca33aa3b4d1b6e4a0207 ]

The make_request_fn pointer should only be assigned by blk_alloc_queue.
Fix a left over manual initialization.

Fixes: ff27668ce809 ("bcache: pass the make_request methods to blk_queue_make_request")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/request.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 71a90fbec314..77d1a2697517 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1372,7 +1372,6 @@ void bch_flash_dev_request_init(struct bcache_device *d)
 {
 	struct gendisk *g = d->disk;
 
-	g->queue->make_request_fn		= flash_dev_make_request;
 	g->queue->backing_dev_info->congested_fn = flash_dev_congested;
 	d->cache_miss				= flash_dev_cache_miss;
 	d->ioctl				= flash_dev_ioctl;
-- 
2.25.1

