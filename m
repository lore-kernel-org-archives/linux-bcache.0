From: Pavel Machek <pavel@ucw.cz>
Subject: v4.12: register_dcache lockdep problem on boot
Date: Tue, 25 Jul 2017 10:54:47 +0200
Message-ID: <20170725085447.GA4149@amd>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49392 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750980AbdGYIyu (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 25 Jul 2017 04:54:50 -0400
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

I get this one during boot...

								Pavel


[    0.000000] Linux version 4.12.0+ (pavel@duo) (gcc version 4.9.2 (Debian=
 4.9.2-10) ) #411 SMP Tue Jul 25 09:04:04 CEST 2017
[    0.000000] Disabled fast string operations
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point=
 registers'
=2E..
[   11.178720] EXT4-fs (sda4): re-mounted. Opts: errors=3Dremount-ro
[   12.680438] ------------[ cut here ]------------
[   12.683112] WARNING: CPU: 2 PID: 2811 at kernel/locking/lockdep.c:721 re=
gister_lock_class+0x128/0x46a
[   12.685896] Modules linked in:
[   12.688629] CPU: 2 PID: 2811 Comm: bcache-register Not tainted 4.12.0+ #=
411
[   12.691453] Hardware name: LENOVO 42872WU/42872WU, BIOS 8DET73WW (1.43 )=
 10/12/2016
[   12.694359] task: f2486040 task.stack: f25f4000
[   12.697259] EIP: register_lock_class+0x128/0x46a
[   12.700144] EFLAGS: 00010097 CPU: 2
[   12.702977] EAX: c4f68379 EBX: c5396730 ECX: 00000000 EDX: 00000c3f
[   12.705858] ESI: 00000000 EDI: f269d084 EBP: f25f5c84 ESP: f25f5c58
[   12.708788]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   12.711717] CR0: 80050033 CR2: b764930e CR3: 333d9b80 CR4: 00040630
[   12.714689] Call Trace:
[   12.717617]  __lock_acquire+0x86/0x94a
[   12.720466]  lock_acquire+0x4a/0x66
[   12.723223]  ? mca_reap+0x56/0x115
[   12.725972]  down_write_trylock+0x44/0x59
[   12.728737]  ? mca_reap+0x56/0x115
[   12.731454]  mca_reap+0x56/0x115
[   12.734131]  mca_alloc+0x80/0x390
[   12.736741]  bch_btree_node_get+0x76/0x27e
[   12.739324]  run_cache_set+0x2c0/0x7c1
[   12.741866]  register_bcache+0xc35/0x109b
[   12.744356]  ? register_bcache+0xc35/0x109b
[   12.746826]  ? x86_perf_event_set_period+0x187/0x20c
[   12.749305]  ? __mutex_lock+0x2a/0x5d7
[   12.751725]  ? bch_cache_set_alloc+0x577/0x577
[   12.754138]  kobj_attr_store+0x10/0x1f
[   12.756508]  ? kobj_attr_store+0x10/0x1f
[   12.758906]  sysfs_kf_write+0x2f/0x41
[   12.761258]  ? sysfs_file_ops+0x40/0x40
[   12.763521]  kernfs_fop_write+0xd3/0x14a
[   12.765762]  ? sysfs_file_ops+0x40/0x40
[   12.767948]  ? kernfs_vma_page_mkwrite+0x67/0x67
[   12.770121]  __vfs_write+0x1c/0x103
[   12.772076]  ? vfs_write+0x93/0x13c
[   12.774058]  ? __sb_start_write+0xeb/0x14c
[   12.776147]  ? vfs_write+0x93/0x13c
[   12.778135]  vfs_write+0xa1/0x13c
[   12.780033]  SyS_write+0x3d/0x81
[   12.781854]  do_int80_syscall_32+0x42/0x84
[   12.783631]  entry_INT80_32+0x2e/0x2e
[   12.785357] EIP: 0xb7758c42
[   12.787015] EFLAGS: 00000246 CPU: 2
[   12.788711] EAX: ffffffda EBX: 00000003 ECX: b7755000 EDX: 0000000a
[   12.790428] ESI: 0000000a EDI: b7755000 EBP: bfca9a0c ESP: bfca9954
[   12.792168]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
[   12.793861] Code: 0f 85 94 00 00 00 68 da 7f e8 c4 68 f6 7d e8 c4 e8 58 =
e0 00 00 0f ff 83 c4 08 eb 7e 8b 47 0c 39 83 08 01 00 00 0f 84 1e 03 00 00 =
<0f> ff e9 17 03 00 00 85 db 74 0b 3b 43 10 74 e1 8b 1b 85 db 75
[   12.797697] ---[ end trace 6e213ee067267bec ]---
[   12.808884] bcache: bch_journal_replay() journal replay done, 0 keys in =
2 entries, seq 4
[   12.822321] bcache: register_cache() registered cache device sdb1
[   13.378319] bcache: register_bdev() registered backing device sda3
[   15.243852] Adding 1681428k swap on /dev/sda1.  Priority:-1 extents:1 ac=
ross:1681428k=20
[  239.805060] EXT4-fs (sda2): mounted filesystem with ordered data mode. O=
pts: errors=3Dremount-ro
[  240.021482] systemd-journald[2514]: Received request to flush runtime jo=
urnal from PID 1
[  251.847202] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recov=
ery directory
[  251.866580] NFSD: starting 90-second grace period (net c5071e80)
[  254.912204] e1000e: eth2 NIC Link is Up 100 Mbps Full Duplex, Flow Contr=
ol: Rx/Tx
[  254.912257] e1000e 0000:00:19.0 eth2: 10/100 speed: disabling TSO
[  287.780875] EXT4-fs (sdb4): mounted filesystem with ordered data mode. O=
pts: (null)
[  287.783634] EXT4-fs (sdb2): mounted filesystem with ordered data mode. O=
pts: (null)

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAll3B1cACgkQMOfwapXb+vLRHgCgj98i6xqchIeegiKud6A41jFb
7awAnjkfYUwHjm9mY+Ek3gOvLt9xqju1
=dKSe
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
