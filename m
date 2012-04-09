From: David Rhodes Clymer <david-LEGOU7lN1jbY0TyS/+Ba5Q@public.gmane.org>
Subject: Re: New bcache code up
Date: Mon, 9 Apr 2012 15:33:41 -0400
Message-ID: <CAB7K1hF+PXvOYeaGtiP26SsgfWRnHfG-2_tNeANJiF-eKRxVwA@mail.gmail.com>
References: <20120409021220.GA4713@dhcp-172-18-216-138.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120409021220.GA4713-RcKxWJ4Cfj3IzGYXcIpNmNLIRw13R84JkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On Sun, Apr 8, 2012 at 10:12 PM, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> I just pushed new code to the bcache-3.2-dev branch. I expect this
> version to be more or less stable and production ready, but it does need
> new testing.

I run into a linking error when trying to build this:

  AS      arch/x86/lib/putuser.o
  AS      arch/x86/lib/rwlock.o
  AS      arch/x86/lib/rwsem.o
  CC      arch/x86/lib/string_32.o
  CC      arch/x86/lib/strstr_32.o
  AS      arch/x86/lib/thunk_32.o
  CC      arch/x86/lib/usercopy.o
  CC      arch/x86/lib/usercopy_32.o
  AR      arch/x86/lib/lib.a
  LD      vmlinux.o
  MODPOST vmlinux.o
  GEN     .version
  CHK     include/generated/compile.h
  UPD     include/generated/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
drivers/built-in.o: In function `__update_writeback_rate':
/usr/local/src/bcache/linux-bcache/drivers/block/bcache/writeback.c:229:
undefined reference to `__udivdi3'
/usr/local/src/bcache/linux-bcache/drivers/block/bcache/writeback.c:232:
undefined reference to `__udivdi3'
/usr/local/src/bcache/linux-bcache/drivers/block/bcache/writeback.c:247:
undefined reference to `__divdi3'
/usr/local/src/bcache/linux-bcache/drivers/block/bcache/writeback.c:254:
undefined reference to `__divdi3'
/usr/local/src/bcache/linux-bcache/drivers/block/bcache/writeback.c:256:
undefined reference to `__divdi3'
drivers/built-in.o: In function `writeback_delay':
/usr/local/src/bcache/linux-bcache/drivers/block/bcache/writeback.c:304:
undefined reference to `__udivdi3'
drivers/built-in.o: In function `__cache_set_show':
/usr/local/src/bcache/linux-bcache/drivers/block/bcache/sysfs.c:432:
undefined reference to `__udivdi3'
/usr/local/src/bcache/linux-bcache/drivers/block/bcache/sysfs.c:432:
undefined reference to `__udivdi3'
/usr/local/src/bcache/linux-bcache/drivers/block/bcache/sysfs.c:432:
undefined reference to `__udivdi3'
/usr/local/src/bcache/linux-bcache/drivers/block/bcache/sysfs.c:432:
undefined reference to `__udivdi3'
drivers/built-in.o:/usr/local/src/bcache/linux-bcache/drivers/block/bcache/sysfs.c:433:
more undefined references to `__udivdi3' follow
make: *** [.tmp_vmlinux1] Error 1


I copied /boot/config-3.2.0-2-686-pae to .config, and the only thing
that I know I changed was enabling bcache (compiled in, not as a
module). I'm running debian wheezy (testing).

Am I just doing something silly?

-davidc
