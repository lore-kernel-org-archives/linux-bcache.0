From: Marc MERLIN <marc@merlins.org>
Subject: Re: echo dev > /sys/fs/bcache/register gives page allocation failure: order:4, mode:0x2040d0
Date: Mon, 15 Feb 2016 07:32:36 -0800
Message-ID: <20160215153236.GI4115@merlins.org>
References: <20160215060410.GA30802@merlins.org> <20160215121104.GA30514@kmo-pixel> <20160215060410.GA30802@merlins.org> <20160215120255.GE18134@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:49154 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbcBOPc5 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 15 Feb 2016 10:32:57 -0500
Content-Disposition: inline
In-Reply-To: <20160215121104.GA30514@kmo-pixel> <20160215120255.GE18134@c203.arch.suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

On Mon, Feb 15, 2016 at 01:02:55PM +0100, Johannes Thumshirn wrote:
> > So I did
> > make-bcache -B /dev/md5
> > echo /dev/md5 > /sys/fs/bcache/register
> > 
> > and it fails:
> > bash: page allocation failure: order:4, mode:0x2040d0
> 
> Is this system under some kind of memory preassure? Did this happen right
> after boot or when the system was already running for quite some time?
 
Uptime 17 days, it's a server that does a lot of I/O, but free shows I have
6GB available for buffer cache out of 8, so that shouldn't be too bad. Seems
like I'm hitting an issue with memory fragmentation or a specific kind of
memory not being available?
(but I don't have any other kernel processes complaining about memory
allocation failure, at least not consistently like here)

On Mon, Feb 15, 2016 at 03:11:04AM -0900, Kent Overstreet wrote:
> > and it fails:
> > bash: page allocation failure: order:4, mode:0x2040d0
> 
> You want CONFIG_COMPACTION=y

Good suggestion, but I already have it:
gargamel:~# grep CONFIG_COMPACTION /boot/config-4.3.3-amd64-i915-volpreempt-20150421
CONFIG_COMPACTION=y

Thanks for the replies,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
