From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Breaking chages from 3.13.0 to 3.17.1
Date: Tue, 17 Feb 2015 18:59:33 +0100
Message-ID: <55ccrb-aqg.ln1@hurikhan77.spdns.de>
References: <CAGCathzXBxg1aOBCJ4cmhEmeMVsdXOScA6kn=eNZeZgOSsSd-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36176 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348AbbBQSA3 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 17 Feb 2015 13:00:29 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1YNmRV-00083w-SN
	for linux-bcache@vger.kernel.org; Tue, 17 Feb 2015 19:00:17 +0100
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Tue, 17 Feb 2015 19:00:12 +0100
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Tue, 17 Feb 2015 19:00:12 +0100
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Lucas Clemente Vella <lvella@gmail.com> schrieb:

> Hi, I've updated my kernel from 3.13.0 to 3.16.0, but the new kernel
> wouldn't boot (I belive because of my bcache setup). So I have updated
> a little further to kernel 3.17.1, and now it boots, but I get the
> following log messages:
> 
> $ dmesg | grep bcache
> [    1.156474] bcache: error on 585603df-7dd5-4d6f-a2ab-e80b59cc994d:
> no journal entries found, disabling caching
> [    1.157393] bcache: register_cache() registered cache device sdb
> [    1.157464] bcache: register_bdev() registered backing device sda2
> [    1.157598] bcache: register_bdev() registered backing device sda1
> [    1.157695] bcache: cache_set_free() Cache set
> 585603df-7dd5-4d6f-a2ab-e80b59cc994d unregistered
> [    1.239026] EXT4-fs (bcache1): mounted filesystem with ordered data
> mode. Opts: (null)
> [    1.425166] bcache: bch_journal_replay() journal replay done, 788
> keys in 92 entries, seq 1095169
> [    1.455283] bcache: bch_cached_dev_attach() Caching sda2 as bcache0
> on set 25497b90-14dd-4242-b35a-a15598492902
> [    1.455317] bcache: register_cache() registered cache device sdb3
> [    5.011443] EXT4-fs (bcache1): re-mounted. Opts: errors=remount-ro
> [    7.649948] EXT4-fs (bcache0): mounted filesystem with ordered data
> mode. Opts: (null)
> 
> This first message worries me, and I didn't had it before. Does it
> means that the SSD caching is bypassed entirely? Was there any
> incompatible changes between the two kernel versions? If so, how can I
> safely reenable the caching?
> 
> It seems weird that it is trying to sdb as cache device, because only
> the partition sdb3 was formated as cache.

Did you maybe first format sdb as bcache, then decided it would be better to 
partition it, then formatted sdb3? This could mean there's an orphan 
superblock lying around which is detected when bcache initializes. I once 
had a similar behavior where I formatted sdb as btrfs, then decided it would 
be better to have a GPT partition, and then formatted the partition. lsblk 
or blkid still showed me the wrong device (but also the partitioned one) and 
I decided to better use wipefs on the device and repartition again so this 
orphan superblock doesn't cause any havoc later.

So, essentially the change between those kernel versions could be how bcache 
detects its devices.

If this is the case and you are brave, you could find out which offset the 
superblock of bcache is at and destroy its superblock signature by changing 
a single byte of the raw sdb device with a hex editor. Just pay attention 
that it is not within some partition boundary which holds important data. 
You could also try to wipe sdb1 (write zeroes) after storing its data in a 
tar archive, when recreate its fs and restore from tar. If some orphan 
superblock is within the boundaries of sdb1, it would essentially be 
destroyed. If you are using modern partitioning, there's usually a gap 
before the first partition of 1 to 2 MBs which could also be wiped. But pay 
attention that boot loaders may have put payload into that gap.

I'd check the output of blkid and lsblk from the old and new kernel first, 
best being done from a rescue system. Then compare the UUIDs of the detected 
partitions between old and new kernel. It should give an idea of what's gone 
wrong.

-- 
Replies to list only preferred.
