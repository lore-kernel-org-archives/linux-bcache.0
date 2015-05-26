From: David Mohr <david@mcbf.net>
Subject: Re: bcache-tools fails to build with gcc 5.1.1
Date: Mon, 25 May 2015 23:28:10 -0600
Message-ID: <cbc3c220c8e862fc15ebb2696c6ca9e9@de.mcbf.net>
References: <555F6F66.20209@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from seeker.mcbf.net ([109.239.49.157]:52051 "EHLO seeker.mcbf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbbEZHjT (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 26 May 2015 03:39:19 -0400
In-Reply-To: <555F6F66.20209@rolffokkens.nl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Rolf Fokkens <rolf@rolffokkens.nl>
Cc: linux-bcache@vger.kernel.org

Debian also noticed this issue [1] and had a submission of a slightly=20
simpler patch below. Since crc64 doesn't seem to be particularly=20
performance sensitive, I think it's nicer to just remove the inline (an=
d=20
that's what I will include for now until one or the other is applied to=
=20
git).

~David

[1]: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D777798#10

diff --git a/bcache.c b/bcache.c
index 8f37445..8b4b986 100644
--- a/bcache.c
+++ b/bcache.c
@@ -115,7 +115,7 @@ static const uint64_t crc_table[256] =3D {
  	0x9AFCE626CE85B507ULL
  };

-inline uint64_t crc64(const void *_data, size_t len)
+uint64_t crc64(const void *_data, size_t len)
  {
  	uint64_t crc =3D 0xFFFFFFFFFFFFFFFFULL;
  	const unsigned char *data =3D _data;


On 2015-05-22 12:03, Rolf Fokkens wrote:
> Hi all,
>=20
> By upgrading to Fedora 22 I've become a gcc 5.1.1 user. gcc rightfull=
y
> complains about the following during make:
>=20
> [rolf.fokkens@home07 bcache-tools-1.0.8.orig]$ make
> cc -O2 -Wall -g `pkg-config --cflags uuid blkid`   -c -o bcache.o=20
> bcache.c
> bcache.c:125:9: warning: =E2=80=98crc_table=E2=80=99 is static but us=
ed in inline
> function =E2=80=98crc64=E2=80=99 which is not static
>    crc =3D crc_table[i] ^ (crc << 8);
>          ^
> cc -O2 -Wall -g `pkg-config --cflags uuid blkid`    make-bcache.c
> bcache.o  `pkg-config --libs uuid blkid` -o make-bcache
> /tmp/cchVVBrJ.o: In function `write_sb':
> /tmp/bcache-tools-1.0.8.orig/make-bcache.c:277: undefined reference t=
o=20
> `crc64'
> collect2: error: ld returned 1 exit status
> <builtin>: recipe for target 'make-bcache' failed
> make: *** [make-bcache] Error 1
> [rolf.fokkens@home07 bcache-tools-1.0.8.orig]$
>=20
> This fix is:
>=20
> diff -ruN bcache-tools-1.0.8.orig/bcache.c bcache-tools-1.0.8/bcache.=
c
> --- bcache-tools-1.0.8.orig/bcache.c    2014-12-04 23:51:24.000000000=
=20
> +0100
> +++ bcache-tools-1.0.8/bcache.c    2015-05-22 19:40:41.039355096 +020=
0
> @@ -26,7 +26,7 @@
>   * x^7 + x^4 + x + 1
>  */
>=20
> -static const uint64_t crc_table[256] =3D {
> +const uint64_t crc_table[256] =3D {
>      0x0000000000000000ULL, 0x42F0E1EBA9EA3693ULL,=20
> 0x85E1C3D753D46D26ULL,
>      0xC711223CFA3E5BB5ULL, 0x493366450E42ECDFULL,=20
> 0x0BC387AEA7A8DA4CULL,
>      0xCCD2A5925D9681F9ULL, 0x8E224479F47CB76AULL,=20
> 0x9266CC8A1C85D9BEULL,
> @@ -114,16 +114,3 @@
>      0x5DEDC41A34BBEEB2ULL, 0x1F1D25F19D51D821ULL,=20
> 0xD80C07CD676F8394ULL,
>      0x9AFCE626CE85B507ULL
>  };
> -
> -inline uint64_t crc64(const void *_data, size_t len)
> -{
> -    uint64_t crc =3D 0xFFFFFFFFFFFFFFFFULL;
> -    const unsigned char *data =3D _data;
> -
> -    while (len--) {
> -        int i =3D ((int) (crc >> 56) ^ *data++) & 0xFF;
> -        crc =3D crc_table[i] ^ (crc << 8);
> -    }
> -
> -    return crc ^ 0xFFFFFFFFFFFFFFFFULL;
> -}
> diff -ruN bcache-tools-1.0.8.orig/bcache.h bcache-tools-1.0.8/bcache.=
h
> --- bcache-tools-1.0.8.orig/bcache.h    2014-12-04 23:51:24.000000000=
=20
> +0100
> +++ bcache-tools-1.0.8/bcache.h    2015-05-22 19:40:34.924320569 +020=
0
> @@ -115,7 +115,20 @@
>  #define BDEV_STATE_DIRTY    2U
>  #define BDEV_STATE_STALE    3U
>=20
> -uint64_t crc64(const void *_data, size_t len);
> +extern const uint64_t crc_table[];
> +
> +inline uint64_t crc64(const void *_data, size_t len)
> +{
> +        uint64_t crc =3D 0xFFFFFFFFFFFFFFFFULL;
> +        const unsigned char *data =3D _data;
> +
> +        while (len--) {
> +                int i =3D ((int) (crc >> 56) ^ *data++) & 0xFF;
> +                crc =3D crc_table[i] ^ (crc << 8);
> +        }
> +
> +        return crc ^ 0xFFFFFFFFFFFFFFFFULL;
> +}
>=20
>  #define node(i, j)        ((void *) ((i)->d + (j)))
>  #define end(i)            node(i, (i)->keys)
>=20
> This is also on github:
>=20
> https://github.com/g2p/bcache-tools/pull/24
>=20
> Cheers!
>=20
> Rolf
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e"=20
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
