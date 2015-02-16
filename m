From: Lucas Clemente Vella <lvella@gmail.com>
Subject: Breaking chages from 3.13.0 to 3.17.1
Date: Mon, 16 Feb 2015 00:20:20 -0200
Message-ID: <CAGCathzXBxg1aOBCJ4cmhEmeMVsdXOScA6kn=eNZeZgOSsSd-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:42689 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbbBPCUl (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sun, 15 Feb 2015 21:20:41 -0500
Received: by mail-ig0-f178.google.com with SMTP id hl2so21091454igb.5
        for <linux-bcache@vger.kernel.org>; Sun, 15 Feb 2015 18:20:40 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi, I've updated my kernel from 3.13.0 to 3.16.0, but the new kernel
wouldn't boot (I belive because of my bcache setup). So I have updated
a little further to kernel 3.17.1, and now it boots, but I get the
following log messages:

$ dmesg | grep bcache
[    1.156474] bcache: error on 585603df-7dd5-4d6f-a2ab-e80b59cc994d:
no journal entries found, disabling caching
[    1.157393] bcache: register_cache() registered cache device sdb
[    1.157464] bcache: register_bdev() registered backing device sda2
[    1.157598] bcache: register_bdev() registered backing device sda1
[    1.157695] bcache: cache_set_free() Cache set
585603df-7dd5-4d6f-a2ab-e80b59cc994d unregistered
[    1.239026] EXT4-fs (bcache1): mounted filesystem with ordered data
mode. Opts: (null)
[    1.425166] bcache: bch_journal_replay() journal replay done, 788
keys in 92 entries, seq 1095169
[    1.455283] bcache: bch_cached_dev_attach() Caching sda2 as bcache0
on set 25497b90-14dd-4242-b35a-a15598492902
[    1.455317] bcache: register_cache() registered cache device sdb3
[    5.011443] EXT4-fs (bcache1): re-mounted. Opts: errors=remount-ro
[    7.649948] EXT4-fs (bcache0): mounted filesystem with ordered data
mode. Opts: (null)

This first message worries me, and I didn't had it before. Does it
means that the SSD caching is bypassed entirely? Was there any
incompatible changes between the two kernel versions? If so, how can I
safely reenable the caching?

It seems weird that it is trying to sdb as cache device, because only
the partition sdb3 was formated as cache.

The panic is also registered here:

$ cat /sys/fs/bcache/25497b90-14dd-4242-b35a-a15598492902/errors
[unregister] panic

Nonetheless, it seems to be working:
$ cat /sys/fs/bcache/25497b90-14dd-4242-b35a-a15598492902/stats_five_minute/cache_hit_ratio
66

For comparision, this is what I get with the old kernel (3.13.0):

$ dmesg | grep bcache
[    6.688644] bcache: bch_journal_replay() journal replay done, 471
keys in 55 entries, seq 1096484
[    6.688828] bcache: register_cache() registered cache device sdb3
[    6.689292] bcache: register_bdev() registered backing device sda2
[    6.702362] bcache: bch_cached_dev_attach() Caching sda2 as bcache0
on set 25497b90-14dd-4242-b35a-a15598492902
[    6.710999] bcache: register_bdev() registered backing device sda1
[    6.805596] EXT4-fs (bcache1): mounted filesystem with ordered data
mode. Opts: (null)
[    9.456598] EXT4-fs (bcache1): re-mounted. Opts: errors=remount-ro
[    9.678654] EXT4-fs (bcache0): mounted filesystem with ordered data
mode. Opts: (null

-- 
Lucas Clemente Vella
lvella@gmail.com
