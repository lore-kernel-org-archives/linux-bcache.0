From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Partitions on bcache devices
Date: Wed, 28 Sep 2016 19:11:42 +0200
Message-ID: <20160928191142.2e545aa5@harpe.intellique.com>
References: <951934014.5256.1475070307225@ox.pcextreme.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/PPd2_JWLTc.Y47VJ5jUe_rl"; protocol="application/pgp-signature"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:21225 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932977AbcI1RVi (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 28 Sep 2016 13:21:38 -0400
In-Reply-To: <951934014.5256.1475070307225@ox.pcextreme.nl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Wido den Hollander <wido@42on.com>
Cc: linux-bcache@vger.kernel.org

--Sig_/PPd2_JWLTc.Y47VJ5jUe_rl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Wed, 28 Sep 2016 15:45:07 +0200 (CEST)
Wido den Hollander <wido@42on.com> =C3=A9crivait:

> Hi,
>=20
> Currently it is not possible to create partitions on bcache devices,
> eg, if you have bcache0 you can't create bcache0p1, bcache0p2, etc.
>=20
> There are patches [0] out there which 'enable' this, but they aren't
> suited to be send upstream.
>=20
> For the Ceph [1] project it would be very beneficial if bcache would
> support the creation of partitions on the devices.

What's the use case exactly? You can create LVM lvs on bcache devices
if you need to split them. And I don't really understand why it would
be beneficial to Ceph, which is about agreggating many devices.

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/PPd2_JWLTc.Y47VJ5jUe_rl
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlfr+c4ACgkQX3jQXNUicVad5wCg5dxmwNUUu7FmvvvWixSMYWYy
9WMAnjfRHo5MmMDPw3wzh9a9KS6Tjl7n
=s13E
-----END PGP SIGNATURE-----

--Sig_/PPd2_JWLTc.Y47VJ5jUe_rl--
