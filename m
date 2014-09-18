From: Robie Basak <robie.basak@canonical.com>
Subject: Re: bcache-tools ITP
Date: Thu, 18 Sep 2014 08:59:58 +0100
Message-ID: <20140918075958.GY29881@mal.justgohome.co.uk>
References: <20140530155757.GU2893@mal.justgohome.co.uk>
 <175f4ae1c88f5506984eb3a1673829a5@de.mcbf.net>
 <20140715111552.GA17765@mal.justgohome.co.uk>
 <20140917115538.GW29881@mal.justgohome.co.uk>
 <20140917232114.GB17913@birch.djwong.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="9+VnUxDxRuy97YQ+"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:38616 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaIRIAB (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 18 Sep 2014 04:00:01 -0400
Content-Disposition: inline
In-Reply-To: <20140917232114.GB17913@birch.djwong.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-bcache@vger.kernel.org


--9+VnUxDxRuy97YQ+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

(cutting out everything but the list, since this isn't directly related
to the Debian ITP)

On Wed, Sep 17, 2014 at 04:21:14PM -0700, Darrick J. Wong wrote:
> If you're interested in the bcache-status[1] tool, I'd be happy to work w=
ith
> you to get (and keep) it in Debian.  I /think/ it's in the Fedora package.
>=20
> (afaict the script is not in any of those git trees...)

Can we get your script upstream (wherever it is that we decide it is) so
that it just ships and distributions don't individually have to carry
it?

For a start, maybe send g2p a pull request?

Robie

--9+VnUxDxRuy97YQ+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUGpD+AAoJEOVkucJ1vdUumc0P/RaOGXIwtid8ULrjXyTnvJhI
hYdPegt3tvNcfwICf27Ao2f17FW4CLgwT+CO+mJ3TLcZbj0XKEj/Cg5nHabBgrd9
q81K8hmb8LoXKmqZghoE4KRdjS0tpJbnLHui/OPWYMC+/Jb6X607G4fJuRrEtiFl
N1PaL8/Lo7U9Z4g3PfuHt6b5JEk7C7kzaZEYGoICMzVkurJnbDs4wfQcHsCeaU5/
V2RMWBYtdFvMHlK30dgnPl31LyKSRB0IBXE1L769Dz7s3IwXQHuKEodmhFmUWt4g
AFlhJldqzJ5nmgpLdAyFFyCcOTkOBYOBs5kj8/Ty5jTfDf17C1Hz3HHvuKA5kxc9
bRzqWYP6L+tYRPA/C5iFwTpkmUyw+uMZ6IIN9yXo8K3c0ZB651TMxL050g6dQkYr
zPGTb9EKt5/KQfnhNfShEnxgUVgVgoWy7TuUc25O75uwQt8RnCToSdjLLXGTAnJU
MoS1U+7+OBr9aeawhQF6i+AyuTAkHC6PGKpM9OCYEAFnh2blk+huSRwm3b6A74vr
kxSO/+KrYc2gxYaqLGb3XWLMnuazYK0s6eY5AA4vFXrST6VlliPdkXHNW+/zPKa1
TuImAp9d+QurRBFjRfmIKeN60MN3VO8XEZsFbS09eriFgMNsJM9JdmqKtF+mqGLN
a4ymy+CF1+9bdWdbwn2J
=iMcr
-----END PGP SIGNATURE-----

--9+VnUxDxRuy97YQ+--
