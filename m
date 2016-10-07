From: Michele Brodoloni <mik.linux@gmail.com>
Subject: Re: bcache: bch_btree_gc() gc failed!
Date: Fri, 7 Oct 2016 18:01:59 +0000 (UTC)
Message-ID: <nt8nun$r23$2@blaine.gmane.org>
References: <nt7uef$u76$1@blaine.gmane.org> <nt860l$r23$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:49900 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1755269AbcJGSCZ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 7 Oct 2016 14:02:25 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <glbd-linux-bcache@m.gmane.org>)
        id 1bsZTL-0002Wt-Sb
        for linux-bcache@vger.kernel.org; Fri, 07 Oct 2016 20:02:15 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Ok.. I solved..
I just detached and reattached the cache

# echo 7eb257b3-940d-42ca-ab23-52752f8b17f8 > /sys/block/bcache1/bcache/detach
# echo 7eb257b3-940d-42ca-ab23-52752f8b17f8 > /sys/block/bcache1/bcache/attach

that did the trick.

# bcache-super-show /dev/sdd1
sb.magic		ok
sb.first_sector		8 [match]
sb.csum			98719AA13E8D185F [match]
sb.version		1 [backing device]
dev.label		(empty)
dev.uuid		904aaaa4-473a-446d-aad5-4e55cde972a8
dev.sectors_per_block	1
dev.sectors_per_bucket	1024
dev.data.first_sector	16
dev.data.cache_mode	0 [writethrough]
dev.data.cache_state	1 [clean]
cset.uuid		7eb257b3-940d-42ca-ab23-52752f8b17f8

# bcache-super-show /dev/sde1
sb.magic		ok
sb.first_sector		8 [match]
sb.csum			98719AA13E8D185F [match]
sb.version		1 [backing device]
dev.label		(empty)
dev.uuid		904aaaa4-473a-446d-aad5-4e55cde972a8
dev.sectors_per_block	1
dev.sectors_per_bucket	1024
dev.data.first_sector	16
dev.data.cache_mode	0 [writethrough]
dev.data.cache_state	1 [clean]
cset.uuid		7eb257b3-940d-42ca-ab23-52752f8b17f8


Everything is ok.

Il Fri, 07 Oct 2016 12:55:50 +0000, Michele Brodoloni ha scritto:

> Hi,
> I tried to reboot the machine, but bcache is still dead.
> /sys/block/bcache0/bcache/state reports "clean" (RAID5)
> /sys/block/bcache1/bcache/state reports "no cache" (SAN RAID10)
> 
> I did not mention before that the SAN is used like a DAS, and it isn't
> shared with other machines. There's just one server accessing it.
> 
> Regards,
> Michele
> 
> Il Fri, 07 Oct 2016 10:46:39 +0000, Michele Brodoloni ha scritto:
> 
>> Hello,
>> I have bcache running on a Debian 8.0 x86_64 with kernel 4.4.16.
>> I got 2x Samsung PRO 850 250gb in hardware RAID0 acting as cache device
>> for 1) a local RAID5 volume 2) a SAN RAID10 volume in active/backup
>> multipath fiber channel
>> 
>> I noticed today that SAN backing devices got detached from cache:
>> 
>> # bcache-super-show /dev/sdc1 sb.magic		ok
> sb.first_sector		8 [match]
>> sb.csum			2D71F678442855F6 [match]
>> sb.version		3 [cache device]
>> dev.label		(empty)
>> dev.uuid		c3dd7b4e-04e0-4578-a0ce-b35a5745e459
> dev.sectors_per_block	1
>> dev.sectors_per_bucket	1024 dev.cache.first_sector	1024
>> dev.cache.cache_sectors	629144576 dev.cache.total_sectors
> 629145600
>> dev.cache.ordered	yes dev.cache.discard	no
> dev.cache.pos		0
>> dev.cache.replacement	0 [lru] cset.uuid
>> 7eb257b3-940d-42ca-ab23-52752f8b17f8
>> 
>> # bcache-super-show /dev/sdd1 sb.magic		ok
> sb.first_sector		8 [match]
>> sb.csum			514C0F59BC7C1938 [match]
>> sb.version		1 [backing device]
>> dev.label		(empty)
>> dev.uuid		904aaaa4-473a-446d-aad5-4e55cde972a8
> dev.sectors_per_block	1
>> dev.sectors_per_bucket	1024 dev.data.first_sector	16
> dev.data.cache_mode
>> 0 [writethrough]
>> dev.data.cache_state	0 [detached] cset.uuid
>> 00000000-0000-0000-0000-000000000000
>> 
>> # bcache-super-show /dev/sde1 sb.magic		ok
> sb.first_sector		8 [match]
>> sb.csum			514C0F59BC7C1938 [match]
>> sb.version		1 [backing device]
>> dev.label		(empty)
>> dev.uuid		904aaaa4-473a-446d-aad5-4e55cde972a8
> dev.sectors_per_block	1
>> dev.sectors_per_bucket	1024 dev.data.first_sector	16
> dev.data.cache_mode
>> 0 [writethrough]
>> dev.data.cache_state	0 [detached] cset.uuid
>> 00000000-0000-0000-0000-000000000000
>> 
>> (Obviously /dev/sdd1 and /dev/sde1 are the same device but with
>> different path)
>> 
>> Another side effect is that my syslog, kern.log logfiles are eating all
>> my root partition space with messages like this:
>> 
>> Oct  7 12:27:31 lnx kernel: [2300151.278097] bcache: bch_btree_gc() gc
>> failed!
>> 
>> 
>> What can be done to troubleshoot this issue?
>> 
>> Regards,
>> Michele
