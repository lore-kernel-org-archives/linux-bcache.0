From: =?UTF-8?q?Marcin=20Miros=C5=82aw?= <marcin@mejor.pl>
Subject: [PATCH v2 2/4] No need to spawn subshell for every source file.
Date: Tue, 13 Sep 2016 12:55:42 +0200
Message-ID: <1473764144-18993-2-git-send-email-marcin@mejor.pl>
References: <1473764144-18993-1-git-send-email-marcin@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:49854 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756062AbcIMK4k (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 13 Sep 2016 06:56:40 -0400
In-Reply-To: <1473764144-18993-1-git-send-email-marcin@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: =?UTF-8?q?Marcin=20Miros=C5=82aw?= <marcin@mejor.pl>

Until now every time cc was invoked also was pkgconfig invoked:
$ cc ... `pkg-config --cflags        "blkid uuid libnih"`
Output of pkg-config can be gather once and then used for all compiler invocation.

Signed-off-by: Marcin Mirosław <marcin@mejor.pl>
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
