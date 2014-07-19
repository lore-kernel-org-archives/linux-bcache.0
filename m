From: Josep Lladonosa <jlladono@gmail.com>
Subject: Re: "device busy" error when registering device
Date: Sat, 19 Jul 2014 09:23:59 +0200
Message-ID: <CAPBO7TYGDMGUNNJWpjRmrTr5N6i2061Nu4BmbjtFROz=1siCRA@mail.gmail.com>
References: <lqcd46$hvl$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:41114 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbaGSHYA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sat, 19 Jul 2014 03:24:00 -0400
Received: by mail-wi0-f171.google.com with SMTP id hi2so1838254wib.10
        for <linux-bcache@vger.kernel.org>; Sat, 19 Jul 2014 00:23:59 -0700 (PDT)
In-Reply-To: <lqcd46$hvl$1@ger.gmane.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Ian Pilcher <arequipeno@gmail.com>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On 19 July 2014 02:11, Ian Pilcher <arequipeno@gmail.com> wrote:
> I just finished moving my existing Fedora 20 root filesystem onto a
> bcache device (actually LVM on top of a bcache physical volume).
>
> The bcache cache device is /dev/sda2, a partition on my SSD; the back=
ing
> device is /dev/md126p5, a partition on an Intel RAID (imsm) volume.
>
> This configuration only boots successfully about 50% of the time.  Th=
e
> other 50% of the time, the bcache device is not created, and dracut
> times out and dumps me into an emergency shell.
>
> After changing the bcache-register script to use /sys/fs/bcache/regis=
ter
> (instead of register_quiet), I see a "device busy" error when udev
> attempts to register the backing device:
>
>   [    2.105581] bcache: register_bcache() error opening /dev/md126p5=
:
> device busy
>
> This is kernel 3.5.15, so this doesn't mean that the device is alread=
y
> registered; something else has it (temporarily) opened.  I say that i=
t's
> opened temporarily, because I am able to register the backing device
> manually from the dracut shell -- which starts the the bcache device.
>
> Looking at /usr/lib/udev/bcache-register and the bcache_register sour=
ce
> in drivers/md/bcache/super.c, I notice 2 things.
>
> (1) bcache-register gives up immediately when an error occurs because=
 of
>     a (possibly temporary) conflict.
>
> (2) Although the driver logs a different message in the already
>     registered case ("device already registered" instead of "device
>     busy"), it doesn't provide userspace with any way to distinguish =
the
>     two cases; it always returns -EINVAL.
>
> Suggested fix:
>
> (1) Change bcache_register to return -EBUSY in the device busy case
>     (while still returning -EINVAL in the already registered case).
>
> (2) Change bcache-register to check the exit code of the registration
>     attempt and retry in the EBUSY case.
>
> Does this make sense?
>
> --
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> Ian Pilcher                                         arequipeno@gmail.=
com
> -------- "I grew up before Mark Zuckerberg invented friendship" -----=
---
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hello,

I am using bcache for a boot device and have found a "rare" behaviour, =
too.
In my case, I think bcache device is tried to be registered twice,
first incorrectly (perhaps first readonly system mount?), or tries to
register whole devices (in my case bcache0 is made of sda1 and sdb7)
instead of partitions. It could be related to initramfs scripts.

My lsblk:

=2E# lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda           8:0    0 238,5G  0 disk
=E2=94=9C=E2=94=80sda1        8:1    0 201,8G  0 part
=E2=94=82 =E2=94=94=E2=94=80bcache0 254:0    0   898G  0 disk /
=E2=94=9C=E2=94=80sda2        8:2    0   226M  0 part
=E2=94=94=E2=94=80sda3        8:3    0  36,5G  0 part
sdb           8:16   0 931,5G  0 disk
=E2=94=9C=E2=94=80sdb1        8:17   0   1,9G  0 part
=E2=94=9C=E2=94=80sdb2        8:18   0     1M  0 part
=E2=94=9C=E2=94=80sdb5        8:21   0   953M  0 part /boot
=E2=94=9C=E2=94=80sdb6        8:22   0  30,8G  0 part [SWAP]
=E2=94=94=E2=94=80sdb7        8:23   0   898G  0 part
  =E2=94=94=E2=94=80bcache0 254:0    0   898G  0 disk /


I tracked down the code by adding some variables log and found that
flash_dev_run is sometimes called with values higher than
0x9000000000000000 and makes bcache lock system boot:

=46eb 26 16:40:02 minijep kernel: [    3.062304] sd 1:0:0:0: [sda]
500118192 512-byte logical blocks: (256 GB/238 GiB)
=46eb 26 16:40:02 minijep kernel: [    3.062342] sd 1:0:0:0: [sda] Writ=
e
Protect is off
=46eb 26 16:40:02 minijep kernel: [    3.062357] sd 1:0:0:0: [sda] Writ=
e
cache: enabled, read cache: enabled, doesn't support DPO or FUA
=46eb 26 16:40:02 minijep kernel: [    3.063053]  sda: sda1 sda2 sda3
=46eb 26 16:40:02 minijep kernel: [    3.063305] sd 1:0:0:0: [sda]
Attached SCSI disk
=46eb 26 16:40:02 minijep kernel: [    3.065135] sr0: scsi3-mmc drive:
24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
=46eb 26 16:40:02 minijep kernel: [    3.065136] cdrom: Uniform CD-ROM
driver Revision: 3.20
=46eb 26 16:40:02 minijep kernel: [    3.065351] sd 4:0:0:0: [sdb]
1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
=46eb 26 16:40:02 minijep kernel: [    3.065355] sd 4:0:0:0: [sdb]
4096-byte physical blocks
=46eb 26 16:40:02 minijep kernel: [    3.065394] sd 4:0:0:0: [sdb] Writ=
e
Protect is off
=46eb 26 16:40:02 minijep kernel: [    3.065409] sd 4:0:0:0: [sdb] Writ=
e
cache: enabled, read cache: enabled, doesn't support DPO or FUA
=46eb 26 16:40:02 minijep kernel: [    3.066631] sd 1:0:0:0: Attached
scsi generic sg0 type 0
=46eb 26 16:40:02 minijep kernel: [    3.066669] sr 2:0:0:0: Attached
scsi generic sg1 type 5
=46eb 26 16:40:02 minijep kernel: [    3.066710] sd 4:0:0:0: Attached
scsi generic sg2 type 0
=46eb 26 16:40:02 minijep kernel: [    3.144996] bcache:
bch_cache_set_alloc() P7000: bch_cache_set_alloc: c->nr_uuids 4096
=46eb 26 16:40:02 minijep kernel: [    3.145035] bio: create slab <bio-=
1> at 1
=46eb 26 16:40:02 minijep kernel: [    3.357056]  sdb: sdb1 sdb2 sdb5 s=
db6 sdb7
=46eb 26 16:40:02 minijep kernel: [    3.357972] sd 4:0:0:0: [sdb]
Attached SCSI disk
=46eb 26 16:40:02 minijep kernel: [    3.386779] bcache: uuid_io() read
UUIDs at 0:0 len 1024 -> [0:60275712 gen 0]
=46eb 26 16:40:02 minijep kernel: [    3.499528] Switched to clocksourc=
e tsc
=46eb 26 16:40:02 minijep kernel: [    3.928562] bcache:
bch_journal_replay() journal replay done, 354 keys in 31 entries, seq
1076068
=46eb 26 16:40:02 minijep kernel: [    3.928717] bcache:
_debug_show_uuids_of_cache_set() probes17-302: flash_dev_run: u
ffff880801300000 c->nr_uuids 1000 u + c->nr_uuids ffff880801380000,
sizeof(struct uuid_entry) 128, c->nr_uuids*sizeof(struct uuid_entry)
524288
=46eb 26 16:40:02 minijep kernel: [    3.928720] bcache:
_debug_show_uuids_of_cache_set() probes17-9999: flash_dev_run: u
ffff880801300000 c->nr_uuids 1000 u + c->nr_uuids ffff880801380000,
sizeof(struct uuid_entry) 128, c->nr_uuids*sizeof(struct uuid_entry)
524288
=46eb 26 16:40:02 minijep kernel: [    3.928723] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[0] u: ffff880801300000,
u->sectors: 1504f6b8
=46eb 26 16:40:02 minijep kernel: [    3.928724] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[1] u: ffff880801300080,
u->sectors: aed46001
=46eb 26 16:40:02 minijep kernel: [    3.928726] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[2] u: ffff880801300100,
u->sectors: 9000000000800000
=46eb 26 16:40:02 minijep kernel: [    3.928727] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[3] u: ffff880801300180,
u->sectors: 15050838
=46eb 26 16:40:02 minijep kernel: [    3.928729] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[4] u: ffff880801300200,
u->sectors: 13e9fe800
=46eb 26 16:40:02 minijep kernel: [    3.928730] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[5] u: ffff880801300280,
u->sectors: 9000000040000000
=46eb 26 16:40:02 minijep kernel: [    3.928732] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[6] u: ffff880801300300,
u->sectors: 15051ff0
=46eb 26 16:40:02 minijep kernel: [    3.928733] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[7] u: ffff880801300380,
u->sectors: 13ec38800
=46eb 26 16:40:02 minijep kernel: [    3.928734] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[8] u: ffff880801300400,
u->sectors: 9000000037000000
=46eb 26 16:40:02 minijep kernel: [    3.928736] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[9] u: ffff880801300480,
u->sectors: 1505a648
=46eb 26 16:40:02 minijep kernel: [    3.928738] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[10] u: ffff880801300500,
u->sectors: 948d8800
=46eb 26 16:40:02 minijep kernel: [    3.928740] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[11] u: ffff880801300580,
u->sectors: 9000000002000000
=46eb 26 16:40:02 minijep kernel: [    3.928741] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[12] u: ffff880801300600,
u->sectors: 15400798
=46eb 26 16:40:02 minijep kernel: [    3.928743] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[13] u: ffff880801300680,
u->sectors: 2da2c000
=46eb 26 16:40:02 minijep kernel: [    3.928744] bcache:
flash_devs_run() P00: flash_dev_run:  uuids[14] u: ffff880801300700,
u->sectors: 9000000000800000

Those enormous values (incorrectly read from device?) make no sense,
compared to normal values. That is why, in order to be able to boot, I
add an if filter in flash_devs_run() in super.c:

-------in super.c---------------------------------------------
static int flash_devs_run(struct cache_set *c)
{
    int ret =3D 0;
    struct uuid_entry *u;

    for (u =3D c->uuids;
         u < c->uuids + c->nr_uuids && !ret;
         u++)
            if (u->sectors < 0x9000000000000000) //line added to be
able to root boot!
        if (UUID_FLASH_ONLY(u))
            ret =3D flash_dev_run(c, u);

    return ret;
}
-------------------------------------------------------------

Even with this "patch", system boots but it has a 30 second wait
during boot process. See wait from time 5.7 to 35.66 log lines:

=46eb 27 21:05:33 minijep kernel: [    5.758655] [drm] Enabling RC6
states: RC6 on, RC6p off, RC6pp off
=46eb 27 21:05:33 minijep kernel: [   35.663535] Adding 32225276k swap
on /dev/sdb6.  Priority:-1 extents:1 across:32225276k
=46eb 27 21:05:33 minijep kernel: [   35.686366] EXT4-fs (bcache0):
re-mounted. Opts: (null)
=46eb 27 21:05:33 minijep kernel: [   35.796078] EXT4-fs (bcache0):
re-mounted. Opts: errors=3Dremount-ro
=46eb 27 21:05:33 minijep kernel: [   36.026857] fuse init (API version=
 7.22)
=46eb 27 21:05:33 minijep kernel: [   36.035753] loop: module loaded



--=20
--
Salutacions...Josep
--
