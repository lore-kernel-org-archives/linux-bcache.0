From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: bcache fails after reboot if discard is enabled
Date: Wed, 08 Apr 2015 20:46:20 +0200
Message-ID: <tk9gvb-hsq.ln1@hurikhan77.spdns.de>
References: <54A66945.6030403@profihost.ag> <54A66C44.6070505@profihost.ag> <54A819A0.9010501@rolffokkens.nl> <54A843BC.608@profihost.ag> <loom.20150105T010336-763@post.gmane.org> <tcfnqb-u59.ln1@hurikhan77.spdns.de> <CAPL5yKf4Tz1oUDNTEz20+CXh-UEeZaNBZCD9pevg47kGnWmDQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57038 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921AbbDHSqb (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 8 Apr 2015 14:46:31 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1Yfuzd-0003AC-0a
	for linux-bcache@vger.kernel.org; Wed, 08 Apr 2015 20:46:29 +0200
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Wed, 08 Apr 2015 20:46:28 +0200
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Wed, 08 Apr 2015 20:46:28 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Dan Merillat <dan.merillat@gmail.com> schrieb:

>> It works perfectly fine here with latest 3.18. My setup is backing a
>> btrfs filesystem in write-back mode. I can reboot cleanly, hard-reset
>> upon freezes, I had no issues yet and no data loss. Even after hard-reset
>> the kernel logs of both bcache and btrfs were clean, the filesystem was
>> clean, just the usual btrfs recovery messages after an unclean shutdown.
>>
>> I wonder if the SSD and/or the block layer in use may be part of the
>> problem:
>>
>>   * if putting bcache on LVM, discards may not be handled well
>>   * if putting bcache or the backing fs on LVM, barriers may not be
>>   handled
>>     well (bcache relies on perfectly working barriers)
>>   * does the SSD support powerloss protection? (IOW, use capacitors)
>>   * latest firmware applied? read the changelogs of it?
>>
>> I'd try to first figure out these differences before looking further into
>> debugging. I guess that most consumer-grade drives at least lack a few of
>> the important features to use write-back mode, or use bcache at all.
>>
>> So, to start the list: My SSD is a Crucial MX100 128GB with discards
>> enabled (for both bcache and btrfs), using plain raw devices (no LVM or
>> MD involved). It supports TRIM (as my chipset does), and it supports
>> powerloss- protection and maybe even some internal RAID-like data
>> protection layer (whatever that is, it's in the papers).
>>
>> I'm not sure what a hard-reset technically means to the SSD but I guess
>> it is handled as some sort of short powerloss. Reading through different
>> SSD firmware update descriptions, I also see a lot words around power-off
>> and reset problems being fixed that could lead to data-loss otherwise.
>> That could be pretty fatal to bcache as it considers it storage as always
>> unclean (probably even in write-through mode). Having damaged data blocks
>> out of expected write order (barriers!) could be pretty bad when bcache
>> recovers from last shutdown and replays logs.
> 
> Samsung 840-EVO 256GB here, running 4.0-rc7 (was 3.18)
> 
> There's no known issues with TRIM on an 840-EVO, and no powerloss or
> anything of the sort occurred.  I was seeing excessive write
> amplification on my SSD, and enabled discard - then my machine
> promptly started lagging, eventually disk access locked up and after a
> reboot I was confronted with:
> 
> [  276.558692] bcache: journal_read_bucket() 157: too big, 552 bytes,
> offset 2047
> [  276.571448] bcache: prio_read() bad csum reading priorities
> [  276.571528] bcache: prio_read() bad magic reading priorities
> [  276.576807] bcache: error on 804d6906-fa80-40ac-9081-a71a4d595378:
> bad btree header at bucket 65638, block 0, 0 keys, disabling caching
> [  276.577457] bcache: register_cache() registered cache device sda4
> [  276.577632] bcache: cache_set_free() Cache set
> 804d6906-fa80-40ac-9081-a71a4d595378 unregistered
> 
> Attempting to check the backingstore (echo 1 > bcache/running):
> 
> [  687.912987] BTRFS (device bcache0): parent transid verify failed on
> 7567956930560 wanted 613690 found 613681
> [  687.913192] BTRFS (device bcache0): parent transid verify failed on
> 7567956930560 wanted 613690 found 613681
> [  687.913231] BTRFS: failed to read tree root on bcache0
> [  687.936073] BTRFS: open_ctree failed

Uncool... :-(

> The cache device is not going through LVM or anything of the sort, so
> this is a direct failure of bcache.  Perhaps due to eraseblock
> alignment and assumptions about sizes?  Either way, I've got a ton of
> data to recover/restore now and I'm unhappy about it.

I think the bucket size in bcache defaults to something else than 2MB which, 
according to my knowledge, is what most SSDs use as erase block size - thus 
important for doing discards correctly (aligned).

Next: I think the native sector size of the SSD is assumed to be 2k for 
bcache. I'd recommend setting it to 4k.

Third - partition alignment: Which partitioning tool did you use? On which 
boundary did it start the first partition? For SSD is should be 2M, not 
sector 63 (really bad idea) and not 1M (which is the default of fdisk I 
think, while gdisk defaults to 2M). I suggest using cgdisk to prepare the 
drive tho it will eventually create GPT-only partitions - check your kernel 
support for it.

Fourth - wear-levelling reservation: Depending on your BIOS the kernel may 
see parts of your drive which should usually be hidden (host protected area, 
HPA). If the HPA is visible, you should take that into account. 128GB SSDs 
usually have an HPA of 8GB accounting for 120GB. Depending on the 
manufacturer, they are announced with 120 or 128GB size. Recommendation: Use 
only 120GB. Better leave some extra spare space. It helps performance and 
live-time of the drive, especially when under write heavy applications. 
General recommendation is to use only about 80% of the drive calculated form 
the native size (read: including HPA). 256GB drives usually are sold as 
240GB but they are 256GB native. 512 is 500, and so on. There may be 
"strange" sizes like 480 which are simply multiples of the lower variants 
(because they are RAID-striped internally for better performance, like 4x 
120, so calculate 4x128GB natively). This is only a general abstraction, 
don't take it as law. Manufactures may follow different strategies. But it 
is generally not a bad idea to take this formula into account.

Take note, that when you reformat according to this recommendation, you have 
to trim your drive to take advantage of this. You can use "blkdiscard" for 
this to selectively or completely trim the drives. Proceed with care, take 
backups first. If used wrong, it will eat your data or even kill your kitty.

Apart from that, I've heard about discard problems with the Evo series from 
different sources. Samsung lately updated some firmwares, with the caveat 
that for some users that bricked their drives. Samsung will replace those 
drives. But at least it told me not to trust Samsung too much. In my job we 
also had a lot of problems with those drives in the past regarding SATA 
problems, performance problems (also in Windows), computer freezes, 
bluescreens. Most of them were fixed by BIOS and firmware updates, some 
others by using a high-quality SATA cable. So from my experience I'd check 
for such issues, too (especially the cable issue since SSDs can use higher 
SATA rates). We had good experience with SanDisk so far (read: no problems 
yet). I cannot say anything about other manufacturers.

I myself am using a Crucial MX100 128GB and am generally happy with it, 
except that writing is a bit slower compared to similar sized drives from 
other manufactures. But writing is not my primary target, and with bcache 
write-back it is still a lot faster than to HDD natively. I'm perfectly 
happy with its stability and reliability. And seeing that this drive didn't 
need a single firmware update yet since it is based off a (for Crucial) well 
known and established controller, speaks for stability. You cannot say that 
about Samsung although they offer great drives performance-wise. Personally 
I can recommend Crucial, tho on a broader range I don't have much experience 
with it wrt/ reliability.

Anyways: Your warning is well placed here regarding bcache and caching 
strategies. One should take it into account.

PS: I've used a block size of 4k and bucket size of 2M for my bcache setup. 
Probably it makes a difference. Other people here may give a deeper insight 
and maybe even explain why bcache defaults to 2k and 1M.

-- 
Replies to list only preferred.
