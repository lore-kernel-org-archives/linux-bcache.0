From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Reasoning of exposing queue/rotational=0
Date: Wed, 10 May 2017 22:18:55 +0200
Message-ID: <20170510221855.181f621f@jupiter.sol.kaishome.de>
References: <20170504232457.13c269c0@jupiter.sol.kaishome.de>
        <f99de33e-f90e-1492-7561-5a63d6814a9e@coly.li>
        <20170505174438.GA22811@suse.com>
        <20170505202317.68bdbc20@jupiter.sol.kaishome.de>
        <20170505190231.GA31457@suse.com>
        <20170505211434.665c00f8@jupiter.sol.kaishome.de>
        <alpine.LRH.2.11.1705091804420.19359@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:54123 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1754336AbdEJUTH (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 10 May 2017 16:19:07 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <glbd-linux-bcache@m.gmane.org>)
        id 1d8Y4Z-00062a-Ed
        for linux-bcache@vger.kernel.org; Wed, 10 May 2017 22:18:59 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Am Tue, 9 May 2017 18:11:06 +0000 (UTC)
schrieb Eric Wheeler <bcache@lists.ewheeler.net>:

> On Fri, 5 May 2017, Kai Krakow wrote:
> 
> > Am Fri, 5 May 2017 21:02:31 +0200
> > schrieb Vojtech Pavlik <vojtech@suse.com>:
> >   
> > > On Fri, May 05, 2017 at 08:23:17PM +0200, Kai Krakow wrote:  
>  [...]  
>  [...]  
> > > 
> > > Originally, rotational=1 is just a flag coming from the
> > > IDE/SCSI/SATA/etc. layers to the OS telling it whether the device
> > > is spinning or not. Without any specific implications as to the
> > > behavior of the device.
> > > 
> > > It is writable for a reason - not even all flash based devices
> > > report the flag correctly at the hardware level.
> > > 
> > > Linux uses the flag on the block device (queue) to tell whether
> > > seeks are very expensive compared to linear reads and whether it
> > > makes sense to spend large amounts CPU cycles and memory on
> > > reordering.
> > > 
> > > Btrfs is one user that tries to change the allocation policy and
> > > thus the likelihood of fragmentation and/or long seeks based on
> > > whether the device reports 'rotational'.
> > > 
> > > However, it actually has three modes at the fs level: 'nossd',
> > > 'ssd' and 'ssd_spread', with the last being faster on cheaper
> > > SSDs. There are large differences even between individual SSD
> > > profiles. Again, for a good reason, btrfs has these as mount
> > > options that override any 'rotational' hint.
> > > 
> > > All in all, if you want all the performance available, you need
> > > to see what works best for your workload.
> > > 
> > > The same applies to i/o schedulers. They're much less dependent
> > > on the underlying device than the workload put on them.
> > > 
> > > This is not the first time the question comes up.  
> > 
> > I tried to look up information about it previously but didn't came
> > up with useful results.
> >   
>  [...]  
> > > 
> > > A bcache device performance profile is neither one of a rotational
> > > device, nor one of a SSD.
> > > 
> > > Sequential reads may be bypassed or not. If not, some parts of it
> > > may be cached, in which case there will be seeks on the backing
> > > device even when there should be none on a real rotational device.
> > > 
> > > Random reads may be fast if they're hitting cached locations.
> > > 
> > > Random and sequential writes will be always cached if writeback is
> > > enabled and so there is no point in spending CPU cycles on
> > > optimizing writes.
> > > 
> > > How much the bcache device will behave like the backing device
> > > and how much like the caching device does depend mainly on the
> > > workload and the size of its working set compared to the size of
> > > the cache.
> > > 
> > > I do not believe that the choice of rotational=0 was arbitrary or
> > > a default. It's simply that bcache changes the access pattern to
> > > both the caching and backing device so much that it no longer
> > > resembles a rotational device's performance profile in any case.
> > >   
>  [...]  
> > 
> > Okay, that answers my questions. Thanks. :-)
> > 
> > But that only tells me that a "default" cannot be really chosen.
> > Both make sense.
> > 
> > I wonder if Linux chose to call the flag "non_rotational", would it
> > also default to 0 in bcache? I think nobody would know. ;-)
> > 
> > For me it looks like sticking that to rotational=1 gives overall
> > better long-time performance and btrfs filesystem layout.
> > 
> > Anyone who stumbles across this should judge on his own based on
> > Vojtech's good answer.  
> 
> Indeed!
> 
> Also note:
> 
> # cat /sys/block/bcache0/queue/scheduler 
> none

Yes, I know that.

> There is no scheduler for bcache, so the bio's pass through whatever
> your backing (cache) device uses as a queue scheduler, which could
> differ between cache/backing.

What does this exactly mean? I understand that depending on where the
bio ends up, I'm using two different IO schedulers.

At least this is how I currently set things up: I use different
scheduler (or different scheduler settings) to exploit exactly that
behavior.

> If you use hardware RAID, your
> 'rotational' flag is probably wrong for SSDs so set it on boot
> somehow (udev, etc.)

No hardware RAID involved here... Just three plain disks and one SSD.

I'm currently using udev to force it "1" for the bcache compound device
(which is what I guess the filesystem is seeing). The underlying bdev
and cdev still have their original rotational flag set, I didn't touch
it.


-- 
Regards,
Kai

Replies to list-only preferred.
