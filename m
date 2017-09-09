From: do xing Chiang <hermeseagle@gmail.com>
Subject: BCACHE Can't on CENTOS6.9
Date: Sat, 9 Sep 2017 16:39:31 +0800
Message-ID: <CAGusKs+K5scp8g2WKogF_S3uukBkpuAbr_eC0FFJYryno+pXHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pg0-f45.google.com ([74.125.83.45]:33139 "EHLO
        mail-pg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755672AbdIIIjc (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 9 Sep 2017 04:39:32 -0400
Received: by mail-pg0-f45.google.com with SMTP id t3so8292610pgt.0
        for <linux-bcache@vger.kernel.org>; Sat, 09 Sep 2017 01:39:32 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Dear ALL:
I have Problem With bcache-tools  compile , I got a problem with a new
upgrade kernel from 2.6.x to  4.4.13 on Centos 6.9
but my Base is on Centos 6.9 , it means a lot of libs are old for BCACHE .
Bcache was introduce in Kernel 3.X
When I compiled bcache-tools
it happened


alhost ~]# gcc -v
Using built-in specs.
COLLECT_GCC=3Dgcc
COLLECT_LTO_WRAPPER=3D/opt/rh/devtoolset-3/root/usr/libexec/gcc/x86_64-redh=
at-linux/4.9.2/lto-wrapper
Target: x86_64-redhat-linux
Configured with: ../configure --prefix=3D/opt/rh/devtoolset-3/root/usr
--mandir=3D/opt/rh/devtoolset-3/root/usr/share/man
--infodir=3D/opt/rh/devtoolset-3/root/usr/share/info
--with-bugurl=3Dhttp://bugzilla.redhat.com/bugzilla --enable-bootstrap
--enable-shared --enable-threads=3Dposix --enable-checking=3Drelease
--enable-multilib --with-system-zlib --enable-__cxa_atexit
--disable-libunwind-exceptions --enable-gnu-unique-object
--enable-linker-build-id --enable-languages=3Dc,c++,fortran,lto
--enable-plugin --with-linker-hash-style=3Dgnu --enable-initfini-array
--disable-libgcj
--with-isl=3D/builddir/build/BUILD/gcc-4.9.2-20150212/obj-x86_64-redhat-lin=
ux/isl-install
--with-cloog=3D/builddir/build/BUILD/gcc-4.9.2-20150212/obj-x86_64-redhat-l=
inux/cloog-install
--with-mpc=3D/builddir/build/BUILD/gcc-4.9.2-20150212/obj-x86_64-redhat-lin=
ux/mpc-install
--with-tune=3Dgeneric --with-arch_32=3Di686 --build=3Dx86_64-redhat-linux
Thread model: posix
gcc version 4.9.2 20150212 (Red Hat 4.9.2-6) (GCC)



[root@localhost ~]# cd bcachefs-tools/
[root@localhost bcachefs-tools]# make
cc -std=3Dgnu89 -O2 -g -MMD -Wall -Wno-pointer-sign -fno-strict-aliasing
-I. -Iinclude -Ilibbcachefs -D_FILE_OFFSET_BITS=3D64 -D_GNU_SOURCE
-D_LGPL_SOURCE -DRCU_MEMBARRIER -DNO_BCACHE_CHARDEV -DNO_BCACHE_FS
-DNO_BCACHE_SYSFS  -Wno-unused-but-set-variable -flto `pkg-config
--cflags "blkid uuid liburcu libsodium zlib"`   -c -o bcachefs.o
bcachefs.c
In file included from tools-util.h:15:0,
                 from cmds.h:10,
                 from bcachefs.c:24:
include/linux/log2.h:188:1: error: expected =E2=80=98=3D=E2=80=99, =E2=80=
=98,=E2=80=99, =E2=80=98;=E2=80=99, =E2=80=98asm=E2=80=99 or
=E2=80=98__attribute__=E2=80=99 before =E2=80=98int=E2=80=99
 int __get_order(unsigned long size)
 ^
make: *** [bcachefs.o] Error 1


--=20
Regards
Hermes Chiang =E8=94=A3=E6=9D=B1=E6=96=B0
Certificated SCSA, Sun Soliars ,
Expired Certification CCNA
Certification  OCP -DATABASE, OCA-DATABASE,OCA-SQL EXPERT
