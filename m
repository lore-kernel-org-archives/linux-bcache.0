From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: bcache_gc: BUG: soft lockup
Date: Wed, 11 May 2016 11:26:47 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1605111114190.22680@mx.ewheeler.net>
References: <6ee4d38a0d4cfffc288f0ee527ea7d14@rcube.hebserv.net> <20160129115444.GA30565@c203.arch.suse.de> <1448626993.2877.112.camel@suse.de> <2f979d1d6e991272cebc8ff40a955c8a@rcube.hebserv.net> <1447419912.2616.19.camel@suse.de> <1447418245.2616.15.camel@suse.de>
 <648d9a0567372b10a3861eee8320328c@rcube.hebserv.net> <7d53afb3c7a34bb1022f0d9b6c079022@rcube.hebserv.net> <9c96132d5fce4a5a77b1b086f7c6095d@rcube.hebserv.net> <594053ea9538352f4f3e01b954c6080d@rcube.hebserv.net> <alpine.LRH.2.11.1511291738340.5445@mail.ewheeler.net>
 <df4137dc888a7058b4b6a290613bf890@rcube.hebserv.net> <b91ce8156337b782c82317d25b3228bd@rcube.hebserv.net> <alpine.LRH.2.11.1605101750050.22680@mx.ewheeler.net> <20160511113310.Horde.RDd2DNU6iws5IFalOeBLL89@www3.nde.ag>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [66.155.3.69] ([66.155.3.69]:33707 "EHLO mx.ewheeler.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751692AbcEKS0i (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 11 May 2016 14:26:38 -0400
In-Reply-To: <20160511113310.Horde.RDd2DNU6iws5IFalOeBLL89@www3.nde.ag>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Cc: Eric Wheeler <bcache@lists.ewheeler.net>, Yannis Aribaud <bugs@d6bell.net>, Johannes Thumshirn <jthumshirn@suse.de>, linux-bcache@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>

On Wed, 11 May 2016, Jens-U. Mozdzen wrote:

> Hi *,
> 
> Zitat von Eric Wheeler <bcache@lists.ewheeler.net>:
> >On Mon, 2 May 2016, Yannis Aribaud wrote:
> >[...]
> >I think this is the first time I've heard of Ceph being used in a bcache
> >stack on the list.  Are there any others out there with success?  If so,
> >what kernel versions and disk stack configuration?
> 
> After an extensive test period, we have just started a productive Ceph
> environment on our bcache-based SAN servers:
> 
> - MD-RAID6 (several SAS disks) as bcache backing device
> - MD-RAID1 (two SAS SSDs) as bcache cache device, only for that single backing
> device
> - LVM on top of /dev/bcache0
> - LVs, xfs-formatted, mounted at a convenient place, used by OSDs

So no ceph here?  

If you're using 4.4.y then you definitely need the patch from Ming Lei.  
Read this (rather long) thread if you want the details:
  "block: make sure big bio is splitted into at most 256 bvecs"
This affects 4.3 and newer iirc.  

OTOH, 4.1 is rock solid.  As of 4.1.21 or so it has all of the bcache 
stability fixes to date.


> kernel on our SAN nodes is 4.1.13-5-default (64 bit), as distributed by
> OpenSUSE Leap 42.1 (SUSE makes sure vital bcache patches are included, amongst
> others).
> 
> We're planning to later switch to a similar setup like the OP is running,
> using separate disks with a common bcache caching device for OSDs.
> 
> While we have not stressed the Ceph part yet on the productive system (there's
> plenty of other data served by SCST/FC, NFS, SaMBa and others), we did not yet
> run into problems and especially no kernel crashes.
> 
> >[...]
> >Also, does your backing device(s) set raid_partial_stripes_expensive=1 in
> >queue_limits (eg, md raid5/6)?  I've seen bugs around that that might
> >not be fixed yet.
> 
> This does sound disturbing to me - could you please give more details,
> probably in a new thread?

Same as above I think.  When bcache writebacks in opt_io sized writes that 
exceed 256 bvecs then you run into issues.  It only does that if 
raid_partial_stripes_expensive=1 like raid5/6 when it tries to prevent 
re-writes to the same stride.  

--
Eric Wheeler


> 
> Regards,
> Jens
> 
