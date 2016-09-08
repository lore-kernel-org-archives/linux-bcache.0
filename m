From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: [bcachefs] bcachefs-tools compilation error: crypto.h:16:59: error:
 initializer element is not constant, static const struct nonce
 bch_master_key_nonce = BCACHE_MASTER_KEY_NONCE;
Date: Thu, 8 Sep 2016 17:21:04 +0200
Message-ID: <21ae7146-855c-bbaa-faa1-3ec0148cce49@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:19052 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934545AbcIHPVz (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 8 Sep 2016 11:21:55 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi!

I'm compiling bcachefs-tools on gcc-4.9.3, hardend, with pie/ssp patches.
Compilation failed  and gcc throwed:
cc -O2 -std=gnu99 -Wall -D_FILE_OFFSET_BITS=64 -I. `pkg-config --cflags
"blkid uuid libnih"`   -c -o bcache-format.o bcache-format.c
In file included from bcache-format.c:29:0:
crypto.h:16:59: error: initializer element is not constant
 static const struct nonce bch_master_key_nonce = BCACHE_MASTER_KEY_NONCE;
                                                           ^

I'm confused with option "--block=size", what is default value of this
option? 4096? 512 (according to /sys/fs/bcache/<uuid>/block_size)?
Do I correctly understand from sources that block_size defaults to max
value of block size from all formated devices?

Thanks,
Marcin
