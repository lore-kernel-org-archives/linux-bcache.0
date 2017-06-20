From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: =?ISO-8859-15?Q?Re=3A_Re=3A_Bug=3A_bcache=A0get_stucked?=
Date: Tue, 20 Jun 2017 21:29:54 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1706202127460.17052@mail.ewheeler.net>
References: 201706150944349331667@zte.com.cn,alpine.LRH.2.11.1706151925060.14877@mail.ewheeler.net <201706161033522392579@zte.com.cn>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1641074820-797641274-1497994194=:17052"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:43854 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752310AbdFTV34 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 20 Jun 2017 17:29:56 -0400
In-Reply-To: <201706161033522392579@zte.com.cn>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: i@coly.li, kent.overstreet@gmail.com, linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1641074820-797641274-1497994194=:17052
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 16 Jun 2017, tang.junhui@zte.com.cn wrote:

> 
> Hello Eric
> 
> 
> > 3.10 is pretty old...  I'm not sure what to suggest.  Is there a 
> > writeback-gc race?
> 
> This issue also exists in new version(such as 4.10 branch),
> 
> When we test in the high branch, this problem is more easily to appear,
> 
> so I am sure this bug still exists in bcache current code.

Hi Tang,

Try the patch below and see if that solves the problem.

Also, see this thread:

https://www.spinics.net/lists/linux-bcache/msg04620.html

--
Eric Wheeler



-------- Forwarded Message --------
Subject: 	[PATCH] md/bcache: Fix a deadlock while calculating writeback rate
Date: 	Sun, 7 May 2017 17:52:22 +0200
From: 	Phillipp Röll <phillipp.roell@trafficplex.de>
To: 	bcache@lists.ewheeler.net
CC: 	Phillipp Röll <phillipp.roell@trafficplex.de>


A bcache foreground write holds a read lock on the writeback_lock
rwsem. In order to complete and release the lock after the actual
write, it needs to update the index, which runs out of a workqueue.

If the bch_writeback_thread is starting to write back dirty data while
the foreground write still holds the lock, it tries to get a write
lock on the writeback lock, thus blocking until the foreground write
completes.

If at this moment a workqueue worker starts an update of the write-
back rate, while foreground write completions are queued behind it,
the update thread will try to get a read lock, which blocks, because
the writeback thread is trying to get a write lock. This blocks the
foreground writes behind it and locks up all writeback and foreground
writes.

Removing the read lock from the writeback rate update thread is the
simplest solution: the worst thing that will happen when the scan
for dirty data is inconsistent is a wrong P-factor in the PID controller.

Signed-off-by: Phillipp Röll <phillipp.roell@trafficplex.de>
---
 drivers/md/bcache/writeback.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 6ac2e48..90da3bd 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -75,14 +75,10 @@ static void update_writeback_rate(struct work_struct *work)
 					     struct cached_dev,
 					     writeback_rate_update);
 
-	down_read(&dc->writeback_lock);
-
 	if (atomic_read(&dc->has_dirty) &&
 	    dc->writeback_percent)
 		__update_writeback_rate(dc);
 
-	up_read(&dc->writeback_lock);
-
 	schedule_delayed_work(&dc->writeback_rate_update,
 			      dc->writeback_rate_update_seconds * HZ);
 }
-- 
2.10.0



--1641074820-797641274-1497994194=:17052--
