From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PATCH] bcache: Fix writeback_thread never writing back
 incomplete stripes.
Date: Wed, 16 Sep 2015 03:32:06 -0800
Message-ID: <20150916113206.GA16164@kmo-pixel>
References: <20150905111012.GA17180@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:32913 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbbIPLcL (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 16 Sep 2015 07:32:11 -0400
Content-Disposition: inline
In-Reply-To: <20150905111012.GA17180@suse.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Vojtech Pavlik <vojtech@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>, Emmanuel Florac <eflorac@intellique.com>, Jiri Kosina <jkosina@suse.com>, Jens Axboe <axboe@kernel.dk>

On Sat, Sep 05, 2015 at 01:10:12PM +0200, Vojtech Pavlik wrote:
> Fix writeback_thread never finishing writing back all dirty data in bcache when
> partial_stripes_expensive is set, and spinning, consuming 100% of CPU instead.
> 
> Signed-off-by: Vojtech Pavlik <vojtech@suse.com>
> ---
> 
> This is a fix for the current upstream bcache, not the devel branch.
> 
> If partial_stripes_expensive is set for a cache set, then writeback_thread
> always attempts to write full stripes out back to the backing device first.
> However, since it does that based on a bitmap and not a simple linear
> search, like the rest of the code of refill_dirty(), it changes the
> last_scanned pointer so that never points to 'end'. refill_dirty() then
> never tries to scan from 'start', resulting in the writeback_thread
> looping, consuming 100% of CPU, but never making progress in writing out
> the incomplete dirty stripes in the cache.
> 
> Scanning the tree after not finding enough full stripes fixes the issue.
> 
> Incomplete dirty stripes are written to the backing device, the device
> eventually reaches a clean state if there is nothing dirtying data and
> writeback_thread sleeps. This also fixes the problem of the cache device
> not being possible to detach in the partial_stripes_expensive scenario.

Good catch!

> It may be more efficient to separate the last_scanned field for normal and
> stripe scans instead.

Actually, I think I like your approach - I think it gives us the behaviour we
want, although it took some thinking to figure out why.

One of the reasons for last_scanned is just to do writeback in LBA order and
avoid making the disks seek around - so, if refill_full_stripes() did just queue
up some IO at last_scanned, we do want to keep scanning from that position for
non full stripes.

But since (as you noted) last_scanned is never going to be >= end after calling
refill_full_strips() (if there were any full stripes) - really the correct thing
to do is loop around to the start if necessary so that we can successfully scan
everything.

The only inefficiency I see with your approach is that on the second scan, after
we've looped, we don't need to scan to the end of the disk - we only need to
scan up to where we initially started.

But, another observation - if we change refill_dirty() so that it always scans
the entire keyspace if necessary, regardless of where last_scanned was - well,
that really isn't specific to the refill_full_stripes() case - we can just
always do that.

Can you give this patch a try?

-- >8 --
Subject: [PATCH] bcache: Change refill_dirty() to always scan entire disk if necessary

Previously, it would only scan the entire disk if it was starting from the very
start of the disk - i.e. if the previous scan got to the end.

This was broken by refill_full_stripes(), which updates last_scanned so that
refill_dirty was never triggering the searched_from_start path.

But if we change refill_dirty() to always scan the entire disk if necessary,
regardless of what last_scanned was, the code gets cleaner and we fix that bug
too.

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
---
 drivers/md/bcache/writeback.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index cdde0f32f0..08a52db38b 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -359,11 +359,13 @@ next:
 	}
 }
 
+/*
+ * Returns true if we scanned the entire disk
+ */
 static bool refill_dirty(struct cached_dev *dc)
 {
 	struct keybuf *buf = &dc->writeback_keys;
-	struct bkey end = KEY(dc->disk.id, MAX_KEY_OFFSET, 0);
-	bool searched_from_start = false;
+	struct bkey start_pos, end = KEY(dc->disk.id, MAX_KEY_OFFSET, 0);
 
 	if (dc->partial_stripes_expensive) {
 		refill_full_stripes(dc);
@@ -371,14 +373,20 @@ static bool refill_dirty(struct cached_dev *dc)
 			return false;
 	}
 
-	if (bkey_cmp(&buf->last_scanned, &end) >= 0) {
-		buf->last_scanned = KEY(dc->disk.id, 0, 0);
-		searched_from_start = true;
-	}
-
+	start_pos = buf->last_scanned;
 	bch_refill_keybuf(dc->disk.c, buf, &end, dirty_pred);
 
-	return bkey_cmp(&buf->last_scanned, &end) >= 0 && searched_from_start;
+	if (bkey_cmp(&buf->last_scanned, &end) < 0)
+		return false;
+
+	/*
+	 * If we get to the end start scanning again from the beginning, and
+	 * only scan up to where we initially started scanning from:
+	 */
+	buf->last_scanned = KEY(dc->disk.id, 0, 0);
+	bch_refill_keybuf(dc->disk.c, buf, &start_pos, dirty_pred);
+
+	return bkey_cmp(&buf->last_scanned, &start_pos) >= 0;
 }
 
 static void bch_writeback(struct cached_dev *dc)
-- 
2.5.1
