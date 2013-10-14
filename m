From: Mark Brown <broonie@kernel.org>
Subject: Re: linux-next: Tree for Oct 14 (bcache)
Date: Mon, 14 Oct 2013 21:27:23 +0100
Message-ID: <20131014202723.GQ2443@sirena.org.uk>
References: <1381762088-18880-1-git-send-email-treding@nvidia.com>
 <525C3EC2.20404@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YiSnftFthKPM0z4v"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <525C3EC2.20404@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org


--YiSnftFthKPM0z4v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 14, 2013 at 11:58:10AM -0700, Randy Dunlap wrote:
> On 10/14/13 07:48, Thierry Reding wrote:

> > Gained a few conflicts, but nothing too exciting. x86 and ARM default
> > configurations build fine. There were some build failures unrelated to

> Maybe you could build allmodconfig instead of a default config
> for more better coverage?  I am seeing lots of build problems.

I'd say in addition - if you look at the last tree I did it's got fixes
for all these tihngs I think.

--YiSnftFthKPM0z4v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSXFOnAAoJELSic+t+oim9kp0QAJCCX5jjgDO9QBDpwz51Gh2A
Zys9MLzehYYH+KIVmzUO5fRyWOpYSkT+YzTMMWxRMxwmlmSiU7e9QanVOTXS3p9G
M2Rm3DJZxO1CXh+bxOv3vR3DUHw6meL1HNBGEM6VeagpBV8goqMtNNbiEwJ3Rx0P
ZYK8a8SWlnqUINdw6Yf4lMpprzk7oFazUAStbwQgvRGyQ+PAY8DO2EOHIYMI45Jx
jc3R2AW+vGFaVurRG0uKeblZQRG/NJFP/DvOml3bC/w8eKqRfHIp8vma6sF/STqe
1vZcanr72FAQcylgJF2B3cj0OUO7yQpjG95e10AYxMKq7lP/CswoSFN+I/4DQLbt
WMXbmL9QWgIvab2928JD2BgPCSLV2R7Z60F7HOK3G6e88BGrqNZ5aXBE4gaYvPUf
S1RSqQuxF+irOt/UGh5ohF1fEExLVikhkAg+FidNUdJM7+pLneTyDNMleD/dbwJU
5jJw+rfDrvEdZk4KAt30D3wfH3X1Y6ZYXqUozvBJBiDoP6jVeVCa7qxMlaLjh2MJ
Qt2O02KdQr5XVBYhmbVUvkGYzlEL+jgVzBoBcngThmftF1E5LsIfxZfKRmuJo3dt
O01JKrV7dX18dk49Q/hWXrMFesApB027nb3dDpJnTnt+WBkkmWZMIbmFbDbxLdbr
Nzn93XhSJh+7rlQwyyug
=GfpC
-----END PGP SIGNATURE-----

--YiSnftFthKPM0z4v--
