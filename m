From: Nix <nix@esperi.org.uk>
Subject: Re: bcache crashes at boot time
Date: Wed, 21 Jun 2017 22:57:39 +0100
Message-ID: <87d19xt358.fsf@esperi.org.uk>
References: <CAE4BCM2DCZ5E29AbXmDwn8T3VBzUczLZa+CXkYVH_dZNrcqVeA@mail.gmail.com>
        <alpine.LRH.2.11.1706202158180.17052@mail.ewheeler.net>
        <87k245vbwp.fsf@esperi.org.uk>
        <20170621191035.5995b87c@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:50554 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752105AbdFUV5r (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 21 Jun 2017 17:57:47 -0400
In-Reply-To: <20170621191035.5995b87c@jupiter.sol.kaishome.de> (Kai Krakow's
        message of "Wed, 21 Jun 2017 19:10:35 +0200")
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kai Krakow <hurikhan77@gmail.com>
Cc: linux-bcache@vger.kernel.org

On 21 Jun 2017, Kai Krakow outgrape:

> Am Wed, 21 Jun 2017 12:05:26 +0100
> schrieb Nix <nix@esperi.org.uk>:
>> The system in question is an oldie that restarts by mounting as much
>> as it can readonly and then doing a reboot (when bcache would
>> routinely whine about timeouts): the things it manages to remount
>> readonly does not usually include / is bcache usually unhappy about
>> this sort of thing? Would it prefer it if I was able to unmount it
>> properly? If so, it's time to upgrade that machine... it's only that
>> I've had an oops before now when stopping bcaches (early in test, not
>> preserved because I thought I'd made a mistake), so I thought it
>> might be unhappy about *that*, as well.
>
> Does your SSD support power loss protection (PLP)?

It's an Intel DC3510, so one of the few that verifiably supports it and
has been verified to have the damn thing actually work: it's quite new
and its SMART logs report that the capacitors used to implement PLP work
fine. I'm also keeping my XFS logs (journals) on there, and they were
fine as well. (XFS routinely keeps stuff only in the log on a normal
shutdown, on the assumption that it'll be able to replay them on remount
without unnecessarily delaying the umount for a potentially huge
metadata update: if the logs were corrupted, it would have told me so
very loudly at startup.)

I think we can rule out the SSD itself as a cause.

> Having no PLP or enabling device write caching (e.g. by means of
> hdparm) could result in unwanted data corruptions...

This wasn't a powerdown, just a reboot. SMART reported no reset of the
SSD across the reboot.

-- 
NULL && (void)
