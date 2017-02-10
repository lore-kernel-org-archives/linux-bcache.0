From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: size limit for backing store? block sizes? ("[sdx] Bad block
 number requested")
Date: Fri, 10 Feb 2017 11:28:12 -0800 (PST)
Message-ID: <alpine.LRH.2.11.1702101127170.5783@mail.ewheeler.net>
References: <20170207133558.Horde.vMEQ46joRTaI1D7afBcEmGv@www3.nde.ag> <20170207205855.3d9c0985@jupiter.sol.kaishome.de> <20170208002843.Horde.s0-rn8GSuWk8FVkt60OB6Yb@www3.nde.ag> <20170208005732.207098f6@jupiter.sol.kaishome.de>
 <20170210115700.Horde.IQLnhCcS8ohxmn7nYsuxBaj@www3.nde.ag>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:49536 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932069AbdBJT2X (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 10 Feb 2017 14:28:23 -0500
In-Reply-To: <20170210115700.Horde.IQLnhCcS8ohxmn7nYsuxBaj@www3.nde.ag>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Cc: linux-bcache@vger.kernel.org

On Fri, 10 Feb 2017, Jens-U. Mozdzen wrote:

> Hello *,
> 
> Zitat von Kai Krakow <hurikhan77@gmail.com>:
> >[...]
> >The hardware block size (aka sector size) is not what is meant here...
> >You should use the biggest value. 8x512b fits into 4k. So bcache would
> >simply use 4k as the block size and it just works despite the sectors
> >being 512b.
> 
> sorry for using confusing terms - yes, I was talking about sector sizes.
> 
> >What I meant is "make-bcacke --block X". It defaults to X=512b. I think
> >you may want to force it to 4k and see if your problem persists.
> 
> I checked my various bcache backing stores and cache devices and got pretty
> inconsistent values. Time to clean up.
> 
> So trying to straighten things out, I started with a fresh backing device and
> feel like something's broken here:
> 
> - created a new RAID device, which has a sector size of 4096 per underlying
> disks:
> 
> myserver:~ # blockdev --getss /dev/md125
> 4096
> 
> - created the bcache super block
> 
> myserver:~ # make-bcache -B --block 4096b /dev/md125
> UUID:                   05d4d36a-ef17-4ecb-99d4-0a0eeec03941
> Set UUID:               dd4165a9-47ca-4e35-9e7a-5968e1e40d92
> version:                1
> block_size:             8
> data_offset:            16
> myserver:~ # bcache-super-show /dev/md125
> sb.magic                ok
> sb.first_sector         8 [match]
> sb.csum                 F4E616E067FA3C45 [match]
> sb.version              1 [backing device]
> 
> dev.label               (empty)
> dev.uuid                05d4d36a-ef17-4ecb-99d4-0a0eeec03941
> dev.sectors_per_block   8
> dev.sectors_per_bucket  1024
> dev.data.first_sector   16
> dev.data.cache_mode     0 [writethrough]
> dev.data.cache_state    0 [detached]
> 
> cset.uuid               dd4165a9-47ca-4e35-9e7a-5968e1e40d92
> myserver:~ # ll /sys/fs/bcache/
> total 0
> drwxr-xr-x 7 root root    0 Feb 10 11:37 32c8c1f9-268c-4405-8fd7-ab9f5acbe3fb
> --w------- 1 root root 4096 Feb 10 11:35 register
> --w------- 1 root root 4096 Feb 10 11:35 register_quiet
> myserver:~ #
> 
> Why does it report 8 sectors per block? With 4k per sector, that'd be a block
> size of 32k?

Its in 512b units and 8*512=4096.  Lots of things are in units of 512 even 
though your block size is 4096.  Its correct, it just looks funny since 
you have 4k sectors.


--
Eric Wheeler


> 
> "myserver" has a running bcache setup in parallel, with the cache device
> having a sector size of 512b (and bcache_super_show reports one sector per
> block). Does this influence "make-bcache", although no cache is attached (and
> the reported cset.uuid is different from the running bcache)?
> 
> Regards,
> Jens
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
