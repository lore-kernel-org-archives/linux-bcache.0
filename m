From: Nix <nix@esperi.org.uk>
Subject: Re: bcache crashes at boot time
Date: Wed, 21 Jun 2017 12:05:26 +0100
Message-ID: <87k245vbwp.fsf@esperi.org.uk>
References: <CAE4BCM2DCZ5E29AbXmDwn8T3VBzUczLZa+CXkYVH_dZNrcqVeA@mail.gmail.com>
        <alpine.LRH.2.11.1706202158180.17052@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:47570 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752585AbdFULFd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 21 Jun 2017 07:05:33 -0400
In-Reply-To: <alpine.LRH.2.11.1706202158180.17052@mail.ewheeler.net> (Eric
        Wheeler's message of "Tue, 20 Jun 2017 22:04:40 +0000 (UTC)")
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Igor Pavlenko <ipavlenko.mail@gmail.com>, linux-bcache@vger.kernel.org

On 20 Jun 2017, Eric Wheeler uttered the following:

> On Mon, 5 Jun 2017, Igor Pavlenko wrote:
>
>> [   45.941155] bcache: register_bdev() registered backing device sda3
>> [   46.138238] bcache: error on 471776aa-1b34-4eff-ba7d-509a9554b43d:
>> inconsistent ptrs: mark = 3, level = 0, disabling caching
>
> ^^^
>
> This is the reason, something was inconsistent enough that it couldn't 
> continue.  

I'm rather worried about this sort of thing, given that I got it after
my first cache population and less than a week using bcache in anger.

The system in question is an oldie that restarts by mounting as much as
it can readonly and then doing a reboot (when bcache would routinely
whine about timeouts): the things it manages to remount readonly does
not usually include / is bcache usually unhappy about this sort of
thing? Would it prefer it if I was able to unmount it properly? If so,
it's time to upgrade that machine... it's only that I've had an oops
before now when stopping bcaches (early in test, not preserved because I
thought I'd made a mistake), so I thought it might be unhappy about
*that*, as well.

-- 
NULL && (void)
