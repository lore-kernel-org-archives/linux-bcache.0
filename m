From: =?UTF-8?q?Marcin=20Miros=C5=82aw?= <marcin@mejor.pl>
Subject: [PATCH v2 1/4] Leave choosing level of optimalization and linker flags to package maintainer.
Date: Tue, 13 Sep 2016 12:55:41 +0200
Message-ID: <1473764144-18993-1-git-send-email-marcin@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:49854 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755336AbcIMK4h (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 13 Sep 2016 06:56:37 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: =?UTF-8?q?Marcin=20Miros=C5=82aw?= <marcin@mejor.pl>

Currently is adding "-static" to linker flags. This needs compiling a couple of dependent libraries to get static
version of it. It is a little problematic, at least on Gentoo. Also static binary isn't needed for typical usage, if
somebody need it then it's easy to add "-static" to env variable LDFLAGS and get static binary.
Similar to CFLAGS, it's easier to add "-g" to CFLAGS than negating it by using "-g0".

Signed-off-by: Marcin Mirosław <marcin@mejor.pl>
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 9f2773e..e9ca92d 100644
--- a/Makefile
+++ b/Makefile
@@ -1,8 +1,8 @@
 
 PREFIX=/usr
 INSTALL=install
-CFLAGS+=-std=gnu99 -O2 -Wall -g -D_FILE_OFFSET_BITS=64 -I.
-LDFLAGS+=-static
+CFLAGS:=-std=gnu99 -O2 -Wall -D_FILE_OFFSET_BITS=64 -I. $(CFLAGS)
+LDFLAGS+=
 
 PKGCONFIG_LIBS="blkid uuid libnih"
 CFLAGS+=`pkg-config --cflags	${PKGCONFIG_LIBS}`
-- 
2.7.3
