From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Bcache on btrfs: the perfect setup or the perfect storm?
Date: Sat, 11 Apr 2015 01:33:02 +0200
Message-ID: <e63mvb-p62.ln1@hurikhan77.spdns.de>
References: <CAK1hC9v9ADdguR+frFPix02U2u-+fuJgaV-cJi0F55fOfeECtg@mail.gmail.com> <55257b31.0308c20a.75a0.7849@mx.google.com> <CAK1hC9t85qM+DACbwWKFwM-7sO3eyBD6jRrYfg658pyKAwRscQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47699 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688AbbDJXiP (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Fri, 10 Apr 2015 19:38:15 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1YgiV2-00048y-GP
	for linux-bcache@vger.kernel.org; Sat, 11 Apr 2015 01:38:12 +0200
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Sat, 11 Apr 2015 01:38:12 +0200
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Sat, 11 Apr 2015 01:38:12 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

arnaud gaboury <arnaud.gaboury@gmail.com> schrieb:

> On Wed, Apr 8, 2015 at 9:02 PM, Kai Krakow <kai@kaishome.de> wrote:
>> arnaud gaboury <arnaud.gaboury@gmail.com> schrieb:
>>
>>> I plan to setup Bcache on  Btrfs SSD/HD caching/backing device. The
>>> box will be a server, but not a production one.
>>>
>>> I know this scheme is not recommended and can be a cause of filesystem
>>> corruption. But as I like living on the edge, I want to give a try,
>>> with a tight backup policy.
>>>
>>> Any advice? Any settings that could be worth to avoid future drama?
>>
>> See my recommendations about partitioning here I just posted:
>> http://permalink.gmane.org/gmane.linux.kernel.bcache.devel/2865
>>
>> Take care of the warnings about trimming/enabling discard. I'd at least
>> test it if you want to use it before trusting your kitty to it. ;-)
>>
>> BTW: I'm planning on a similar system tho the plans may well be 1 or 2
>> years in the future and the system is planned to be based off
>> bcache/btrfs. It should become a production container-VM host. We'll see.
>> Fallback plan is to use a battery-backed RAID controller with CacheCade
>> (SSDs as volume cache).
> 
> Thank you.
> Here is what I did to prevent any drama:

Due to bugs mentioned here, to prevent drama, better don't use discard or at 
least do your tests with appropriate backups, also do your performance 
tests.

> the caching device, a SSD:
> - GPT partitions.
> 
> -------------------------------------------------------
> # gisk /dev/sdd
> Command: p
> Disk /dev/sdb: 224674128 sectors, 107.1 GiB
> Logical sector size: 512 bytes
> Disk identifier (GUID): EAAC52BC-8236-483F-9875-744AF7031E72
> Partition table holds up to 128 entries
> First usable sector is 34, last usable sector is 224674094
> Partitions will be aligned on 2048-sector boundaries
> Total free space is 2014 sectors (1007.0 KiB)
> 
> Number  Start (sector)    End (sector)  Size       Code  Name
>    1            2048       167774207   80.0 GiB    8300  poppy-root
>    2       167774208       224674094   27.1 GiB    8300  poppy-cache

This matches my setup (though I used another layout). My drive reports full 
128GB instead of only 100GB. So I partitioned only 100GB and trimmed the 
whole drive in advance to partitioning.

> Then :
> 
> # make-bcache --wipe-bcache --block 4k --bucket 2M -B /dev/sdd4 -C
> /dev/sdb2 --discard

Take your safety measurements with "discard", see other threads/posts and 
above.

> Now, when referring to your post, I have no idea about:
>  Fourth - wear-levelling reservation.

Wear-levelling means that the drive tries to distribute writes evenly to the 
flash cells. It uses an internal mapping to dynamically remap logical blocks 
to internal block addresses. Because flash cells cannot be overridden, they 
have to be erased first, then written with the new data. The erasing itself 
is slow. This also implies that to modify a single logical sector of a cell, 
the drive has to read, modify, erase, then write a cell. This is clearly 
even slower. It is also known as "write amplification", this is more or less 
the same effect.

To compensate for that (performance), the drive reads a block, modifies the 
data, and writes it to a fresh (already erased) cell. This is known as read-
modify-write-cycle. Here comes the internal remapping into play. The erasing 
of the old cell is deferred into background. It will be done when the drive 
is idle. If you do a lot of writes, this accumulates. The drive needs a 
reservation area for discardable cells (thus, the option is usually called 
"discard" in filesystems).

A flash cell also has a limited lifetime how often it can be erased and 
rewritten. To compensate for that, SSD firmwares implement "wear levelling", 
that means it will try to remap to a flash cell that has a low counter for 
this. If your system informs the drive which cells are no longer holding 
data (the "discard" option), the drive can do a much better job at it 
because it has not to rely on the reservation pool alone. I artificially 
grow this pool by only partitioning about 80% of the native flash size, this 
means the pool has 20% of the whole capacity (usually, this is around 7% by 
default for most manufacturers). (100GB vs. 128GB ~ 20%, 120GB vs. 128GB ~ 
7%)

Now, bcache's bucket size comes into play. Because cells are much bigger 
then logical sectors (usually 512k, if your drive is RAID-striped internally 
and bigger drives usually are, you have integer multiples of that, like 2M 
for a 500GB drive because 4 cells make up on block [1], this is called an 
erase block because it can only be erased/written to all or nothing), you 
want to avoid the read-modify-write cycle as good as possible. This is what 
bcache uses its buckets for. It tries to fill and discard complete buckets 
in one go, caching as most in RAM first before pushing it out to the drive. 
If you are writing a complete block sized the erase block of the drive, it 
doesn't have to read-modify first, it just writes. This is clearly a 
performance benefit.

As a logical consequence, you can improve long-term performance and lifetime 
by using discard and a reservation pool, and you can improve direct 
performance by using an optimal bucket size in bcache. If optimizing Ext4 
for SSD, there are similar approaches to make best use of the erase block 
size.


> Shall I change my partition table for /dev/sdd2 and leave some space?

No, but maybe on sdb2 because that is your SSD, right?

> Below are some infos about the SSD:
[...]

Since sdb is your SSD, the above recommendations apply to sdb, not sdd. If 
you repartition, you may want to trim your whole drive first for the above 
mentioned reasons.


[1]:  If your drive has high write rates, it is probably using striped cells 
because writing flash is a slow process, much slower than reading (25% or 
less).

-- 
Replies to list only preferred.
