From: "Stephen R. van den Berg" <srb@cuci.nl>
Subject: patch (Re: 3.18.3 + latest bcache-dev)
Date: Thu, 22 Jan 2015 13:33:32 +0100
Message-ID: <20150122123332.GA23810@cuci.nl>
References: <20150121012424.GB5533@cuci.nl>
 <CALJ65znLYCJaN2fHx0-7P8RQHPUVkaBpw=ckt0_tQjznth35rw@mail.gmail.com>
 <20150121110400.GA14729@cuci.nl>
 <20150121164553.GA15237@cuci.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from aristoteles.cuci.nl ([212.125.128.18]:59844 "EHLO
	aristoteles.cuci.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbbAVMde (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 22 Jan 2015 07:33:34 -0500
Content-Disposition: inline
In-Reply-To: <20150121164553.GA15237@cuci.nl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Stephen R. van den Berg wrote:
>What I notice are:
>- The 100% CPU usage for four bcache_writebac processes is back.  I've
>  already tried raising the value you suggested from 30 to 60, but I did
>  not have an opportunity to reboot yet.  Will report back on this.

What I saw:
a. After running several hours, copying roughly 3.0TB through the two
   SSD caching devices onto the BTRFS backing device consisting of
   four HDDs, the bcache_writebac processes were still eating 100% CPU each.
b. Then did a manual umount of the fs, then stopped the bcache device
   through the proc filesystem.
c. Rebooted.
d. Came back in a patched kernel, 100% CPU usage is gone.

The patch I used (I did not investigate the correctness of the value
picked, I simply doubled it as an initial guess):

commit 2abecdbd214c94741012de32759bb0de4c6adbf9
Author: Stephen R. van den Berg <srb@cuci.nl>
Date:   Tue Jan 13 23:24:52 2015 +0100

    Increase btree_scan_ratelimit to avoid 100% CPU hogging.

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 653419b..5fff8ad 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -867,7 +867,7 @@ static struct cache_set *bch_cache_set_alloc(struct cache *ca)
 	c->error_limit	= 16 << IO_ERROR_SHIFT;
 
 	c->tiering_percent = 10;
-	c->btree_scan_ratelimit = 30;
+	c->btree_scan_ratelimit = 60;
 
 	c->copy_gc_enabled = 1;
 	c->tiering_enabled = 1;
-- 
Stephen.
