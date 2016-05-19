From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: bcache_gc: BUG: soft lockup
Date: Thu, 19 May 2016 16:26:52 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1605191623370.22436@mx.ewheeler.net>
References: <alpine.LRH.2.11.1605101750050.22680@mx.ewheeler.net> <6ee4d38a0d4cfffc288f0ee527ea7d14@rcube.hebserv.net> <20160129115444.GA30565@c203.arch.suse.de> <1448626993.2877.112.camel@suse.de> <2f979d1d6e991272cebc8ff40a955c8a@rcube.hebserv.net>
 <1447419912.2616.19.camel@suse.de> <1447418245.2616.15.camel@suse.de> <648d9a0567372b10a3861eee8320328c@rcube.hebserv.net> <7d53afb3c7a34bb1022f0d9b6c079022@rcube.hebserv.net> <9c96132d5fce4a5a77b1b086f7c6095d@rcube.hebserv.net> <594053ea9538352f4f3e01b954c6080d@rcube.hebserv.net>
 <alpine.LRH.2.11.1511291738340.5445@mail.ewheeler.net> <df4137dc888a7058b4b6a290613bf890@rcube.hebserv.net> <b91ce8156337b782c82317d25b3228bd@rcube.hebserv.net> <7d0c5f9662d8cf10cea50e62b410198a@rcube.hebserv.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1595348259-625439907-1463700412=:22436"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [66.155.3.69] ([66.155.3.69]:45843 "EHLO mx.ewheeler.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755333AbcESX0k (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 19 May 2016 19:26:40 -0400
In-Reply-To: <7d0c5f9662d8cf10cea50e62b410198a@rcube.hebserv.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Yannis Aribaud <bugs@d6bell.net>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, linux-bcache@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1595348259-625439907-1463700412=:22436
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Mon, 16 May 2016, Yannis Aribaud wrote:

> Hi,
> 
> 
> 11 mai 2016 03:10 "Eric Wheeler" <bcache@lists.ewheeler.net> a écrit:
> > Can you describe your disk stack in more detail? What is below ceph?
> > 
> > I think this is the first time I've heard of Ceph being used in a bcache
> > stack on the list. Are there any others out there with success? If so,
> > what kernel versions and disk stack configuration?
> 
> I'm using one SSD as caching device (one cache set) and several SATA drives
>  as backing devices.
> No RAID, no MD, no LVM, nothing fancy, only bare devices and Bcache.
> 
> Bcache devices are XFS formatted and used by Ceph OSD (journaling on the same 
> device). One OSD per bcache device.
 
What bcache bucket size are you using?  Review this thread and see if it 
sounds similar:
  http://www.spinics.net/lists/linux-bcache/msg03796.html

I wonder if XFS is sending writes down that are too large as speculated 
in the thread above.


Please also try these two patches and see if they help:

  https://lkml.org/lkml/2016/4/5/1046

  http://www.spinics.net/lists/raid/msg51830.html

--
Eric Wheeler

> 
> > So you are using one cache for multiple backing devices in a single cache
> > set? I remember seeing a thread on the list about someone having a
> > similar issue (multiple backends, but not ceph). I put some time into
> > looking for the thread, it might be this one:
> > bcache: Fix writeback_thread never writing back incomplete stripes.
> > 
> > but there was a patch for that which should be in 4.4.y back in March.
> > 
> > Make sure you have this commit:
> > 
> > https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=a556b804dfa654f054f3
> > 304c2c4d274ffe81f92
> 
> My kernel already has this commit.
> 
> > Also, does your backing device(s) set raid_partial_stripes_expensive=1 in
> > queue_limits (eg, md raid5/6)? I've seen bugs around that flag that might
> > not be fixed yet.
> 
> Nope. This is set to 0.





--
Eric Wheeler



> 
> Regards,
> -- 
> Yannis Aribaud
> 
--1595348259-625439907-1463700412=:22436--
