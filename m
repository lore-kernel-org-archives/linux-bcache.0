From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: bcache fails after reboot if discard is enabled
Date: Wed, 08 Apr 2015 21:54:43 +0200
Message-ID: <3ldgvb-het.ln1@hurikhan77.spdns.de>
References: <54A66945.6030403@profihost.ag> <54A66C44.6070505@profihost.ag> <54A819A0.9010501@rolffokkens.nl> <54A843BC.608@profihost.ag> <loom.20150105T010336-763@post.gmane.org> <tcfnqb-u59.ln1@hurikhan77.spdns.de> <CAPL5yKf4Tz1oUDNTEz20+CXh-UEeZaNBZCD9pevg47kGnWmDQQ@mail.gmail.com> <alpine.DEB.2.02.1504081115550.2587@ware.dreamhost.com> <55257303.8020008@profihost.ag> <alpine.DEB.2.02.1504081228581.2587@ware.dreamhost.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33107 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528AbbDHTy4 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 8 Apr 2015 15:54:56 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1Yfw3n-00054D-2Q
	for linux-bcache@vger.kernel.org; Wed, 08 Apr 2015 21:54:51 +0200
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Wed, 08 Apr 2015 21:54:51 +0200
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Wed, 08 Apr 2015 21:54:51 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Eric Wheeler <bcache@lists.ewheeler.net> schrieb:

>> Am 08.04.2015 um 20:17 schrieb Eric Wheeler:
>> > Anecdotally, I seem to remember someone else on the list having trouble
>> > using bcache when the backing device(s?) have TRIM enabled.
>> 
>> Me. Wasn't able to fix it. Trim just results in complete data loss with
>> bcache if you reboot.
>> 
>> Stefan
> 
> Should bcache TRIM handling be disabled by default?
> 
> Kai reports success with TRIM on his Crucial SSD, so perhaps this is not a
> problem for everyone---but data integrity should be a priority and TRIM
> should only be enabled by those who understand the risks and wish to test.
> 
> Of course if the underlying problem could be found and fixed in code, that
> would be even better.

I didn't have a problem yet with it. Bcache/btrfs combo even survived power-
outages here during writes - with discard enabled for both btrfs and bcache. 
There's also no thrashing or unexpected performance drops.

But I always recommend to learn the correct erase block size of your drive. 
I just got a comment from Josep (didn't reply here) that TLC drives may use 
"strange" (unexpected) erase block sizes, read: 3x native erase block size, 
in case of TLC Evo that is 3x 512kB = 1536kB.

For bcache, you should set the bucket size to erase block size. I cannot 
say, however, if that plays into the trimming problem on reboots. Another 
factor may be that the main board resets the drive while it is still 
trimming during reboot/shutdown. It's probably a firmware bug, but could 
also be a problem with missing/non-working power-loss-protection. At least 
it should play into the performance problem when using trimming.

So the lesson here is (apart from "discard" being buggy in some firmwares): 
Erase block size heavily depends on the SSD's internal structure (memory 
cell layout, memory cell layers, memory cell striping). The most common 
value is probably 2M (it should fit most combinations in even multiples for 
MLC and SLC drives, not for TLC tho).

> 
> -Eric
> 
>  
>> > 
>> > -Eric
>> > 
>> > --
>> > Eric Wheeler, President           eWheeler, Inc. dba Global Linux
>> > Security
>> > 888-LINUX26 (888-546-8926)        Fax: 503-716-3878           PO Box
>> > 25107
>> > www.GlobalLinuxSecurity.pro       Linux since 1996!     Portland, OR
>> > 97298
>> > 
>> > On Tue, 7 Apr 2015, Dan Merillat wrote:
>> > 
>> > > > It works perfectly fine here with latest 3.18. My setup is backing
>> > > > a btrfs
>> > > > filesystem in write-back mode. I can reboot cleanly, hard-reset
>> > > > upon freezes, I had no issues yet and no data loss. Even after
>> > > > hard-reset the kernel logs of both bcache and btrfs were clean, the
>> > > > filesystem was clean,
>> > > > just the usual btrfs recovery messages after an unclean shutdown.
>> > > > 
>> > > > I wonder if the SSD and/or the block layer in use may be part of
>> > > > the problem:
>> > > > 
>> > > >    * if putting bcache on LVM, discards may not be handled well
>> > > >    * if putting bcache or the backing fs on LVM, barriers may not
>> > > >    be
>> > > > handled
>> > > >      well (bcache relies on perfectly working barriers)
>> > > >    * does the SSD support powerloss protection? (IOW, use
>> > > >    capacitors) * latest firmware applied? read the changelogs of
>> > > >    it?
>> > > > 
>> > > > I'd try to first figure out these differences before looking
>> > > > further into
>> > > > debugging. I guess that most consumer-grade drives at least lack a
>> > > > few of
>> > > > the important features to use write-back mode, or use bcache at
>> > > > all.
>> > > > 
>> > > > So, to start the list: My SSD is a Crucial MX100 128GB with
>> > > > discards enabled
>> > > > (for both bcache and btrfs), using plain raw devices (no LVM or MD
>> > > > involved). It supports TRIM (as my chipset does), and it supports
>> > > > powerloss-
>> > > > protection and maybe even some internal RAID-like data protection
>> > > > layer (whatever that is, it's in the papers).
>> > > > 
>> > > > I'm not sure what a hard-reset technically means to the SSD but I
>> > > > guess it
>> > > > is handled as some sort of short powerloss. Reading through
>> > > > different SSD
>> > > > firmware update descriptions, I also see a lot words around
>> > > > power-off and
>> > > > reset problems being fixed that could lead to data-loss otherwise.
>> > > > That could be pretty fatal to bcache as it considers it storage as
>> > > > always unclean
>> > > > (probably even in write-through mode). Having damaged data blocks
>> > > > out of expected write order (barriers!) could be pretty bad when
>> > > > bcache recovers
>> > > > from last shutdown and replays logs.
>> > > 
>> > > Samsung 840-EVO 256GB here, running 4.0-rc7 (was 3.18)
>> > > 
>> > > There's no known issues with TRIM on an 840-EVO, and no powerloss or
>> > > anything of the sort occurred.  I was seeing excessive write
>> > > amplification on my SSD, and enabled discard - then my machine
>> > > promptly started lagging, eventually disk access locked up and after
>> > > a reboot I was confronted with:
>> > > 
>> > > [  276.558692] bcache: journal_read_bucket() 157: too big, 552 bytes,
>> > > offset 2047
>> > > [  276.571448] bcache: prio_read() bad csum reading priorities
>> > > [  276.571528] bcache: prio_read() bad magic reading priorities
>> > > [  276.576807] bcache: error on 804d6906-fa80-40ac-9081-a71a4d595378:
>> > > bad btree header at bucket 65638, block 0, 0 keys, disabling caching
>> > > [  276.577457] bcache: register_cache() registered cache device sda4
>> > > [  276.577632] bcache: cache_set_free() Cache set
>> > > 804d6906-fa80-40ac-9081-a71a4d595378 unregistered
>> > > 
>> > > Attempting to check the backingstore (echo 1 > bcache/running):
>> > > 
>> > > [  687.912987] BTRFS (device bcache0): parent transid verify failed
>> > > [  on
>> > > 7567956930560 wanted 613690 found 613681
>> > > [  687.913192] BTRFS (device bcache0): parent transid verify failed
>> > > [  on
>> > > 7567956930560 wanted 613690 found 613681
>> > > [  687.913231] BTRFS: failed to read tree root on bcache0
>> > > [  687.936073] BTRFS: open_ctree failed
>> > > 
>> > > The cache device is not going through LVM or anything of the sort, so
>> > > this is a direct failure of bcache.  Perhaps due to eraseblock
>> > > alignment and assumptions about sizes?  Either way, I've got a ton of
>> > > data to recover/restore now and I'm unhappy about it.

-- 
Replies to list only preferred.
