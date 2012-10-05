From: Kingsly John <member+bcache-4+VQVQEymQXR7s880joybQ@public.gmane.org>
Subject: Re: bcache, layered block devices and unclean shutdowns
Date: Fri, 5 Oct 2012 08:15:17 +0530
Message-ID: <20121005024517.GE17229@narnia.kingsly.net>
References: <20121004103625.GD17229@narnia.kingsly.net>
 <20121004195130.GB29494@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121004195130.GB29494-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

+++ Kent Overstreet [2012-10-04 12:51:30]:

> On Thu, Oct 04, 2012 at 04:06:25PM +0530, Kingsly John wrote:
> > Hi!
> > 
> > In the archives I found a thread from a few months ago where it was
> > recommended that it's best to use bcache on the RAID layer.(rather than the
> > disks themselves or LVM)
> > 
> > Wouldn't this affect bcache's ability to recover from an unclean shutdown?
> > ie, if the raid array itself can't be brought up, bcache wouldn't be able to
> > write caches to disk? (Or is that not a possibility)
> 
> Not sure what you're asking...

If /dev/md0 is the backing device, in the event of an unclean shutdown during
a write it would be dirty(at the raid level) and there would be a resync
etc. 

If the individual disks that make make up /dev/md0 were backing devices
instead, wouldn't bcache ensure that /dev/md0 would never end up dirty when
recovering from an unclean shutdown and eliminate the need for a forced
resync?

Is one better than the other in terms of maintaining data integrity or would
they both be equally reliable?

Kingsly

-- 
