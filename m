From: Eric Wheeler <lists@ewheeler.net>
Subject: Re: can't use ramdisk as cache device. Receive "Can't attach [UUID]:
 cache set not found" error
Date: Wed, 24 Feb 2016 07:37:34 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1602240735220.32077@mail.ewheeler.net>
References: <CABXj3oCqcw0dYGPWZTjEAgWwtA9QMWPT2vsdRBK04S55Mukocg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([71.19.153.34]:36788 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755752AbcBXHoC (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 24 Feb 2016 02:44:02 -0500
In-Reply-To: <CABXj3oCqcw0dYGPWZTjEAgWwtA9QMWPT2vsdRBK04S55Mukocg@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Scott McGillivray <scott.mcgillivray@gmail.com>
Cc: linux-bcache <linux-bcache@vger.kernel.org>


On Tue, 16 Feb 2016, Scott McGillivray wrote:

> Hello
> 
> I am using Ubuntu 15.10 with latest nightly 4.5 kernel. Ubuntu creates
> 16 RAM drives as /dev/ram0 - ram16 by default and i am trying to test
> bcache and use one of these as a cache device.
> 
> wipefs /dev/sdd
> wipefs /dev/sdd -a
> wipefs /dev/ram0
> wipefs /dev/ram0 -a
> make-bcache -B /dev/sdd -C /dev/ram0

Does it work with /dev/zram0?   You would prep it something like this:

	modprobe zram
	echo $((1024*1024*1024)) > /sys/block/zram0/disksize # 1GB
	make-bcache  -C /dev/zram0

-Eric



> At this point there were no errors output but there is also no UUID
> entry in /sys/fs/bcache/. Only register and register_quiet.
> 
> bache-super-show correctly prints info about both block and cache
> devices when queried but when i try to manually attach the cache
> device with echo cset.uuid > /sys/block/bcache0/bcache/attach i get no
> error but in dmesg i see
> 
> bcache: __cached_dev_store() Can't attach
> 3f2521a6-2103-4e2e-a47d-cc56558e8f7d: cache set not found
> 
> If i repeat this example but use another sd block device as cache then
> it works OK.
> 
> Can anyone confirm if it should be possible to use the ramdisk based
> block device as a caching device with bcache ?
> 
> I also tried to use a loop device as cache and that didn't work
> either.. i got "kernel bug" in dmesg for
> drivers/md/bcache/super.c:1812. RIP []
> cache_alloc.isra.21+0x646/0x670[bcache]
> 
> Does bcache need the cache device to be a certain block type i.e sd 8
> ? Should i be able to use any block device from /proc/devices as a
> cache device ?
> 
> The kernel options used for ramdisk are:
> 
> CONFIG_BLK_DEV_RAM=y
> CONFIG_BLK_DEV_RAM_COUNT=16
> CONFIG_BLK_DEV_RAM_SIZE=65536
> CONFIG_BLK_DEV_RAM_DAX=y
> 
> Thank you.
> Scott
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



--
Eric Wheeler, President           eWheeler, Inc. dba Global Linux Security
888-LINUX26 (888-546-8926)        Fax: 503-716-3878           PO Box 25107
www.GlobalLinuxSecurity.pro       Linux since 1996!     Portland, OR 97298
