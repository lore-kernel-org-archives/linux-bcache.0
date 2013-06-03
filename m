From: Patrick Ng <ppng-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Re: Poor performance with bcache write-back mode
Date: Mon, 3 Jun 2013 21:44:59 +0000 (UTC)
Message-ID: <loom.20130603T233345-71@post.gmane.org>
References: <1368741106.62060.YahooMailNeo@web162401.mail.bf1.yahoo.com> <20130529004058.GF2291@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Kent Overstreet <koverstreet@...> writes:

>=20
> On Thu, May 16, 2013 at 02:51:46PM -0700, Patrick Ng wrote:
> > Hi all,
> >=20
> > I have installed Linux kernel 3.9.2 in my Fedora 18. =C2=A0When I r=
an FIO in=20
bcache write-through mode, the
> performance was good, but running a similar test in bcache write-back=
=20
mode, I got very poor performance.
> > Did I miss any options when setting the write-back mode?
> >=20
> > Environment
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > 500G backing store at /dev/sdb1
> > 150G SSD at /dev/sdc1
> >=20
> > Write-through mode
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > make-bcache -B /dev/sdb1 -C /dev/sdc1
> > echo /dev/sdb1 > /sys/fs/bcache/register
> > echo /dev/sdc1 > /sys/fs/bcache/register
> > mkfs.ext4 /dev/bcache0
> > mount /dev/bcache0 /mnt/bcache
> >=20
> >=20
> > Running FIO with random, 100% read, iosize=3D4096, queue depth=3D16
> > the result is approx. 65k IOPS
> >=20
> >=20
> > Write-backe mode (setup is almost the same as write-through except =
the=20
extra step at the end "echo
> writeback ...")
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > make-bcache -B /dev/sdb1 -C /dev/sdc1
> > echo /dev/sdb1 > /sys/fs/bcache/register
> > echo /dev/sdc1 > /sys/fs/bcache/register
> > mkfs.ext4 /dev/bcache0
> > mount /dev/bcache0 /mnt/bcache
> > echo writeback > /sys/block/bcache0/bcache/cache_mode
> >=20
> > Running FIO with random, 100% read, iosize=3D4096, queue depth=3D16
> > the result is approx. 12k IOPS
> >=20
> > Running FIO with random, 80% read 20% write, iosize=3D4096, queue d=
epth=3D16
> > the result is approx. 2k IOPS
>=20
> You're probably getting bit by the congested bypass - try setting
> congested_read_threshold_us and congested_write_threshold_us both to =
0.
>=20
> I wish there was a better solution to the congestion bypass stuff, it=
's
> a hard problem...
>=20

Hi Kent, thank you for responding to my question.

I have tried setting both congested_read_threshold_us and=20
congested_write_threshold_us to zero.

The result of FIO random 100% read test in WriteBack mode has improved =
and=20
the IOPS is as good as in WriteThur mode.

The result of FIO random 80% read 20% write remain the same with no=20
improvement.

It appears that the option does not help on the WRITE?

Thanks,
Patrick
