From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [ANNOUNCE] bcachefs!
Date: Fri, 17 Jul 2015 19:10:07 -0700
Message-ID: <20150718021007.GA3196@kmo-pixel>
References: <1436940689.6520.1.camel@hasee>
 <CAC7rs0sbg2ci6=niQ0X11AONZbr2AOYhRbxfDH_w4N4A7dyPLw@mail.gmail.com>
 <1436944556.6520.5.camel@hasee>
 <CAF1ivSa4bZaw2w9nu1tQeYx7JBb2_fVDV67Le=ybC2m8OdX3gg@mail.gmail.com>
 <20150717231700.GA4166@kmo-pixel>
 <1437176155.9009.0.camel@ssi>
 <20150717234023.GB4166@kmo-pixel>
 <1437176911.9298.0.camel@ssi>
 <20150717235133.GC4166@kmo-pixel>
 <1437177497.9298.3.camel@ssi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:32821 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbbGRCKL (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 17 Jul 2015 22:10:11 -0400
Received: by pdbqm3 with SMTP id qm3so70163579pdb.0
        for <linux-bcache@vger.kernel.org>; Fri, 17 Jul 2015 19:10:11 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1437177497.9298.3.camel@ssi>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On Fri, Jul 17, 2015 at 04:58:17PM -0700, Ming Lin wrote:
> On Fri, 2015-07-17 at 16:51 -0700, Kent Overstreet wrote:
> > On Fri, Jul 17, 2015 at 04:48:31PM -0700, Ming Lin wrote:
> > > 
> > > On Fri, 2015-07-17 at 16:40 -0700, Kent Overstreet wrote:
> > > > On Fri, Jul 17, 2015 at 04:35:55PM -0700, Ming Lin wrote:
> > > > > 
> > > > > On Fri, 2015-07-17 at 16:17 -0700, Kent Overstreet wrote:
> > > > > > On Wed, Jul 15, 2015 at 12:39:36AM -0700, Ming Lin wrote:
> > > > > > > On Wed, Jul 15, 2015 at 12:15 AM, Ming Lin <mlin@kernel.org> wrote:
> > > > > > > > On Tue, 2015-07-14 at 23:58 -0700, Kent Overstreet wrote:
> > > > > > > >> Can you strace it?
> > > > > > > >
> > > > > > > > Strange. Now error message changed.
> > > > > > > 
> > > > > > > I mean sometimes it showed:
> > > > > > > 
> > > > > > > mount: /dev/sdt already mounted or /mnt/ busy
> > > > > > 
> > > > > > I have no idea what's going on, it works for me - is there anything unusual
> > > > > > about your setup? what kind of block device is /dev/sdt? is there any chance
> > > > > > there's another process that has it open? maybe try rebooting?
> > > > > 
> > > > > It's a regular HDD. I tried rebooting several times.
> > > > > 
> > > > > Now I try in qemu-kvm. Only the first time it can be mounted.
> > > > > 
> > > > > On host: qemu-img create hdd1.img 20G
> > > > > On guest: it's /dev/vda
> > > > > 
> > > > > root@block:~# bcacheadm format -C /dev/vda 
> > > > > UUID:			4730ed95-4c57-42db-856c-dbce36085625
> > > > > Set UUID:		e69ef0e0-0344-40d7-a6b1-c23d14745a32
> > > > > version:		6
> > > > > nbuckets:		40960
> > > > > block_size:		1
> > > > > bucket_size:		1024
> > > > > nr_in_set:		1
> > > > > nr_this_dev:		0
> > > > > first_bucket:		3
> > > > > 
> > > > > root@block:~# mount -t bcache /dev/vda /mnt/
> > > > > 
> > > > > root@block:~# mount |grep bcache
> > > > > /dev/vda on /mnt type bcache (rw,relatime)
> > > > > 
> > > > > root@block:~# reboot
> > > > > 
> > > > > root@block:~# dmesg |grep -i bcache
> > > > > [    2.548754] bcache: bch_journal_replay() journal replay done, 1 keys in 1 entries, seq 3
> > > > > [    2.636217] bcache: register_cache() registered cache device vda
> > > > > 
> > > > > 
> > > > > root@block:~# mount -t bcache /dev/vda /mnt/
> > > > > mount: No such file or directory
> > > > > 
> > > > > Now dmesg shows:
> > > > > 
> > > > > bcache: bch_open_as_blockdevs() register_cache_set err device already registered
> > > > 
> > > > Ohhhh.
> > > > 
> > > > The cache set is getting registered by the udev hooks. We should be able to
> > > > mount it anyways - same as you can mount any other fs in multiple locations.
> > > > 
> > > > I won't be able to fix this for at least a couple days, but for now - just
> > > > shut it down it via sysfs (echo 1 > /sys/fs/bcache/<uuid>/stop), then mount it.
> > > 
> > > It works!
> > > Any hint how to fix it? On udev or bcache-tool or kernel?
> > > I'd like to fix it.
> > 
> > The relevant code is in drivers/md/bcache/fs.c, bch_mount() ->
> > bch_open_as_blockdevs().
> > 
> > Part of the problem is that bcachefs isn't able to use much of the normal
> > generic mount path for block devices, partly because a fs can span multiple
> > block devices (same as btrfs).
> > 
> > I'm not sure the right way to fix it - it's going to take some thought, but
> > we want to do something like "is it already open? just take a ref on the
> > existing cache set".
> 
> I'll look into it.

Thanks

> And, echo 1 > /sys/fs/bcache/<uuid>/stop, got below.
> I'll also try to fix it.
> 
> [   25.826280] ======================================================
> [   25.828038] [ INFO: possible circular locking dependency detected ]
> [   25.828587] 4.1.0-00943-g3683e624 #7 Not tainted

I think the correct fix is to change cache_set_flush() to not hold register_lock
while it's calling into the sysfs code. Want to do that, and add a comment so it
doesn't get screwed up again? Also try and make sure we don't actually need
register_lock for what you take out from under it.

BTW - probably the most valuable thing you could help out with is the
documentation, in particular the guide:
http://bcache.evilpiepirate.org/BcacheGuide/

Can you read through (at least some of) that, and tell me what's useful and what
needs clarifying? And tell me what you'd like to see added to the guide next -
I'll try and work on documentation over the next two weeks, since I probably
won't be able to do much real coding with my test machines offline.
