From: Vegard Hansen <vegard.x-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Problem building kernel 3.2
Date: Sun, 18 Nov 2012 19:07:41 +0100
Message-ID: <CAMx1jcZqDn5vUFh52Za6o_gnUfhEOduFemxD7DMhQeoYt3up2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hi,

Using Debian Wheezy I'm having truble building linux-bcache. Using the
old config from debian wheezy when selecting modules. I can add the
config if you need that too.

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
drivers/md/bcache/request.c: In function =91bio_to_cgroup=92:
drivers/md/bcache/request.c:40:2: error: implicit declaration of
function =91get_bio_cgroup=92 [-Werror=3Dimplicit-function-declaration]
drivers/md/bcache/request.c:40:2: warning: passing argument 1 of
=91cgroup_to_bcache=92 makes pointer from integer without a cast [enabl=
ed
by default]
drivers/md/bcache/request.c:29:20: note: expected =91struct cgroup *=92
but argument is of type =91int=92
drivers/md/bcache/request.c: At top level:
drivers/md/bcache/request.c:165:2: warning: initialization from
incompatible pointer type [enabled by default]
drivers/md/bcache/request.c:165:2: warning: (near initialization for
=91bcache_subsys.create=92) [enabled by default]
drivers/md/bcache/request.c:166:2: warning: initialization from
incompatible pointer type [enabled by default]
drivers/md/bcache/request.c:166:2: warning: (near initialization for
=91bcache_subsys.destroy=92) [enabled by default]
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
drivers/md/bcache/request.c: In function =91bio_to_cgroup=92:
drivers/md/bcache/request.c:40:2: error: implicit declaration of
function =91get_bio_cgroup=92 [-Werror=3Dimplicit-function-declaration]
drivers/md/bcache/request.c:40:2: warning: passing argument 1 of
=91cgroup_to_bcache=92 makes pointer from integer without a cast [enabl=
ed
by default]
drivers/md/bcache/request.c:29:20: note: expected =91struct cgroup *=92
but argument is of type =91int=92
drivers/md/bcache/request.c: At top level:
drivers/md/bcache/request.c:165:2: warning: initialization from
incompatible pointer type [enabled by default]
drivers/md/bcache/request.c:165:2: warning: (near initialization for
=91bcache_subsys.create=92) [enabled by default]
drivers/md/bcache/request.c:166:2: warning: initialization from
incompatible pointer type [enabled by default]
drivers/md/bcache/request.c:166:2: warning: (near initialization for
=91bcache_subsys.destroy=92) [enabled by default]
cc1: some warnings being treated as errors
make[3]: *** [drivers/md/bcache/request.o] Error 1
make[2]: *** [drivers/md/bcache] Error 2
make[1]: *** [drivers/md] Error 2
make: *** [drivers] Error 2

--
Med vennlig hilsen
Vegard Hansen
Mob.: (+47) 9110 1337
