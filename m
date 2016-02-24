From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: bcache and LVM --- works great.
Date: Wed, 24 Feb 2016 07:18:24 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1602240655380.32077@mail.ewheeler.net>
References: <87k2mgo2rz.fsf@vostro.rath.org> <87mvr9tddy.fsf@vostro.rath.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1641074820-1278092237-1456296964=:32077"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([71.19.153.34]:36721 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752047AbcBXHS2 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 24 Feb 2016 02:18:28 -0500
In-Reply-To: <87mvr9tddy.fsf@vostro.rath.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Nikolaus Rath <Nikolaus@rath.org>
Cc: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1641074820-1278092237-1456296964=:32077
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Tue, 9 Feb 2016, Nikolaus Rath wrote:
> On Feb 07 2016, Nikolaus Rath <Nikolaus@rath.org> wrote:
> > Hello,
> >
> > The internet claims that using bcache with LVM is not a good idea
> > (eg. on https://wiki.archlinux.org/index.php/Bcache )- but I wasn't able
> > to find any substantial information other than this general
> > recommendation.
> >
> > Is this still (or has ever been) correct? If so, what issues can arise?
> > And does this happen only when using bcache on top of an LVM LV, or also
> > when using a bcache device as an LVM PV?

We use bcache0 as the PV for our LVs and our caching device is actually an 
LV sliced from an SSD PV backed by hardware raid10 (Areca).  We have 
hot-detached the cache, lvresized it, re-make-bcache'd the cache, and 
re-attached it without needing a reboot (backing dev resizes can't be hot 
though---also not sure what would happen if we re-attached after resize 
without make-bcache'ing the cache).  We haven't tried making the backing 
device an LV, but the caching device works great as an LV.

With LVM on both top and bottom of our bcache stack we have been stable 
for a year with 100's of TBs written.  We burned out the Samsung 840's 
after about 150 TB written and replaced them hot.  Even though they 
started to stutter, no data lost and no issue.  In fact we replaced the 
aging SSDs without rebooting the hardware (and moved from raid1 to raid10 
at the same time).

> I now have the following stack:
> 
> btrfs on LUKS on LVM on bcache
> 
> The VG contains two bcache PVs with backing devices on different
> spinning disks, and a shared cache device on SSD. I'm using Kernel 4.3.

4.3 is missing the bcache stability patches, so be sure you have 
pulled them in.  (4.3 is EOL too, so change if you can.)

Be sure to cherry-pick these from linux 4.5-rc1:
        git cherry-pick 2ef9ccbf~1..627ccd20

or use one of the 4.1 or 3.18 longterm kernels.  4.1.17 is rock solid.  
Haven't tried 4.1.18 yet, but it has the stability patches now and I 
expect 4.1.18 will be a great kernel too.

> I'm super happy with the performance, boot times increased from 1:30
> minutes to X11 and 2:00 to Firefox to roughly 0:10 to X11 and 0:30 to
> Firefox.
> 
> Time will tell if it also keeps my data intact, but I hope btrfs would
> at least detect any corruption. 

Excellent!  

We have great success with bcache as well with possibly PB's of data 
written and well over a year of use. Our VM stack looks something like 
this:
   KVM{btrfs -> lvm -> virtio-scsi+unmap} -> 
	LV -> PV -> bcache0(writeback) -> 
		backing device: hardware raid5 (full blockdev)
		caching device: lvm->pv->(hardware raid10 ssd)
	  

-Eric
 
> 
> Best,
> -Nikolaus
> 
> (No Cc on replies please, I'm reading the list)
> -- 
> GPG encrypted emails preferred. Key id: 0xD113FCAC3C4E599F
> Fingerprint: ED31 791B 2C5C 1613 AF38 8B8A D113 FCAC 3C4E 599F
> 
>              »Time flies like an arrow, fruit flies like a Banana.«
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--1641074820-1278092237-1456296964=:32077--
