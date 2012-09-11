From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Build warnings on linux-bcache.git/bcache
Date: Tue, 11 Sep 2012 12:53:19 -0700
Message-ID: <20120911195319.GK19739@google.com>
References: <CAOzFzEi+jXDrBXyv-5dQe_PHnArojJt9FFXMvBGRDwiBy95p_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOzFzEi+jXDrBXyv-5dQe_PHnArojJt9FFXMvBGRDwiBy95p_w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Tue, Sep 11, 2012 at 11:20:56PM +1000, Joseph Glanville wrote:
> Hi Kent, list.
>=20
> I am getting a few build warnings on the current bcache branch with g=
cc 4.7.1
> They are all formatting errors, don't look to be harmful at first
> glance unless you touch the sysfs atributes.

Yeah, that's a known issue - gcc doesn't like my approach to adding
human readable units to vsnprintf. I am probably going to end up backin=
g
out that change when I get around to it.

Sorry I haven't been spending as much time on bcache lately, I know
there's bugs I need to chase down - but, when I finish pushing my block
layer changes in bcache ought to be going into staging :)

> In file included from drivers/md/bcache/super.c:132:0:
> drivers/md/bcache/sysfs.c: In function =E2=80=98__cached_dev_show=E2=80=
=99:
> drivers/md/bcache/sysfs.c:113:4: warning: unknown conversion type
> character =E2=80=98l=E2=80=99 in format [-Wformat]
> drivers/md/bcache/sysfs.c:113:4: warning: too many arguments for
> format [-Wformat-extra-args]
> drivers/md/bcache/sysfs.c:115:4: warning: unknown conversion type
> character =E2=80=98l=E2=80=99 in format [-Wformat]
> drivers/md/bcache/sysfs.c:115:4: warning: too many arguments for
> format [-Wformat-extra-args]
> drivers/md/bcache/sysfs.c:117:4: warning: unknown conversion type
> character =E2=80=98l=E2=80=99 in format [-Wformat]
> drivers/md/bcache/sysfs.c:117:4: warning: too many arguments for
> format [-Wformat-extra-args]
> drivers/md/bcache/sysfs.c:130:2: warning: unknown conversion type
> character =E2=80=98l=E2=80=99 in format [-Wformat]
> drivers/md/bcache/sysfs.c:130:2: warning: too many arguments for
> format [-Wformat-extra-args]
> drivers/md/bcache/sysfs.c: In function =E2=80=98flash_dev_show=E2=80=99=
:
> drivers/md/bcache/sysfs.c:294:2: warning: unknown conversion type
> character =E2=80=98l=E2=80=99 in format [-Wformat]
> drivers/md/bcache/sysfs.c:294:2: warning: too many arguments for
> format [-Wformat-extra-args]
> drivers/md/bcache/sysfs.c: In function =E2=80=98__cache_set_show=E2=80=
=99:
> drivers/md/bcache/sysfs.c:433:2: warning: unknown conversion type
> character =E2=80=98z=E2=80=99 in format [-Wformat]
> drivers/md/bcache/sysfs.c:433:2: warning: too many arguments for
> format [-Wformat-extra-args]
> drivers/md/bcache/sysfs.c:445:2: warning: unknown conversion type
> character =E2=80=98l=E2=80=99 in format [-Wformat]
> drivers/md/bcache/sysfs.c:445:2: warning: too many arguments for
> format [-Wformat-extra-args]
> drivers/md/bcache/sysfs.c:460:2: warning: unknown conversion type
> character =E2=80=98l=E2=80=99 in format [-Wformat]
> drivers/md/bcache/sysfs.c:460:2: warning: too many arguments for
> format [-Wformat-extra-args]
> drivers/md/bcache/sysfs.c: In function =E2=80=98__cache_show=E2=80=99=
:
> drivers/md/bcache/sysfs.c:635:2: warning: unknown conversion type
> character =E2=80=98l=E2=80=99 in format [-Wformat]
> drivers/md/bcache/sysfs.c:635:2: warning: too many arguments for
> format [-Wformat-extra-args]
> drivers/md/bcache/sysfs.c:637:2: warning: unknown conversion type
> character =E2=80=98l=E2=80=99 in format [-Wformat]
> drivers/md/bcache/sysfs.c:637:2: warning: too many arguments for
> format [-Wformat-extra-args]
> drivers/md/bcache/sysfs.c:639:2: warning: unknown conversion type
> character =E2=80=98l=E2=80=99 in format [-Wformat]
> drivers/md/bcache/sysfs.c:639:2: warning: too many arguments for
> format [-Wformat-extra-args]
>=20
> drivers/md/bcache/stats.c: In function =E2=80=98cache_stats_show=E2=80=
=99:
> drivers/md/bcache/stats.c:75:2: warning: unknown conversion type
> character =E2=80=98l=E2=80=99 in format [-Wformat]
> drivers/md/bcache/stats.c:75:2: warning: too many arguments for forma=
t
> [-Wformat-extra-args]
>=20
>=20
> --=20
> CTO | Orion Virtualisation Solutions | www.orionvm.com.au
> Phone: 1300 56 99 52 | Mobile: 0428 754 846
