From: Pavel Goran <via-bcache@pvgoran.name>
Subject: Regression in 4.14: wrong data being read from bcache device
Date: Thu, 16 Nov 2017 15:28:38 +0700
Message-ID: <1321800569.20171116152838@pvgoran.name>
Reply-To: Pavel Goran <via-bcache@pvgoran.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from vostok.pvgoran.name ([71.19.149.48]:55791 "EHLO
        vostok.pvgoran.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933545AbdKPIdm (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 16 Nov 2017 03:33:42 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello list,

I encountered a severe problem when trying to switch to kernel version 4.14.
In short, reads from the bcache device produce different data in 4.14 and
4.13.

I'm running Gentoo Linux with manually-compiled kernels (normally it's
pf-kernel; after encountering this problem, I tried version 4.14 of the
regular Gentoo kernel, and the problem was still there). I'm using an embedded
initramfs (generated with drakut 2 years ago). bcache is compiled in kernel
(not a module). I was using bcache (and this device in particular) for more
than a year.

My setup is as follows:

* /dev/bcache0 uses /dev/sda9 as cache and /dev/sdb1 as backing device

* LVM Volume Group consists of /dev/bcache0

* /dev/dm-1 is an LVM Logical Volume containing a JFS filesystem

bcache is running in writearound mode. Data from priority_stats:

Unused:         64%
Clean:          33%
Dirty:          0%
Metadata:       0%
Average:        391
Sectors per Q:  412592
Quantiles:      [1 5 14 27 45 90 105 115 122 140 154 260 267 285 363 369 438 507 530 540 554 583 596 608 636 671 688 805 815 826 834]

Here is what

On first reboot in 4.14, /dev/dm-1 failed a fsck check. An error message was
something about secondary data structures not matching primary. After this,
the filesystem failed to mount, and boot stopped. Then I rebooted under 4.13
and fsck did not find any errors, even after forced check; now I'm
successfully running 4.13 and actively access the filesystem read-write
without any problems.

I booted under 4.13 and 4.14 in single-user mode and took dumps of the first
16M of /dev/sdb1, /dev/bcache0 and /dev/dm-1 (the last one was actually 1M).
When I compare the 4.13 and 4.14 dumps of each device, I see that dumps from
/dev/sdb1 are the same, but dumps from /dev/bcache0 and /dev/dm-1 are
considerably different: it's 1437954 (of 16M) different bytes for bcache0, and
16317 (of 1M) different bytes for dm-1.

The patterns of invalid (4.14) data vary: I observe (1) almost-normal data
(for example, the superblock of the JFS filesystem seems to be mostly OK, with
differences like the dirty bit set in 4.14 data and not set in 4.13 data, and
a different s_logserial value), (2) non-zero bytes in place of zeroes, (3)
zeroes or mostly zeroes in place of non-zero bytes, (4) FF bytes in place of
zeroes or mostly zeroes.

In both kernels, dmesg doesn't show any abnormal bcache-related records. With
both kernels, I get records like this:

[    3.999534] bcache: bch_journal_replay() journal replay done, 11 keys in 8 entries, seq 21829
[    3.999917] bcache: register_cache() registered cache device sda9
[    4.029076] bcache: register_bdev() registered backing device sdb1
[    4.031208] bcache: bch_cached_dev_attach() Caching sdb1 as bcache0 on set 42eb0424-c06b-4a0d-af25-a76fb0ff8289

And then:

[   12.423886] bcache: register_bcache() error opening /dev/sda9: device already registered
[   12.850808] bcache: register_bcache() error opening /dev/sdb1: device already registered

(Looks like udev trying to repeatedly register the device).

Overall, this looks like a very serious bug that can corrupt or completely
destroy the data on bcache devices.

Pavel Goran
