From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: bcache crashes at boot time
Date: Thu, 22 Jun 2017 00:47:52 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1706220045190.17052@mail.ewheeler.net>
References: <CAE4BCM2DCZ5E29AbXmDwn8T3VBzUczLZa+CXkYVH_dZNrcqVeA@mail.gmail.com> <alpine.LRH.2.11.1706202158180.17052@mail.ewheeler.net> <87k245vbwp.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:41358 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750994AbdFVArx (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 21 Jun 2017 20:47:53 -0400
In-Reply-To: <87k245vbwp.fsf@esperi.org.uk>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: kent.overstreet@gmail.com
Cc: Igor Pavlenko <ipavlenko.mail@gmail.com>, Nix <nix@esperi.org.uk>, linux-bcache@vger.kernel.org

On Wed, 21 Jun 2017, Nix wrote:

> On 20 Jun 2017, Eric Wheeler uttered the following:
> 
> > On Mon, 5 Jun 2017, Igor Pavlenko wrote:
> >
> >> [   45.941155] bcache: register_bdev() registered backing device sda3
> >> [   46.138238] bcache: error on 471776aa-1b34-4eff-ba7d-509a9554b43d:
> >> inconsistent ptrs: mark = 3, level = 0, disabling caching
> >
> > ^^^
> >
> > This is the reason, something was inconsistent enough that it couldn't 
> > continue.  

Kent, do you know what this means in detail, and can you guess what might 
have caused it?

> I'm rather worried about this sort of thing, given that I got it after
> my first cache population and less than a week using bcache in anger.

Do you have a difference between `blockdev --getpbsz /dev/cache` vs 
/dev/bdev (or whatever your devices are named) ?

The physical blocksize must be the same as the cachedev IIRC.  If 4k, use 
-w 4k in make-bcache.  There's a thread somewhere discussing those 
details.  


--
Eric Wheeler


> 
> The system in question is an oldie that restarts by mounting as much as
> it can readonly and then doing a reboot (when bcache would routinely
> whine about timeouts): the things it manages to remount readonly does
> not usually include / is bcache usually unhappy about this sort of
> thing? Would it prefer it if I was able to unmount it properly? If so,
> it's time to upgrade that machine... it's only that I've had an oops
> before now when stopping bcaches (early in test, not preserved because I
> thought I'd made a mistake), so I thought it might be unhappy about
> *that*, as well.
> 
> -- 
> NULL && (void)
> 
