From: James Pharaoh <james@pharaoh.uk>
Subject: Extra write mode to close RAID5 write hole (kind of)
Date: Wed, 26 Oct 2016 16:20:38 +0100
Message-ID: <bd0112e0-976a-59e8-94ef-81777f240ffd@pharaoh.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from kiara-balancer-1.wellbehavedsoftware.com ([138.201.134.108]:46684
        "EHLO kiara-balancer-1.wellbehavedsoftware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753786AbcJZPZ7 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 26 Oct 2016 11:25:59 -0400
Received: from mail-backup-1.vpn.wellbehavedsoftware.com (unknown [10.109.160.60])
        by mail-hub.vpn.wellbehavedsoftware.com (Postfix) with ESMTP id 5CECDB6BF7
        for <linux-bcache@vger.kernel.org>; Wed, 26 Oct 2016 15:20:50 +0000 (UTC)
Received: from [10.0.0.125] (89.red-83-46-81.dynamicip.rima-tde.net [83.46.81.89])
        by mail-backup-1.vpn.wellbehavedsoftware.com (Postfix) with ESMTPSA id 01DF0C59B9
        for <linux-bcache@vger.kernel.org>; Wed, 26 Oct 2016 15:20:39 +0000 (UTC)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi all,

I'm creating an elaborate storage system and using bcache, with great 
success, to combine SSDs with smallish (500GB) network mounted block 
devices, with RAID5 in between.

I believe this should allow me to use RAID5 at large scale without high 
risk of data loss, because I can very quickly rebuild the small number 
of devices efficiently, across a distributed system.

I am using separate filesystems on each and abstracting their 
combination at a higher level, and I have redundant copies of their data 
in different locations (different countries in fact), so even if I lose 
one it can be recreated efficiently.

I believe this addresses the issue of two devices failing 
simultaneously, because it would affect an even smaller proportion of 
the total data than a single failure, which would simply trigger a 
number of RAID5 rebuilds.

I have high faith in SSD storage, especially given drives' SMART 
capabilities to report failure well in advance of it happening, so it 
occurs to me that bcache is going to close the RAID5 write hole for me, 
assuming certain things.

I am making assumptions about the ordering of writes that RAID5 makes, 
and will post to the appropriate list about that, with the possibility 
of another option. However, I also note that bcache "optimises" 
sequential writes directly to the underlying device:

 > Since random IO is what SSDs excel at, there generally won't be much
 > benefit to caching large sequential IO. Bcache detects sequential IO
 > and skips it; it also keeps a rolling average of the IO sizes per
 > task, and as long as the average is above the cutoff it will skip all
 > IO from that task - instead of caching the first 512k after every
 > seek. Backups and large file copies should thus entirely bypass the
 > cache.

Since I want my bcache device to essentially be a "journal", and to 
close the RAID5 write hole, I would prefer to disable this behaviour.

I propose, therefore, a further write mode, in which data is always 
written to the cache first, and synced, before it is written to the 
underlying device. This could be called "journal" perhaps, or something 
similar.

I am optimistic that this would be a relatively small change to the 
code, since it only requires to always choose the cache to write data to 
first. Perhaps the sync behaviour is also more complex, I am not 
familiar with the internals.

So, does anyone have any idea if this is practical, if it would 
genuinely close the write hole, or any other thoughts?

I am prepared to write up what I am designing in detail and open source 
it, I believe it would be a useful method of managing this kind of high 
scale storage in general.

James
