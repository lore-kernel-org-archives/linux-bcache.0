From: Vojtech Pavlik <vojtech@suse.com>
Subject: [PATCH] bcache: Fix writeback_thread never writing back incomplete
 stripes.
Date: Sat, 5 Sep 2015 13:10:12 +0200
Message-ID: <20150905111012.GA17180@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jablonecka.jablonka.cz ([91.219.244.36]:56608 "EHLO
	jablonecka.jablonka.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbbIELKT (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sat, 5 Sep 2015 07:10:19 -0400
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>, Emmanuel Florac <eflorac@intellique.com>, Jiri Kosina <jkosina@suse.com>, Jens Axboe <axboe@kernel.dk>

Fix writeback_thread never finishing writing back all dirty data in bcache when
partial_stripes_expensive is set, and spinning, consuming 100% of CPU instead.

Signed-off-by: Vojtech Pavlik <vojtech@suse.com>
---

This is a fix for the current upstream bcache, not the devel branch.

If partial_stripes_expensive is set for a cache set, then writeback_thread
always attempts to write full stripes out back to the backing device first.
However, since it does that based on a bitmap and not a simple linear
search, like the rest of the code of refill_dirty(), it changes the
last_scanned pointer so that never points to 'end'. refill_dirty() then
never tries to scan from 'start', resulting in the writeback_thread
looping, consuming 100% of CPU, but never making progress in writing out
the incomplete dirty stripes in the cache.

Scanning the tree after not finding enough full stripes fixes the issue.

Incomplete dirty stripes are written to the backing device, the device
eventually reaches a clean state if there is nothing dirtying data and
writeback_thread sleeps. This also fixes the problem of the cache device
not being possible to detach in the partial_stripes_expensive scenario.

It may be more efficient to separate the last_scanned field for normal and
stripe scans instead.

 drivers/md/bcache/writeback.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index f1986bc..6f8b81d 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -382,6 +382,7 @@ static bool refill_dirty(struct cached_dev *dc)
 		refill_full_stripes(dc);
 		if (array_freelist_empty(&buf->freelist))
 			return false;
+		bch_refill_keybuf(dc->disk.c, buf, &end, dirty_pred);
 	}
 
 	if (bkey_cmp(&buf->last_scanned, &end) >= 0) {
-- 
2.1.4
