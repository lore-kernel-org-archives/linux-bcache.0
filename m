From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: Re: [bcachefs] bcache (dm-10): IO error on dm-10 for checksum error
 (due to change of str_hash?)
Date: Thu, 15 Sep 2016 11:39:55 +0200
Message-ID: <382be297-c74f-8e5b-c9ad-60783359fbb6@mejor.pl>
References: <0d572bc6-179d-f779-5d40-6fba6c66a3e6@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:59216 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1765152AbcIOJki (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 15 Sep 2016 05:40:38 -0400
In-Reply-To: <0d572bc6-179d-f779-5d40-6fba6c66a3e6@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

And I can't mount fs again:
[ 9620.478666] bcache (dm-10): journal replay done, 2218 keys in 100
entries, seq 63824
[ 9623.561759] bcache: bch_open_as_blockdevs() register_cache_set err
error gcing inode nlinks
[ 9623.584080] bcache (dm-10): stopped

Marcin
