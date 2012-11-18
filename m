From: James Sefton <james-3k2nYdb70uTQXOPxS62xeg@public.gmane.org>
Subject: RE: Problem building kernel 3.2
Date: Sun, 18 Nov 2012 18:11:57 +0000
Message-ID: <93462A6BCE1CD840B94554FBBEE4C936030AF66DC5@THHS2E12BE8X.hostedservice2.net>
References: <CAMx1jcZqDn5vUFh52Za6o_gnUfhEOduFemxD7DMhQeoYt3up2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAMx1jcZqDn5vUFh52Za6o_gnUfhEOduFemxD7DMhQeoYt3up2w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vegard Hansen <vegard.x-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-bcache <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hi Vegard,

I was messing around with this a few weeks ago and had a similar error.
I seem to remember I got around it by messing around with the options selected when running make menuconfig.

In the section where you enable the bcache features, I think there are a series of sub-items. (some for debugging, and a few others iirc)
I got it to compile by removing all sub-options and just leaving the main bcache component included in the build.

I am sure someone will correct me if I am way off.

Hope it helps a little.

James

-----Original Message-----
From: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Vegard Hansen
Sent: 18 November 2012 18:08
To: linux-bcache
Subject: Problem building kernel 3.2

Hi,

Using Debian Wheezy I'm having truble building linux-bcache. Using the old config from debian wheezy when selecting modules. I can add the config if you need that too.

Using v3.2-2173-gcafb412 (bcache-3.2):
root@foo:~/linux-bcache# make
scripts/kconfig/conf --silentoldconfig Kconfig
make[1]: Nothing to be done for `relocs'.
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  VDSOSYM arch/x86/vdso/vdso-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-int80-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-syscall-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-sysenter-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-syms.lds
  LD      arch/x86/vdso/built-in.o
  LD      arch/x86/built-in.o
  CC      fs/bio.o
  LD      fs/built-in.o
  CC      block/blk-core.o
  LD      block/built-in.o
  CC      drivers/md/bcache/writeback.o
  CC      drivers/md/bcache/request.o
drivers/md/bcache/request.c: In function 'bio_to_cgroup':
drivers/md/bcache/request.c:40:2: error: implicit declaration of function 'get_bio_cgroup' [-Werror=implicit-function-declaration]
drivers/md/bcache/request.c:40:2: warning: passing argument 1 of 'cgroup_to_bcache' makes pointer from integer without a cast [enabled by default]
drivers/md/bcache/request.c:29:20: note: expected 'struct cgroup *'
but argument is of type 'int'
drivers/md/bcache/request.c: At top level:
drivers/md/bcache/request.c:165:2: warning: initialization from incompatible pointer type [enabled by default]
drivers/md/bcache/request.c:165:2: warning: (near initialization for
'bcache_subsys.create') [enabled by default]
drivers/md/bcache/request.c:166:2: warning: initialization from incompatible pointer type [enabled by default]
drivers/md/bcache/request.c:166:2: warning: (near initialization for
'bcache_subsys.destroy') [enabled by default]
cc1: some warnings being treated as errors
make[3]: *** [drivers/md/bcache/request.o] Error 1
make[2]: *** [drivers/md/bcache] Error 2
make[1]: *** [drivers/md] Error 2
make: *** [drivers] Error 2

Using v3.2-2166-g2a29dd2 (bcache-3.2-fixed):
root@foo:~/linux-bcache# make
make[1]: Nothing to be done for `relocs'.
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  VDSOSYM arch/x86/vdso/vdso-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-int80-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-syscall-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-sysenter-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-syms.lds
  LD      arch/x86/vdso/built-in.o
  LD      arch/x86/built-in.o
  CC      fs/bio.o
  LD      fs/built-in.o
  CC      block/blk-core.o
  LD      block/built-in.o
  CC      drivers/md/bcache/writeback.o
  CC      drivers/md/bcache/request.o
drivers/md/bcache/request.c: In function 'bio_to_cgroup':
drivers/md/bcache/request.c:40:2: error: implicit declaration of function 'get_bio_cgroup' [-Werror=implicit-function-declaration]
drivers/md/bcache/request.c:40:2: warning: passing argument 1 of 'cgroup_to_bcache' makes pointer from integer without a cast [enabled by default]
drivers/md/bcache/request.c:29:20: note: expected 'struct cgroup *'
but argument is of type 'int'
drivers/md/bcache/request.c: At top level:
drivers/md/bcache/request.c:165:2: warning: initialization from incompatible pointer type [enabled by default]
drivers/md/bcache/request.c:165:2: warning: (near initialization for
'bcache_subsys.create') [enabled by default]
drivers/md/bcache/request.c:166:2: warning: initialization from incompatible pointer type [enabled by default]
drivers/md/bcache/request.c:166:2: warning: (near initialization for
'bcache_subsys.destroy') [enabled by default]
cc1: some warnings being treated as errors
make[3]: *** [drivers/md/bcache/request.o] Error 1
make[2]: *** [drivers/md/bcache] Error 2
make[1]: *** [drivers/md] Error 2
make: *** [drivers] Error 2

--
Med vennlig hilsen
Vegard Hansen
Mob.: (+47) 9110 1337
--
To unsubscribe from this list: send the line "unsubscribe linux-bcache" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
