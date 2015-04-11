From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: bcache fails after reboot if discard is enabled
Date: Sat, 11 Apr 2015 02:14:27 +0200
Message-ID: <3k5mvb-c14.ln1@hurikhan77.spdns.de>
References: <54A66945.6030403@profihost.ag> <54A66C44.6070505@profihost.ag> <54A819A0.9010501@rolffokkens.nl> <54A843BC.608@profihost.ag> <loom.20150105T010336-763@post.gmane.org> <tcfnqb-u59.ln1@hurikhan77.spdns.de> <CAPL5yKf4Tz1oUDNTEz20+CXh-UEeZaNBZCD9pevg47kGnWmDQQ@mail.gmail.com> <alpine.DEB.2.02.1504081115550.2587@ware.dreamhost.com> <55257303.8020008@profihost.ag> <alpine.DEB.2.02.1504081228581.2587@ware.dreamhost.com> <3ldgvb-het.ln1@hurikhan77.spdns.de> <CAPL5yKdH97vJaYZxdu9ZHhrmK0OOAvEqtAk3Efz2+TvtOBUShw@mail.gmail.com> <5a1mvb-6k.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48896 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003AbbDKAW6 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Fri, 10 Apr 2015 20:22:58 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1YgjCJ-0007uI-TR
	for linux-bcache@vger.kernel.org; Sat, 11 Apr 2015 02:22:55 +0200
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Sat, 11 Apr 2015 02:22:55 +0200
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Sat, 11 Apr 2015 02:22:55 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Kai Krakow <hurikhan77@gmail.com> schrieb:

> Dan Merillat <dan.merillat@gmail.com> schrieb:
> 
>> You can't always use the correct eraseblock size with BCache, since it
>> doesn't (didn't, at least at the time I created my cache) support
>> non-powers-of-two that TLC drives use.  That said, TRIM is not
>> supposed to blow away entire eraseblocks, just let the drive know the
>> mapping between presented LBA and internal address is no longer
>> needed, allowing it to do what it wishes with that knowledge
>> (generally reclaim multiple partial blocks to create fully empty
>> blocks).
> 
> Yes, I know that TRIM doesn't simply blow away blocks. It just marks them
> as unused. My recommendation was more or less for it to be efficient,
> otherwise you may experience write amplification problems on SSD which
> turns into peaks of bad performance from time to time.
> 
> One has simply take into account that SSD is a completely different
> technology than HDD. A logical sector here is not the native block size of
> the inner organization of the drive. It is made of flash memory blocks
> which are a lot larger than a single sector. Each of these blocks may be
> organized into "chunks" or "stripes" (in terms of RAID), so what makes up
> a complete logical block depends on the internal organization and layout
> of the flash chips.
> 
> With this knowledge one has to think about the fact that flash memory
> cannot be overridden or modified in a traditional aspect. Essentially,
> flash memory is write-once-read-multiple in this regard. For a block of
> flash memory to be reused, it has to be erased. That operation is not
> fast, it takes some time, and it can only applied to the complete
> organizational unit, read: the erase block size.
> 
> So, to be on the safe side performance-wise, you should tell your system
> (if applicable) at least an integer multiple of this native erase block
> size. My recommendation of 2MB should be safe for SLC and MLC drives, no
> matter if they are striped internally of 1, 2, or 4 flash memory blocks
> (usually 512k, read 1x, 2x, or 4x 512k, which is 2MB). As I learned, this
> is probably not true for TLC drives. For such drives, you probably may
> want to _not_ use discard in bcache and instead leave a space reservation
> to let the firmware do performant wear-levelling in the background. Thus I
> recommend to only partition 80% of the drive and leave the rest of it
> pre-trimmed.
> 
>> I can't find any reports of errors with TRIM support in the 840-EVO
>> series.  They had/may still have a problem reading old data that was a
>> big deal in the fall, and there was an 850 firmware that bricked some
>> drives.  Nothing about TRIM erasing unintended data, though.
> 
> I don't remember where but I read about problems with TRIM and data loss
> with Samsung firmware in different (but rare) scenarios. Even the
> Samsung's performance restoration tool could accidently destroy data
> because it trimmed the drive. I cannot say which of the series this
> applied to. I used this tool multiple times myself and has good results
> with it, and could not confirm those reports. But I'd take my safety
> guards first, anyways, and use backups, and test my setup. Of course, you
> should always to it, but for those drives I'm especially picky about it.
> 
>> There were no problems with bcache at all in the year+ I've used it,
>> until I enabled bcache discard. Before that, I put on over 100
>> terabytes of writes to the bcache partition with no interface errors.
> 
> There are reports about endurance tests that say you can write petabytes
> of data to SSD before they die. Samsung's drives belong to the best
> performers here with one downside: If they die, in those tests they took
> all your data with them and without warning. Most other drives went into
> read-only mode first so you could at least get your data off those drives,
> but after a reboot those drives were dead, too.
> 
> http://techreport.com/review/27909/the-ssd-endurance-experiment-theyre-all-dead
> 
> From those reports, I conclude: If your drive suddenly slows down, it's a
> good idea to order a replacement and check the SMART stats (if you didn't
> do that before).
> 
>>  I've also never seen a TRIM failure in other filesystems using the
>> same model in my other systems.  There was no powerloss, the system
>> went through a software reboot cycle before the failure.  I'm
>> therefore *extremely* hesitant about allowing this to be written off
>> as a hardware failure.
> 
> I'm also not sure to instead call it a general bug or problem of bcache.
> The TRIM implementation seems to be correct, at least it doesn't show
> problems for me. I have TRIM enabled for btrfs, bcache, and the kernel
> claims it to be supported. So I'd rather call it an incompatibility or
> firmware flaw which needs to be worked around.
> 
> I think one has to keep in mind, that most consumer grade drives are
> tested by the manufacturers only for Windows. If they pass all tests
> there, they are good enough. That's sadly fact. Linux may expose bugs of
> hardware/firmware that are otherwise not visible.

I'd like to amend: Because Samsung's TLC drives (at least for 21nm 
production) are unaligned for most OS operations (because the block size is 
no power of two), the firmware has to be more complex. This implies it is 
more prone to bugs. So, this is not a question of Samsung or not, it is a 
question of TLC or not. But Samsung is one of the first to implement TLC on 
a broad basis. They fixed this problem with the new 19nm production by using 
alignable block sizes. See tables one here:

http://www.anandtech.com/show/7173/samsung-ssd-840-evo-review-120gb-250gb-500gb-750gb-1tb-models-tested

It may be a better to use 512kb bucket size in bcache when wanting to try 
discard because this gives the firmware a chance to do wear-levelling for 3 
blocks at once and then throw away this job instead of accumulating maybe 
hundrets of "half-sized" discard jobs and wait and manage until those jobs 
can be merged into one erase job. If you instruct the drive to discard 2M, 
it can immediatly discard 1.5M but has to store information about discarding 
the remainder of 512k sometime later. This introduces a more complex code 
path to trigger, and more complex means a higher probability for bugs. Of 
course every firmware has to implement that code path because the OS may 
send discards unaligned. But as filesystems usually operate on aligned 
bounderies, that code path is usually not triggered. But still, that path 
can expose more bugs in every manufacturer's firmware.

Concluding: Of course, this only applies if you use such a "strange" Samsung 
drive. Most of Samsung's drives use "normal" block sizes. And as mentioned 
earlier, this is probably not specific to Samsung but to all manufacturers 
that use TLC and non-power-of-two block sizes.

So, if I were to hit this problem, I'd try to experiment with smaller bucket 
sizes in bcache that fit into the erase block size with an integer multiple 
if I'd still wanted to use discard. If this helps, there's probably an easy 
way to work around this quirk in bcache's kernel code.

-- 
Replies to list only preferred.
