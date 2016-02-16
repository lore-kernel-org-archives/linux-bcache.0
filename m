From: Scott McGillivray <scott.mcgillivray@gmail.com>
Subject: can't use ramdisk as cache device. Receive "Can't attach [UUID]:
 cache set not found" error
Date: Tue, 16 Feb 2016 10:40:50 +0800
Message-ID: <CABXj3oCqcw0dYGPWZTjEAgWwtA9QMWPT2vsdRBK04S55Mukocg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-yw0-f171.google.com ([209.85.161.171]:36559 "EHLO
	mail-yw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbcBPClJ (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 15 Feb 2016 21:41:09 -0500
Received: by mail-yw0-f171.google.com with SMTP id e63so34194051ywc.3
        for <linux-bcache@vger.kernel.org>; Mon, 15 Feb 2016 18:41:09 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache <linux-bcache@vger.kernel.org>

Hello

I am using Ubuntu 15.10 with latest nightly 4.5 kernel. Ubuntu creates
16 RAM drives as /dev/ram0 - ram16 by default and i am trying to test
bcache and use one of these as a cache device.

wipefs /dev/sdd
wipefs /dev/sdd -a
wipefs /dev/ram0
wipefs /dev/ram0 -a
make-bcache -B /dev/sdd -C /dev/ram0

At this point there were no errors output but there is also no UUID
entry in /sys/fs/bcache/. Only register and register_quiet.

bache-super-show correctly prints info about both block and cache
devices when queried but when i try to manually attach the cache
device with echo cset.uuid > /sys/block/bcache0/bcache/attach i get no
error but in dmesg i see

bcache: __cached_dev_store() Can't attach
3f2521a6-2103-4e2e-a47d-cc56558e8f7d: cache set not found

If i repeat this example but use another sd block device as cache then
it works OK.

Can anyone confirm if it should be possible to use the ramdisk based
block device as a caching device with bcache ?

I also tried to use a loop device as cache and that didn't work
either.. i got "kernel bug" in dmesg for
drivers/md/bcache/super.c:1812. RIP []
cache_alloc.isra.21+0x646/0x670[bcache]

Does bcache need the cache device to be a certain block type i.e sd 8
? Should i be able to use any block device from /proc/devices as a
cache device ?

The kernel options used for ramdisk are:

CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=65536
CONFIG_BLK_DEV_RAM_DAX=y

Thank you.
Scott
