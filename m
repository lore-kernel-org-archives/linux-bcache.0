From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Poor performance with bcache write-back mode
Date: Tue, 28 May 2013 17:40:58 -0700
Message-ID: <20130529004058.GF2291@google.com>
References: <1368741106.62060.YahooMailNeo@web162401.mail.bf1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1368741106.62060.YahooMailNeo-QseONlJJzSFal3a5i+KC+JEhsgyP+Z75VpNB7YpNyf8@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Patrick Ng <ppng-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On Thu, May 16, 2013 at 02:51:46PM -0700, Patrick Ng wrote:
> Hi all,
>=20
> I have installed Linux kernel 3.9.2 in my Fedora 18. =C2=A0When I ran=
 FIO in bcache write-through mode, the performance was good, but runnin=
g a similar test in bcache write-back mode, I got very poor performance=
=2E
> Did I miss any options when setting the write-back mode?
>=20
> Environment
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 500G backing store at /dev/sdb1
> 150G SSD at /dev/sdc1
>=20
> Write-through mode
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> make-bcache -B /dev/sdb1 -C /dev/sdc1
> echo /dev/sdb1 > /sys/fs/bcache/register
> echo /dev/sdc1 > /sys/fs/bcache/register
> mkfs.ext4 /dev/bcache0
> mount /dev/bcache0 /mnt/bcache
>=20
>=20
> Running FIO with random, 100% read, iosize=3D4096, queue depth=3D16
> the result is approx. 65k IOPS
>=20
>=20
> Write-backe mode (setup is almost the same as write-through except th=
e extra step at the end "echo writeback ...")
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> make-bcache -B /dev/sdb1 -C /dev/sdc1
> echo /dev/sdb1 > /sys/fs/bcache/register
> echo /dev/sdc1 > /sys/fs/bcache/register
> mkfs.ext4 /dev/bcache0
> mount /dev/bcache0 /mnt/bcache
> echo writeback > /sys/block/bcache0/bcache/cache_mode
>=20
> Running FIO with random, 100% read, iosize=3D4096, queue depth=3D16
> the result is approx. 12k IOPS
>=20
> Running FIO with random, 80% read 20% write, iosize=3D4096, queue dep=
th=3D16
> the result is approx. 2k IOPS

You're probably getting bit by the congested bypass - try setting
congested_read_threshold_us and congested_write_threshold_us both to 0.

I wish there was a better solution to the congestion bypass stuff, it's
a hard problem...
