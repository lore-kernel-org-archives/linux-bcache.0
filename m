From: =?UTF-8?B?0JPQtdC+0YDQs9C40Lkg0KHRgtCw0YDQuNC60L7Qsg==?=
	<gstarikov@gmail.com>
Subject: Fwd: cant mount bcachefs
Date: Wed, 29 Jul 2015 20:36:51 +0300
Message-ID: <CAOOKTyC1Xa2PKpZH1R5s-n9nSLpSOd=7su0SDh9dkQ-D6zjceA@mail.gmail.com>
References: <CAOOKTyBohkud24RBZegyHhEqpo+FV6H-o2MgPyr+CVvSvc1s-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:38201 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbbG2Rgx (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 29 Jul 2015 13:36:53 -0400
Received: by wibxm9 with SMTP id xm9so36566463wib.1
        for <linux-bcache@vger.kernel.org>; Wed, 29 Jul 2015 10:36:52 -0700 (PDT)
In-Reply-To: <CAOOKTyBohkud24RBZegyHhEqpo+FV6H-o2MgPyr+CVvSvc1s-A@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello,
I followed instruction at http://bcache.evilpiepirate.org/ and it cant mount...
What I'm doing wrong?


I make:

git clone -b bcache-dev http://evilpiepirate.org/git/linux-bcache.git
git clone -b dev http://evilpiepirate.org/git/bcache-tools.git

cd bcache-tools/linux-bcache/
make oldconfig
make -j6 deb-pkg
make -j6 modules_install
make -j6 install
reboot

wipefs -a /dev/sdd

Then, just run

bcacheadm format -C /dev/sdd
strace -v -o bcache_mount_strace.txt mount /dev/sdd /test_bcachefs

and it hangup....

root@bcache:~# tail bcache_mount_strace.txt
geteuid()                               = 0
getgid()                                = 0
getegid()                               = 0
prctl(PR_GET_DUMPABLE)                  = 1
stat("/run", {st_dev=makedev(0, 18), st_ino=2625,
st_mode=S_IFDIR|0755, st_nlink=23, st_uid=0, st_gid=0,
st_blksize=4096, st_blocks=0, st_size=740,
st_atime=2015/07/17-13:07:47, st_mtime=2015/07/29-14:20:25,
st_ctime=2015/07/29-14:20:25}) = 0
lstat("/etc/mtab", {st_dev=makedev(8, 1), st_ino=131233,
st_mode=S_IFLNK|0777, st_nlink=1, st_uid=0, st_gid=0, st_blksize=4096,
st_blocks=0, st_size=12, st_atime=2015/07/29-06:40:34,
st_mtime=2015/07/12-10:40:12, st_ctime=2015/07/12-10:40:12}) = 0
lstat("/run/mount/utab", {st_dev=makedev(0, 18), st_ino=1968,
st_mode=S_IFREG|0644, st_nlink=1, st_uid=0, st_gid=0, st_blksize=4096,
st_blocks=0, st_size=0, st_atime=2015/07/17-13:10:49,
st_mtime=2015/07/17-13:10:49, st_ctime=2015/07/17-13:10:49}) = 0
open("/run/mount/utab", O_RDWR|O_CREAT|O_CLOEXEC, 0644) = 3
close(3)                                = 0
mount("/dev/sdd", "/test_bcachefs", "bcache", MS_MGC_VAL, NULL
