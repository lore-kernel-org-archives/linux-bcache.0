From: Stefan Bader <stefan.bader@canonical.com>
Subject: [PATCH resend] bcache: prevent crash on changing writeback_running
Date: Fri, 10 Jul 2015 16:10:56 +0200
Message-ID: <1436537456-17338-1-git-send-email-stefan.bader@canonical.com>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:43024 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455AbbGJOK7 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 10 Jul 2015 10:10:59 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com

I sent this out quite a while ago. Back then it was said that it
was applied to the development tree. But it seems it never made its
way upstream. 
I re-tested with a 4.0.7 kernel and compared this against a 4.0 kernel
with this patch applied. Still it is possible to trigger a NULL pointer
violation when writing 0 into writeback_running of a bcache device that
is not attached to a cache set (without the patch).

-Stefan


---

From e949c64fa6acbdaab999410250855a6a4fc6bad1 Mon Sep 17 00:00:00 2001
From: Stefan Bader <stefan.bader@canonical.com>
Date: Mon, 18 Aug 2014 20:00:13 +0200
Subject: [PATCH] bcache: prevent crash on changing writeback_running

commit a664d0f05a2e ("bcache: fix crash on shutdown in passthrough mode")

added a safeguard in the shutdown case. At least while not being
attached it is also possible to trigger a kernel bug by writing into
writeback_running. This change  adds the same check before trying to
wake up the thread for that case.

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/md/bcache/writeback.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
index 0a9dab1..073a042 100644
--- a/drivers/md/bcache/writeback.h
+++ b/drivers/md/bcache/writeback.h
@@ -63,7 +63,8 @@ static inline bool should_writeback(struct cached_dev *dc, struct bio *bio,
 
 static inline void bch_writeback_queue(struct cached_dev *dc)
 {
-	wake_up_process(dc->writeback_thread);
+	if (!IS_ERR_OR_NULL(dc->writeback_thread))
+		wake_up_process(dc->writeback_thread);
 }
 
 static inline void bch_writeback_add(struct cached_dev *dc)
-- 
1.9.1
