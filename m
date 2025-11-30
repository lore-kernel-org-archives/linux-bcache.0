Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA64A36D4EB;
	Sun, 30 Nov 2025 15:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764515342; cv=none; b=RsRuBXvgZ5SpSGA19tHkeIFZA2S+yp4+oYsLYE/cE3mreor2ufCGWQLu9q1SiRqc+J3y4gj1puOIv7i80G/jju3qjaf3sudc/YcfgrXjzQYMCnoutHAny7B8tvlTatedhQ2zNmBaJ1kr7ZQYR+96jMf2F5l249NJVZf3uohe7FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764515342; c=relaxed/simple;
	bh=y04TCg/OlFCstgjvPYD6rCqqVLGcl9qg0iyZXd7XNCM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SWoE0YQJkqA8XJJCXVUFH9qRwGVuwO28TIgSxxhKDbD7X5Qop7pG2qQFsicsTVGogTF1VmJh0u4lxkm59ejxHQ+cIu9LTH914futAiQnGZ/d3wyFk6tjmVssFsQEb5RZY0NKH9CnCPD21B7cuHpMqgV+o4en6J+yFfCpxaPtDbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB07C4CEF8;
	Sun, 30 Nov 2025 15:08:59 +0000 (UTC)
From: colyli@fnnas.com
To: linux-bcache@vger.kernel.org,
	linux-block@vger.kernel.org
Cc: Coly Li <colyli@fnnas.com>,
	Shida Zhang <zhangshida@kylinos.cn>,
	Christoph Hellwig <hch@infradead.org>,
	Jia-Ju Bai <baijiaju1990@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] bcache: call bio_endio() to replace directly calling bio->bi_end_io()
Date: Sun, 30 Nov 2025 23:08:54 +0800
Message-ID: <20251130150855.1681-1-colyli@fnnas.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Coly Li <colyli@fnnas.com>

When a bcache device is not attached to a cache device, current code
calls the request's bi_end_io() callback directly. The correct method is
to call bio_endio(bio) instead of bio->bi_end_io(bio).

This patch fixes the incorrect calling.

Fixes: bc082a55d25c ("bcache: fix inaccurate io state for detached bcache devices")
Fixes: 40f567bbb3b0 ("md: bcache: check the return value of kzalloc() in detached_dev_do_request()")
Reported-by: Shida Zhang <zhangshida@kylinos.cn>
Closes: https://lore.kernel.org/linux-block/20251121081748.1443507-1-zhangshida@kylinos.cn/
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: stable@vger.kernel.org #4.17+
Signed-off-by: Coly Li <colyli@fnnas.com>
---
 drivers/md/bcache/request.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index af345dc6fde1..7b815064db54 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1104,7 +1104,7 @@ static void detached_dev_end_io(struct bio *bio)
 	}
 
 	kfree(ddip);
-	bio->bi_end_io(bio);
+	bio_endio(bio);
 }
 
 static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
@@ -1121,7 +1121,7 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
 	ddip = kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
 	if (!ddip) {
 		bio->bi_status = BLK_STS_RESOURCE;
-		bio->bi_end_io(bio);
+		bio_endio(bio);
 		return;
 	}
 
@@ -1136,7 +1136,7 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
 
 	if ((bio_op(bio) == REQ_OP_DISCARD) &&
 	    !bdev_max_discard_sectors(dc->bdev))
-		bio->bi_end_io(bio);
+		bio_endio(bio);
 	else
 		submit_bio_noacct(bio);
 }
-- 
2.47.3

