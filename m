From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: Compilation error: ERROR: "pagecache_add_put"
 [drivers/md/bcache/bcache.ko] undefined!
Date: Tue, 29 Mar 2016 16:12:12 +0200
Message-ID: <56FA8D3C.60307@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:63546 "EHLO jowisz.mejor.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbcC2OMn (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 29 Mar 2016 10:12:43 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi again!
Since commit 53b6273b131a864947a2c55a18c07e86487e0a87 I'm getting error=
s:
Kernel: arch/x86/boot/bzImage is ready  (#6)
  Building modules, stage 2.
  MODPOST 538 modules
ERROR: "pagecache_add_put" [drivers/md/bcache/bcache.ko] undefined!
ERROR: "pagecache_block_put" [drivers/md/bcache/bcache.ko] undefined!
ERROR: "pagecache_add_get" [drivers/md/bcache/bcache.ko] undefined!
ERROR: "__pagecache_block_get" [drivers/md/bcache/bcache.ko] undefined!
ERROR: "__pagecache_block_put" [drivers/md/bcache/bcache.ko] undefined!
ERROR: "pagecache_block_get" [drivers/md/bcache/bcache.ko] undefined!
scripts/Makefile.modpost:91: polecenia dla obiektu '__modpost' nie
powiod=C5=82y si=C4=99
make[1]: *** [__modpost] B=C5=82=C4=85d 1
Makefile:1108: recipe for target 'modules' failed
make: *** [modules] Error 2

Marcin
