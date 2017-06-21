From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: bcache crashes at boot time
Date: Wed, 21 Jun 2017 19:10:35 +0200
Message-ID: <20170621191035.5995b87c@jupiter.sol.kaishome.de>
References: <CAE4BCM2DCZ5E29AbXmDwn8T3VBzUczLZa+CXkYVH_dZNrcqVeA@mail.gmail.com>
        <alpine.LRH.2.11.1706202158180.17052@mail.ewheeler.net>
        <87k245vbwp.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:37355 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751126AbdFURLu (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 21 Jun 2017 13:11:50 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <glbd-linux-bcache@m.gmane.org>)
        id 1dNjAM-0008U0-Jf
        for linux-bcache@vger.kernel.org; Wed, 21 Jun 2017 19:11:42 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Am Wed, 21 Jun 2017 12:05:26 +0100
schrieb Nix <nix@esperi.org.uk>:

> On 20 Jun 2017, Eric Wheeler uttered the following:
> 
> > On Mon, 5 Jun 2017, Igor Pavlenko wrote:
> >  
> >> [   45.941155] bcache: register_bdev() registered backing device
> >> sda3 [   46.138238] bcache: error on
> >> 471776aa-1b34-4eff-ba7d-509a9554b43d: inconsistent ptrs: mark = 3,
> >> level = 0, disabling caching  
> >
> > ^^^
> >
> > This is the reason, something was inconsistent enough that it
> > couldn't continue.    
> 
> I'm rather worried about this sort of thing, given that I got it after
> my first cache population and less than a week using bcache in anger.
> 
> The system in question is an oldie that restarts by mounting as much
> as it can readonly and then doing a reboot (when bcache would
> routinely whine about timeouts): the things it manages to remount
> readonly does not usually include / is bcache usually unhappy about
> this sort of thing? Would it prefer it if I was able to unmount it
> properly? If so, it's time to upgrade that machine... it's only that
> I've had an oops before now when stopping bcaches (early in test, not
> preserved because I thought I'd made a mistake), so I thought it
> might be unhappy about *that*, as well.

Does your SSD support power loss protection (PLP)?

My SSD went offline (disconnected from sda for unknown reason, a cold
reboot fixed it) without bcache having any issue (neither the cached
backing device had any issue)...

Having no PLP or enabling device write caching (e.g. by means of
hdparm) could result in unwanted data corruptions...


-- 
Regards,
Kai

Replies to list-only preferred.
