From: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Subject: Re: Build warnings on linux-bcache.git/bcache
Date: Wed, 12 Sep 2012 07:13:10 +1000
Message-ID: <CAOzFzEipL_xMn2HQXnO6rp+SmupYop5FxHB9w5xMAK8oPT_UOw@mail.gmail.com>
References: <CAOzFzEi+jXDrBXyv-5dQe_PHnArojJt9FFXMvBGRDwiBy95p_w@mail.gmail.com>
	<20120911195319.GK19739@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120911195319.GK19739-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 12 September 2012 05:53, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wr=
ote:
> On Tue, Sep 11, 2012 at 11:20:56PM +1000, Joseph Glanville wrote:
>> Hi Kent, list.
>>
>> I am getting a few build warnings on the current bcache branch with =
gcc 4.7.1
>> They are all formatting errors, don't look to be harmful at first
>> glance unless you touch the sysfs atributes.
>
> Yeah, that's a known issue - gcc doesn't like my approach to adding
> human readable units to vsnprintf. I am probably going to end up back=
ing
> out that change when I get around to it.
>
> Sorry I haven't been spending as much time on bcache lately, I know
> there's bugs I need to chase down - but, when I finish pushing my blo=
ck
> layer changes in bcache ought to be going into staging :)
>
>> In file included from drivers/md/bcache/super.c:132:0:
>> drivers/md/bcache/sysfs.c: In function =91__cached_dev_show=92:
>> drivers/md/bcache/sysfs.c:113:4: warning: unknown conversion type
>> character =91l=92 in format [-Wformat]
>> drivers/md/bcache/sysfs.c:113:4: warning: too many arguments for
>> format [-Wformat-extra-args]
>> drivers/md/bcache/sysfs.c:115:4: warning: unknown conversion type
>> character =91l=92 in format [-Wformat]
>> drivers/md/bcache/sysfs.c:115:4: warning: too many arguments for
>> format [-Wformat-extra-args]
>> drivers/md/bcache/sysfs.c:117:4: warning: unknown conversion type
>> character =91l=92 in format [-Wformat]
>> drivers/md/bcache/sysfs.c:117:4: warning: too many arguments for
>> format [-Wformat-extra-args]
>> drivers/md/bcache/sysfs.c:130:2: warning: unknown conversion type
>> character =91l=92 in format [-Wformat]
>> drivers/md/bcache/sysfs.c:130:2: warning: too many arguments for
>> format [-Wformat-extra-args]
>> drivers/md/bcache/sysfs.c: In function =91flash_dev_show=92:
>> drivers/md/bcache/sysfs.c:294:2: warning: unknown conversion type
>> character =91l=92 in format [-Wformat]
>> drivers/md/bcache/sysfs.c:294:2: warning: too many arguments for
>> format [-Wformat-extra-args]
>> drivers/md/bcache/sysfs.c: In function =91__cache_set_show=92:
>> drivers/md/bcache/sysfs.c:433:2: warning: unknown conversion type
>> character =91z=92 in format [-Wformat]
>> drivers/md/bcache/sysfs.c:433:2: warning: too many arguments for
>> format [-Wformat-extra-args]
>> drivers/md/bcache/sysfs.c:445:2: warning: unknown conversion type
>> character =91l=92 in format [-Wformat]
>> drivers/md/bcache/sysfs.c:445:2: warning: too many arguments for
>> format [-Wformat-extra-args]
>> drivers/md/bcache/sysfs.c:460:2: warning: unknown conversion type
>> character =91l=92 in format [-Wformat]
>> drivers/md/bcache/sysfs.c:460:2: warning: too many arguments for
>> format [-Wformat-extra-args]
>> drivers/md/bcache/sysfs.c: In function =91__cache_show=92:
>> drivers/md/bcache/sysfs.c:635:2: warning: unknown conversion type
>> character =91l=92 in format [-Wformat]
>> drivers/md/bcache/sysfs.c:635:2: warning: too many arguments for
>> format [-Wformat-extra-args]
>> drivers/md/bcache/sysfs.c:637:2: warning: unknown conversion type
>> character =91l=92 in format [-Wformat]
>> drivers/md/bcache/sysfs.c:637:2: warning: too many arguments for
>> format [-Wformat-extra-args]
>> drivers/md/bcache/sysfs.c:639:2: warning: unknown conversion type
>> character =91l=92 in format [-Wformat]
>> drivers/md/bcache/sysfs.c:639:2: warning: too many arguments for
>> format [-Wformat-extra-args]
>>
>> drivers/md/bcache/stats.c: In function =91cache_stats_show=92:
>> drivers/md/bcache/stats.c:75:2: warning: unknown conversion type
>> character =91l=92 in format [-Wformat]
>> drivers/md/bcache/stats.c:75:2: warning: too many arguments for form=
at
>> [-Wformat-extra-args]
>>
>>
>> --
>> CTO | Orion Virtualisation Solutions | www.orionvm.com.au
>> Phone: 1300 56 99 52 | Mobile: 0428 754 846

I have been following on LKML, overall the block cleanups seem to have
been quite well received. :)

We are running linux-bcache/bcache-3.2 on our staging environment now.
The strange swap bug I reported earlier doesn't seem to be occuring
anymore but I am yet to run full stress tests.
AFAICT performance has improved somewhat, I haven't setup sufficiently
fast backing stores to tell wether or not the sequential bypass
performance problems have budged much.

I also discovered that perf doesn't play nicely with Xen on kernels < 3=
=2E6. :(
Perf support for Xen is returning in 3.6 though and I have rebased the
bcache branch on 3.6rc5 so I will try get you a perf report shortly
that will hopefully shed some light on that.

Joseph.

--=20
CTO | Orion Virtualisation Solutions | www.orionvm.com.au
Phone: 1300 56 99 52 | Mobile: 0428 754 846
