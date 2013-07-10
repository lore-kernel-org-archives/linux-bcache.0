From: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Subject: Re: Bug#715019: linux-image-3.10-rc7-amd64: Bcache (with cache on
 LVM?) stops system from shutting down
Date: Wed, 10 Jul 2013 23:42:28 +0100
Message-ID: <1373496148.24446.21.camel@deadeye.wl.decadent.org.uk>
References: <20130705135658.9757.33407.reportbug@domo-b>
	 <20130705184222.GX4752@decadent.org.uk>
	 <CAL3dRBXX8Ex3iNE1v8N4pswqwh08enGPih0sP_ubpqUmbctdHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-kJN0H/UbAcHpHtRycgsd"
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL3dRBXX8Ex3iNE1v8N4pswqwh08enGPih0sP_ubpqUmbctdHA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarno Elonen <jarno.elonen-DbzOA/0qlwOT8k0kg1mbHA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: 715019-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org, lvm2-R+A61+qa7K2F9N/2sQ04j0B+6BGkLq7r@public.gmane.org
List-Id: linux-bcache@vger.kernel.org


--=-kJN0H/UbAcHpHtRycgsd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-07-08 at 19:56 +0300, Jarno Elonen wrote:
> Ok, I tried to take a photo but apparently the camera was set for very
> low resolution. :/ Anyway, a few pictures attached, and here's also a
> manual transcript of a few lines:
[...]
> [242866.xxxxxx] ata5.00: exception Emask 0x0 SAct 0x0 SError 0x0
> action 0x6 frozen
> [242866.xxxxxx] ata5.00: failed command: FLUSH CACHE EXT
> [242866.xxxxxx] ata8.00: exception Emask 0x0 SAct 0x0 SError 0x0
> action 0x6 frozen
> [242866.xxxxxx] ata8.00: failed command: FLUSH CACHE EXT
> [242866.xxxxxx] ata8.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> [242866.xxxxxx]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask
> 0x4 (timeout)
> [242866.xxxxxx] ata8.00: status { DRDY }
> [242867.xxxxxx] ata5.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> ...
> [242877.xxxxxx] ata3: COMRESET failed (errno=3D-16)
> [242877.xxxxxx] ata5: COMRESET failed (errno=3D-16)
> ...
>=20
> These kinds of splurs com up once in a minute or so.

This suggests to me that LVM is *not* part of the problem, but instead
the disks are being shut down before bcache has been quiesced.

bcache developers - is this supposed to just work, or does the init
system need to do (or not do) something special for bcache devices?

Ben.

--=20
Ben Hutchings
It is easier to write an incorrect program than to understand a correct one=
.

--=-kJN0H/UbAcHpHtRycgsd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUd3jVOe/yOyVhhEJAQqwDhAAyXaHFzpt2tJcCiG/tywZoBfMzyrMOOX7
XwuhDw0ijGyUDXa1K1MAFGk6UcHlG8itHqPTiQB/ZphpuW0A2eniP0TwYOB5uO0m
RR8Z/aL0bGaP6wXiZmGiUO57Kw2CIGa08Abr94KnYvSrNDGfPJegdMv1o9qjZYyP
+FN8sNH6D8B+BL9Aq6O70khI9oJbmkKzdUNoN2hOBS9d5Hh4NRXQ1sUhFambE8Os
vIpOCzXRDG/HZAvMQj1D7g9qpEfyEbBYFRuDDRRDPwMLeEBXc4fkpq2TXt7FNiNj
SghnxiyjyifdSoEejClXZnRpa+lWPtlY6OKtpmTMWA0hsMzh8ZfnR1x7czo/88Dk
aXWiC7GH8G6M4Rah2awkca4bGPCEw97g7q/wgfijc16xS6MUdSXf8ICj1rnEmNcv
qsOHtSZcl/jU+dxu/iOZZ7Xj663cl3lbZJG9A8tLt5G9yaQ/CyB76cDf4rIDXzMZ
aX8YXQ/FNrpuAIurkB9wNTq1ixW6VsrtkFIpO3HVwUFEmHr+NatKmqr1QYEBLJgB
TgX8dCesXfvuHaY6fdby3NOTx+D2uaWvoP6/cVR0CtfoOi+/4p7/rlwWTpPMjAg/
QrN5t1pS8VNC5KG7J6W9LPsztoGPS3MOICfj2STn8kDqJtPsNy9JkbbHx2HQ7mwI
tnq5zLFuFUM=
=XGTc
-----END PGP SIGNATURE-----

--=-kJN0H/UbAcHpHtRycgsd--
