From: Michael Lyle <mlyle@lyle.org>
Subject: [PATCH v2 2/2] bcache: rearrange writeback main thread ratelimit
Date: Mon,  9 Oct 2017 00:37:30 -0700
Message-ID: <20171009073730.8939-3-mlyle@lyle.org>
References: <20171009073730.8939-1-mlyle@lyle.org>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:37745 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753933AbdJIHht (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 9 Oct 2017 03:37:49 -0400
Received: by mail-pf0-f194.google.com with SMTP id z80so7101738pff.4
        for <linux-bcache@vger.kernel.org>; Mon, 09 Oct 2017 00:37:49 -0700 (PDT)
In-Reply-To: <20171009073730.8939-1-mlyle@lyle.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Cc: colyli@suse.de, Michael Lyle <mlyle@lyle.org>

The time spent searching for things to write back "counts" for the
actual rate achieved, so don't flush the accumulated rate with each
chunk.

This will maintain better fidelity to user-commanded rates, but it
may slightly increase the burstiness of writeback.  The writeback
lock needs improvement to help mitigate this.

Signed-off-by: Michael Lyle <mlyle@lyle.org>
---
 drivers/md/bcache/writeback.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 42d087b9fb56..719b104db0cc 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -526,6 +526,8 @@ static int bch_writeback_thread(void *arg)
 	struct cached_dev *dc = arg;
 	bool searched_full_index;
 
+	bch_ratelimit_reset(&dc->writeback_rate);
+
 	while (!kthread_should_stop()) {
 		down_write(&dc->writeback_lock);
 		if (!atomic_read(&dc->has_dirty) ||
@@ -553,7 +555,6 @@ static int bch_writeback_thread(void *arg)
 
 		up_write(&dc->writeback_lock);
 
-		bch_ratelimit_reset(&dc->writeback_rate);
 		read_dirty(dc);
 
 		if (searched_full_index) {
@@ -563,6 +564,8 @@ static int bch_writeback_thread(void *arg)
 			       !kthread_should_stop() &&
 			       !test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags))
 				delay = schedule_timeout_interruptible(delay);
+
+			bch_ratelimit_reset(&dc->writeback_rate);
 		}
 	}
 
-- 
2.11.0
