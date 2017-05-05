From: Nix <nix@esperi.org.uk>
Subject: Re: what happened to the nifty ioprio cache hinting stuff?
Date: Fri, 05 May 2017 22:41:18 +0100
Message-ID: <878tmbasn5.fsf@esperi.org.uk>
References: <877f1zil5d.fsf@esperi.org.uk>
        <alpine.LRH.2.11.1705021726500.5014@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:40338 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751760AbdEEVl3 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 5 May 2017 17:41:29 -0400
In-Reply-To: <alpine.LRH.2.11.1705021726500.5014@mail.ewheeler.net> (Eric
        Wheeler's message of "Tue, 2 May 2017 17:26:55 +0000 (UTC)")
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Jens Axboe <axboe@kernel.dk>, linux-bcache@vger.kernel.org, Kai Krakow <kai@kaishome.de>

On 2 May 2017, Eric Wheeler outgrape:

> Hi Jens,
>
> It looks like there are still people interested (excited, even!) in the 
> sysfs entries for ioprio cache hinting in bcache.  

As an aside, I expect to use it for all sorts of things (like backups:
bup likes to reread all data sometimes, and I don't want to blow the
bcache when it does), but in particular I plan to use it for things I
know will be using large volumes of data for the last time before
destruction -- things like manual and automated 'git gc', where I know
that preserving the old packfiles in the bcache is a total waste of time
and where the packfiles being read in only to be deleted may be very
large.

(I'm running in writearound mode, so the lack of useful ioprio for
writeback is not a problem for me, and I can cope with the lack of
ioprio for NFS reads, though I vaguely wish there was a way to propagate
some sort of please-don't-cache-this hint across that channel too!)
