From: Michael Lyle <mlyle@lyle.org>
Subject: [PATCH] bcache: writeback rate clamping: make 32 bit safe
Date: Mon, 16 Oct 2017 10:34:47 -0700
Message-ID: <20171016173447.27253-1-mlyle@lyle.org>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:51117 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754307AbdJPRe7 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 16 Oct 2017 13:34:59 -0400
Received: by mail-pg0-f66.google.com with SMTP id y7so7360660pgb.7
        for <linux-bcache@vger.kernel.org>; Mon, 16 Oct 2017 10:34:59 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Cc: axboe@kernel.dk, Michael Lyle <mlyle@lyle.org>

Sorry this got through to linux-block, was detected by the kbuilds test
robot.  NSEC_PER_SEC is a long constant; 2.5 * 10^9 doesn't fit in a
signed long constant.

Signed-off-by: Michael Lyle <mlyle@lyle.org>
---
 drivers/md/bcache/util.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
index 4dbe37e82877..e548b8b51322 100644
--- a/drivers/md/bcache/util.c
+++ b/drivers/md/bcache/util.c
@@ -238,8 +238,8 @@ uint64_t bch_next_delay(struct bch_ratelimit *d, uint64_t done)
 	 * don't let us sleep more than 2.5 seconds (so we can notice/respond
 	 * if the control system tells us to speed up!).
 	 */
-	if (time_before64(now + NSEC_PER_SEC * 5 / 2, d->next))
-		d->next = now + NSEC_PER_SEC * 5 / 2;
+	if (time_before64(now + NSEC_PER_SEC * 5LLU / 2LLU, d->next))
+		d->next = now + NSEC_PER_SEC * 5LLU / 2LLU;
 
 	if (time_after64(now - NSEC_PER_SEC * 2, d->next))
 		d->next = now - NSEC_PER_SEC * 2;
-- 
2.11.0
