From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] bcache: let the writeback thread run at least once at startup
Date: Fri, 11 Apr 2014 19:33:25 -0700
Message-ID: <20140412023325.GD9176@birch.djwong.org>
References: <20140411002636.GB9176@birch.djwong.org>
 <20140411004649.GA4817@kmo>
 <20140411014135.GA18933@birch.djwong.org>
 <20140412023101.GC9176@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19876 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055AbaDLCd3 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 11 Apr 2014 22:33:29 -0400
Content-Disposition: inline
In-Reply-To: <20140412023101.GC9176@birch.djwong.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-bcache@vger.kernel.org

Change bch_cached_dev_attach() to always wake up the writeback thread,
because the newly created wb thread remains in uninterruptible sleep
state until something explicitly wakes it up.  This wakeup allows the
thread to call bch_writeback_thread(), whereupon it will most likely
end up in interruptible sleep.  In theory we could just let the first
write take care of this, but there's really no reason not to do the
transition quickly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 drivers/md/bcache/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 24a3a15..3ffe970 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1048,8 +1048,8 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c)
 		bch_sectors_dirty_init(dc);
 		atomic_set(&dc->has_dirty, 1);
 		atomic_inc(&dc->count);
-		bch_writeback_queue(dc);
 	}
+	bch_writeback_queue(dc);
 
 	bch_cached_dev_run(dc);
 	bcache_device_link(&dc->disk, c, "bdev");
