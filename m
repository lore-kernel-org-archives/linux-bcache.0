From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: BUG: drivers/md/bcache/writeback.c:237
Date: Thu, 25 Feb 2016 23:44:01 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1602252341070.3635@mail.ewheeler.net>
References: <alpine.LRH.2.11.1602240403300.32077@mail.ewheeler.net> <56C1F2A4.4090208@evilazrael.de> <20160224204530.GA13079@merlins.org> <CAC8teKUjvdyPM62UnwuFsXMoa74LsnxAOwm7ioFb03-TyA=4ZA@mail.gmail.com> <20160225152053.GC15421@merlins.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([71.19.153.34]:40470 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751959AbcBYXoE (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 25 Feb 2016 18:44:04 -0500
In-Reply-To: <20160225152053.GC15421@merlins.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: Zhu Yanhai <zhu.yanhai@gmail.com>, Christoph Nelles <evilazrael@evilazrael.de>, linux-bcache@vger.kernel.org


On Thu, 25 Feb 2016, Marc MERLIN wrote:

> On Thu, Feb 25, 2016 at 06:18:03PM +0800, Zhu Yanhai wrote:
> > Marc,
> > When did you *first* see this BUG_ON? During boot up or far after the
> > whole system is up?
> 
> I setup bcache, had it work a bit.
> During shutdown, it crapped out when syncing/unmounting

Do you have more information about what crapped out on shutdown?  
   Memory?
   IO Error?
   Just hung so the reset button was pushed?

Was there a backtrace?

It might be a good idea to use netconsole and point it at a syslog 
server to catch the whole backtrace.

> After each subsequent boot, the system crashed as soon as the module loaded
> and scanned my disks.

So just to clarify, the current BUG_ON discussed is happening at boot, and 
is not the mid-shutdown error that first happened?

-Eric

> 
> While I understand I did hit a bug, I've been on a cruisade to get BUG_ON
> removed from btrfs code and replaced with warns/abort/remount read only.
> On a production system, BUG_ON really sucks, especially if it happens as
> soon as the kernel loads and before you can even do anything to fix the
> issue :)
> 
> If there is any chance this can be changed into some kind of abort that
> disables bcache or just prevents bcache from making damaging writes to the
> backing device, by simply disabling the cache, that would be much better :)
> 
> In the meantime, I've stopped using writeback since it seems that it's been
> the reason why I hit this problem.
> 
> Thanks,
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/  
> 
