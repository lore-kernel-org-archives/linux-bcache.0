From: =?UTF-8?B?0JPQtdC+0YDQs9C40Lkg0KHRgtCw0YDQuNC60L7Qsg==?=
	<gstarikov@gmail.com>
Subject: Re: cant mount bcachefs
Date: Thu, 30 Jul 2015 03:05:46 +0300
Message-ID: <CAOOKTyBPL_fp80pax79t9v7+Ct+mFGg7+_L9ix2tpbfwg654Tg@mail.gmail.com>
References: <CAOOKTyBohkud24RBZegyHhEqpo+FV6H-o2MgPyr+CVvSvc1s-A@mail.gmail.com>
	<CAOOKTyC1Xa2PKpZH1R5s-n9nSLpSOd=7su0SDh9dkQ-D6zjceA@mail.gmail.com>
	<CAF1ivSZ_R-NBfLP6p3_G1kyAr2iZJeDMbxvs7CC9xCS4A8CsVg@mail.gmail.com>
	<CAOOKTyAb5Es0Wb=CTF0DeiUzkYvqjw0we0j_z6L+vbRqR1zvnw@mail.gmail.com>
	<CAF1ivSagk2UWnx81XDhhS=sa3FezZVu11N06obbBMd_dtSS5PA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:38668 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217AbbG3AFs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 29 Jul 2015 20:05:48 -0400
Received: by wibxm9 with SMTP id xm9so47017982wib.1
        for <linux-bcache@vger.kernel.org>; Wed, 29 Jul 2015 17:05:46 -0700 (PDT)
In-Reply-To: <CAF1ivSagk2UWnx81XDhhS=sa3FezZVu11N06obbBMd_dtSS5PA@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: linux-bcache@vger.kernel.org

thank you! it's working!

2015-07-30 2:09 GMT+03:00 Ming Lin <mlin@kernel.org>:
> On Wed, Jul 29, 2015 at 3:36 PM, =D0=93=D0=B5=D0=BE=D1=80=D0=B3=D0=B8=
=D0=B9 =D0=A1=D1=82=D0=B0=D1=80=D0=B8=D0=BA=D0=BE=D0=B2 <gstarikov@gmai=
l.com> wrote:
>> there is no messages in dmesg in case of mount attempt.
>> after reboot dmesg contain many messages like this one:
>
> I just tried to boot old bcache device with bcachefs kernel and it lo=
cked too.
> If you just want to have a try bcachefs, you can do below to disable
> register the old bcache device.
>
> root@bee:/lib/udev/rules.d# ls *bcache*
> 69-bcache.rules
> root@bee:/lib/udev/rules.d# mv 69-bcache.rules 69-bcache.rules.bak
> root@bee:/lib/udev/rules.d# ls *bcache*
> 69-bcache.rules.bak
>
>
>> [=D0=9F=D1=82. =D0=B8=D1=8E=D0=BB=D1=8F 17 13:11:50 2015] INFO: task=
 bcache-register:340 blocked for
>> more than 120 seconds.
>> [=D0=9F=D1=82. =D0=B8=D1=8E=D0=BB=D1=8F 17 13:11:50 2015]       Tain=
ted: G            E   4.1.0+ #1
>> [=D0=9F=D1=82. =D0=B8=D1=8E=D0=BB=D1=8F 17 13:11:50 2015] "echo 0 >
>> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> [=D0=9F=D1=82. =D0=B8=D1=8E=D0=BB=D1=8F 17 13:11:50 2015] bcache-reg=
ister D ffff88005fa0fbf8     0
>> 340      1 0x00000004
>> [=D0=9F=D1=82. =D0=B8=D1=8E=D0=BB=D1=8F 17 13:11:50 2015]  ffff88005=
fa0fbf8 ffffffff81c14580
>> ffff88002d961420 ffff88005fa0fc28
>> [=D0=9F=D1=82. =D0=B8=D1=8E=D0=BB=D1=8F 17 13:11:50 2015]  ffff88005=
fa10000 ffffffffc02536a4
>> ffff88002d961420 00000000ffffffff
>> [=D0=9F=D1=82. =D0=B8=D1=8E=D0=BB=D1=8F 17 13:11:50 2015]  ffffffffc=
02536a8 ffff88005fa0fc18
>> ffffffff817d9367 ffff88006d260010
>> [=D0=9F=D1=82. =D0=B8=D1=8E=D0=BB=D1=8F 17 13:11:50 2015] Call Trace=
:
>> [=D0=9F=D1=82. =D0=B8=D1=8E=D0=BB=D1=8F 17 13:11:50 2015]  [<fffffff=
f817d9367>] schedule+0x37/0x90
>> [=D0=9F=D1=82. =D0=B8=D1=8E=D0=BB=D1=8F 17 13:11:50 2015]  [<fffffff=
f817d96fe>]
>> schedule_preempt_disabled+0xe/0x10
>> [=D0=9F=D1=82. =D0=B8=D1=8E=D0=BB=D1=8F 17 13:11:50 2015]  [<fffffff=
f817db4f5>]
>> __mutex_lock_slowpath+0x95/0x110
>> [=D0=9F=D1=82. =D0=B8=D1=8E=D0=BB=D1=8F 17 13:11:50 2015]  [<fffffff=
f817d5487>] ? printk+0x46/0x48
>> [=D0=9F=D1=82. =D0=B8=D1=8E=D0=BB=D1=8F 17 13:11:50 2015]  [<fffffff=
f817db593>] mutex_lock+0x23/0x40
>> [=D0=9F=D1=82. =D0=B8=D1=8E=D0=BB=D1=8F 17 13:11:50 2015]  [<fffffff=
fc01f70bc>]
>> bch_backing_dev_register+0x3ac/0x430 [bcache]
>> [=D0=9F=D1=82. =D0=B8=D1=8E=D0=BB=D1=8F 17 13:11:50 2015]  [<fffffff=
fc022d0e5>]
>> bch_register_one+0xf5/0x310 [bcache]
>> [=D0=9F=D1=82. =D0=B8=D1=8E=D0=BB=D1=8F 17 13:11:50 2015]  [<fffffff=
fc022d362>]
>> register_bcache+0x62/0xd0 [bcache]
>> [=D0=9F=D1=82. =D0=B8=D1=8E=D0=BB=D1=8F 17 13:11:50 2015]  [<fffffff=
f81278c57>] kernfs_fop_write+0x127/0x180
>> [=D0=9F=D1=82. =D0=B8=D1=8E=D0=BB=D1=8F 17 13:11:50 2015]  [<fffffff=
f811fc6f8>] __vfs_write+0x28/0xf0
>> [=D0=9F=D1=82. =D0=B8=D1=8E=D0=BB=D1=8F 17 13:11:50 2015]  [<fffffff=
f811ff3ac>] ? __sb_start_write+0x4c/0x100
>> [=D0=9F=D1=82. =D0=B8=D1=8E=D0=BB=D1=8F 17 13:11:50 2015]  [<fffffff=
f81322343>] ?
>> security_file_permission+0x23/0xa0
>> [=D0=9F=D1=82. =D0=B8=D1=8E=D0=BB=D1=8F 17 13:11:50 2015]  [<fffffff=
f811fce29>] vfs_write+0xa9/0x1b0
>> [=D0=9F=D1=82. =D0=B8=D1=8E=D0=BB=D1=8F 17 13:11:50 2015]  [<fffffff=
f811fdbf6>] SyS_write+0x46/0xb0
>> [=D0=9F=D1=82. =D0=B8=D1=8E=D0=BB=D1=8F 17 13:11:50 2015]  [<fffffff=
f81066f3f>] ? do_page_fault+0x2f/0x80
>> [=D0=9F=D1=82. =D0=B8=D1=8E=D0=BB=D1=8F 17 13:11:50 2015]  [<fffffff=
f817dd932>] system_call_fastpath+0x16/0x75
>>
>>
>> root@bcache:~# ps -ax | grep mount
>>   999 ?        D      0:00 mount /dev/sdb /test_bcachefs/
>>  1731 ?        S      0:00 strace -v mount /dev/sdd /test_bcachefs
>>  1734 ?        D      0:00 mount /dev/sdd /test_bcachefs
>>  1746 ?        S      0:00 strace -v -o bcache_mount_strace.txt moun=
t
>> /dev/sdd /test_bcachefs
>>  1749 ?        D      0:00 mount /dev/sdd /test_bcachefs
>>  2062 ?        D      0:00 mount -t bcache /dev/sdd /test_bcachefs
>>  2197 pts/3    D+     0:00 mount /dev/sdd /test_bcachefs
>>
>> root@bcache:~# cat /proc/999/stack
>> [<ffffffffc0229f01>] read_super+0x2d1/0x420 [bcache]
>> [<ffffffffc022ce24>] bch_register_cache_set+0x104/0x2d0 [bcache]
>> [<ffffffffc02146b3>] bch_mount+0x123/0x330 [bcache]
>> [<ffffffff81200c78>] mount_fs+0x38/0x190
>> [<ffffffff8121d65b>] vfs_kern_mount+0x6b/0x120
>> [<ffffffff81220654>] do_mount+0x204/0xb60
>> [<ffffffff812212cb>] SyS_mount+0x8b/0xd0
>> [<ffffffff817dd932>] system_call_fastpath+0x16/0x75
>> [<ffffffffffffffff>] 0xffffffffffffffff
>>
>>
>> root@bcache:~# cat /proc/2197/stack
>> [<ffffffffc0229f01>] read_super+0x2d1/0x420 [bcache]
>> [<ffffffffc022ce24>] bch_register_cache_set+0x104/0x2d0 [bcache]
>> [<ffffffffc02146b3>] bch_mount+0x123/0x330 [bcache]
>> [<ffffffff81200c78>] mount_fs+0x38/0x190
>> [<ffffffff8121d65b>] vfs_kern_mount+0x6b/0x120
>> [<ffffffff81220654>] do_mount+0x204/0xb60
>> [<ffffffff812212cb>] SyS_mount+0x8b/0xd0
>> [<ffffffff817dd932>] system_call_fastpath+0x16/0x75
>> [<ffffffffffffffff>] 0xffffffffffffffff
>>
>> 2015-07-29 23:16 GMT+03:00 Ming Lin <mlin@kernel.org>:
>>> On Wed, Jul 29, 2015 at 10:36 AM, =D0=93=D0=B5=D0=BE=D1=80=D0=B3=D0=
=B8=D0=B9 =D0=A1=D1=82=D0=B0=D1=80=D0=B8=D0=BA=D0=BE=D0=B2 <gstarikov@g=
mail.com> wrote:
>>>> Hello,
>>>> I followed instruction at http://bcache.evilpiepirate.org/ and it =
cant mount...
>>>> What I'm doing wrong?
>>>>
>>>>
>>>> I make:
>>>>
>>>> git clone -b bcache-dev http://evilpiepirate.org/git/linux-bcache.=
git
>>>> git clone -b dev http://evilpiepirate.org/git/bcache-tools.git
>>>>
>>>> cd bcache-tools/linux-bcache/
>>>> make oldconfig
>>>> make -j6 deb-pkg
>>>> make -j6 modules_install
>>>> make -j6 install
>>>> reboot
>>>>
>>>> wipefs -a /dev/sdd
>>>>
>>>> Then, just run
>>>>
>>>> bcacheadm format -C /dev/sdd
>>>> strace -v -o bcache_mount_strace.txt mount /dev/sdd /test_bcachefs
>>>>
>>>> and it hangup....
>>>
>>> Any message in dmesg?
>>>
>>> Could you do:
>>>
>>> cat  /proc/`pidof mount`/stack
>>>
>>>>
>>>> root@bcache:~# tail bcache_mount_strace.txt
>>>> geteuid()                               =3D 0
>>>> getgid()                                =3D 0
>>>> getegid()                               =3D 0
>>>> prctl(PR_GET_DUMPABLE)                  =3D 1
>>>> stat("/run", {st_dev=3Dmakedev(0, 18), st_ino=3D2625,
>>>> st_mode=3DS_IFDIR|0755, st_nlink=3D23, st_uid=3D0, st_gid=3D0,
>>>> st_blksize=3D4096, st_blocks=3D0, st_size=3D740,
>>>> st_atime=3D2015/07/17-13:07:47, st_mtime=3D2015/07/29-14:20:25,
>>>> st_ctime=3D2015/07/29-14:20:25}) =3D 0
>>>> lstat("/etc/mtab", {st_dev=3Dmakedev(8, 1), st_ino=3D131233,
>>>> st_mode=3DS_IFLNK|0777, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_b=
lksize=3D4096,
>>>> st_blocks=3D0, st_size=3D12, st_atime=3D2015/07/29-06:40:34,
>>>> st_mtime=3D2015/07/12-10:40:12, st_ctime=3D2015/07/12-10:40:12}) =3D=
 0
>>>> lstat("/run/mount/utab", {st_dev=3Dmakedev(0, 18), st_ino=3D1968,
>>>> st_mode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_b=
lksize=3D4096,
>>>> st_blocks=3D0, st_size=3D0, st_atime=3D2015/07/17-13:10:49,
>>>> st_mtime=3D2015/07/17-13:10:49, st_ctime=3D2015/07/17-13:10:49}) =3D=
 0
>>>> open("/run/mount/utab", O_RDWR|O_CREAT|O_CLOEXEC, 0644) =3D 3
>>>> close(3)                                =3D 0
>>>> mount("/dev/sdd", "/test_bcachefs", "bcache", MS_MGC_VAL, NULL
