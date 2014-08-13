From: Rolf Fokkens <rolf@rolffokkens.nl>
Subject: Re: "device busy" error when registering device
Date: Wed, 13 Aug 2014 22:24:33 +0200
Message-ID: <53EBC981.1000303@rolffokkens.nl>
References: <lqcd46$hvl$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:33946 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaHMUYh (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 13 Aug 2014 16:24:37 -0400
Received: by mail-wi0-f173.google.com with SMTP id f8so7996532wiw.0
        for <linux-bcache@vger.kernel.org>; Wed, 13 Aug 2014 13:24:36 -0700 (PDT)
In-Reply-To: <lqcd46$hvl$1@ger.gmane.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Ian Pilcher <arequipeno@gmail.com>, linux-bcache@vger.kernel.org

Hi Ian,

Sorry for the late response. Due to holidays it escaped my attention.

I'm running a very similar setup, but my system boots 100% of the time. 
So it may be useful to find out what's causing the problems at your 
system. You're using Intel RAID and I'm using Linux software RAID. It 
may be relevant, I don't know.

These are the details of my system, maybe you can spot a significant 
difference:

[root@home07 ~]# cat /proc/version
Linux version 3.15.6-200.fc20.x86_64 
(mockbuild@bkernel02.phx2.fedoraproject.org) (gcc version 4.8.3 20140624 
(Red Hat 4.8.3-1) (GCC) ) #1 SMP Fri Jul 18 02:36:27 UTC 2014
[root@home07 ~]#
Filesystem                 Size  Used Avail Use% Mounted on
/dev/mapper/BCACHE-ROOTFS   79G   56G   20G  75% /
devtmpfs                   3.9G     0  3.9G   0% /dev
tmpfs                      3.9G  212K  3.9G   1% /dev/shm
tmpfs                      3.9G  9.2M  3.9G   1% /run
tmpfs                      3.9G     0  3.9G   0% /sys/fs/cgroup
tmpfs                      3.9G  888K  3.9G   1% /tmp
/dev/md0                   462M  383M   56M  88% /boot
[root@home07 ~]# vgdisplay
   --- Volume group ---
   VG Name               BCACHE
   System ID
   Format                lvm2
   Metadata Areas        1
   Metadata Sequence No  18
   VG Access             read/write
   VG Status             resizable
   MAX LV                0
   Cur LV                3
   Open LV               2
   Max PV                0
   Cur PV                1
   Act PV                1
   VG Size               139.91 GiB
   PE Size               4.00 MiB
   Total PE              35816
   Alloc PE / Size       35328 / 138.00 GiB
   Free  PE / Size       488 / 1.91 GiB
   VG UUID               jIxLKK-ASqT-hlHy-D87m-lVLu-TFFc-7Tncp6

[root@home07 ~]# pvdisplay
   --- Physical volume ---
   PV Name               /dev/bcache0
   VG Name               BCACHE
   PV Size               139.91 GiB / not usable 2.87 MiB
   Allocatable           yes
   PE Size               4.00 MiB
   Total PE              35816
   Free PE               488
   Allocated PE          35328
   PV UUID               McXfNf-PEn1-DFEl-pAsX-3aIz-C2y6-xf75QV
[root@home07 ~]# bcache-status -s
--- bcache ---
UUID                        bc9e13cb-b50d-4016-bb52-1e20390ce248
Block Size                  512 B
Bucket Size                 512.00 KiB
Congested?                  False
Read Congestion             0.0ms
Write Congestion            0.0ms
Total Cache Size            30 GiB
Total Cache Used            23 GiB    (77%)
Total Cache Unused          7 GiB    (23%)
Evictable Cache             28 GiB    (94%)
Replacement Policy          [lru] fifo random
Cache Mode                  writethrough [writeback] writearound none
Total Hits                  155910    (95%)
Total Misses                7204
Total Bypass Hits           5230    (100%)
Total Bypass Misses         0
Total Bypassed              4.0 MiB
--- Backing Device ---
   Device File               /dev/md2 (9:2)
   bcache Device File        /dev/bcache0 (252:0)
   Size                      140 GiB
   Cache Mode                writethrough [writeback] writearound none
   Readahead                 0
   Sequential Cutoff         0 B
   Merge sequential?         False
   State                     dirty
   Writeback?                True
   Dirty Data                2 GiB
   Total Hits                155910    (95%)
   Total Misses              7204
   Total Bypass Hits         5230    (100%)
   Total Bypass Misses       0
   Total Bypassed            4.0 MiB
--- Cache Device ---
   Device File               /dev/sdd1 (8:49)
   Size                      30 GiB
   Block Size                512 B
   Bucket Size               512.00 KiB
   Replacement Policy        [lru] fifo random
   Discard?                  False
   I/O Errors                0
   Metadata Written          43.9 MiB
   Data Written              4 GiB
   Buckets                   61440
   Cache Used                23 GiB    (77%)
   Cache Unused              7 GiB    (23%)
[root@home07 ~]# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md1 : active raid5 sdc3[0] sda3[1] sdb3[2]
       1027968 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

md0 : active raid1 sdc1[0] sda1[1] sdb1[2]
       496896 blocks [3/3] [UUU]

md2 : active raid5 sda5[1] sdc5[0] sdb5[2]
       146705280 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

unused devices: <none>
[root@home07 ~]#

sda, sdb and sdc are SAMSUNG HD160JJ disks
sdd is a SanDisk SDSSDP06

The following may also be relevant, your device may be loked due to 
misidentification:

[root@home07 ~]# for i in /dev/sd[abc]1 /dev/sd[abc]3 /dev/md2 /dev/sdd1 
/dev/bcache0 ; do echo $i; wipefs "$i" | sed 's/^/   /'; done
/dev/sda1
    offset               type
----------------------------------------------------------------
    0x438                ext3   [filesystem]
                         LABEL: BOOT
                         UUID: a3768dfd-37ec-45d1-a01b-76280ed390d0

    0x1e540000           linux_raid_member   [raid]
                         UUID: b7036aaf-3c8d-e714-bfe7-8010bc810f04

/dev/sdb1
    offset               type
----------------------------------------------------------------
    0x438                ext3   [filesystem]
                         LABEL: BOOT
                         UUID: a3768dfd-37ec-45d1-a01b-76280ed390d0

    0x1e540000           linux_raid_member   [raid]
                         UUID: b7036aaf-3c8d-e714-bfe7-8010bc810f04

/dev/sdc1
    offset               type
----------------------------------------------------------------
    0x438                ext3   [filesystem]
                         LABEL: BOOT
                         UUID: a3768dfd-37ec-45d1-a01b-76280ed390d0

    0x1e540000           linux_raid_member   [raid]
                         UUID: b7036aaf-3c8d-e714-bfe7-8010bc810f04

/dev/sda3
    offset               type
----------------------------------------------------------------
    0x1f5f0000           linux_raid_member   [raid]
                         UUID: 59d3d229-892d-7dae-e109-537ecd2580d5

/dev/sdb3
    offset               type
----------------------------------------------------------------
    0x218                LVM2_member   [raid]
                         UUID: 12Zw7I-EFzj-hX5g-MXyM-0LTu-rg9d-vi25QE

    0x1f5f0000           linux_raid_member   [raid]
                         UUID: 59d3d229-892d-7dae-e109-537ecd2580d5

/dev/sdc3
    offset               type
----------------------------------------------------------------
    0x218                LVM2_member   [raid]
                         UUID: 12Zw7I-EFzj-hX5g-MXyM-0LTu-rg9d-vi25QE

    0x1f5f0000           linux_raid_member   [raid]
                         UUID: 59d3d229-892d-7dae-e109-537ecd2580d5

/dev/md2
    offset               type
----------------------------------------------------------------
    0x1018               bcache   [other]
                         UUID: 63aef7ae-d550-4ca6-8063-0b7d0cd63ad5

/dev/sdd1
    offset               type
----------------------------------------------------------------
    0x1018               bcache   [other]
                         UUID: 0d553929-3ef5-4f65-8479-2868bbba7329

/dev/bcache0
    offset               type
----------------------------------------------------------------
    0x218                LVM2_member   [raid]
                         UUID: McXfNf-PEn1-DFEl-pAsX-3aIz-C2y6-xf75QV

[root@home07 ~]#


Note the single (bcache) signature on md2.Check if your md126p2 RAID 
device also has single signature.

Also note the double signatures on sdb3 and sdc3. I wasn't aware of 
this, these double signatures might get me into trouble if LVM would 
claim them before linux raid. But I've been lucky apparently.

Rolf

On 07/19/2014 02:11 AM, Ian Pilcher wrote:
> I just finished moving my existing Fedora 20 root filesystem onto a
> bcache device (actually LVM on top of a bcache physical volume).
>
> The bcache cache device is /dev/sda2, a partition on my SSD; the backing
> device is /dev/md126p5, a partition on an Intel RAID (imsm) volume.
>
> This configuration only boots successfully about 50% of the time.  The
> other 50% of the time, the bcache device is not created, and dracut
> times out and dumps me into an emergency shell.
>
> After changing the bcache-register script to use /sys/fs/bcache/register
> (instead of register_quiet), I see a "device busy" error when udev
> attempts to register the backing device:
>
>    [    2.105581] bcache: register_bcache() error opening /dev/md126p5:
> device busy
>
> This is kernel 3.5.15, so this doesn't mean that the device is already
> registered; something else has it (temporarily) opened.  I say that it's
> opened temporarily, because I am able to register the backing device
> manually from the dracut shell -- which starts the the bcache device.
>
> Looking at /usr/lib/udev/bcache-register and the bcache_register source
> in drivers/md/bcache/super.c, I notice 2 things.
>
> (1) bcache-register gives up immediately when an error occurs because of
>      a (possibly temporary) conflict.
>
> (2) Although the driver logs a different message in the already
>      registered case ("device already registered" instead of "device
>      busy"), it doesn't provide userspace with any way to distinguish the
>      two cases; it always returns -EINVAL.
>
> Suggested fix:
>
> (1) Change bcache_register to return -EBUSY in the device busy case
>      (while still returning -EINVAL in the already registered case).
>
> (2) Change bcache-register to check the exit code of the registration
>      attempt and retry in the EBUSY case.
>
> Does this make sense?
>
