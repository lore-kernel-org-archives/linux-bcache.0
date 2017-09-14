From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: SSD usage for bcache - Read and Writeback
Date: Thu, 14 Sep 2017 17:04:00 +0200
Message-ID: <20170914170400.3463da66@harpe.intellique.com>
References: <CAD7b65Ly7rEVyShjD=1NBsYBMiyQGXuzKv0h2Ys5KN=ghTJcaA@mail.gmail.com>
        <51852c79-bee0-19c3-92d8-6044f3e3e2a7@coly.li>
        <4a5bb8a9-3de9-bae9-abea-cfa014c87084@upx.com>
        <20170914164006.64488884@harpe.intellique.com>
        <CAD7b65Lcc+soTr2bLuCoseQR8CLfmSfXE-oXQUxvJMCxH+Znfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/2xnfDdRvTGS9Z9m/kq6Bwfo"; protocol="application/pgp-signature"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:56282 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751255AbdINPBJ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 14 Sep 2017 11:01:09 -0400
In-Reply-To: <CAD7b65Lcc+soTr2bLuCoseQR8CLfmSfXE-oXQUxvJMCxH+Znfg@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: FERNANDO FREDIANI <fernando.frediani@upx.com>
Cc: linux-bcache@vger.kernel.org

--Sig_/2xnfDdRvTGS9Z9m/kq6Bwfo
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Thu, 14 Sep 2017 11:46:11 -0300
FERNANDO FREDIANI <fernando.frediani@upx.com> =C3=A9crivait:

> Not really mandatory but optional.
>=20
> From bcache documentation:
>=20
> "In the event of a data IO error on the flash it will try to recover
> by reading from disk or invalidating cache entries.  For
> unrecoverable errors (meta data or dirty data), caching is
> automatically disabled; if dirty data was present in the cache it
> first disables writeback caching and waits for all dirty data to be
> flushed."

If the cache is dirty and has failed, your data is lost or corrupted
all the same. The way a SSD fails is usually one second it works, the
next second it's as dead as a rock. If you're using it as a write
cache, whatever amount of data is dirty is lost. If it's 8 GB, you've
lost your last 8 GB of writes, often very important filesystem metadata
and/or database journal, i.e. your data is completely hosed.

Don't use SSDs as write cache without RAID-1 (or use very expensive,
redundant NVMe SSDs only), unless your data isn't very important.

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/2xnfDdRvTGS9Z9m/kq6Bwfo
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlm6mmAACgkQX3jQXNUicVZRKgCg8R7kCMFA/USiXiOrh+2MZ9Lz
mG8AoIYZV7Lj06bsSc5GZtrUQBWIBjPv
=myD1
-----END PGP SIGNATURE-----

--Sig_/2xnfDdRvTGS9Z9m/kq6Bwfo--
