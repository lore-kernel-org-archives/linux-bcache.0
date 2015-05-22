From: Rolf Fokkens <rolf@rolffokkens.nl>
Subject: bcache-tools fails to build with gcc 5.1.1
Date: Fri, 22 May 2015 20:03:18 +0200
Message-ID: <555F6F66.20209@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:33783 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756981AbbEVSDV (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 22 May 2015 14:03:21 -0400
Received: by wicmx19 with SMTP id mx19so46832604wic.0
        for <linux-bcache@vger.kernel.org>; Fri, 22 May 2015 11:03:20 -0700 (PDT)
Received: from home07.rolf-en-monique.lan ([31.161.100.138])
        by mx.google.com with ESMTPSA id mv11sm8768442wic.23.2015.05.22.11.03.19
        for <linux-bcache@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 May 2015 11:03:19 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi all,

By upgrading to Fedora 22 I've become a gcc 5.1.1 user. gcc rightfully=20
complains about the following during make:

[rolf.fokkens@home07 bcache-tools-1.0.8.orig]$ make
cc -O2 -Wall -g `pkg-config --cflags uuid blkid`   -c -o bcache.o bcach=
e.c
bcache.c:125:9: warning: =E2=80=98crc_table=E2=80=99 is static but used=
 in inline=20
function =E2=80=98crc64=E2=80=99 which is not static
    crc =3D crc_table[i] ^ (crc << 8);
          ^
cc -O2 -Wall -g `pkg-config --cflags uuid blkid`    make-bcache.c=20
bcache.o  `pkg-config --libs uuid blkid` -o make-bcache
/tmp/cchVVBrJ.o: In function `write_sb':
/tmp/bcache-tools-1.0.8.orig/make-bcache.c:277: undefined reference to=20
`crc64'
collect2: error: ld returned 1 exit status
<builtin>: recipe for target 'make-bcache' failed
make: *** [make-bcache] Error 1
[rolf.fokkens@home07 bcache-tools-1.0.8.orig]$

This fix is:

diff -ruN bcache-tools-1.0.8.orig/bcache.c bcache-tools-1.0.8/bcache.c
--- bcache-tools-1.0.8.orig/bcache.c    2014-12-04 23:51:24.000000000 +=
0100
+++ bcache-tools-1.0.8/bcache.c    2015-05-22 19:40:41.039355096 +0200
@@ -26,7 +26,7 @@
   * x^7 + x^4 + x + 1
  */

-static const uint64_t crc_table[256] =3D {
+const uint64_t crc_table[256] =3D {
      0x0000000000000000ULL, 0x42F0E1EBA9EA3693ULL, 0x85E1C3D753D46D26U=
LL,
      0xC711223CFA3E5BB5ULL, 0x493366450E42ECDFULL, 0x0BC387AEA7A8DA4CU=
LL,
      0xCCD2A5925D9681F9ULL, 0x8E224479F47CB76AULL, 0x9266CC8A1C85D9BEU=
LL,
@@ -114,16 +114,3 @@
      0x5DEDC41A34BBEEB2ULL, 0x1F1D25F19D51D821ULL, 0xD80C07CD676F8394U=
LL,
      0x9AFCE626CE85B507ULL
  };
-
-inline uint64_t crc64(const void *_data, size_t len)
-{
-    uint64_t crc =3D 0xFFFFFFFFFFFFFFFFULL;
-    const unsigned char *data =3D _data;
-
-    while (len--) {
-        int i =3D ((int) (crc >> 56) ^ *data++) & 0xFF;
-        crc =3D crc_table[i] ^ (crc << 8);
-    }
-
-    return crc ^ 0xFFFFFFFFFFFFFFFFULL;
-}
diff -ruN bcache-tools-1.0.8.orig/bcache.h bcache-tools-1.0.8/bcache.h
--- bcache-tools-1.0.8.orig/bcache.h    2014-12-04 23:51:24.000000000 +=
0100
+++ bcache-tools-1.0.8/bcache.h    2015-05-22 19:40:34.924320569 +0200
@@ -115,7 +115,20 @@
  #define BDEV_STATE_DIRTY    2U
  #define BDEV_STATE_STALE    3U

-uint64_t crc64(const void *_data, size_t len);
+extern const uint64_t crc_table[];
+
+inline uint64_t crc64(const void *_data, size_t len)
+{
+        uint64_t crc =3D 0xFFFFFFFFFFFFFFFFULL;
+        const unsigned char *data =3D _data;
+
+        while (len--) {
+                int i =3D ((int) (crc >> 56) ^ *data++) & 0xFF;
+                crc =3D crc_table[i] ^ (crc << 8);
+        }
+
+        return crc ^ 0xFFFFFFFFFFFFFFFFULL;
+}

  #define node(i, j)        ((void *) ((i)->d + (j)))
  #define end(i)            node(i, (i)->keys)

This is also on github:

https://github.com/g2p/bcache-tools/pull/24

Cheers!

Rolf
