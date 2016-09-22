From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: [bcachefs] checksum error probably after switching to crc64
Date: Thu, 22 Sep 2016 12:58:04 +0200
Message-ID: <74415af5-1208-22e5-acd5-6f94410056e3@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:63262 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756154AbcIVK7H (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 22 Sep 2016 06:59:07 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi!
I'm at:
commit b7cb7779de9609899fa53f7bab4e3cee69ac1f7e
Author: Kent Overstreet <kent.overstreet@gmail.com>
Date:   Wed Sep 21 17:38:38 2016 -0800

    bcache: fix an ordering issue in btree_interior_update code

    Also a bunch of refactoring


Steps:
# bcache format --discard  --compression_type=lz4 /dev/system10/bcache
(underlaying devices does not support discard)
# mount & use fs
# echo crc64 > data_checksum
# echo crc64 > metadata_checksum
# use filesystem
After sometime I'm getting:
[ 6444.192279] bcache (dm-11): IO error on dm-11 for checksum error
