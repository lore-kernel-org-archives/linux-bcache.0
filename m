From: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Subject: Build warnings on linux-bcache.git/bcache
Date: Tue, 11 Sep 2012 23:20:56 +1000
Message-ID: <CAOzFzEi+jXDrBXyv-5dQe_PHnArojJt9FFXMvBGRDwiBy95p_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hi Kent, list.

I am getting a few build warnings on the current bcache branch with gcc=
 4.7.1
They are all formatting errors, don't look to be harmful at first
glance unless you touch the sysfs atributes.

In file included from drivers/md/bcache/super.c:132:0:
drivers/md/bcache/sysfs.c: In function =91__cached_dev_show=92:
drivers/md/bcache/sysfs.c:113:4: warning: unknown conversion type
character =91l=92 in format [-Wformat]
drivers/md/bcache/sysfs.c:113:4: warning: too many arguments for
format [-Wformat-extra-args]
drivers/md/bcache/sysfs.c:115:4: warning: unknown conversion type
character =91l=92 in format [-Wformat]
drivers/md/bcache/sysfs.c:115:4: warning: too many arguments for
format [-Wformat-extra-args]
drivers/md/bcache/sysfs.c:117:4: warning: unknown conversion type
character =91l=92 in format [-Wformat]
drivers/md/bcache/sysfs.c:117:4: warning: too many arguments for
format [-Wformat-extra-args]
drivers/md/bcache/sysfs.c:130:2: warning: unknown conversion type
character =91l=92 in format [-Wformat]
drivers/md/bcache/sysfs.c:130:2: warning: too many arguments for
format [-Wformat-extra-args]
drivers/md/bcache/sysfs.c: In function =91flash_dev_show=92:
drivers/md/bcache/sysfs.c:294:2: warning: unknown conversion type
character =91l=92 in format [-Wformat]
drivers/md/bcache/sysfs.c:294:2: warning: too many arguments for
format [-Wformat-extra-args]
drivers/md/bcache/sysfs.c: In function =91__cache_set_show=92:
drivers/md/bcache/sysfs.c:433:2: warning: unknown conversion type
character =91z=92 in format [-Wformat]
drivers/md/bcache/sysfs.c:433:2: warning: too many arguments for
format [-Wformat-extra-args]
drivers/md/bcache/sysfs.c:445:2: warning: unknown conversion type
character =91l=92 in format [-Wformat]
drivers/md/bcache/sysfs.c:445:2: warning: too many arguments for
format [-Wformat-extra-args]
drivers/md/bcache/sysfs.c:460:2: warning: unknown conversion type
character =91l=92 in format [-Wformat]
drivers/md/bcache/sysfs.c:460:2: warning: too many arguments for
format [-Wformat-extra-args]
drivers/md/bcache/sysfs.c: In function =91__cache_show=92:
drivers/md/bcache/sysfs.c:635:2: warning: unknown conversion type
character =91l=92 in format [-Wformat]
drivers/md/bcache/sysfs.c:635:2: warning: too many arguments for
format [-Wformat-extra-args]
drivers/md/bcache/sysfs.c:637:2: warning: unknown conversion type
character =91l=92 in format [-Wformat]
drivers/md/bcache/sysfs.c:637:2: warning: too many arguments for
format [-Wformat-extra-args]
drivers/md/bcache/sysfs.c:639:2: warning: unknown conversion type
character =91l=92 in format [-Wformat]
drivers/md/bcache/sysfs.c:639:2: warning: too many arguments for
format [-Wformat-extra-args]

drivers/md/bcache/stats.c: In function =91cache_stats_show=92:
drivers/md/bcache/stats.c:75:2: warning: unknown conversion type
character =91l=92 in format [-Wformat]
drivers/md/bcache/stats.c:75:2: warning: too many arguments for format
[-Wformat-extra-args]


--=20
CTO | Orion Virtualisation Solutions | www.orionvm.com.au
Phone: 1300 56 99 52 | Mobile: 0428 754 846
