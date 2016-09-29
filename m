From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Partitions on bcache devices
Date: Thu, 29 Sep 2016 18:25:49 +0200
Message-ID: <20160929182549.3e012c7e@harpe.intellique.com>
References: <951934014.5256.1475070307225@ox.pcextreme.nl>
        <20160928191142.2e545aa5@harpe.intellique.com>
        <1406388200.5277.1475090090844@ox.pcextreme.nl>
        <20160929160903.10b63b45@harpe.intellique.com>
        <225072061.5367.1475163518820@ox.pcextreme.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/SUY4bmBqdOliIOuRV/kigjH"; protocol="application/pgp-signature"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:23172 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755438AbcI2QZw (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 29 Sep 2016 12:25:52 -0400
In-Reply-To: <225072061.5367.1475163518820@ox.pcextreme.nl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Wido den Hollander <wido@42on.com>
Cc: linux-bcache@vger.kernel.org

--Sig_/SUY4bmBqdOliIOuRV/kigjH
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Thu, 29 Sep 2016 17:38:38 +0200 (CEST)
Wido den Hollander <wido@42on.com> =C3=A9crivait:

> Yes, I'm sure. You can create the partitions, but they will not show
> up as devices which you can use due to a limitation in the bcache
> kernel driver.
>=20
> Patches [0] are out there to make this work, but they are not in
> bcache yet.
>=20
> Hence my thread if this support can be added.
>=20
> Wido
>=20
> [0]: https://yaple.net/2016/03/31/bcache-partitions-and-dkms/

Ah OK, it's because bcache driver only allocates one minor number to
the device... Could be done indeed.

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/SUY4bmBqdOliIOuRV/kigjH
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlftQI4ACgkQX3jQXNUicVYD1wCg3k35yWQO3STSAkJ/Qe+4FMWe
TGUAn3MP2kdTSK395tmLczWa9c6LQrtb
=bOwx
-----END PGP SIGNATURE-----

--Sig_/SUY4bmBqdOliIOuRV/kigjH--
