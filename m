From: Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 08/11] bcache: Fix a dumb CPU spinning bug in writeback
Date: Mon, 23 Sep 2013 23:17:33 -0700
Message-ID: <1380003456-19938-9-git-send-email-kmo@daterainc.com>
References: <1380003456-19938-1-git-send-email-kmo@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1380003456-19938-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Cc: axboe@kernel.dk, Kent Overstreet <kmo@daterainc.com>
List-Id: linux-bcache@vger.kernel.org

schedule_timeout() != schedule_timeout_uninterruptible()

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: linux-stable <stable@vger.kernel.org> # >= v3.10
---
 drivers/md/bcache/writeback.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 27ac519..ba3ee48 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -397,8 +397,7 @@ static void read_dirty(struct closure *cl)
 		if (delay > 0 &&
 		    (KEY_START(&w->key) != dc->last_read ||
 		     jiffies_to_msecs(delay) > 50))
-			while (delay)
-				delay = schedule_timeout(delay);
+			delay = schedule_timeout_uninterruptible(delay);
 
 		dc->last_read	= KEY_OFFSET(&w->key);
 
-- 
1.8.4.rc3
