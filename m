From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: bcache_gc: BUG: soft lockup
Date: Tue, 10 May 2016 18:11:02 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1605101750050.22680@mx.ewheeler.net>
References: <6ee4d38a0d4cfffc288f0ee527ea7d14@rcube.hebserv.net> <20160129115444.GA30565@c203.arch.suse.de> <1448626993.2877.112.camel@suse.de> <2f979d1d6e991272cebc8ff40a955c8a@rcube.hebserv.net> <1447419912.2616.19.camel@suse.de> <1447418245.2616.15.camel@suse.de>
 <648d9a0567372b10a3861eee8320328c@rcube.hebserv.net> <7d53afb3c7a34bb1022f0d9b6c079022@rcube.hebserv.net> <9c96132d5fce4a5a77b1b086f7c6095d@rcube.hebserv.net> <594053ea9538352f4f3e01b954c6080d@rcube.hebserv.net> <alpine.LRH.2.11.1511291738340.5445@mail.ewheeler.net>
 <df4137dc888a7058b4b6a290613bf890@rcube.hebserv.net> <b91ce8156337b782c82317d25b3228bd@rcube.hebserv.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [66.155.3.69] ([66.155.3.69]:57070 "EHLO mx.ewheeler.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbcEKBK4 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 10 May 2016 21:10:56 -0400
In-Reply-To: <b91ce8156337b782c82317d25b3228bd@rcube.hebserv.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Yannis Aribaud <bugs@d6bell.net>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, linux-bcache@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>

On Mon, 2 May 2016, Yannis Aribaud wrote:

> Hi evryone,
> 
> Once again I got a crash on one of my servers running Bcache.
> This time the server is running a vanilla 4.4.7 kernel.
> 
> I'm using one SSD as cache for multiple devices (Ceph OSD devices) and got this:
> I joint to this email an extensive dmesg output.

Can you describe your disk stack in more detail?  What is below ceph?

I think this is the first time I've heard of Ceph being used in a bcache 
stack on the list.  Are there any others out there with success?  If so, 
what kernel versions and disk stack configuration?

So you are using one cache for multiple backing devices in a single cache 
set?  I remember seeing a thread on the list about someone having a 
similar issue (multiple backends, but not ceph).  I put some time into 
looking for the thread, it might be this one:  
  bcache: Fix writeback_thread never writing back incomplete stripes. 

but there was a patch for that which should be in 4.4.y back in March.    

Make sure you have this commit: 
  
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=a556b804dfa654f054f3d304c2c4d274ffe81f92

Also, does your backing device(s) set raid_partial_stripes_expensive=1 in 
queue_limits (eg, md raid5/6)?  I've seen bugs around that flag that might 
not be fixed yet.

--
Eric Wheeler


> 
> PS: This server isn't the same hardware as my previous bcache issues.
> 
> If any of you has an idea...
> 
> Best regards,
> -- 
> Yannis Aribaud
> 
