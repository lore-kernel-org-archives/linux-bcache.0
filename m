From: Igor Pavlenko <ipavlenko.mail@gmail.com>
Subject: bcache crashes at boot time
Date: Mon, 5 Jun 2017 15:38:27 +0300
Message-ID: <CAE4BCM2DCZ5E29AbXmDwn8T3VBzUczLZa+CXkYVH_dZNrcqVeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pg0-f48.google.com ([74.125.83.48]:33654 "EHLO
        mail-pg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751667AbdFEMi2 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 5 Jun 2017 08:38:28 -0400
Received: by mail-pg0-f48.google.com with SMTP id f185so19834190pgc.0
        for <linux-bcache@vger.kernel.org>; Mon, 05 Jun 2017 05:38:28 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi

Bcache crashes at boot time making root fs unavailable. Same error
occurs when I try to add caching and backing devices manually through
/sys/fs/bcache/register. I reproduced the error on ubuntu 17.04
(kernel 4.10.0) and fedora (4.4.67).

The cache was in writeback mode.

Is it possible to recover my data?

dmesg output:

[   45.941155] bcache: register_bdev() registered backing device sda3
[   46.138238] bcache: error on 471776aa-1b34-4eff-ba7d-509a9554b43d:
inconsistent ptrs: mark = 3, level = 0, disabling caching
[   46.139868] CPU: 0 PID: 1495 Comm: bcache-register Tainted: G     U
[   46.154267]  [<ffffffffc090ba34>]
__bch_btree_mark_key.part.23+0x244/0x270 [bcache]
[   46.156051]  [<ffffffffc090e3df>] bch_initial_mark_key+0xdf/0xf0 [bcache]
[   46.157744]  [<ffffffffc090e44c>] bch_btree_check_recurse+0x5c/0x230 [bcache]
[   46.159432]  [<ffffffffc090db2a>] ? bch_btree_node_get+0xba/0x280 [bcache]
[   46.160994]  [<ffffffffc090e51f>]
bch_btree_check_recurse+0x12f/0x230 [bcache]
[   46.162428]  [<ffffffffc0913738>] ? __bch_submit_bbio+0x58/0x60 [bcache]
[   46.163894]  [<ffffffffc090e800>] bch_btree_check+0x180/0x1d0 [bcache]
[   46.166862]  [<ffffffffc091d5d5>] run_cache_set+0x3b5/0x8e0 [bcache]
[   46.168399]  [<ffffffffc091ee47>] register_bcache+0xe07/0x11b0 [bcache]
[   47.182133] bcache: bch_journal_replay() journal replay done,
237858 keys in 207 entries, seq 3687554
[   47.184437] bcache: bch_cached_dev_attach() Can't attach sda3: shutting down
[   47.186168] bcache: register_cache() registered cache device sdb1
[   47.187538] bcache: cache_set_free() Cache set
471776aa-1b34-4eff-ba7d-509a9554b43d unregistered


-- 
Igor Pavlenko
ipavlenko.mail@gmail.com
