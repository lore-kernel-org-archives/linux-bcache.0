From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: Re: size limit for backing store? block sizes? ("[sdx] Bad block
 number requested")
Date: Fri, 10 Feb 2017 11:57:00 +0100
Message-ID: <20170210115700.Horde.IQLnhCcS8ohxmn7nYsuxBaj@www3.nde.ag>
References: <20170207133558.Horde.vMEQ46joRTaI1D7afBcEmGv@www3.nde.ag>
 <20170207205855.3d9c0985@jupiter.sol.kaishome.de>
 <20170208002843.Horde.s0-rn8GSuWk8FVkt60OB6Yb@www3.nde.ag>
 <20170208005732.207098f6@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.182]:24148 "EHLO
        mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752717AbdBJK5G (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 10 Feb 2017 05:57:06 -0500
Received: from hh2-mail.hh.nde.ag (gw-hh2.hh.nde.ag [85.183.17.20])
        by post.strato.de (RZmta 39.12 AUTH)
        with ESMTPA id c035a7t1AAv2NYc
        for <linux-bcache@vger.kernel.org>;
        Fri, 10 Feb 2017 11:57:02 +0100 (CET)
Received: from www3.nde.ag (hh2-www.hh.nde.ag [192.168.102.4])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        by hh2-mail.hh.nde.ag (Postfix) with ESMTPS id ABA821C068
        for <linux-bcache@vger.kernel.org>; Fri, 10 Feb 2017 11:57:00 +0100 (CET)
In-Reply-To: <20170208005732.207098f6@jupiter.sol.kaishome.de>
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
Cc: linux-bcache@vger.kernel.org

Hello *,

Zitat von Kai Krakow <hurikhan77@gmail.com>:
> [...]
> The hardware block size (aka sector size) is not what is meant here...
> You should use the biggest value. 8x512b fits into 4k. So bcache would
> simply use 4k as the block size and it just works despite the sectors
> being 512b.

sorry for using confusing terms - yes, I was talking about sector sizes.

> What I meant is "make-bcacke --block X". It defaults to X=512b. I think
> you may want to force it to 4k and see if your problem persists.

I checked my various bcache backing stores and cache devices and got  
pretty inconsistent values. Time to clean up.

So trying to straighten things out, I started with a fresh backing  
device and feel like something's broken here:

- created a new RAID device, which has a sector size of 4096 per  
underlying disks:

myserver:~ # blockdev --getss /dev/md125
4096

- created the bcache super block

myserver:~ # make-bcache -B --block 4096b /dev/md125
UUID:                   05d4d36a-ef17-4ecb-99d4-0a0eeec03941
Set UUID:               dd4165a9-47ca-4e35-9e7a-5968e1e40d92
version:                1
block_size:             8
data_offset:            16
myserver:~ # bcache-super-show /dev/md125
sb.magic                ok
sb.first_sector         8 [match]
sb.csum                 F4E616E067FA3C45 [match]
sb.version              1 [backing device]

dev.label               (empty)
dev.uuid                05d4d36a-ef17-4ecb-99d4-0a0eeec03941
dev.sectors_per_block   8
dev.sectors_per_bucket  1024
dev.data.first_sector   16
dev.data.cache_mode     0 [writethrough]
dev.data.cache_state    0 [detached]

cset.uuid               dd4165a9-47ca-4e35-9e7a-5968e1e40d92
myserver:~ # ll /sys/fs/bcache/
total 0
drwxr-xr-x 7 root root    0 Feb 10 11:37 32c8c1f9-268c-4405-8fd7-ab9f5acbe3fb
--w------- 1 root root 4096 Feb 10 11:35 register
--w------- 1 root root 4096 Feb 10 11:35 register_quiet
myserver:~ #

Why does it report 8 sectors per block? With 4k per sector, that'd be  
a block size of 32k?

"myserver" has a running bcache setup in parallel, with the cache  
device having a sector size of 512b (and bcache_super_show reports one  
sector per block). Does this influence "make-bcache", although no  
cache is attached (and the reported cset.uuid is different from the  
running bcache)?

Regards,
Jens
