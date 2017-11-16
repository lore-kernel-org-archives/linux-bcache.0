From: Campbell Steven <casteven@gmail.com>
Subject: Re: Regression in 4.14: wrong data being read from bcache device
Date: Fri, 17 Nov 2017 08:36:43 +1300
Message-ID: <CAPerZE-KiYVWXtBsu+SR0wCgbSJgzZAufm+3NYdoybjq+6ySbQ@mail.gmail.com>
References: <1321800569.20171116152838@pvgoran.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.161.182]:35852 "EHLO
        mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933803AbdKPTgo (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 16 Nov 2017 14:36:44 -0500
Received: by mail-yw0-f182.google.com with SMTP id a4so128127ywh.3
        for <linux-bcache@vger.kernel.org>; Thu, 16 Nov 2017 11:36:44 -0800 (PST)
In-Reply-To: <1321800569.20171116152838@pvgoran.name>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Pavel Goran <via-bcache@pvgoran.name>
Cc: linux-bcache@vger.kernel.org

On 16 November 2017 at 21:28, Pavel Goran <via-bcache@pvgoran.name> wrote:
> Hello list,
>
> I encountered a severe problem when trying to switch to kernel version 4.14.
> In short, reads from the bcache device produce different data in 4.14 and
> 4.13.
>
> I'm running Gentoo Linux with manually-compiled kernels (normally it's
> pf-kernel; after encountering this problem, I tried version 4.14 of the
> regular Gentoo kernel, and the problem was still there). I'm using an embedded
> initramfs (generated with drakut 2 years ago). bcache is compiled in kernel
> (not a module). I was using bcache (and this device in particular) for more
> than a year.
>
> My setup is as follows:
>
> * /dev/bcache0 uses /dev/sda9 as cache and /dev/sdb1 as backing device
>
> * LVM Volume Group consists of /dev/bcache0
>
> * /dev/dm-1 is an LVM Logical Volume containing a JFS filesystem
>
> bcache is running in writearound mode. Data from priority_stats:
>
> Unused:         64%
> Clean:          33%
> Dirty:          0%
> Metadata:       0%
> Average:        391
> Sectors per Q:  412592
> Quantiles:      [1 5 14 27 45 90 105 115 122 140 154 260 267 285 363 369 438 507 530 540 554 583 596 608 636 671 688 805 815 826 834]
>
> Here is what
>
> On first reboot in 4.14, /dev/dm-1 failed a fsck check. An error message was
> something about secondary data structures not matching primary. After this,
> the filesystem failed to mount, and boot stopped. Then I rebooted under 4.13
> and fsck did not find any errors, even after forced check; now I'm
> successfully running 4.13 and actively access the filesystem read-write
> without any problems.
>
> I booted under 4.13 and 4.14 in single-user mode and took dumps of the first
> 16M of /dev/sdb1, /dev/bcache0 and /dev/dm-1 (the last one was actually 1M).
> When I compare the 4.13 and 4.14 dumps of each device, I see that dumps from
> /dev/sdb1 are the same, but dumps from /dev/bcache0 and /dev/dm-1 are
> considerably different: it's 1437954 (of 16M) different bytes for bcache0, and
> 16317 (of 1M) different bytes for dm-1.
>
> The patterns of invalid (4.14) data vary: I observe (1) almost-normal data
> (for example, the superblock of the JFS filesystem seems to be mostly OK, with
> differences like the dirty bit set in 4.14 data and not set in 4.13 data, and
> a different s_logserial value), (2) non-zero bytes in place of zeroes, (3)
> zeroes or mostly zeroes in place of non-zero bytes, (4) FF bytes in place of
> zeroes or mostly zeroes.
>
> In both kernels, dmesg doesn't show any abnormal bcache-related records. With
> both kernels, I get records like this:
>
> [    3.999534] bcache: bch_journal_replay() journal replay done, 11 keys in 8 entries, seq 21829
> [    3.999917] bcache: register_cache() registered cache device sda9
> [    4.029076] bcache: register_bdev() registered backing device sdb1
> [    4.031208] bcache: bch_cached_dev_attach() Caching sdb1 as bcache0 on set 42eb0424-c06b-4a0d-af25-a76fb0ff8289
>
> And then:
>
> [   12.423886] bcache: register_bcache() error opening /dev/sda9: device already registered
> [   12.850808] bcache: register_bcache() error opening /dev/sdb1: device already registered
>
> (Looks like udev trying to repeatedly register the device).
>
> Overall, this looks like a very serious bug that can corrupt or completely
> destroy the data on bcache devices.
>
> Pavel Goran
>

Hi Pavel,

I'm kind of glad this is what you are seeing as well, as I have been
facing exactly the same issue. For the past few days I've been trying
to build up a nice summary like you have to post, but aside from the
file system (we are using xfs) we are seeing the exactly the same
issue when we try and shift from a 4.7 kernel up to 4.14. I have also
tried the bcache patches out of linux-next (slated for 4.15) which
contain all the latest patches but I see the same result.

I have a test system here so am happy to do any further testing or
debug if developers are unable to repeat this one or want more
information.

These are the messages I get on boot into 4.14 from 4.7 (which had a
working bcache before this boot):

[    7.987709] bcache: register_bdev() registered backing device sda1
[    8.039975] bcache: bch_journal_replay() journal replay done, 9
keys in 9 entries, seq 2695
[    8.053470] bcache: bch_cached_dev_attach() Caching sda1 as bcache0
on set 7d0cfd11-6191-4b6d-a68d-76428e36948d
[    8.053483] bcache: register_cache() registered cache device sdd2
[    8.064088] bcache: register_bdev() registered backing device sdb1
[    8.069736] bcache: bch_cached_dev_attach() Caching sdb1 as bcache1
on set 7d0cfd11-6191-4b6d-a68d-76428e36948d
[    8.069893] bcache: register_bdev() registered backing device sdc1
[    8.076092] bcache: bch_cached_dev_attach() Caching sdc1 as bcache2
on set 7d0cfd11-6191-4b6d-a68d-76428e36948d
[   13.532137] systemd[1]: Set hostname to <bcache-test>.
[   16.051024] bcache: register_bcache() error opening /dev/sdd2:
device already registered
[   16.153337] bcache: register_bcache() error opening /dev/sdb1:
device already registered
[   16.381834] bcache: register_bcache() error opening /dev/sdc1:
device already registered
[   16.429065] bcache: register_bcache() error opening /dev/sda1:
device already registered
[   16.535736] XFS (bcache2): Mounting V5 Filesystem
[   16.537606] XFS (bcache1): Mounting V5 Filesystem
[   16.573616] XFS (bcache1): Ending clean mount
[   16.574389] XFS (bcache0): Mounting V5 Filesystem
[   16.893474] XFS (bcache2): Ending clean mount
[   16.912354] XFS (bcache2): Metadata corruption detected at
xfs_agi_read_verify+0x4f/0xe0 [xfs], xfs_agi block 0x746a32a
[   16.926493] XFS (bcache0): Ending clean mount
[   16.956459] XFS (bcache0): Metadata corruption detected at
xfs_agi_read_verify+0x4f/0xe0 [xfs], xfs_agi block 0x747145a
[   16.956460] XFS (bcache0): Unmount and run xfs_repair
[   16.956461] XFS (bcache0): First 64 bytes of corrupted metadata buffer:
[   16.956499] XFS (bcache0): metadata I/O error: block 0x747145a
("xfs_trans_read_buf_map") error 117 numblks 1
[   16.967095] XFS (bcache0): Metadata corruption detected at
xfs_agi_read_verify+0x4f/0xe0 [xfs], xfs_agi block 0xe8e28b2
[   16.967096] XFS (bcache0): Unmount and run xfs_repair
[   16.967097] XFS (bcache0): First 64 bytes of corrupted metadata buffer:
[   16.967108] XFS (bcache0): metadata I/O error: block 0xe8e28b2
("xfs_trans_read_buf_map") error 117 numblks 1
[   16.976962] XFS (bcache0): Metadata corruption detected at
xfs_agi_read_verify+0x4f/0xe0 [xfs], xfs_agi block 0x15d53d0a
[   16.976963] XFS (bcache0): Unmount and run xfs_repair
[   16.976964] XFS (bcache0): First 64 bytes of corrupted metadata buffer:
[   16.977000] XFS (bcache0): metadata I/O error: block 0x15d53d0a
("xfs_trans_read_buf_map") error 117 numblks 1
[   16.977004] XFS (bcache0): Error -117 reserving per-AG metadata reserve pool.
[   16.977005] XFS (bcache0): xfs_do_force_shutdown(0x8) called from
line 1017 of file fs/xfs/xfs_fsops.c.  Return address =
0xffffffffc08695c0
[   16.977011] XFS (bcache0): Corruption of in-memory data detected.
Shutting down filesystem
[   16.977011] XFS (bcache0): Please umount the filesystem and rectify
the problem(s)
[   18.602638] XFS (bcache2): Unmount and run xfs_repair
[   18.602638] XFS (bcache2): First 64 bytes of corrupted metadata buffer:
[   18.602675] XFS (bcache2): metadata I/O error: block 0x746a32a
("xfs_trans_read_buf_map") error 117 numblks 1
[   18.622489] XFS (bcache2): Metadata corruption detected at
xfs_agi_read_verify+0x4f/0xe0 [xfs], xfs_agi block 0xe8d4652
[   18.622490] XFS (bcache2): Unmount and run xfs_repair
[   18.622491] XFS (bcache2): First 64 bytes of corrupted metadata buffer:
[   18.622527] XFS (bcache2): metadata I/O error: block 0xe8d4652
("xfs_trans_read_buf_map") error 117 numblks 1
[   18.635789] XFS (bcache2): Metadata corruption detected at
xfs_agi_read_verify+0x4f/0xe0 [xfs], xfs_agi block 0x15d3e97a
[   18.635790] XFS (bcache2): Unmount and run xfs_repair
[   18.635791] XFS (bcache2): First 64 bytes of corrupted metadata buffer:
[   18.635827] XFS (bcache2): metadata I/O error: block 0x15d3e97a
("xfs_trans_read_buf_map") error 117 numblks 1
[   18.635830] XFS (bcache2): Error -117 reserving per-AG metadata reserve pool.
[   18.635832] XFS (bcache2): xfs_do_force_shutdown(0x8) called from
line 1017 of file fs/xfs/xfs_fsops.c.  Return address =
0xffffffffc08695c0
[   18.635837] XFS (bcache2): Corruption of in-memory data detected.
Shutting down filesystem
[   18.635838] XFS (bcache2): Please umount the filesystem and rectify
the problem(s)

Campbell
