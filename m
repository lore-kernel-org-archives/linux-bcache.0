From: Thierry <thierry-gY9mk9TZ+INg9hUCZPvPmw@public.gmane.org>
Subject: bad btree header at bucket xxx.
Date: Mon, 04 Nov 2013 00:39:09 +0100
Message-ID: <5276DE9D.6000401@de-leeuw.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi,

After a reboot, the bcache devices didn't appeared. Looking at dmesg I
foud out the following entries:
[ 12.182288] bcache: register_bdev() registered backing device dm-0
[ 12.217379] bcache: register_bdev() registered backing device dm-1
[ 12.253040] bcache: error on d8e791cc-47c2-449c-909a-1e4433a5de11: bad
btree header at bucket 32018, block 0, 0 keys, disabling caching
[ 12.253050] bcache: register_cache() registered cache device sdb1
[ 12.253488] bcache: cache_set_free() Cache set
d8e791cc-47c2-449c-909a-1e4433a5de11 unregistered

Here is my device map
NAME MAJ:MIN RM SIZE TYPE FSTYPE MOUNTPOINT UUID PARTUUID
sda 8:0 0 931.5G disk
=E2=94=9C=E2=94=80sda1 8:1 0 150M part ext2 0ced49ec-a9ec-4711-95b6-8ce=
01153ee3c
2a20f8be-8162-48db-9e51-d97e8fde21ae
=E2=94=9C=E2=94=80sda2 8:2 0 49.9G part ext4 / 79f36847-8365-46da-85a1-=
cbab5ea9e30a
59d37a51-5f05-4356-857c-1937b793e9b1
=E2=94=9C=E2=94=80sda3 8:3 0 881.5G part LVM2_member
Vzf2b6-NmgQ-5Zff-QKRS-puR8-Dlhz-XIkY3t e337497b-b1e3-479e-ba29-e1b20343=
4e97
=E2=94=82 =E2=94=9C=E2=94=80vgDataNew-lvHome (dm-0) 254:0 0 50G lvm bca=
che
ff11059e-0edf-428d-9657-37f255bac07e
=E2=94=82 =E2=94=82 =E2=94=94=E2=94=80bcache0 252:0 0 50G disk ext4 /ho=
me
66bf41ef-174a-4770-b9ef-d37ab06d3f23
=E2=94=82 =E2=94=9C=E2=94=80vgDataNew-lvVM (dm-1) 254:1 0 100G lvm bcac=
he
9497600e-839f-4f59-862a-a7512cb59f0a
=E2=94=82 =E2=94=82 =E2=94=94=E2=94=80bcache1 252:1 0 100G disk ext4 /d=
ata/vm
5ed8126a-2bda-465e-bedb-61272d878fde
=E2=94=82 =E2=94=9C=E2=94=80vgDataNew-lvDownloads (dm-2) 254:2 0 50G lv=
m /home/xxx/xxx
=E2=94=82 =E2=94=94=E2=94=80vgDataNew-lvSwap (dm-3) 254:3 0 12G lvm [SW=
AP]
=E2=94=94=E2=94=80sda4 8:4 0 1007K part f6826e28-5dc0-4122-ba84-8ccaffd=
900fd
sdb 8:16 0 223.6G disk
=E2=94=94=E2=94=80sdb1 8:17 0 223.6G part bcache dff8e23e-7f9a-4a14-94a=
0-ec5b618a35c4
ba9624c2-7fb7-4cfb-8d8a-1da6ca429820
sr0

Here is the output of bacache-super-show

bcache-super-show /dev/sdb1
sb.magic ok
sb.first_sector 8 [match]
sb.csum C161466F71949DD0 [match]
sb.version 3 [cache device]

dev.uuid dff8e23e-7f9a-4a14-94a0-ec5b618a35c4
dev.sectors_per_block 8
dev.sectors_per_bucket 1024
dev.cache.first_sector 1024
dev.cache.cache_sectors 468858880
dev.cache.total_sectors 468859904
dev.cache.discard yes
dev.cache.pos 0

cset.uuid d8e791cc-47c2-449c-909a-1e4433a5de11


bcache-super-show /dev/vgDataNew/lvHome
sb.magic ok
sb.first_sector 8 [match]
sb.csum ADBDC19FD7011CAB [match]
sb.version 1 [backing device]

dev.uuid ff11059e-0edf-428d-9657-37f255bac07e
dev.sectors_per_block 8
dev.sectors_per_bucket 1024
dev.data.first_sector 16
dev.data.cache_mode 3 [no caching]
dev.data.cache_state 3 [inconsistent]

cset.uuid d8e791cc-47c2-449c-909a-1e4433a5de11


bcache-super-show /dev/vgDataNew/lvVM
sb.magic ok
sb.first_sector 8 [match]
sb.csum BFD4613F155DD0D7 [match]
sb.version 1 [backing device]

dev.uuid 9497600e-839f-4f59-862a-a7512cb59f0a
dev.sectors_per_block 8
dev.sectors_per_bucket 1024
dev.data.first_sector 16
dev.data.cache_mode 3 [no caching]
dev.data.cache_state 3 [inconsistent]

cset.uuid d8e791cc-47c2-449c-909a-1e4433a5de11

As you see I restarted the devices after having changed the cache mode
to "none" followed by a echo 1 > running (The state of the 2 devices
were dirty)
e2fsck do not report any problem on any of the bcache device

I am using gentoo kernel 3.11.6.

Not sure it is related but the last operations before reboot were:
* extend the lvDownloads (without FS resize)
* erronously executed resize2fs /dev/bcache1 which resulted in a messag=
e
that indicated that the device already had the maximum length.

Are there other "emegency actions" I should take (cache is till reporte=
d
as inconsistent)?

Any idea what can be the cause of this corruption? Do you need more
information to investigate the issue?

How can I fix it now?

Thanks!

Thierry
