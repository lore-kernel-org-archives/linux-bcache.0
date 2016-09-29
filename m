From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Partitions on bcache devices
Date: Thu, 29 Sep 2016 19:11:27 +0200
Message-ID: <20160929191127.779f94d0@harpe.intellique.com>
References: <951934014.5256.1475070307225@ox.pcextreme.nl>
        <20160928191142.2e545aa5@harpe.intellique.com>
        <1406388200.5277.1475090090844@ox.pcextreme.nl>
        <20160929160903.10b63b45@harpe.intellique.com>
        <20160929174056.Horde.Tkp24xa2MRhriRvK8KE1QU8@www3.nde.ag>
        <20160929183122.3641f307@harpe.intellique.com>
        <293451899.5382.1475167934533@ox.pcextreme.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/1SxzsD4EoE2kw_s.sPj+yez"; protocol="application/pgp-signature"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:43047 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934046AbcI2RLZ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 29 Sep 2016 13:11:25 -0400
In-Reply-To: <293451899.5382.1475167934533@ox.pcextreme.nl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Wido den Hollander <wido@42on.com>
Cc: "Jens-U. Mozdzen" <jmozdzen@nde.ag>, linux-bcache@vger.kernel.org

--Sig_/1SxzsD4EoE2kw_s.sPj+yez
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Thu, 29 Sep 2016 18:52:14 +0200 (CEST)
Wido den Hollander <wido@42on.com> =C3=A9crivait:

> > I agree, but usually you wouldn't partition an MD-RAID either, would
> > you? OSDs are still holding (so far) ordinary filesystems locally
> > mounted on the nodes (except for BlueStore AFAIK).
> >  =20
>=20
> I have partitioned MD-RAID before, works just fine.
>=20

Yes, sure. It just doesn't feel right, my  grey-bearded Unix instinct
tingles :)

> The question still remains, can bcache be patched that it allocates
> the right minor in the kernel so that it allows for partitions.

Even looks easy... As Sam Yaple made a patch.

> I'm not a kernel nor bcache developer, just looking for somebody who
> would be willing to do this. Happy to assist, support and test!

Well if I have some time I may give it a try next week :)

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/1SxzsD4EoE2kw_s.sPj+yez
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlftSz8ACgkQX3jQXNUicVZeuACcC9vV8vP6269N1J3ltkL4Rayk
qjgAnj0LH7SWDdyftaklZ2Kp7SFoOg3M
=u1gL
-----END PGP SIGNATURE-----

--Sig_/1SxzsD4EoE2kw_s.sPj+yez--
