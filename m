From: Thierry Reding <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: linux-next: Tree for Oct 14 (bcache)
Date: Tue, 15 Oct 2013 10:46:32 +0200
Message-ID: <20131015084631.GK7856@ulmo.nvidia.com>
References: <1381762088-18880-1-git-send-email-treding@nvidia.com>
 <525C3EC2.20404@infradead.org>
 <20131014202723.GQ2443@sirena.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="73fGQZLCrFzENemP"
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131014202723.GQ2443-GFdadSzt00ze9xe1eoZjHA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org


--73fGQZLCrFzENemP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 14, 2013 at 09:27:23PM +0100, Mark Brown wrote:
> On Mon, Oct 14, 2013 at 11:58:10AM -0700, Randy Dunlap wrote:
> > On 10/14/13 07:48, Thierry Reding wrote:
>=20
> > > Gained a few conflicts, but nothing too exciting. x86 and ARM default
> > > configurations build fine. There were some build failures unrelated to
>=20
> > Maybe you could build allmodconfig instead of a default config
> > for more better coverage?  I am seeing lots of build problems.
>=20
> I'd say in addition - if you look at the last tree I did it's got fixes
> for all these tihngs I think.

Strange, I didn't see any build fixes in it.

Oh wait, they were applied right after the merges that broke. I hadn't
checked for that.

Thierry

--73fGQZLCrFzENemP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSXQDnAAoJEN0jrNd/PrOhhGMP/0ar3qE208SFMSTAFfI2MPiS
vvfBUcSWGbHb3bpVE5sASPlKiqBjXNrlFAXj6+jvIeis4bN2BvgRmrv6XIe28ZFl
bPL4LIsAP0WMrrXy+OLOkdjqflGSpTAefOjNWbs59tTMRzOSNtudBZ4BzoTZcCSn
GLjtDmp1ytbiaahU5ugiYMww3vamCEX9UN4RqFAxYi7/5RfsUlIOQnPe0qg8Rd3N
IorxWuVa3XNbUS7TF3eSVF3fjrvTxTG2dAUv5/kXVA6pS0lxBHCgncsGgUw/jzPO
URBzk8TRLDwJpZFeOL3B+/eHycqqJhWC9tTxau7ouTBA5UQ+BVw/IB+VQeuXZ+67
C4UMtV9h5N7Rxzpx8uY2SgHCcuhzBdQ71kERYNkKLxJYX9p2JJA8wsOHNMDYFnBW
AtsSC2aN6zsdcoWRa1cGNqX2OtZQsZs5gW8w1ePAjq/hS67Q2cpX4wSFlKe3MRaH
JSUNTnG1hgRgjeka6lGQIg8fBDt0c6sFfKBmC37Na86XQukXhLUv02LEG8cc4d7f
wwDpp0lltpgnBZcIeRogmJeCzc5+eMG9Wy3pIZmpE7pu65yfq8bB8BYU69nnYvU2
SeeBnzqab4FqlNIh/7bikdAxEkYFJ2CHC5rhm+/tAFHXUdwV1d0qJGxCwgzEMo8f
5FpMu/7l/3zwlMmWK7OY
=K3Ii
-----END PGP SIGNATURE-----

--73fGQZLCrFzENemP--
