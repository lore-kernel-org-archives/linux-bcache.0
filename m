From: Coly Li <i@coly.li>
Subject: Re: BCACHE Can't on CENTOS6.9
Date: Sat, 9 Sep 2017 20:36:30 +0800
Message-ID: <eae298fa-c38b-0741-b030-2e6bf425dd4c@coly.li>
References: <CAGusKs+K5scp8g2WKogF_S3uukBkpuAbr_eC0FFJYryno+pXHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:45716 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753519AbdIIMgl (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 9 Sep 2017 08:36:41 -0400
In-Reply-To: <CAGusKs+K5scp8g2WKogF_S3uukBkpuAbr_eC0FFJYryno+pXHA@mail.gmail.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: do xing Chiang <hermeseagle@gmail.com>, linux-bcache@vger.kernel.org

On 2017/9/9 下午4:39, do xing Chiang wrote:
> Dear ALL:
> I have Problem With bcache-tools  compile , I got a problem with a new
> upgrade kernel from 2.6.x to  4.4.13 on Centos 6.9
> but my Base is on Centos 6.9 , it means a lot of libs are old for BCACHE .
> Bcache was introduce in Kernel 3.X
> When I compiled bcache-tools
> it happened
> 
> 
> alhost ~]# gcc -v
> Using built-in specs.
> COLLECT_GCC=gcc
> COLLECT_LTO_WRAPPER=/opt/rh/devtoolset-3/root/usr/libexec/gcc/x86_64-redhat-linux/4.9.2/lto-wrapper
> Target: x86_64-redhat-linux
> Configured with: ../configure --prefix=/opt/rh/devtoolset-3/root/usr
> --mandir=/opt/rh/devtoolset-3/root/usr/share/man
> --infodir=/opt/rh/devtoolset-3/root/usr/share/info
> --with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-bootstrap
> --enable-shared --enable-threads=posix --enable-checking=release
> --enable-multilib --with-system-zlib --enable-__cxa_atexit
> --disable-libunwind-exceptions --enable-gnu-unique-object
> --enable-linker-build-id --enable-languages=c,c++,fortran,lto
> --enable-plugin --with-linker-hash-style=gnu --enable-initfini-array
> --disable-libgcj
> --with-isl=/builddir/build/BUILD/gcc-4.9.2-20150212/obj-x86_64-redhat-linux/isl-install
> --with-cloog=/builddir/build/BUILD/gcc-4.9.2-20150212/obj-x86_64-redhat-linux/cloog-install
> --with-mpc=/builddir/build/BUILD/gcc-4.9.2-20150212/obj-x86_64-redhat-linux/mpc-install
> --with-tune=generic --with-arch_32=i686 --build=x86_64-redhat-linux
> Thread model: posix
> gcc version 4.9.2 20150212 (Red Hat 4.9.2-6) (GCC)
> 
> 
> 
> [root@localhost ~]# cd bcachefs-tools/
> [root@localhost bcachefs-tools]# make
> cc -std=gnu89 -O2 -g -MMD -Wall -Wno-pointer-sign -fno-strict-aliasing
> -I. -Iinclude -Ilibbcachefs -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
> -D_LGPL_SOURCE -DRCU_MEMBARRIER -DNO_BCACHE_CHARDEV -DNO_BCACHE_FS
> -DNO_BCACHE_SYSFS  -Wno-unused-but-set-variable -flto `pkg-config
> --cflags "blkid uuid liburcu libsodium zlib"`   -c -o bcachefs.o
> bcachefs.c
> In file included from tools-util.h:15:0,
>                  from cmds.h:10,
>                  from bcachefs.c:24:
> include/linux/log2.h:188:1: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or
> ‘__attribute__’ before ‘int’
>  int __get_order(unsigned long size)
>  ^
> make: *** [bcachefs.o] Error 1
> 
> 
It seems you are compiling bcachefs-tool. But you ask for bcache-tool.
Which one do you exactly want to run ?

-- 
Coly Li
