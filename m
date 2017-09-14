From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: SSD usage for bcache - Read and Writeback
Date: Thu, 14 Sep 2017 16:40:21 +0200
Message-ID: <20170914164006.64488884@harpe.intellique.com>
References: <CAD7b65Ly7rEVyShjD=1NBsYBMiyQGXuzKv0h2Ys5KN=ghTJcaA@mail.gmail.com>
        <51852c79-bee0-19c3-92d8-6044f3e3e2a7@coly.li>
        <4a5bb8a9-3de9-bae9-abea-cfa014c87084@upx.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/ls+pUn7AOfzoazzs+=leu6d"; protocol="application/pgp-signature"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:21244 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751277AbdINOnm (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 14 Sep 2017 10:43:42 -0400
In-Reply-To: <4a5bb8a9-3de9-bae9-abea-cfa014c87084@upx.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: FERNANDO FREDIANI <fernando.frediani@upx.com>
Cc: Coly Li <i@coly.li>, linux-bcache@vger.kernel.org

--Sig_/ls+pUn7AOfzoazzs+=leu6d
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Thu, 14 Sep 2017 10:10:09 -0300
FERNANDO FREDIANI <fernando.frediani@upx.com> =C3=A9crivait:

> If the users reads a piece of data that is just writen to SSD
> (unlikely) it should first and in any condition be commited to the
> permanent storage and then read from there and cached in another area
> of the SSD. Writaback cache is very volatile and lasts only a few
> seconds while the data is not yet committed to permanent storage.
>=20
> In fact multiple device suport is not implemented yet, that's why I
> am asking it and comparing with other well technology as ZFS.
>=20

However nothing in bcache prevents you from using for instance a RAID
of SSDs as a cache device. Actually for write caching it's mandatory
IMO.=20

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/ls+pUn7AOfzoazzs+=leu6d
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlm6lOkACgkQX3jQXNUicVbvAACeKGS3LayAErpdqEkKCNLzk0Jh
HJ4An29Ptuwv94FHksqrfE3kVwatkQZ2
=2/Rg
-----END PGP SIGNATURE-----

--Sig_/ls+pUn7AOfzoazzs+=leu6d--
