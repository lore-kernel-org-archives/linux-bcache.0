From: Coly Li <colyli@suse.de>
Subject: [PATCH 02/12] bcache: fix sequential large write IO bypass
Date: Wed,  6 Sep 2017 14:25:52 +0800
Message-ID: <20170906062602.50497-3-colyli@suse.de>
References: <20170906062602.50497-1-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170906062602.50497-1-colyli@suse.de>
Sender: stable-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk
Cc: bcache@lists.ewheeler.net, Tang Junhui <tang.junhui@zte.com.cn>, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

From: Tang Junhui <tang.junhui@zte.com.cn>

Sequential write IOs were tested with bs=1M by FIO in writeback cache
mode, these IOs were expected to be bypassed, but actually they did not.
We debug the code, and find in check_should_bypass():
    if (!congested &&
        mode == CACHE_MODE_WRITEBACK &&
        op_is_write(bio_op(bio)) &&
        (bio-＞bi_opf & REQ_SYNC))
        goto rescale
that means, If in writeback mode, a write IO with REQ_SYNC flag will not
be bypassed though it is a sequential large IO, It's not a correct thing
to do actually, so this patch remove these codes.

Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
Reviewed-by: Kent Overstreet <kent.overstreet@gmail.com>
Reviewed-by: Eric Wheeler <bcache@linux.ewheeler.net>
Cc: stable@vger.kernel.org
---
 drivers/md/bcache/request.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 019b3df9f1c6..958072a11347 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -400,12 +400,6 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
 	if (!congested && !dc->sequential_cutoff)
 		goto rescale;
 
-	if (!congested &&
-	    mode == CACHE_MODE_WRITEBACK &&
-	    op_is_write(bio->bi_opf) &&
-	    op_is_sync(bio->bi_opf))
-		goto rescale;
-
 	spin_lock(&dc->io_lock);
 
 	hlist_for_each_entry(i, iohash(dc, bio->bi_iter.bi_sector), hash)
-- 
2.13.5
