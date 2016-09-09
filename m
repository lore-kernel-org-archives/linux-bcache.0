From: =?UTF-8?q?Marcin=20Miros=C5=82aw?= <marcin@mejor.pl>
Subject: [PATCH 1/4] No need to spawn subshell for every source file.
Date: Fri,  9 Sep 2016 15:28:37 +0200
Message-ID: <1473427720-1350-1-git-send-email-marcin@mejor.pl>
References: <20160904043611.6nw2vjhs3j2cnnqm@kmo-pixel>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:7148 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750992AbcIINa5 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 9 Sep 2016 09:30:57 -0400
In-Reply-To: <20160904043611.6nw2vjhs3j2cnnqm@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: =?UTF-8?q?Marcin=20Miros=C5=82aw?= <marcin@mejor.pl>

---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index e9ca92d..a3cb1fa 100644
--- a/Makefile
+++ b/Makefile
@@ -5,8 +5,8 @@ CFLAGS:=-std=gnu99 -O2 -Wall -D_FILE_OFFSET_BITS=64 -I. $(CFLAGS)
 LDFLAGS+=
 
 PKGCONFIG_LIBS="blkid uuid libnih"
-CFLAGS+=`pkg-config --cflags	${PKGCONFIG_LIBS}`
-LDLIBS+=`pkg-config --libs	${PKGCONFIG_LIBS}` -lscrypt -lsodium -lkeyutils
+CFLAGS+=$(shell pkg-config --cflags	${PKGCONFIG_LIBS})
+LDLIBS+=$(shell pkg-config --libs	${PKGCONFIG_LIBS}) -lscrypt -lsodium -lkeyutils
 
 ifeq ($(PREFIX),/usr)
 	ROOT_SBINDIR=/sbin
-- 
2.7.3
