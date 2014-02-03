From: Christian Engelmayer <cengelma@gmx.at>
Subject: [PATCH] bcache: Remove unused pointer in bch_extent_bad()
Date: Tue, 4 Feb 2014 00:49:41 +0100
Message-ID: <20140204004941.342fb4bf@spike>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2mN1InXCuULzQzJ5WbiQAat"; protocol="application/pgp-signature"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:63454 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbaBCXto (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Mon, 3 Feb 2014 18:49:44 -0500
Received: from spike ([81.217.122.98]) by mail.gmx.com (mrgmx102) with ESMTPSA
 (Nemesis) id 0Mam2Q-1VvgFA3FD0-00KRjH for <linux-bcache@vger.kernel.org>;
 Tue, 04 Feb 2014 00:49:42 +0100
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-bcache@vger.kernel.org

--Sig_/2mN1InXCuULzQzJ5WbiQAat
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Remove unused pointer 'g' in function bch_extent_bad().

Detected by Coverity: CID 1166029.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
 drivers/md/bcache/extents.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/bcache/extents.c b/drivers/md/bcache/extents.c
index c3ead58..9825eb8 100644
--- a/drivers/md/bcache/extents.c
+++ b/drivers/md/bcache/extents.c
@@ -524,7 +524,6 @@ err:
 static bool bch_extent_bad(struct btree_keys *bk, const struct bkey *k)
 {
 	struct btree *b =3D container_of(bk, struct btree, keys);
-	struct bucket *g;
 	unsigned i, stale;
=20
 	if (!KEY_PTRS(k) ||
@@ -539,7 +538,6 @@ static bool bch_extent_bad(struct btree_keys *bk, const=
 struct bkey *k)
 		return false;
=20
 	for (i =3D 0; i < KEY_PTRS(k); i++) {
-		g =3D PTR_BUCKET(b->c, k, i);
 		stale =3D ptr_stale(b->c, k, i);
=20
 		btree_bug_on(stale > 96, b,
--=20
1.8.3.2

--Sig_/2mN1InXCuULzQzJ5WbiQAat
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJS8CsVAAoJEKssnEpaPQKEfAsP/1HcK+vSCdSpOSBm6eQ5+8ku
Dr2TMUzVkLW0zCHS5KWEX57TuiVAvN/CdnzayRZlm9ZZIxIRGVrYaV1q0W43W8/P
S+eM6fDdDZeI0recY9oZYWTLndu9cP/ZxmyVffscU5j0sC1k6bFaao2BASckAN4V
awr9EvOBJmvNI1k1Q0KsX46kMCd6dnW8Kq54bQzuBx6GXnN6ZBINUNgFZrOw9zLd
8mGVfkNCyf5CFkEduqfuieSIoMeQ2QWXHp4xjHrigPmYEF/Z8A22uZSKRfNDUtGg
6pGN/o+MZ4llY+HNFu1RFx4qoJ8FedcE9UjqzSuRAIjFUX7i9D87/VxGzrgiZWZC
qbwowOl8Z42K1gbIOBZRcUFQl5/ROstrmkQZDP0jJ3PfScW04z6Drdbvho43urDG
FoD1WCIy2QFZ+K8E6/714TLS3yEgOH8JnzuS3P7czKeSACG8ATd63qggCU7L7Uuy
8fY25Echgh7IRYmQ8tcXgDDO0ZEj1qKvHrV7BxCM4X2pzernsOSEBwBrn9pr33Fa
M4GJKmSdeUF/vppA6/WJgOEzdz6OftL0jCQPQUgCIpaarihmeacfRRflWsl1mJZ3
Pf9cCYIavKUi2dZEyn4xuRwXqMwz3PhjzAQaKxbuIeEPfcpYUkxAh3Ev1t3ub1Ly
u38QYjBbnVtfnBIeY4St
=8LCb
-----END PGP SIGNATURE-----

--Sig_/2mN1InXCuULzQzJ5WbiQAat--
