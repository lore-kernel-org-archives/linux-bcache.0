From: arnaud gaboury <arnaud.gaboury@gmail.com>
Subject: Re: Issue when mkfs.btrfs on a bcached partition
Date: Sat, 11 Apr 2015 11:43:37 +0200
Message-ID: <CAK1hC9vkAnFgMarrFiwWKvKSQyMUR9xnCd++cN8yaEPcnxrn-w@mail.gmail.com>
References: <CAK1hC9v+ghET3=XAStWzofF-4But=sGhFgA-jhHZOobe2jSEzg@mail.gmail.com>
	<55215369.3255c20a.65f8.ffffc9b6@mx.google.com>
	<CAK1hC9voriAOCLhbO=adzxAwQ1Qrbu9BXX3L9eNadZTeDAyqgw@mail.gmail.com>
	<CAC2ZOYs7ZeduxVbp7fPaySo7vF9Na6A2Qg_7mgTu1QuptZoTEQ@mail.gmail.com>
	<CAK1hC9sKHUtt4MwCBfQoNS3Y9f0YkoU8cGPOF3DWi77MqnFcfg@mail.gmail.com>
	<CAC2ZOYsOc+FOstONB4GPxkNUVVAri5equvaoXXJAjqConLb+KQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:36121 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbbDKJnj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sat, 11 Apr 2015 05:43:39 -0400
Received: by lagv1 with SMTP id v1so28171244lag.3
        for <linux-bcache@vger.kernel.org>; Sat, 11 Apr 2015 02:43:37 -0700 (PDT)
In-Reply-To: <CAC2ZOYsOc+FOstONB4GPxkNUVVAri5equvaoXXJAjqConLb+KQ@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kai Krakow <kai@kaishome.de>, linux-bcache@vger.kernel.org

On Mon, Apr 6, 2015 at 8:39 PM, Kai Krakow <kai@kaishome.de> wrote:
> Bcache itself needs at least one partition or device for the caching =
layer.
> This is, you make one empty partition on your SSD and format it with
> make-bcache -C. Take care to use a bucket size that fits your SSDs er=
ase
> block size. Usually 2MB is a safe value. You also want to enable disc=
ard
> since most modern SSDs work better with it than relying on the hidden
> reservation area for wear-levelling. If you want to gain maximum
> performance, you can also choose write-back mode. This is usually saf=
e.
> Ensure that your SSD supports power-loss protection. Otherwise you ma=
y loose
> data when the power is lost. Usually, all major manufacturers like In=
tel,
> Samsung, Crucial, and SanDisk support it - at least for the more expe=
nsive
> drives. The product specs will tell you.
>
> Next, you create the partitions for the to-be-cached filesystems. You=
 cannot
> simply put the filesystem raw onto the partition. You have to prepare=
 the
> partition with make-bcache -B first ("B" for backing device). This th=
en
> creates you a new virtual device "bcacheX" (with X being a number) wh=
ich you
> use to operate your filesystem. Attach this virtual device to your ca=
ching
> device/partition. Then use you normal mkfs tools to format this virtu=
al
> device. The underlying raw device/partition is not used by you, it is
> managed by bcache. This configuration is stored by bcache and automat=
ically
> restored on next reboot by the kernel. You can attach multiple backin=
g
> devices to the same caching device - it's designed that multiple file=
systems
> can share the same bcache dynamically.
>
> You can also put your rootfs on bcache (I did it) but this involves
> recreating the rootfs (because you need to format your rootfs partiti=
on with
> make-bcache -B first, attach it, then recreate it on the new virtual =
bcache
> device), and I am not sure if you need an initramfs then to boot. But=
 most
> distributions boot from initramfs anyways, but you should make sure t=
hey
> support bcache in initramfs. I think this is because the kernel has t=
o wait
> for the bcache devices to appear first because they are not immediatl=
y
> available and thus a "root=3D/dev/bcache/bcache0" (or similar) would =
fail as
> it is not immediatly found. I think udev rules need to run first so t=
he
> symlinks and device nodes are created, and detected bcache's become
> registered again and imported into the kernel's knowledge.
>
> bcache caching device =3D intermediate storage for cached data
> bcache backing device =3D persistent storage for data
>
> bcache migrates data from the caching device to the backing device to
> persist data and make room for new data in the cache. In write-back m=
ode it
> will persist data with a delay and with idle priority in the backgrou=
nd when
> you write to the backing device (in reality it is a bit more advanced=
 and
> complicated for performance reasons and does a very good and reliable=
 job).
> In write-through mode it will write to the caching device and the bac=
king
> device at the same time, ensuring that data is persisted to the backi=
ng
> device when the kernel acknowledges the process that data was flushed=
 and
> written. Upon re-read it is then already present in the cache. In
> write-around mode, data is never written to the cache, only to the ba=
cking
> device. Only reads will be written to the cache and can be re-read fr=
om the
> cache on successive read-requests.
>
> Write-back mode is usually safe because the caching device is journal=
led.
> Bcache will rewrite all dirty data after (unexpected) reboots to the
> persistent backing device, in fact bcache doesn't even finish writing=
 dirty
> data at shutdown as part of its design, it will always boot dirty and
> continue writing back dirty data and reliably finish filesystem
> transactions. Only when the backing device has ack'ed all data writte=
n, the
> caching data is marked clean. Here's another caveat in case of power-=
loss:
> If your hard disk ack's the data as written but internally it's still=
 in its
> cache and not yet written, and you experience a power-loss, the knowl=
edge
> from bcache about data written is inconsistent with what the harddisk=
 has
> written. To be safe, you may want to disable write-caching of your ha=
rddisks
> (with hdparm) and instead enable write-back in bcache to compensate f=
or
> that. You also may want to lower SCTERC for your harddisk (with smart=
ctl)
> from default 120s to 7s, so that sector errors become signalled to bc=
ache
> and the kernel before the SCSI layer resets, and thus bcache and your
> filesystem can reliably handle the problem. This is often a feature o=
nly of
> enterprise-grade and/or RAID-ready drives. If your drive doesn't supp=
ort it,
> you may instead want to increase your kernel SCSI timeout from defaul=
t 30s
> to something slightly above 120s. This way, you ensure that bcache is=
 safe
> even in case of hardware failures.
>
> In case of recovery (when you have to access data without the caching
> device, e.g. when the SSD has died), it is only safe to access your d=
ata
> when you didn't use write-back mode - because of the aforementioned d=
esign
> that the cache is always dirty, even after clean shutdown. Tho, in no=
rmal
> operation bcache doesn't keep dirty data around for too long. But it =
is
> filesystem-agnostic and thus doesn't know what makes up a transaction=
 on the
> filesystem, so your filesystem probably has broken meta data without
> accessing through the cache. But I think it supports write barriers, =
so if
> your filesystem does, it should be transactionally safe and you may j=
ust
> loose the last minutes of data but at least meta-data is consistent.
>
> HTH
> Kai

Very good article about Bcache in general. Thank you so much for all
these basic information.
>
> arnaud gaboury <arnaud.gaboury@gmail.com> schrieb am Mo., 6. Apr. 201=
5 um
> 12:49 Uhr:
>>
>> On Sun, Apr 5, 2015 at 11:05 PM, Kai Krakow <kai@kaishome.de> wrote:
>> > Apparently you didn't CC to the list...
>> >
>> > Subvolumes in a btrfs pool are not like volumes in a lvm pool. Bca=
che
>> > only
>> > acts on complete filesystem, thus you cannot only bcache a single
>> > subvolume.
>> > It also doesn't make sense.
>> >
>> > You usually make one single bcache caching device on SSD (make-bca=
che
>> > -C),
>> > then create backing devices on to be cached partitions (make-bcach=
e -B),
>> > and
>> > attach them to each other. Multiple backing partitions can be atta=
ched
>> > to
>> > the same single caching device. Those backing device neither need =
to
>> > have to
>> > belong to the same filesystem, neither need to have the same files=
ystem
>> > format. They can be completely unrelated. Currently, there's not m=
uch
>> > sense
>> > in using multiple caching devices (except you want to implement
>> > different
>> > caching strategies). In the future, bcache will support RAID like
>> > schemes by
>> > combining multiple caching devices.
>> >
>> > So to keep it easy, I suggest to only use one caching device (exce=
pt you
>> > have more than one SSD in which case you probably should create an=
 LVM
>> > mirror of them and create bcache on top for error resilience).
>>
>> Very good. Now I am still worried of one point I may miss.
>> My setup is this one : my root filesystem on a SSD, and an HD for
>> storing extra stuff, with an encrypted partition for DB. The idea is
>> to use SSD as caching device.
>> Bcache, I guess, like any cache: it will write data on cache. How
>> about if my caching device has already a root filesystem? Where will
>> baccahe store the data?
>> I am afraid in fact I misunderstood the whole thing and need an empt=
y
>> device? Thus my first idea to dedicate a Btrfs partition to bcache.
>>
>> Thank you for any hint how bcache will manage the cached device
>> writing and if I can use ny root filesystem or need an empty SSD (or
>> partition).
>>
>>
>> >
>> > Here's my setup, 3x btrfs mraid-1 draid-0 (sdc,sdd,sde) with one c=
aching
>> > device on SSD (sdb):
>> >
>> > $ lsblk
>> > NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
>> > sda           8:0    0   1,8T  0 disk
>> > =E2=94=94=E2=94=80sda1        8:1    0   1,8T  0 part
>> > sdb           8:16   0 119,2G  0 disk
>> > =E2=94=9C=E2=94=80sdb1        8:17   0   512M  0 part
>> > =E2=94=9C=E2=94=80sdb2        8:18   0    20G  0 part [SWAP]
>> > =E2=94=9C=E2=94=80sdb3        8:19   0  79,5G  0 part
>> > =E2=94=82 =E2=94=9C=E2=94=80bcache0 252:0    0 925,5G  0 disk
>> > =E2=94=82 =E2=94=9C=E2=94=80bcache1 252:1    0 925,5G  0 disk
>> > =E2=94=82 =E2=94=94=E2=94=80bcache2 252:2    0 925,5G  0 disk /usr=
/portage
>> > =E2=94=94=E2=94=80sdb4        8:20   0  19,2G  0 part
>> > sdc           8:32   0 931,5G  0 disk
>> > =E2=94=9C=E2=94=80sdc1        8:33   0     6G  0 part [SWAP]
>> > =E2=94=94=E2=94=80sdc2        8:34   0 925,5G  0 part
>> >   =E2=94=94=E2=94=80bcache2 252:2    0 925,5G  0 disk /usr/portage
>> > sdd           8:48   0 931,5G  0 disk
>> > =E2=94=9C=E2=94=80sdd1        8:49   0     6G  0 part [SWAP]
>> > =E2=94=94=E2=94=80sdd2        8:50   0 925,5G  0 part
>> >   =E2=94=94=E2=94=80bcache0 252:0    0 925,5G  0 disk
>> > sde           8:64   0 931,5G  0 disk
>> > =E2=94=9C=E2=94=80sde1        8:65   0     6G  0 part [SWAP]
>> > =E2=94=94=E2=94=80sde2        8:66   0 925,5G  0 part
>> >   =E2=94=94=E2=94=80bcache1 252:1    0 925,5G  0 disk
>> >
>> > Ignore the mount points, they are more or less bogus with btrfs si=
nce
>> > lsblk
>> > is not able to differentiate multiple device setups and multiple
>> > subvolumes
>> > correctly. I'm running my rootfs from this setup. Bcache{0,1,2} be=
long
>> > to
>> > the same filesystem.
>> >
>> > arnaud gaboury <arnaud.gaboury@gmail.com> schrieb am So., 5. Apr. =
2015
>> > um
>> > 21:40 Uhr:
>> >>
>> >> On Sun, Apr 5, 2015 at 5:23 PM, Kai Krakow <kai@kaishome.de> wrot=
e:
>> >> > arnaud gaboury <arnaud.gaboury@gmail.com> schrieb:
>> >> >
>> >> >> Here is what I did:
>> >> >>  # make-bcache -C /dev/sdb1
>> >> >>  # echo "UUID" > /sys/block/bcache0/bcache/attach
>> >> >> --------------------------------------
>> >> >> $ lsblk -o
>> >> >> .......................
>> >> >> sdb                      sdb
>> >> >> =E2=94=94=E2=94=80sdb1                   sdb1    bcache
>> >> >>   =E2=94=94=E2=94=80bcache0              bcache0
>> >> >> --------------------------------
>> >> >> # mkfs.btrfs -L poppy-root /dev/sdb1
>> >> >> /dev/sdb1 appears to contain an existing filesystem (bcache).
>> >> >> Error: Use the -f option to force overwrite.
>> >> >>
>> >> >>
>> >> >> Please may you tell what is wrong and how can I make btrfs on
>> >> >> bcached
>> >> >> partition?
>> >> >
>> >> > You need to mkfs on /dev/bcache0. Bcache itself reserves the
>> >> > partition
>> >> > with
>> >> > its own superblock and creates a subdevice so you cannot accide=
ntly
>> >> > access
>> >> > the data without passing through the cache layer. This means yo=
u will
>> >> > also
>> >> > mount /dev/bcache0 as your btrfs in fstab (or simply use
>> >> > LABEL=3Dpoppy-root or
>> >> > /dev/disk/by-label/...).
>> >>
>> >> Thank you for hint. I finally managed to do it with /dev/bcache0
>> >> =E2=94=94=E2=94=80sdd4                   sdd4      8:52  bcache
>> >>   =E2=94=94=E2=94=80bcache1              bcache1 254:1   crypto_L=
UKS
>> >>     =E2=94=94=E2=94=80sdd4_crypt         dm-8    253:8   btrfs   =
    poppy-encrypt
>> >>
>> >> Curious to see if the above setup will survive.
>> >>
>> >> Now I am trying to set up my caching device, on a ssd. I of cours=
e can
>> >> bcache the whole device:
>> >> =E2=94=94=E2=94=80sdb2                   sdb2      8:18  bcache
>> >>   =E2=94=94=E2=94=80bcache0              bcache0 254:0   btrfs   =
    poppy-root
>> >> But his ssd will in fact be my root file system. So I decided to
>> >> create some btrfs subvolumes, with one for caching.
>> >> gabx@hortensia =E2=9E=A4=E2=9E=A4 ~ % sudo btrfs subvolume list /=
mnt/btrfs
>> >> ID 257 gen 7 top level 5 path var
>> >> ID 258 gen 8 top level 5 path home
>> >> ID 259 gen 9 top level 5 path root
>> >> ID 260 gen 10 top level 5 path cache
>> >>
>> >> Now I want (if possible) blocks to-bache only the cache subvolume=
=2E
>> >> Obviously, # blocks to-bcache /mnt/backup/cache  does not work.
>> >>
>> >> Is it possible to achieve caching only a btrfs subvolume? If yes,
>> >> against what shall I run the to-bcache command?
>> >>
>> >> Thank you much for your help. Took me very long to achieve the wh=
ole
>> >> setup!
>> >>
>> >>
>> >> >
>> >> > If you already overwrote something, I suggest to wipefs first o=
n the
>> >> > partitions, otherwise the kernel may accidently misdetect files=
ystems
>> >> > that
>> >> > are no longer there.
>> >> >
>> >> > --
>> >> > Replies to list only preferred.
>> >>
>> >>
>> >>
>> >> --
>> >>
>> >> google.com/+arnaudgabourygabx
>>
