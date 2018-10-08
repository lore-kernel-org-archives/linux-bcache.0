From: Coly Li <colyli@suse.de>
Subject: [PATCH 08/15] bcache: fix miss key refill->end in writeback
Date: Mon,  8 Oct 2018 20:41:14 +0800
Message-ID: <20181008124121.20192-9-colyli@suse.de>
References: <20181008124121.20192-1-colyli@suse.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20181008124121.20192-1-colyli@suse.de>
Sender: stable-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Tang Junhui <tang.junhui.linux@gmail.com>, stable@vger.kernel.org, Coly Li <colyli@suse.de>
List-Id: linux-bcache@vger.kernel.org

From: Tang Junhui <tang.junhui.linux@gmail.com>

refill->end record the last key of writeback, for example, at the first
time, keys (1,128K) to (1,1024K) are flush to the backend device, but
the end key (1,1024K) is not included, since the bellow code:
	if (bkey_cmp(k, refill->end) >= 0) {
		ret = MAP_DONE;
		goto out;
	}
And in the next time when we refill writeback keybuf again, we searched
key start from (1,1024K), and got a key bigger than it, so the key
(1,1024K) missed.
This patch modify the above code, and let the end key to be included to
the writeback key buffer.

Signed-off-by: Tang Junhui <tang.junhui.linux@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/btree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index e7d4817681f2..3f4211b5cd33 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -2434,7 +2434,7 @@ static int refill_keybuf_fn(struct btree_op *op, struct btree *b,
 	struct keybuf *buf = refill->buf;
 	int ret = MAP_CONTINUE;
 
-	if (bkey_cmp(k, refill->end) >= 0) {
+	if (bkey_cmp(k, refill->end) > 0) {
 		ret = MAP_DONE;
 		goto out;
 	}
-- 
2.19.0
