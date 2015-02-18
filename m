From: Lucas Clemente Vella <lvella@gmail.com>
Subject: Re: Breaking chages from 3.13.0 to 3.17.1
Date: Tue, 17 Feb 2015 23:21:17 -0200
Message-ID: <CAGCathxxVP2dF_X8dRv==g5w5shzuHiDy6PaVx4KKUnhopEU3g@mail.gmail.com>
References: <CAGCathzXBxg1aOBCJ4cmhEmeMVsdXOScA6kn=eNZeZgOSsSd-Q@mail.gmail.com>
 <55ccrb-aqg.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:64702 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbbBRBVj (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 17 Feb 2015 20:21:39 -0500
Received: by mail-ig0-f169.google.com with SMTP id hl2so47661071igb.0
        for <linux-bcache@vger.kernel.org>; Tue, 17 Feb 2015 17:21:39 -0800 (PST)
In-Reply-To: <55ccrb-aqg.ln1@hurikhan77.spdns.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kai Krakow <hurikhan77@gmail.com>
Cc: linux-bcache@vger.kernel.org

I found the bcache magic number in libblkid/src/superblocks/bcache.c
from util-linux-2.25.1 package (source code for blkid), that happens
to be:
static const char bcache_magic[] = {
        0xc6, 0x85, 0x73, 0xf6, 0x4e, 0x1a, 0x45, 0xca,
        0x82, 0x65, 0xf5, 0x7f, 0x48, 0xba, 0x6d, 0x81
};

I found where this sequence appeared in my disk superblock with:
$ sudo hexdump -C -n 31744 /dev/sdb | less
(being 31744 the number of bytes before the first partition, as
reported by fdisk)

Then I did:
$ sudo dd if=/dev/zero of=/dev/sdb bs=1 ibs=1 obs=1 seek=4120 skip=4120 count=16

Rebooted, and it worked! Thanks!

2015-02-17 15:59 GMT-02:00 Kai Krakow <hurikhan77@gmail.com>:
> Lucas Clemente Vella <lvella@gmail.com> schrieb:
>
>> Hi, I've updated my kernel from 3.13.0 to 3.16.0, but the new kernel
>> wouldn't boot (I belive because of my bcache setup). So I have updated
>> a little further to kernel 3.17.1, and now it boots, but I get the
>> following log messages:
>>
>> $ dmesg | grep bcache
>> [    1.156474] bcache: error on 585603df-7dd5-4d6f-a2ab-e80b59cc994d:
>> no journal entries found, disabling caching
>> [    1.157393] bcache: register_cache() registered cache device sdb
>> [    1.157464] bcache: register_bdev() registered backing device sda2
>> [    1.157598] bcache: register_bdev() registered backing device sda1
>> [    1.157695] bcache: cache_set_free() Cache set
>> 585603df-7dd5-4d6f-a2ab-e80b59cc994d unregistered
>> [    1.239026] EXT4-fs (bcache1): mounted filesystem with ordered data
>> mode. Opts: (null)
>> [    1.425166] bcache: bch_journal_replay() journal replay done, 788
>> keys in 92 entries, seq 1095169
>> [    1.455283] bcache: bch_cached_dev_attach() Caching sda2 as bcache0
>> on set 25497b90-14dd-4242-b35a-a15598492902
>> [    1.455317] bcache: register_cache() registered cache device sdb3
>> [    5.011443] EXT4-fs (bcache1): re-mounted. Opts: errors=remount-ro
>> [    7.649948] EXT4-fs (bcache0): mounted filesystem with ordered data
>> mode. Opts: (null)
>>
>> This first message worries me, and I didn't had it before. Does it
>> means that the SSD caching is bypassed entirely? Was there any
>> incompatible changes between the two kernel versions? If so, how can I
>> safely reenable the caching?
>>
>> It seems weird that it is trying to sdb as cache device, because only
>> the partition sdb3 was formated as cache.
>
> Did you maybe first format sdb as bcache, then decided it would be better to
> partition it, then formatted sdb3? This could mean there's an orphan
> superblock lying around which is detected when bcache initializes. I once
> had a similar behavior where I formatted sdb as btrfs, then decided it would
> be better to have a GPT partition, and then formatted the partition. lsblk
> or blkid still showed me the wrong device (but also the partitioned one) and
> I decided to better use wipefs on the device and repartition again so this
> orphan superblock doesn't cause any havoc later.
>
> So, essentially the change between those kernel versions could be how bcache
> detects its devices.
>
> If this is the case and you are brave, you could find out which offset the
> superblock of bcache is at and destroy its superblock signature by changing
> a single byte of the raw sdb device with a hex editor. Just pay attention
> that it is not within some partition boundary which holds important data.
> You could also try to wipe sdb1 (write zeroes) after storing its data in a
> tar archive, when recreate its fs and restore from tar. If some orphan
> superblock is within the boundaries of sdb1, it would essentially be
> destroyed. If you are using modern partitioning, there's usually a gap
> before the first partition of 1 to 2 MBs which could also be wiped. But pay
> attention that boot loaders may have put payload into that gap.
>
> I'd check the output of blkid and lsblk from the old and new kernel first,
> best being done from a rescue system. Then compare the UUIDs of the detected
> partitions between old and new kernel. It should give an idea of what's gone
> wrong.
>
> --
> Replies to list only preferred.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Lucas Clemente Vella
lvella@gmail.com
