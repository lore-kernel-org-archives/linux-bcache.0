From: Thorkild Stray <thorkild.stray@cxense.com>
Subject: Fwd: Stale bcache (writethrough) leading to cache being disabled.
Date: Wed, 9 Apr 2014 06:05:39 +0200
Message-ID: <CAJ0Z65yHV_VM2=YWZx2T5DcQwQ=wnVz-T_acgxJWQi0JZAEFcg@mail.gmail.com>
References: <CAJ0Z65yaZMPVy0z0BseQf0s57Tf8wRkHKeqHLPof5TDyyZEmTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ve0-f182.google.com ([209.85.128.182]:39807 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaDIEFk (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 9 Apr 2014 00:05:40 -0400
Received: by mail-ve0-f182.google.com with SMTP id jw12so1660762veb.27
        for <linux-bcache@vger.kernel.org>; Tue, 08 Apr 2014 21:05:40 -0700 (PDT)
In-Reply-To: <CAJ0Z65yaZMPVy0z0BseQf0s57Tf8wRkHKeqHLPof5TDyyZEmTw@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi,

Setup:
Kernel: 3.11.10-15, with "Data corruption fix"
(http://evilpiepirate.org/git/linux-bcache.git/commit/drivers/md/bcache/bset.c?h=bcache-dev&id=ef71ec00002d92a08eb27e9d036e3d48835b6597)
on top of it (before the fix, I could regularly reproduce data
corruption on if the btree shrinker was enabled ).Running in
writethrough with sequential merging turned off. The application on
top does large sequential writes periodically, which are then accessed
in a random-read fashion.  This gives us a substantial performance
boost on these nodes.
Backing md-raid directly on top of physical disks, no LVM
Partitioned ssd where 200GB is used as cache above a raid-1 of 2 spinning disks.

The problem is that some of these nodes are now disabling bcache.
(Probably) Due to writethrough, the data is still consistent (no
corruption has been detected), so the impact is just very bad
performance (i.e spinning disks only). Content of
/sys/block/bcache0/bcache/state is "no cache" on these nodes after it
disables itself.

The specific kernel message when it disables itself is:

2014-03-25T23:55:03.525100+00:00 machine1 kernel: [6822460.984018]
bcache: error on 5acb2ff8-db07-4d13-a6ca-dbfdbf1d87eb: key too stale:
97, need_gc 97, disabling caching

If I reenables the cache again, it bombs out with the same message
again. cache_mode

Digging further back in the history, I found:
2014-03-24T13:47:34.973100+00:00 machine1 kernel: [6699681.169256]
WARNING: CPU: 5 PID: 293092 at
/home/thorkild/kernel-w-bcace/drivers/md/bcache/alloc.c:80
bch_inc_gen+0x9a/0xe0 [bcache]()
2014-03-24T13:47:34.973104+00:00 machine1 kernel: [6699681.169258]
Modules linked in: iptable_nat nf_nat_ipv4 nf_nat xt_LOG xt_limit
xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_set xt_conntrack
nf_conntrack iptable_filter ip_tables x_tables ip_set_hash_ip ip_set
nfnetlink ipip ip_tunnel tunnel4 eeepc_wmi asus_wmi sparse_keymap
mei_me serio_raw video mei mac_hid lpc_ich wmi lp parport bcache
raid10 raid456 async_pq async_xor async_memcpy async_raid6_recov
async_tx raid1 raid0 multipath linear btrfs raid6_pq e1000e ahci
libahci ptp pps_core xor zlib_deflate
2014-03-24T13:47:34.973106+00:00 machine1 kernel: [6699681.169277]
CPU: 5 PID: 293092 Comm: kworker/5:0 Not tainted 3.11.10-15-generic
#23~f5
2014-03-24T13:47:34.973130+00:00 machine1 kernel: [6699681.169278]
Hardware name: System manufacturer System Product Name/P8B WS, BIOS
2106 07/16/2012
2014-03-24T13:47:34.973131+00:00 machine1 kernel: [6699681.169283]
Workqueue: bcache bch_journal [bcache]
2014-03-24T13:47:34.973132+00:00 machine1 kernel: [6699681.169284]
0000000000000050 ffff88028e3dba98 ffffffff8173bc0e 0000000000000007
2014-03-24T13:47:34.973133+00:00 machine1 kernel: [6699681.169286]
0000000000000000 ffff88028e3dbad8 ffffffff810653ac ffff88028e3dbad8
2014-03-24T13:47:34.973134+00:00 machine1 kernel: [6699681.169288]
ffffc90007764bbc ffff8807f34b6000 000007ffffffffff 0000000000000000
2014-03-24T13:47:34.973134+00:00 machine1 kernel: [6699681.169290] Call Trace:
2014-03-24T13:47:34.973136+00:00 machine1 kernel: [6699681.169294]
[<ffffffff8173bc0e>] dump_stack+0x46/0x58
2014-03-24T13:47:34.973137+00:00 machine1 kernel: [6699681.169297]
[<ffffffff810653ac>] warn_slowpath_common+0x8c/0xc0
2014-03-24T13:47:34.973138+00:00 machine1 kernel: [6699681.169299]
[<ffffffff810653fa>] warn_slowpath_null+0x1a/0x20
2014-03-24T13:47:34.973139+00:00 machine1 kernel: [6699681.169302]
[<ffffffffa01d033a>] bch_inc_gen+0x9a/0xe0 [bcache]
2014-03-24T13:47:34.973140+00:00 machine1 kernel: [6699681.169304]
[<ffffffff81743ae9>] ? mutex_lock+0x39/0x41
2014-03-24T13:47:34.973140+00:00 machine1 kernel: [6699681.169308]
[<ffffffffa01d2b48>] btree_node_free+0x138/0x210 [bcache]
2014-03-24T13:47:34.973141+00:00 machine1 kernel: [6699681.169311]
[<ffffffffa01d78a1>] btree_split+0x3f1/0x740 [bcache]
2014-03-24T13:47:34.973142+00:00 machine1 kernel: [6699681.169315]
[<ffffffffa01dc509>] ? bch_btree_iter_next_filter+0x39/0x50 [bcache]
2014-03-24T13:47:34.973143+00:00 machine1 kernel: [6699681.169318]
[<ffffffffa01d7feb>] bch_btree_insert_recurse+0x3fb/0x510 [bcache]
2014-03-24T13:47:34.973144+00:00 machine1 kernel: [6699681.169322]
[<ffffffffa01d7f78>] bch_btree_insert_recurse+0x388/0x510 [bcache]
2014-03-24T13:47:34.973145+00:00 machine1 kernel: [6699681.169325]
[<ffffffffa01d8256>] bch_btree_insert+0x156/0x330 [bcache]
2014-03-24T13:47:34.973146+00:00 machine1 kernel: [6699681.169330]
[<ffffffffa01e490a>] bch_btree_insert_async+0x1a/0xe0 [bcache]
2014-03-24T13:47:34.973147+00:00 machine1 kernel: [6699681.169333]
[<ffffffffa01df429>] bch_journal+0x49/0x300 [bcache]
2014-03-24T13:47:34.973147+00:00 machine1 kernel: [6699681.169336]
[<ffffffff81081060>] process_one_work+0x170/0x4a0
2014-03-24T13:47:34.973148+00:00 machine1 kernel: [6699681.169338]
[<ffffffff81082121>] worker_thread+0x121/0x390
2014-03-24T13:47:34.973149+00:00 machine1 kernel: [6699681.169339]
[<ffffffff81082000>] ? manage_workers.isra.21+0x170/0x170
2014-03-24T13:47:34.973150+00:00 machine1 kernel: [6699681.169342]
[<ffffffff81088fe0>] kthread+0xc0/0xd0
2014-03-24T13:47:34.973151+00:00 machine1 kernel: [6699681.169343]
[<ffffffff81088f20>] ? flush_kthread_worker+0xb0/0xb0
2014-03-24T13:47:34.973151+00:00 machine1 kernel: [6699681.169346]
[<ffffffff817508ac>] ret_from_fork+0x7c/0xb0
2014-03-24T13:47:34.973152+00:00 machine1 kernel: [6699681.169348]
[<ffffffff81088f20>] ? flush_kthread_worker+0xb0/0xb0
2014-03-24T13:47:34.973153+00:00 machine1 kernel: [6699681.169349]
---[ end trace 9b2a76687ddee9b0 ]---

We've run for a while (probably a bit over 3 months) with the btree
shrinker disabled (due to it leading to corruption before
3.11.10-15+prerelease of the mentioned fix on these boxes - I seemed
to be the only able to reproduce that issue), and I am wondering if
this may be the root cause of the first complaint. This then leads to
an inconsistent cache, which makes bcache then politely disable
itself.

We're now running with the btree shrinker enabled, and I was wondering:

1) Is my theory about this being due to the shrinker disabled plausible?

2) The cache set cleanly disabled itself, so what I would like to do
is to just reset the cache device without touching the backing device,
and readd it to see if the problem will occur over time with the
shrinker enabled too. Has anybody done something like that?
Thanks for any input. Before this, bcache has been very useful on these servers.

--
Thorkild
