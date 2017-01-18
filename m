From: Andre Noll <maan@tuebingen.mpg.de>
Subject: Re: Hang in bcache/qemu
Date: Wed, 18 Jan 2017 09:48:30 +0100
Message-ID: <20170118084830.GA3690@tuebingen.mpg.de>
References: <2059985.veGUll5WnS@j-t460p>
 <20170118043556.08485efe@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from fmailer.gwdg.de ([134.76.11.16]:33797 "EHLO fmailer.gwdg.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752229AbdARJsM (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 18 Jan 2017 04:48:12 -0500
Content-Disposition: inline
In-Reply-To: <20170118043556.08485efe@jupiter.sol.kaishome.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kai Krakow <hurikhan77@gmail.com>
Cc: linux-bcache@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, Jan Wiele <jan@wiele.org>


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 18, 04:35, Kai Krakow wrote
> > Mainboard: Asrock Rack EP2C602
> > CPU: 2x Intel Xeon E5-2670
> > Linux: 4.8.13-1-ARCH
> > Cache-device: Partition on Samsung SSD 850 EVO 500GB
> > Backing-device: 500GB Western Digital Black
> >=20
> >=20
> > Bcache is running in writeback mode. On top of bcache, I'm running
> > LVM, which provides a Games-LV for a Qemu Windows-10 VM (Games-HD
> > with drive letter 'D'. Drive C is hosted on a non-bcache block
> > device. Each VM has its own GPU via passthrough). For a second/third
> > VM, I create snapshots of the Games-LV.
> >=20
> > When playing the game Overwatch, the first VM suddenly stops to
> > respond (after about >20min), some seconds later the second VM, too.
> >=20
> > Currently I'm not near the machine with the problem, but I'm
> > appending as much information as possible.
>=20
> Bcache doesn't seem to be involved in the backtrace - at least I
> couldn't spot it but I'm not a kernel dev. Are you maybe using bfq
> block scheduler? Try to switch to deadline and see if the problem
> persists. I personally had similar problems with bfq.

Bcache IS involved. E.g.

> > [ 4068.253203] Call Trace:
> > [ 4068.253205]  [<ffffffff815f40ec>] schedule+0x3c/0x90
> > [ 4068.253207]  [<ffffffff815f67f2>] rwsem_down_write_failed+0x132/0x2b0
> > [ 4068.253209]  [<ffffffff8130bb37>] call_rwsem_down_write_failed+0x17/=
0x30
> > [ 4068.253211]  [<ffffffff815f5f44>] down_write+0x24/0x40
> > [ 4068.253214]  [<ffffffffa005747b>] bch_writeback_thread+0x6b/0x7f0 [b=
cache]
> > [ 4068.253218]  [<ffffffffa0057410>] ? write_dirty+0xb0/0xb0 > > [bcach=
e]
> > [ 4068.253220]  [<ffffffff8109be38>] kthread+0xd8/0xf0
> > [ 4068.253221]  [<ffffffff8102c782>] ? __switch_to+0x2d2/0x630
> > [ 4068.253223]  [<ffffffff815f823f>] ret_from_fork+0x1f/0x40
> > [ 4068.253225]  [<ffffffff8109bd60>] ? kthread_worker_fn+0x170/0x170

FWIW, I'm seeing this as well on different hardware, and with both
deadline and CFQ, so it's not a scheduler issue. The problem seems to
be the bcache writeback thread calling down_write(&dc->writeback_lock)
while already holding this lock.

Calling down_write_trylock() instead of plain down_write() and
scheduling an interruptible timeout if ->writeback_lock could not be
acquired seems to cure the problem. This only papers over the real
bug though, so that's not a proper solution.

Kent: Any idea?

Thanks
Andre
--=20
Max Planck Institute for Developmental Biology
Spemannstra=C3=9Fe 35, 72076 T=C3=BCbingen, Germany. Phone: (+49) 7071 601 =
829
http://people.tuebingen.mpg.de/maan/

--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlh/K94ACgkQWto1QDEAkw/qxgCgpLIOI5P8+C6HalnaC4PsRG3E
LmsAn0StOE/Js9hLEFv+gkTIpsjATGeL
=uROl
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
