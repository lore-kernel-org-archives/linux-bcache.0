From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: [bcachefs] bcache: bch_open_as_blockdevs() register_cache_set err Bad
 checksum
Date: Fri, 9 Sep 2016 09:36:59 +0200
Message-ID: <18fba014-c2d9-2685-cf6d-b1ee0de35bda@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:19790 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751913AbcIIHh4 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 9 Sep 2016 03:37:56 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi!
Today I launched host at my job. When I tried to mount bcachefs I got:
bcache: bch_open_as_blockdevs() register_cache_set err Bad checksum

This is simple, not tieres fs. I don't have idea what to do next to help
debug this. Data on this fs are completely unimportant.

Marcin
