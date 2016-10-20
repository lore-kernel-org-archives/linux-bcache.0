From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: [PATCH v3 3/3] bcache: update bio->bi_opf bypass/writeback REQ_ flag
 hints
Date: Wed, 19 Oct 2016 17:36:37 -0700
Message-ID: <S932571AbcJTAjd/20161020003933Z+4461@vger.kernel.org>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:44265 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932509AbcJTAjc (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 19 Oct 2016 20:39:32 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.ewheeler.net (Postfix) with ESMTP id 65B09A0C2C
        for <linux-bcache@vger.kernel.org>; Wed, 19 Oct 2016 17:39:32 -0700 (PDT)
Received: from mail.ewheeler.net ([127.0.0.1])
        by localhost (mail.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id IK9RlLgvJoVT for <linux-bcache@vger.kernel.org>;
        Wed, 19 Oct 2016 17:39:32 -0700 (PDT)
Received: from mx.ewheeler.net (mx.ewheeler.net [66.155.3.69])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mail.ewheeler.net (Postfix) with ESMTPSA id 80C69A0C51
        for <linux-bcache@vger.kernel.org>; Wed, 19 Oct 2016 17:39:26 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

Bypass if:
	bio->bi_opf & (REQ_RAHEAD|REQ_THROTTLED)

Writeback if:
	bio->bi_opf & (REQ_SYNC|REQ_META|REQ_PRIO|REQ_NOIDLE|REQ_FUA|REQ_PREFLUSH)

Signed-off-by: Eric Wheeler <bcache@linux.ewheeler.net>
---
 drivers/md/bcache/request.c   | 3 +++
 drivers/md/bcache/writeback.h | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 52e646f..ff356d7 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -388,6 +388,9 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
 	     op_is_write(bio_op(bio))))
 		goto skip;
 
+	if (bio->bi_opf & (REQ_RAHEAD|REQ_THROTTLED))
+		goto skip;
+
 	/* If the ioprio already exists on the bio, use that.  We assume that
 	 * the upper layer properly assigned the calling process's ioprio to
 	 * the bio being passed to bcache. Otherwise, use current's ioc. */
diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
index 176b1b3..359361c 100644
--- a/drivers/md/bcache/writeback.h
+++ b/drivers/md/bcache/writeback.h
@@ -81,7 +81,7 @@ static inline bool should_writeback(struct cached_dev *dc, struct bio *bio,
 		return true;
 	}
 
-	return bio->bi_opf & REQ_SYNC ||
+	return bio->bi_opf & (REQ_SYNC|REQ_META|REQ_PRIO|REQ_NOIDLE|REQ_FUA|REQ_PREFLUSH) ||
 		in_use <= CUTOFF_WRITEBACK;
 }
 
-- 
1.8.3.1
