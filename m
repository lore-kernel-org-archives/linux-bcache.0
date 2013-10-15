From: Thierry Reding <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: linux-next: Tree for Oct 14 (bcache)
Date: Tue, 15 Oct 2013 10:44:00 +0200
Message-ID: <20131015084359.GJ7856@ulmo.nvidia.com>
References: <1381762088-18880-1-git-send-email-treding@nvidia.com>
 <525C3EC2.20404@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdJFN6SSISdF2ksn"
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <525C3EC2.20404-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org


--sdJFN6SSISdF2ksn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 14, 2013 at 11:58:10AM -0700, Randy Dunlap wrote:
> On 10/14/13 07:48, Thierry Reding wrote:
> > Hi all,
> >=20
> > I've uploaded today's linux-next tree to the master branch of the
> > repository below:
> >=20
> >         git://gitorious.org/thierryreding/linux-next.git
> >=20
> > A next-20131014 tag is also provided for convenience.
> >=20
> > Gained a few conflicts, but nothing too exciting. x86 and ARM default
> > configurations build fine. There were some build failures unrelated to
>=20
> Maybe you could build allmodconfig instead of a default config
> for more better coverage?  I am seeing lots of build problems.

Ideally I'd be able to run allmodconfig for each merge, but I have
neither the computing power nor the time to do that. I can add
allmodconfig to the set of configurations that I build after the final
merge, but I don't know how much good that is if I don't actually have
any time to fix them up.

Furthermore I'm beginning to think that perhaps we should create some
infrastructure around this that would make it easier to submit requests
for build coverage. Quite a few people seem to run autobuilders, so if
all those could be harnessed to build linux-next (perhaps even on a per
merge basis) that would give great coverage.

> > the merge, most of which I fixed and added as patches on top of the
> > final merge.
>=20
>=20
> on x86_64:
>=20
> drivers/md/bcache/request.c: In function 'cached_dev_write':
> drivers/md/bcache/request.c:1076:8: error: 'struct btree_op' has no membe=
r named 'cache_bio'

It's quite possible that I messed that up during the merge. The bcache
conflicts weren't very trivial. This one in particular seems to be
caused by a commit that went into 3.12-rc5 and one in the block tree's
linux-next branch.

Thierry

--sdJFN6SSISdF2ksn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSXQBPAAoJEN0jrNd/PrOhX0kP/0x+WYPwHV9ZzDrXa2rIQSO4
g3eUuaHLPzYZPX3x8BQZ49IKNdhukFvG/neI72raZ7k5pC+zBjiNZGGEnjVV4bNB
P4Tf8jdjBnlfQWTw2a9snxF6U7Gtel34ZOvChbOQnCTICtfdV607BY0cuhuHMCHO
HldT7jpFXIRVj33K6BsLGCxt6ZbMPDyYkhXvjFqEJn+PnmDN786hRuTHxCLNcrE0
10fBN3HutJdLhYNyND/KKc9z7t1qu8ZN3qEzV1PB0d0t1Wpp8xFBnCCx+0GHe6Hp
u+jaKjrfEMmhXOD3BawDczU+8CnAvK+dKNecdzeA+16uqTDtwoC4Pyvc3QWbqNAg
Cqu2FCnI92kwyXkH6OtI7WcYzFj5HS9tlyM0cVoMoUdxJKS9A1gR+ON3rCkkbI5U
x9dYGlhxhAEc2BFV+kt3Fj76AmxI156A4EnsNelhkHWMqhWpZ4YOgIpfl3tyzC17
EdYiZ0A4fHsKC8g2Fc039/vSmHkS8zt2O9suSaqePkbTLaLZLbIdBNqMYLhbN/MB
Jrqwa+3ox1zVW1jBCKL2KR1GfDmRpgkzLVabuWxkFsv8J/eFVogxNaDEC7o5I5SN
s/zv9gEj5fsh4l7fsyy14BIvEW9u4p8eLxpoKEPulM193dN8r8BuRK8sVeNBK626
UBKU1PxAfk9y2p/cbcuC
=2Yvo
-----END PGP SIGNATURE-----

--sdJFN6SSISdF2ksn--
