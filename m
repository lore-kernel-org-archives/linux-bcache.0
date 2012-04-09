From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: New bcache code up
Date: Mon, 9 Apr 2012 13:09:20 -0700
Message-ID: <CAH+dOxKyewKObmzPkWykw2Og76sK=-0MEhtDoHRcnjnnwfYEQQ@mail.gmail.com>
References: <20120409021220.GA4713@dhcp-172-18-216-138.mtv.corp.google.com>
	<CAB7K1hF+PXvOYeaGtiP26SsgfWRnHfG-2_tNeANJiF-eKRxVwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAB7K1hF+PXvOYeaGtiP26SsgfWRnHfG-2_tNeANJiF-eKRxVwA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Rhodes Clymer <david-LEGOU7lN1jbY0TyS/+Ba5Q@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Whoops, 32 bit compiles broke again... Argh. I'll fix this soon as I
get a chance.

On Mon, Apr 9, 2012 at 12:33 PM, David Rhodes Clymer
<david-LEGOU7lN1jbY0TyS/+Ba5Q@public.gmane.org> wrote:
> On Sun, Apr 8, 2012 at 10:12 PM, Kent Overstreet <koverstreet@google.=
com> wrote:
>> I just pushed new code to the bcache-3.2-dev branch. I expect this
>> version to be more or less stable and production ready, but it does =
need
>> new testing.
>
> I run into a linking error when trying to build this:
>
> =A0AS =A0 =A0 =A0arch/x86/lib/putuser.o
> =A0AS =A0 =A0 =A0arch/x86/lib/rwlock.o
> =A0AS =A0 =A0 =A0arch/x86/lib/rwsem.o
> =A0CC =A0 =A0 =A0arch/x86/lib/string_32.o
> =A0CC =A0 =A0 =A0arch/x86/lib/strstr_32.o
> =A0AS =A0 =A0 =A0arch/x86/lib/thunk_32.o
> =A0CC =A0 =A0 =A0arch/x86/lib/usercopy.o
> =A0CC =A0 =A0 =A0arch/x86/lib/usercopy_32.o
> =A0AR =A0 =A0 =A0arch/x86/lib/lib.a
> =A0LD =A0 =A0 =A0vmlinux.o
> =A0MODPOST vmlinux.o
> =A0GEN =A0 =A0 .version
> =A0CHK =A0 =A0 include/generated/compile.h
> =A0UPD =A0 =A0 include/generated/compile.h
> =A0CC =A0 =A0 =A0init/version.o
> =A0LD =A0 =A0 =A0init/built-in.o
> =A0LD =A0 =A0 =A0.tmp_vmlinux1
> drivers/built-in.o: In function `__update_writeback_rate':
> /usr/local/src/bcache/linux-bcache/drivers/block/bcache/writeback.c:2=
29:
> undefined reference to `__udivdi3'
> /usr/local/src/bcache/linux-bcache/drivers/block/bcache/writeback.c:2=
32:
> undefined reference to `__udivdi3'
> /usr/local/src/bcache/linux-bcache/drivers/block/bcache/writeback.c:2=
47:
> undefined reference to `__divdi3'
> /usr/local/src/bcache/linux-bcache/drivers/block/bcache/writeback.c:2=
54:
> undefined reference to `__divdi3'
> /usr/local/src/bcache/linux-bcache/drivers/block/bcache/writeback.c:2=
56:
> undefined reference to `__divdi3'
> drivers/built-in.o: In function `writeback_delay':
> /usr/local/src/bcache/linux-bcache/drivers/block/bcache/writeback.c:3=
04:
> undefined reference to `__udivdi3'
> drivers/built-in.o: In function `__cache_set_show':
> /usr/local/src/bcache/linux-bcache/drivers/block/bcache/sysfs.c:432:
> undefined reference to `__udivdi3'
> /usr/local/src/bcache/linux-bcache/drivers/block/bcache/sysfs.c:432:
> undefined reference to `__udivdi3'
> /usr/local/src/bcache/linux-bcache/drivers/block/bcache/sysfs.c:432:
> undefined reference to `__udivdi3'
> /usr/local/src/bcache/linux-bcache/drivers/block/bcache/sysfs.c:432:
> undefined reference to `__udivdi3'
> drivers/built-in.o:/usr/local/src/bcache/linux-bcache/drivers/block/b=
cache/sysfs.c:433:
> more undefined references to `__udivdi3' follow
> make: *** [.tmp_vmlinux1] Error 1
>
>
> I copied /boot/config-3.2.0-2-686-pae to .config, and the only thing
> that I know I changed was enabling bcache (compiled in, not as a
> module). I'm running debian wheezy (testing).
>
> Am I just doing something silly?
>
> -davidc
