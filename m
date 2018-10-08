From: Coly Li <colyli@suse.de>
Subject: [PATCH 02/15] bcache: trace missed reading by cache_missed
Date: Mon,  8 Oct 2018 20:41:08 +0800
Message-ID: <20181008124121.20192-3-colyli@suse.de>
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

Missed reading IOs are identified by s->cache_missed, not the
s->cache_miss, so in trace_bcache_read() using trace_bcache_read
to identify whether the IO is missed or not.

Signed-off-by: Tang Junhui <tang.junhui.linux@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/request.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 51be355a3309..4946d486f734 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -850,7 +850,7 @@ static void cached_dev_read_done_bh(struct closure *cl)
 
 	bch_mark_cache_accounting(s->iop.c, s->d,
 				  !s->cache_missed, s->iop.bypass);
-	trace_bcache_read(s->orig_bio, !s->cache_miss, s->iop.bypass);
+	trace_bcache_read(s->orig_bio, !s->cache_missed, s->iop.bypass);
 
 	if (s->iop.status)
 		continue_at_nobarrier(cl, cached_dev_read_error, bcache_wq);
-- 
2.19.0
