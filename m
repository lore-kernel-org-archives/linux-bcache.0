From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Partitions on bcache devices
Date: Thu, 29 Sep 2016 16:09:03 +0200
Message-ID: <20160929160903.10b63b45@harpe.intellique.com>
References: <951934014.5256.1475070307225@ox.pcextreme.nl>
        <20160928191142.2e545aa5@harpe.intellique.com>
        <1406388200.5277.1475090090844@ox.pcextreme.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/23JbvE3DKrg2=_3+ZvAnxRG"; protocol="application/pgp-signature"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:32438 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754727AbcI2OJV (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 29 Sep 2016 10:09:21 -0400
In-Reply-To: <1406388200.5277.1475090090844@ox.pcextreme.nl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Wido den Hollander <wido@42on.com>
Cc: linux-bcache@vger.kernel.org

--Sig_/23JbvE3DKrg2=_3+ZvAnxRG
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Wed, 28 Sep 2016 21:14:50 +0200 (CEST)
Wido den Hollander <wido@42on.com> =C3=A9crivait:

> In both cases Ceph wants to create partitions on all disks it uses.
> By adding bcache in between the performance can be boosted really
> well. Fast NVM-e SSDs with some large SATA drives vastly improve
> performance.
>=20
> Yes, you could use LVM in between, but that just adds more layers and
> is rather complex to accomplish with the current tooling. If bcache
> would support partitions it would all be a lot easier.
>=20
> And next to Ceph there might be other tools which can benefit from
> partitions on bcache, who knows?

Two points: first I'm pretty sure LVM is the preferred method nowadays
to create volumes on disks that are not boot drives. In fact, all
enterprises distros propose to set up even the boot drive with LVM
instead of partitionning and have been doing so for 10 years.=20
So I'm pretty sure having in ceph the option to use LVM instead of
partitionning would be a darn good thing :)

Second: are you absolutely sure you can't partition a bcache device?
Does parted refuse to open and partition it? In which case, you may
only be missing some appropriate udev rules.

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/23JbvE3DKrg2=_3+ZvAnxRG
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlftIJQACgkQX3jQXNUicVZYZgCeLlPiFekdfNXsEAaMzRZx7A7W
HVsAn0zj2UDtQknPF42b/MZ9+cPJTq1c
=G0yQ
-----END PGP SIGNATURE-----

--Sig_/23JbvE3DKrg2=_3+ZvAnxRG--
