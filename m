From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [PATCH] md/bcache: Fix a deadlock while calculating writeback
 rate
Date: Tue, 9 May 2017 18:53:16 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1705091844180.19359@mail.ewheeler.net>
References: <20170507155222.19114-1-phillipp.roell@trafficplex.de>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1641074820-1891078090-1494355468=:19359"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:54060 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753731AbdEISxW (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 9 May 2017 14:53:22 -0400
In-Reply-To: <20170507155222.19114-1-phillipp.roell@trafficplex.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: =?ISO-8859-15?Q?Phillipp_R=F6ll?= <phillipp.roell@trafficplex.de>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1641074820-1891078090-1494355468=:19359
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Sun, 7 May 2017, Phillipp Röll wrote:
> A bcache foreground write holds a read lock on the writeback_lock
> rwsem. In order to complete and release the lock after the actual
> write, it needs to update the index, which runs out of a workqueue.
> 
> If the bch_writeback_thread is starting to write back dirty data while
> the foreground write still holds the lock, it tries to get a write
> lock on the writeback lock, thus blocking until the foreground write
> completes.
> 
> If at this moment a workqueue worker starts an update of the write-
> back rate, while foreground write completions are queued behind it,
> the update thread will try to get a read lock, which blocks, because
> the writeback thread is trying to get a write lock. This blocks the
> foreground writes behind it and locks up all writeback and foreground
> writes.
> 
> Removing the read lock from the writeback rate update thread is the
> simplest solution: the worst thing that will happen when the scan
> for dirty data is inconsistent is a wrong P-factor in the PID controller.

Hi Phillipp,

Thank you for tracking this down!  Did you have an actual deadlock case 
that this fixed?


I wonder: in the event of a race, can the updated P-factor be invalid (ie, 
partially populated)? I don't believe 64-bit assignments are atomic on all 
architectures (see __update_writeback_rate) so you might get the upper or 
lower 32 bits of the P-factor or of other values assigned therein.  Could 
the rate be calculated in such a race by the writeback thread such that no 
progress is made (eg, effectively rate==0)?

I certainly want to see deadlocks fixed and thought this could be a 
consideration.  Worst case we could put a spinlock around the use of the 
dc->writeback_rate* fields.

What do you think?

--
Eric Wheeler

> 
> Signed-off-by: Phillipp Röll <phillipp.roell@trafficplex.de>
> ---
>  drivers/md/bcache/writeback.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index 6ac2e48..90da3bd 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -75,14 +75,10 @@ static void update_writeback_rate(struct work_struct *work)
>  					     struct cached_dev,
>  					     writeback_rate_update);
>  
> -	down_read(&dc->writeback_lock);
> -
>  	if (atomic_read(&dc->has_dirty) &&
>  	    dc->writeback_percent)
>  		__update_writeback_rate(dc);
>  
> -	up_read(&dc->writeback_lock);
> -
>  	schedule_delayed_work(&dc->writeback_rate_update,
>  			      dc->writeback_rate_update_seconds * HZ);
>  }
> -- 
> 2.10.0
> 
> 
> 
--1641074820-1891078090-1494355468=:19359--
