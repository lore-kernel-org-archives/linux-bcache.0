From: Ming Lin <mlin@kernel.org>
Subject: Re: cant mount bcachefs
Date: Wed, 29 Jul 2015 13:16:45 -0700
Message-ID: <CAF1ivSZ_R-NBfLP6p3_G1kyAr2iZJeDMbxvs7CC9xCS4A8CsVg@mail.gmail.com>
References: <CAOOKTyBohkud24RBZegyHhEqpo+FV6H-o2MgPyr+CVvSvc1s-A@mail.gmail.com>
	<CAOOKTyC1Xa2PKpZH1R5s-n9nSLpSOd=7su0SDh9dkQ-D6zjceA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35001 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbbG2UQt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 29 Jul 2015 16:16:49 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C267E2064B
	for <linux-bcache@vger.kernel.org>; Wed, 29 Jul 2015 20:16:47 +0000 (UTC)
Received: from mail-vk0-f51.google.com (mail-vk0-f51.google.com [209.85.213.51])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 9595720457
	for <linux-bcache@vger.kernel.org>; Wed, 29 Jul 2015 20:16:46 +0000 (UTC)
Received: by vkhg129 with SMTP id g129so3647775vkh.2
        for <linux-bcache@vger.kernel.org>; Wed, 29 Jul 2015 13:16:45 -0700 (PDT)
In-Reply-To: <CAOOKTyC1Xa2PKpZH1R5s-n9nSLpSOd=7su0SDh9dkQ-D6zjceA@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: =?UTF-8?B?0JPQtdC+0YDQs9C40Lkg0KHRgtCw0YDQuNC60L7Qsg==?= <gstarikov@gmail.com>
Cc: linux-bcache@vger.kernel.org

On Wed, Jul 29, 2015 at 10:36 AM, =D0=93=D0=B5=D0=BE=D1=80=D0=B3=D0=B8=D0=
=B9 =D0=A1=D1=82=D0=B0=D1=80=D0=B8=D0=BA=D0=BE=D0=B2 <gstarikov@gmail.c=
om> wrote:
> Hello,
> I followed instruction at http://bcache.evilpiepirate.org/ and it can=
t mount...
> What I'm doing wrong?
>
>
> I make:
>
> git clone -b bcache-dev http://evilpiepirate.org/git/linux-bcache.git
> git clone -b dev http://evilpiepirate.org/git/bcache-tools.git
>
> cd bcache-tools/linux-bcache/
> make oldconfig
> make -j6 deb-pkg
> make -j6 modules_install
> make -j6 install
> reboot
>
> wipefs -a /dev/sdd
>
> Then, just run
>
> bcacheadm format -C /dev/sdd
> strace -v -o bcache_mount_strace.txt mount /dev/sdd /test_bcachefs
>
> and it hangup....

Any message in dmesg?

Could you do:

cat  /proc/`pidof mount`/stack

>
> root@bcache:~# tail bcache_mount_strace.txt
> geteuid()                               =3D 0
> getgid()                                =3D 0
> getegid()                               =3D 0
> prctl(PR_GET_DUMPABLE)                  =3D 1
> stat("/run", {st_dev=3Dmakedev(0, 18), st_ino=3D2625,
> st_mode=3DS_IFDIR|0755, st_nlink=3D23, st_uid=3D0, st_gid=3D0,
> st_blksize=3D4096, st_blocks=3D0, st_size=3D740,
> st_atime=3D2015/07/17-13:07:47, st_mtime=3D2015/07/29-14:20:25,
> st_ctime=3D2015/07/29-14:20:25}) =3D 0
> lstat("/etc/mtab", {st_dev=3Dmakedev(8, 1), st_ino=3D131233,
> st_mode=3DS_IFLNK|0777, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blks=
ize=3D4096,
> st_blocks=3D0, st_size=3D12, st_atime=3D2015/07/29-06:40:34,
> st_mtime=3D2015/07/12-10:40:12, st_ctime=3D2015/07/12-10:40:12}) =3D =
0
> lstat("/run/mount/utab", {st_dev=3Dmakedev(0, 18), st_ino=3D1968,
> st_mode=3DS_IFREG|0644, st_nlink=3D1, st_uid=3D0, st_gid=3D0, st_blks=
ize=3D4096,
> st_blocks=3D0, st_size=3D0, st_atime=3D2015/07/17-13:10:49,
> st_mtime=3D2015/07/17-13:10:49, st_ctime=3D2015/07/17-13:10:49}) =3D =
0
> open("/run/mount/utab", O_RDWR|O_CREAT|O_CLOEXEC, 0644) =3D 3
> close(3)                                =3D 0
> mount("/dev/sdd", "/test_bcachefs", "bcache", MS_MGC_VAL, NULL
