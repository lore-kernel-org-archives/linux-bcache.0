From: =?iso-8859-1?Q?Phillipp_R=F6ll?= <phillipp.roell@trafficplex.de>
Subject: AW: AW: [PATCH] md/bcache: Fix a deadlock while calculating writeback
 rate
Date: Thu, 18 May 2017 18:52:26 +0000
Message-ID: <0924dae08c12467aa68f9c9e3bb434b5@EX2013-CAS2.de2.eu-rbx.webhod.com>
References: <20170507155222.19114-1-phillipp.roell@trafficplex.de>
 <alpine.LRH.2.11.1705091844180.19359@mail.ewheeler.net>
 <4e43a54e075047af9b2e3cf8a0452c1b@EX2013-CAS2.de2.eu-rbx.webhod.com>
 <alpine.LRH.2.11.1705121852580.19359@mail.ewheeler.net>
 <alpine.LRH.2.11.1705181704250.19359@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mxpool-ex2013.de-fra.webhod.com ([87.98.246.70]:58193 "EHLO
        delivery.hub1.de-fra.webhod.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754354AbdERTBd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 18 May 2017 15:01:33 -0400
In-Reply-To: <alpine.LRH.2.11.1705181704250.19359@mail.ewheeler.net>
Content-Language: de-DE
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>



> -----Ursprüngliche Nachricht-----
> Von: Eric Wheeler [mailto:bcache@lists.ewheeler.net]
> Gesendet: Donnerstag, 18. Mai 2017 19:05
> An: Phillipp Röll
> Cc: linux-bcache@vger.kernel.org
> Betreff: Re: AW: [PATCH] md/bcache: Fix a deadlock while calculating
> writeback rate
> 
> On Fri, 12 May 2017, Eric Wheeler wrote:
> 
> > On Wed, 10 May 2017, Phillipp Röll wrote:
> >
> > > Hi Eric,
> > >
> > > > Thank you for tracking this down!  Did you have an actual deadlock
> > > > case that this fixed?
> > >
> > > Yes. We had at least dozens, if not hundreds, of "kernel hung task"
> > > events followed by complete IO lockups on our production systems,
> > > with traces like
> > > this: https://paste42.de/059f78f7f9f27e9d88cd65fc02811e92/11749/
> > >
> > > Reproduction is actually pretty easy:
> > >
> > > - Setup bcache with SSD + HDD and LVM on top of the resulting bcache
> > > device
> > > - Create three LVs in the new cached VG
> > > - Start dd'ing from one of these LVs to another LV
> > > - Start fio with randrw on the third LV
> > > - Wait 5-10 minutes for the message to pop up and the system to lock
> > > up
> > >
> > > > I wonder: in the event of a race, can the updated P-factor be
> > > > invalid (ie, partially populated)? I don't believe 64-bit
> > > > assignments are atomic on all architectures (see
> > > > __update_writeback_rate) so you might get the upper or lower 32
> > > > bits of the P-factor or of other values assigned therein.  Could
> > > > the rate be calculated in such a race by the writeback thread such that
> no progress is made (eg, effectively rate==0)?
> > >
> > > That seems to be right, yes. I think I can add that spinlock. Would
> > > you say the spinlock should be used for the sysfs-info as well?
> >
> > Yes, anywhere it is used.  It might be a good idea to write a short
> > accessor function if there are lots of places that need to grab the lock.
> > Some kind of future-proofing would be a good idea to make it easy if
> > anyone else grabs the value and doesn't realize it needs to be locked.
> 
> Hi Phillipp,
> 
> Just checking in:
> 
> Will you have a spinlock version of the patch available soon?
> 
> -Eric
> 
> ps, be sure to Cc: linux-bcache@vger.kernel.org on your replies :)
> 

Hi Eric,
honestly I don't know. I haven't touched C in a decade and would have
to read up on documentation first, setup the dev ecosystem with
build and testing and I have no clue when I can spare a day or two
for that. Removing a lock is one thing, adding one is a different beast.

Plus, for our arch the problem is solved, it's just not upstream,
so the priority has gone from "critical" to "none". I wouldn't be
surprised if I couldn't work on this until after the summer, sorry.

- Phillipp

> >
> > --
> > Eric Wheeler
> >
> >
> >
> > >
> > > We're using amd64 only and had the patch tested with IO stress tests
> > > for
> > > 10 to 14 days and running in prod for 3 months now without issue.
> > > But that doesn't mean anything for the other architectures...
> > >
> > > Phillipp
> > >
> > > > > Signed-off-by: Phillipp Röll <phillipp.roell@trafficplex.de>
> > > > > ---
> > > > >  drivers/md/bcache/writeback.c | 4 ----
> > > > >  1 file changed, 4 deletions(-)
> > > > >
> > > > > diff --git a/drivers/md/bcache/writeback.c
> > > > b/drivers/md/bcache/writeback.c
> > > > > index 6ac2e48..90da3bd 100644
> > > > > --- a/drivers/md/bcache/writeback.c
> > > > > +++ b/drivers/md/bcache/writeback.c
> > > > > @@ -75,14 +75,10 @@ static void update_writeback_rate(struct
> > > > work_struct *work)
> > > > >  					     struct cached_dev,
> > > > >  					     writeback_rate_update);
> > > > >
> > > > > -	down_read(&dc->writeback_lock);
> > > > > -
> > > > >  	if (atomic_read(&dc->has_dirty) &&
> > > > >  	    dc->writeback_percent)
> > > > >  		__update_writeback_rate(dc);
> > > > >
> > > > > -	up_read(&dc->writeback_lock);
> > > > > -
> > > > >  	schedule_delayed_work(&dc->writeback_rate_update,
> > > > >  			      dc->writeback_rate_update_seconds *
> HZ);  }
> > > > > --
> > > > > 2.10.0
> > > > >
> > > > >
> > > > >
> > >
