From: Dmitry Smirnov <onlyjob-IGUgQLVVQiRCV4ILt04nZQ@public.gmane.org>
Subject: bcache-tools: probe-bcache.8 man page
Date: Thu, 16 Feb 2012 13:32:44 +1100
Message-ID: <201202161332.49215.onlyjob@member.fsf.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4005244.JB94TQDxDz";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

--nextPart4005244.JB94TQDxDz
Content-Type: multipart/mixed;
  boundary="Boundary-01=_MrGPPKR7hs4QSjB"
Content-Transfer-Encoding: 7bit


--Boundary-01=_MrGPPKR7hs4QSjB
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Kent,

please find a little patch (attached) to introduce probe-bcache.8 man page =
to=20
bcache-tools.

Thank you.

Cheers,
Dmitry.

--Boundary-01=_MrGPPKR7hs4QSjB
Content-Type: text/x-patch;
  charset="UTF-8";
  name="0001-added-probe-bcache.8-man-page.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-added-probe-bcache.8-man-page.patch"

=46rom 0ff7680042622e356516739936095cb4eab02de6 Mon Sep 17 00:00:00 2001
=46rom: Dmitry Smirnov <onlyjob-IGUgQLVVQiRCV4ILt04nZQ@public.gmane.org>
Date: Thu, 16 Feb 2012 13:23:00 +1100
Subject: [PATCH] added probe-bcache.8 man page

=2D--
 Makefile       |    2 +-
 probe-bcache.8 |   17 +++++++++++++++++
 2 files changed, 18 insertions(+), 1 deletions(-)
 create mode 100644 probe-bcache.8

diff --git a/Makefile b/Makefile
index 684f28a..f94113a 100644
=2D-- a/Makefile
+++ b/Makefile
@@ -9,7 +9,7 @@ install: make-bcache probe-bcache
 	install -m0755 probe-bcache $(DESTDIR)/sbin/
 	install -m0644 61-bcache.rules $(DESTDIR)/lib/udev/rules.d/
 	install -m0755 initramfs $(DESTDIR)/usr/share/initramfs-tools/hooks/bcache
=2D	install -m0644 make-bcache.8 $(DESTDIR)${PREFIX}/share/man/man8
+	install -m0644 *.8 $(DESTDIR)${PREFIX}/share/man/man8
 #	install -m0755 bcache-test $(DESTDIR)${PREFIX}/sbin/
=20
 clean:
diff --git a/probe-bcache.8 b/probe-bcache.8
new file mode 100644
index 0000000..e95ec04
=2D-- /dev/null
+++ b/probe-bcache.8
@@ -0,0 +1,17 @@
+.TH probe-bcache 8
+.SH NAME
+probe-bcache \- probe a bcache device
+.SH SYNOPSIS
+.B probe-bcache
+[\fB \-o\ \fIudev\fR ]
+.I device
+.SH OPTIONS
+.TP
+.BR \-o
+return UUID in udev style for invocation by udev rule as IMPORT{program}
+.SH USAGE
+Return UUID if device identified as bcache-formatted.
+
+Only necessary until support for the bcache superblock is included
+in blkid; in the meantime, provides just enough functionality for a udev s=
cript
+to create the /dev/disk/by-uuid symlink.=20
\ No newline at end of file
=2D-=20
1.7.8.3


--Boundary-01=_MrGPPKR7hs4QSjB--

--nextPart4005244.JB94TQDxDz
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPPGrMAAoJEFK2u9lTlo0bYYkP/2RcZFZpTxWDHVa8tq/6K8rI
ffyjuXxZhODwW4GN/2ysMnqKy3O/BwKYY8SKfeCKf7gIXDqoTbJOI5WO0zvXDT8g
dSMd2h3wr3ouffnfolkWKHLMEQ5jZgN6DRHrnIHHI1lZCYBSSyEvm2AcTIvw0vZU
bnqmKMF1BMKk4WD1OfGOuJBAcnDoXgG3y4Br6HXAvL19W8UU4CBc6s/yo+FqxGTs
eOO/nisKPYy7KZ5+agszlBoH/I0raXiQ7iWhFtIEaqKGJTkMC4HM5L3+4Gs7ukQD
s8TJ6jfdWcKf5KM37dcrrhOSQzZ15Jvjac7GZsWsz8I6PjI2s/9xGnfvTQuKPNMD
Xnqwe308XpwSCxbHF6lM7FPRM5TwD949joqsOYsOZlM0ACilMACNOTJgzwH8Iffg
mUAK0Jc1DmclhTcfIucgF8tHAyov5Hv4Y3Y+x6loY8w/SZ8k12jQ+yAmysMH3IWg
Fwc6ZKhSTe0IM/kURxWJ7f2Pl7LrmY667t1/SXoyk5U2MQF5HYNuztQ25sRGzePs
IN64bcCr2vRd4Vv3gstWq8p4QuIvw+W4ktaQxW4oxicSKmO94wu+N1Y/7lVpCEpC
lxR5mMH2M475dkOlcOwpreeDx7tyUcTWAB2xjXaxpU2n7XSrH8x8eq7MfSeFvtw3
YVk6kUj5sSlpoK2rRjxp
=6bOs
-----END PGP SIGNATURE-----

--nextPart4005244.JB94TQDxDz--
