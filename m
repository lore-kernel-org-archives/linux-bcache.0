From: Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 07/11] bcache: Fix a flush/fua performance bug
Date: Mon, 23 Sep 2013 23:17:32 -0700
Message-ID: <1380003456-19938-8-git-send-email-kmo@daterainc.com>
References: <1380003456-19938-1-git-send-email-kmo@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1380003456-19938-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Cc: axboe@kernel.dk, Kent Overstreet <kmo@daterainc.com>, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

bch_journal_meta() was missing the flush to make the journal write
actually go down (instead of waiting up to journal_delay_ms)...

Whoops

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: linux-stable <stable@vger.kernel.org> # >= v3.10
---
 drivers/md/bcache/journal.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index f5203df..8435f81 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -695,6 +695,7 @@ void bch_journal_meta(struct cache_set *c, struct closure *cl)
 		if (cl)
 			BUG_ON(!closure_wait(&w->wait, cl));
 
+		closure_flush(&c->journal.io);
 		__journal_try_write(c, true);
 	}
 }
-- 
1.8.4.rc3
