From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [ANNOUNCE] bcachefs!
Date: Fri, 17 Jul 2015 16:40:23 -0700
Message-ID: <20150717234023.GB4166@kmo-pixel>
References: <20150714005825.GA24027@kmo-pixel>
 <1436940689.6520.1.camel@hasee>
 <CAC7rs0sbg2ci6=niQ0X11AONZbr2AOYhRbxfDH_w4N4A7dyPLw@mail.gmail.com>
 <1436944556.6520.5.camel@hasee>
 <CAF1ivSa4bZaw2w9nu1tQeYx7JBb2_fVDV67Le=ybC2m8OdX3gg@mail.gmail.com>
 <20150717231700.GA4166@kmo-pixel>
 <1437176155.9009.0.camel@ssi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:35698 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbbGQXk1 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 17 Jul 2015 19:40:27 -0400
Received: by pactm7 with SMTP id tm7so68535781pac.2
        for <linux-bcache@vger.kernel.org>; Fri, 17 Jul 2015 16:40:27 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1437176155.9009.0.camel@ssi>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On Fri, Jul 17, 2015 at 04:35:55PM -0700, Ming Lin wrote:
> 
> On Fri, 2015-07-17 at 16:17 -0700, Kent Overstreet wrote:
> > On Wed, Jul 15, 2015 at 12:39:36AM -0700, Ming Lin wrote:
> > > On Wed, Jul 15, 2015 at 12:15 AM, Ming Lin <mlin@kernel.org> wrote:
> > > > On Tue, 2015-07-14 at 23:58 -0700, Kent Overstreet wrote:
> > > >> Can you strace it?
> > > >
> > > > Strange. Now error message changed.
> > > 
> > > I mean sometimes it showed:
> > > 
> > > mount: /dev/sdt already mounted or /mnt/ busy
> > 
> > I have no idea what's going on, it works for me - is there anything unusual
> > about your setup? what kind of block device is /dev/sdt? is there any chance
> > there's another process that has it open? maybe try rebooting?
> 
> It's a regular HDD. I tried rebooting several times.
> 
> Now I try in qemu-kvm. Only the first time it can be mounted.
> 
> On host: qemu-img create hdd1.img 20G
> On guest: it's /dev/vda
> 
> root@block:~# bcacheadm format -C /dev/vda 
> UUID:			4730ed95-4c57-42db-856c-dbce36085625
> Set UUID:		e69ef0e0-0344-40d7-a6b1-c23d14745a32
> version:		6
> nbuckets:		40960
> block_size:		1
> bucket_size:		1024
> nr_in_set:		1
> nr_this_dev:		0
> first_bucket:		3
> 
> root@block:~# mount -t bcache /dev/vda /mnt/
> 
> root@block:~# mount |grep bcache
> /dev/vda on /mnt type bcache (rw,relatime)
> 
> root@block:~# reboot
> 
> root@block:~# dmesg |grep -i bcache
> [    2.548754] bcache: bch_journal_replay() journal replay done, 1 keys in 1 entries, seq 3
> [    2.636217] bcache: register_cache() registered cache device vda
> 
> 
> root@block:~# mount -t bcache /dev/vda /mnt/
> mount: No such file or directory
> 
> Now dmesg shows:
> 
> bcache: bch_open_as_blockdevs() register_cache_set err device already registered

Ohhhh.

The cache set is getting registered by the udev hooks. We should be able to
mount it anyways - same as you can mount any other fs in multiple locations.

I won't be able to fix this for at least a couple days, but for now - just
shut it down it via sysfs (echo 1 > /sys/fs/bcache/<uuid>/stop), then mount it.
