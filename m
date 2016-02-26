From: Marc MERLIN <marc@merlins.org>
Subject: Re: BUG: drivers/md/bcache/writeback.c:237
Date: Thu, 25 Feb 2016 16:17:13 -0800
Message-ID: <20160226001713.GC29543@merlins.org>
References: <alpine.LRH.2.11.1602240403300.32077@mail.ewheeler.net> <56C1F2A4.4090208@evilazrael.de> <20160224204530.GA13079@merlins.org> <CAC8teKUjvdyPM62UnwuFsXMoa74LsnxAOwm7ioFb03-TyA=4ZA@mail.gmail.com> <20160225152053.GC15421@merlins.org> <alpine.LRH.2.11.1602252341070.3635@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:47605 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbcBZARQ (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 25 Feb 2016 19:17:16 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1602252341070.3635@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Zhu Yanhai <zhu.yanhai@gmail.com>, Christoph Nelles <evilazrael@evilazrael.de>, linux-bcache@vger.kernel.org

On Thu, Feb 25, 2016 at 11:44:01PM +0000, Eric Wheeler wrote:
> 
> On Thu, 25 Feb 2016, Marc MERLIN wrote:
> 
> > On Thu, Feb 25, 2016 at 06:18:03PM +0800, Zhu Yanhai wrote:
> > > Marc,
> > > When did you *first* see this BUG_ON? During boot up or far after the
> > > whole system is up?
> > 
> > I setup bcache, had it work a bit.
> > During shutdown, it crapped out when syncing/unmounting
> 
> Do you have more information about what crapped out on shutdown?  
>    Memory?
>    IO Error?
>    Just hung so the reset button was pushed?
 
Sadly, I didn't record that carefully. I remember a kernel traceback and
system hang, but that's about it.

> Was there a backtrace?

Yes, but not captured :(

> It might be a good idea to use netconsole and point it at a syslog 
> server to catch the whole backtrace.

Next time sure, but too late now, and no netconsole if the system crashes
before I can even bring the ethernet up.

> > After each subsequent boot, the system crashed as soon as the module loaded
> > and scanned my disks.
> 
> So just to clarify, the current BUG_ON discussed is happening at boot, and 
> is not the mid-shutdown error that first happened?

Correct. The only reason my system is booting right now is that I hid the
partition where the bcache cache is, so it doesn't get seen at boot.
If it's there, as soon as the kernel boots and bcache activates, it crashes.
I'm keeping it in case you want me to try a patch to see if it'll stop the
crashing at boot.

Hence my request for a way to turn off bcache as a kernel command line option 
to allow for recovery in such cases.

Sadly even if we don't have perfect state on how we got there, bad data
shouldn't cause bcache to crash the kernel at boot. It could refuse to make
the cache active, log an error, and move on.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
