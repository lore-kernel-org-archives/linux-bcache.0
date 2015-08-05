From: =?UTF-8?B?0JPQtdC+0YDQs9C40Lkg0KHRgtCw0YDQuNC60L7Qsg==?=
	<gstarikov@gmail.com>
Subject: bcache wont register cache and attempt to access beyond end of device
Date: Wed, 5 Aug 2015 15:52:54 +0300
Message-ID: <CAOOKTyBAb4H1COk4-zmamsR4i4G+oomDQfR7W4vG3opx7mS+6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:33983 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbbHEMwz (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 5 Aug 2015 08:52:55 -0400
Received: by wicne3 with SMTP id ne3so3520724wic.1
        for <linux-bcache@vger.kernel.org>; Wed, 05 Aug 2015 05:52:54 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello,
bcache worked fine until i rebooted server. Now, bcache wont register
cache device. Backing registered successfully.
Is there a way to fix it?
Configuration was : cache - sdc, backing - md0 (md raid6)

Details:

# echo /dev/sdc > /sys/fs/bcache/register

dmesg
[ 1004.580163] bcache: prio_read() bad csum reading priorities
[ 1004.580167] bcache: prio_read() bad magic reading priorities
[ 1004.580497] attempt to access beyond end of device
[ 1004.580499] sdc: rw=48, want=12989067124903043072, limit=468862128
[ 1004.580501] bcache: error on 4ca0fbc9-d20b-4a3d-bbd1-38d9a5810c27:
accessing priorities, disabling caching
[ 1004.582053] bcache: prio_read() bad csum reading priorities
[ 1004.582055] bcache: prio_read() bad magic reading priorities
[ 1004.582395] attempt to access beyond end of device
[ 1004.582397] sdc: rw=48, want=12989067124903043072, limit=468862128
[ 1004.583942] bcache: prio_read() bad csum reading priorities
[ 1004.583944] bcache: prio_read() bad magic reading priorities
[ 1004.584997] bcache: register_cache() registered cache device sdc
[ 1004.585504] bcache: cache_set_free() Cache set
4ca0fbc9-d20b-4a3d-bbd1-38d9a5810c27 unregistered

# bcache-super-show /dev/sdc
sb.magic                ok
sb.first_sector         8 [match]
sb.csum                 44826230D24195E8 [match]
sb.version              3 [cache device]

dev.label               (empty)
dev.uuid                cd4241f5-1271-4a1a-a530-58d3ccc2f97e
dev.sectors_per_block   1
dev.sectors_per_bucket  1024
dev.cache.first_sector  1024
dev.cache.cache_sectors 468860928
dev.cache.total_sectors 468861952
dev.cache.ordered       yes
dev.cache.discard       yes
dev.cache.pos           0
dev.cache.replacement   0 [lru]

cset.uuid               4ca0fbc9-d20b-4a3d-bbd1-38d9a5810c27

# bcache-super-show /dev/md0
sb.magic                ok
sb.first_sector         8 [match]
sb.csum                 F3A7C3593D24C25A [match]
sb.version              1 [backing device]

dev.label               (empty)
dev.uuid                80bdbcce-f1e1-4af9-a2bd-e4be24067fc5
dev.sectors_per_block   1
dev.sectors_per_bucket  1024
dev.data.first_sector   16
dev.data.cache_mode     1 [writeback]
dev.data.cache_state    1 [clean]

cset.uuid               4ca0fbc9-d20b-4a3d-bbd1-38d9a5810c27
