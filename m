From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: bcache fails after reboot if discard is enabled
Date: Mon, 09 Feb 2015 20:46:05 +0100
Message-ID: <tcfnqb-u59.ln1@hurikhan77.spdns.de>
References: <54A66945.6030403@profihost.ag> <54A66C44.6070505@profihost.ag> <54A819A0.9010501@rolffokkens.nl> <54A843BC.608@profihost.ag> <loom.20150105T010336-763@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33044 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328AbbBITq1 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Mon, 9 Feb 2015 14:46:27 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1YKuHp-00080K-8w
	for linux-bcache@vger.kernel.org; Mon, 09 Feb 2015 20:46:25 +0100
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Mon, 09 Feb 2015 20:46:25 +0100
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Mon, 09 Feb 2015 20:46:25 +0100
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Michael Goertz <goertzm@gmail.com> schrieb:

> Stefan Priebe <s.priebe <at> profihost.ag> writes:
> 
>> 
>> Hi Rolf,
>> Am 03.01.2015 um 17:32 schrieb Rolf Fokkens:
>> > I've been using discard for a while, but I ran a few times in serious
>> > FS corruptions. After disabling discard bcache was stable again.
>> >
>> > So far I tributed the corruptions to a low-cost SSD which probably
>> > didn't handle discard very well. But this was only an assumptions.
>> >
>> > I didn't experience specific reboot problems like you describe.
>> 
>> Reboot just triggers it faster and even fs crashes can occur the errors
>> are just examples.
>> 
>> I've now disabled discards in my kernel code.
>> 
>> Kent may you have a look at the 3.18 kernel code regading discards?
>> 
>> Greets,
>> Stefan
>> 
> 
> I just started using bcache and run into this same issue after a reboot. 
> I was running in writeback mode at the time and run into some FS loss as a
> result.  I don't have back traces since my machine wouldn't boot.  I
> recovered by removing the cache device and forcing the backing device to
> run without it.
> 
> I am running Ubuntu 14.04 with the Utopic kernel.  I can provide more
> details of my setup and hardware if that's helpful.

It works perfectly fine here with latest 3.18. My setup is backing a btrfs 
filesystem in write-back mode. I can reboot cleanly, hard-reset upon 
freezes, I had no issues yet and no data loss. Even after hard-reset the 
kernel logs of both bcache and btrfs were clean, the filesystem was clean, 
just the usual btrfs recovery messages after an unclean shutdown.

I wonder if the SSD and/or the block layer in use may be part of the 
problem:

  * if putting bcache on LVM, discards may not be handled well
  * if putting bcache or the backing fs on LVM, barriers may not be handled
    well (bcache relies on perfectly working barriers)
  * does the SSD support powerloss protection? (IOW, use capacitors)
  * latest firmware applied? read the changelogs of it?

I'd try to first figure out these differences before looking further into 
debugging. I guess that most consumer-grade drives at least lack a few of 
the important features to use write-back mode, or use bcache at all.

So, to start the list: My SSD is a Crucial MX100 128GB with discards enabled 
(for both bcache and btrfs), using plain raw devices (no LVM or MD 
involved). It supports TRIM (as my chipset does), and it supports powerloss-
protection and maybe even some internal RAID-like data protection layer 
(whatever that is, it's in the papers).

I'm not sure what a hard-reset technically means to the SSD but I guess it 
is handled as some sort of short powerloss. Reading through different SSD 
firmware update descriptions, I also see a lot words around power-off and 
reset problems being fixed that could lead to data-loss otherwise. That 
could be pretty fatal to bcache as it considers it storage as always unclean 
(probably even in write-through mode). Having damaged data blocks out of 
expected write order (barriers!) could be pretty bad when bcache recovers 
from last shutdown and replays logs.

-- 
Replies to list only preferred.
