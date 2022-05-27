Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D6AAC433F5
	for <linux-bcache@archiver.kernel.org>; Fri, 27 May 2022 15:32:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235167AbiE0PcJ (ORCPT <rfc822;linux-bcache@archiver.kernel.org>);
        Fri, 27 May 2022 11:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345156AbiE0PcJ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 May 2022 11:32:09 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C682F38F;
        Fri, 27 May 2022 08:32:08 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 528D621A96;
        Fri, 27 May 2022 15:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653665527; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fa7cW9X2mq+eo81cCWLHkqcx33oUMhtL9LBXdlcGjrQ=;
        b=Yu2/OlYC3/3yr09mwCD3izKb1vWhpdFskbUaUWPGYewe5OHvVbE8ohttlahfhz6IrwLZyN
        WCzwGLOatg9884iVi1MM7RPB6IqPT6yI4CB36l63lfRqKsBqLcPW7zVgdf7LT2Syl+D35Y
        nd0n69Gr/XtPStlion4tr9sYtElSzQQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653665527;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fa7cW9X2mq+eo81cCWLHkqcx33oUMhtL9LBXdlcGjrQ=;
        b=i2eU3JsOy/LhmHRbst7gLpghS/x1V5Lr6AhTEQOcni62y/ZrmjlsPP1+sOh+go2UNpGdpI
        7S2RFJIJobXc+/CA==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 1EC3B2C141;
        Fri, 27 May 2022 15:32:00 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>, Coly Li <colyli@suse.de>
Subject: [PATCH 3/3] md: bcache: check the return value of kzalloc() in detached_dev_do_request()
Date:   Fri, 27 May 2022 23:28:18 +0800
Message-Id: <20220527152818.27545-4-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220527152818.27545-1-colyli@suse.de>
References: <20220527152818.27545-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

The function kzalloc() in detached_dev_do_request() can fail, so its
return value should be checked.

Fixes: bc082a55d25c ("bcache: fix inaccurate io state for detached bcache devices")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/request.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 320fcdfef48e..02df49d79b4b 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1105,6 +1105,12 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
 	 * which would call closure_get(&dc->disk.cl)
 	 */
 	ddip = kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
+	if (!ddip) {
+		bio->bi_status = BLK_STS_RESOURCE;
+		bio->bi_end_io(bio);
+		return;
+	}
+
 	ddip->d = d;
 	/* Count on the bcache device */
 	ddip->orig_bdev = orig_bdev;
-- 
2.35.3

