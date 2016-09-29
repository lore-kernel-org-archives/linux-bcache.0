From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Partitions on bcache devices
Date: Thu, 29 Sep 2016 18:31:22 +0200
Message-ID: <20160929183122.3641f307@harpe.intellique.com>
References: <951934014.5256.1475070307225@ox.pcextreme.nl>
        <20160928191142.2e545aa5@harpe.intellique.com>
        <1406388200.5277.1475090090844@ox.pcextreme.nl>
        <20160929160903.10b63b45@harpe.intellique.com>
        <20160929174056.Horde.Tkp24xa2MRhriRvK8KE1QU8@www3.nde.ag>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/eFsSebnUEE0KGWO6SSqNB9R"; protocol="application/pgp-signature"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:28283 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755058AbcI2QbT (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 29 Sep 2016 12:31:19 -0400
In-Reply-To: <20160929174056.Horde.Tkp24xa2MRhriRvK8KE1QU8@www3.nde.ag>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Cc: Wido den Hollander <wido@42on.com>, linux-bcache@vger.kernel.org

--Sig_/eFsSebnUEE0KGWO6SSqNB9R
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Thu, 29 Sep 2016 17:40:56 +0200
"Jens-U. Mozdzen" <jmozdzen@nde.ag> =C3=A9crivait:

> Another counter-example: You wouldn't put LVM on a disk that's =20
> intended as a (100%) MD-RAID volume, and add an LV as RAID member... =20
> you'll add a partition table for a reason, but no extra layer
> between the partition and the RAID stuff.
>=20

I agree, but usually you wouldn't partition an MD-RAID either, would
you? OSDs are still holding (so far) ordinary filesystems locally
mounted on the nodes (except for BlueStore AFAIK).

Anyway bcache would mostly make sense for the journal, much less for
the data section, so wouldn't it better to use bcache (or flash) for
journal/metadata only?

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/eFsSebnUEE0KGWO6SSqNB9R
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlftQdoACgkQX3jQXNUicVbDfACdHRoOCXfpxTNaTS2CQNvZjhnw
gVMAoJp60VzsddF8p0pE/WaiNTw8FNg9
=kqqE
-----END PGP SIGNATURE-----

--Sig_/eFsSebnUEE0KGWO6SSqNB9R--
