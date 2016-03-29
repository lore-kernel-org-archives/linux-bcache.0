From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: Error after filling up fileystem (resend to correct email)
Date: Tue, 29 Mar 2016 12:41:27 +0200
Message-ID: <56FA5BD7.1060405@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:29758 "EHLO jowisz.mejor.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbcC2Krn (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 29 Mar 2016 06:47:43 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi!

Because I don't know what features should work I think it's better to
report a bug than do nothing.
I created fs, mounted, then I changed compression (via sysfs) to lz4.
Next I copied portage tree to filesystem. Then I started to think why
"compression_stats" shows that data are compressed but `df` shows values
that looks like data are uncompressed:
cat compression_stats
uncompressed data:
        nr extents:                     1976
        size (bytes):                   1784832
compressed data:
        nr extents:                     282264
        compressed size (bytes):        346365952
        uncompressed size (bytes):      6398948352

df -h:
Filesystem                          Size  Used Avail Use% Mounted on
/dev/mapper/system10-bcacheportage  4.0G  4.0G   82M  99% /usr/portage

So I started to create file filled with zeroes: `dd if=/dev/zero
of=/path/file bs=1M". I filled up filesystem. Then I run `emerge` and I
got I/O error. In dmesg I see:

[ 4466.898819] kworker/u8:0: page allocation failure: order:4,
mode:0x2404000
[ 4466.898825] CPU: 1 PID: 10103 Comm: kworker/u8:0 Tainted: P
 O    4.5.0+ #1
[ 4466.898827] Hardware name:                  /D975XBX, BIOS
BX97510J.86A.1487.2007.0902.1724 09/02/2007
[ 4466.898862] Workqueue: events_unbound bch_bio_decompress_work [bcache]
[ 4466.898865]  0000000000000286 0000000099ecc77f ffff880080b3fa40
ffffffff812aa7c8
[ 4466.898868]  0000000002404000 0000000000000000 ffff880080b3fad0
ffffffff8111ca87
[ 4466.898871]  0000004000000001 0000000000000286 0000000099ecc77f
0000000000000004
[ 4466.898874] Call Trace:
[ 4466.898880]  [<ffffffff812aa7c8>] dump_stack+0x4d/0x65
[ 4466.898884]  [<ffffffff8111ca87>] warn_alloc_failed+0xf7/0x150
[ 4466.898887]  [<ffffffff8111febd>] __alloc_pages_nodemask+0x4ad/0xbd0
[ 4466.898890]  [<ffffffff811207ed>] alloc_kmem_pages+0x1d/0x90
[ 4466.898893]  [<ffffffff8113a3a3>] kmalloc_order+0x13/0x40
[ 4466.898895]  [<ffffffff8113a3ef>] kmalloc_order_trace+0x1f/0xa0
[ 4466.898897]  [<ffffffff81169112>] __kmalloc+0x1b2/0x210
[ 4466.898912]  [<ffffffffc06c3fbf>] __bch_read_endio+0x3af/0x7e0 [bcache]
[ 4466.898915]  [<ffffffff81085642>] ? dequeue_entity+0x412/0x9f0
[ 4466.898930]  [<ffffffffc06c5e5c>] bch_bio_decompress_work+0x3c/0x50
[bcache]
[ 4466.898933]  [<ffffffff8106bd9e>] process_one_work+0x13e/0x400
[ 4466.898936]  [<ffffffff8106c3a9>] worker_thread+0x49/0x470
[ 4466.898938]  [<ffffffff8106c360>] ? rescuer_thread+0x300/0x300
[ 4466.898940]  [<ffffffff81071033>] kthread+0xd3/0xf0
[ 4466.898943]  [<ffffffff81070f60>] ? kthread_park+0x50/0x50
[ 4466.898946]  [<ffffffff8152c29f>] ret_from_fork+0x3f/0x70
[ 4466.898948]  [<ffffffff81070f60>] ? kthread_park+0x50/0x50
[ 4466.898950] Mem-Info:
[ 4466.898954] active_anon:188664 inactive_anon:189553 isolated_anon:0
                active_file:151743 inactive_file:513528 isolated_file:0
                unevictable:1805 dirty:48 writeback:0 unstable:0
                slab_reclaimable:21540 slab_unreclaimable:29725
                mapped:39537 shmem:5913 pagetables:4413 bounce:0
                free:12010 free_pcp:0 free_cma:0
[ 4466.898962] DMA free:15828kB min:28kB low:32kB high:40kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15984kB
managed:15900kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB free_pcp:0kB local_pcp:0kB
free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[ 4466.898964] lowmem_reserve[]: 0 3232 4427 4427
[ 4466.898972] DMA32 free:24396kB min:6204kB low:7752kB high:9304kB
active_anon:551804kB inactive_anon:522896kB active_file:501116kB
inactive_file:1496708kB unevictable:5232kB isolated(anon):0kB
isolated(file):0kB present:3388968kB managed:3314188kB mlocked:5232kB
dirty:144kB writeback:0kB mapped:116660kB shmem:17384kB
slab_reclaimable:59880kB slab_unreclaimable:64416kB kernel_stack:4992kB
pagetables:13236kB unstable:0kB bounce:0kB free_pcp:0kB local_pcp:0kB
free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[ 4466.898974] lowmem_reserve[]: 0 0 1194 1194
[ 4466.898981] Normal free:7816kB min:2292kB low:2864kB high:3436kB
active_anon:202852kB inactive_anon:235316kB active_file:105856kB
inactive_file:557404kB unevictable:1988kB isolated(anon):0kB
isolated(file):0kB present:1310720kB managed:1223584kB mlocked:1988kB
dirty:48kB writeback:0kB mapped:41488kB shmem:6268kB
slab_reclaimable:26280kB slab_unreclaimable:54476kB kernel_stack:2368kB
pagetables:4416kB unstable:0kB bounce:0kB free_pcp:0kB local_pcp:0kB
free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[ 4466.898983] lowmem_reserve[]: 0 0 0 0
[ 4466.898986] DMA: 1*4kB (U) 0*8kB 1*16kB (U) 0*32kB 1*64kB (U) 1*128kB
(U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15828kB
[ 4466.898999] DMA32: 3845*4kB (UME) 741*8kB (UME) 134*16kB (UME)
29*32kB (UM) 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB =
24380kB
[ 4466.899009] Normal: 875*4kB (UME) 107*8kB (UM) 218*16kB (M) 4*32kB
(UM) 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 7972kB
[ 4466.899019] Node 0 hugepages_total=0 hugepages_free=0
hugepages_surp=0 hugepages_size=2048kB
[ 4466.899021] 673295 total pagecache pages
[ 4466.899023] 586 pages in swap cache
[ 4466.899025] Swap cache stats: add 7613, delete 7027, find 938/1569
[ 4466.899026] Free swap  = 6265340kB
[ 4466.899027] Total swap = 6291452kB
[ 4466.899029] 1178918 pages RAM
[ 4466.899030] 0 pages HighMem/MovableOnly
[ 4466.899031] 40500 pages reserved
[ 4466.899032] 4096 pages cma reserved
[ 4466.899036] bcache (dm-15): IO error: decompression error
[ 4466.899687] kworker/u8:0: page allocation failure: order:4,
mode:0x2404000
[ 4466.899696] CPU: 1 PID: 10103 Comm: kworker/u8:0 Tainted: P
 O    4.5.0+ #1
[ 4466.899697] Hardware name:                  /D975XBX, BIOS
BX97510J.86A.1487.2007.0902.1724 09/02/2007
[ 4466.899712] Workqueue: events_unbound bch_bio_decompress_work [bcache]
[ 4466.899714]  0000000000000286 0000000099ecc77f ffff880080b3fa40
ffffffff812aa7c8
[ 4466.899717]  0000000002404000 0000000000000000 ffff880080b3fad0
ffffffff8111ca87
[ 4466.899720]  0000004000000001 0000000000000286 0000000099ecc77f
0000000000000004
[ 4466.899722] Call Trace:
[ 4466.899726]  [<ffffffff812aa7c8>] dump_stack+0x4d/0x65
[ 4466.899728]  [<ffffffff8111ca87>] warn_alloc_failed+0xf7/0x150
[ 4466.899731]  [<ffffffff8111febd>] __alloc_pages_nodemask+0x4ad/0xbd0
[ 4466.899734]  [<ffffffff811207ed>] alloc_kmem_pages+0x1d/0x90
[ 4466.899736]  [<ffffffff8113a3a3>] kmalloc_order+0x13/0x40
[ 4466.899738]  [<ffffffff8113a3ef>] kmalloc_order_trace+0x1f/0xa0
[ 4466.899740]  [<ffffffff81169112>] __kmalloc+0x1b2/0x210
[ 4466.899754]  [<ffffffffc06c3fbf>] __bch_read_endio+0x3af/0x7e0 [bcache]
[ 4466.899756]  [<ffffffff81085642>] ? dequeue_entity+0x412/0x9f0
[ 4466.899758]  [<ffffffff81084a4f>] ? set_next_entity+0x9f/0x820
[ 4466.899773]  [<ffffffffc06c5e5c>] bch_bio_decompress_work+0x3c/0x50
[bcache]
[ 4466.899776]  [<ffffffff8106bd9e>] process_one_work+0x13e/0x400
[ 4466.899778]  [<ffffffff8106c3a9>] worker_thread+0x49/0x470
[ 4466.899780]  [<ffffffff8106c360>] ? rescuer_thread+0x300/0x300
[ 4466.899782]  [<ffffffff81071033>] kthread+0xd3/0xf0
[ 4466.899784]  [<ffffffff81070f60>] ? kthread_park+0x50/0x50
[ 4466.899786]  [<ffffffff8152c29f>] ret_from_fork+0x3f/0x70
[ 4466.899788]  [<ffffffff81070f60>] ? kthread_park+0x50/0x50
[ 4466.899790] Mem-Info:
[ 4466.899794] active_anon:188664 inactive_anon:189553 isolated_anon:0
                active_file:151743 inactive_file:513528 isolated_file:0
                unevictable:1805 dirty:48 writeback:0 unstable:0
                slab_reclaimable:21540 slab_unreclaimable:29725
                mapped:39537 shmem:5913 pagetables:4413 bounce:0
                free:11979 free_pcp:0 free_cma:0
[ 4466.899801] DMA free:15828kB min:28kB low:32kB high:40kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15984kB
managed:15900kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB free_pcp:0kB local_pcp:0kB
free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[ 4466.899803] lowmem_reserve[]: 0 3232 4427 4427
[ 4466.899810] DMA32 free:24396kB min:6204kB low:7752kB high:9304kB
active_anon:551804kB inactive_anon:522896kB active_file:501116kB
inactive_file:1496708kB unevictable:5232kB isolated(anon):0kB
isolated(file):0kB present:3388968kB managed:3314188kB mlocked:5232kB
dirty:144kB writeback:0kB mapped:116660kB shmem:17384kB
slab_reclaimable:59880kB slab_unreclaimable:64416kB kernel_stack:4992kB
pagetables:13236kB unstable:0kB bounce:0kB free_pcp:0kB local_pcp:0kB
free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[ 4466.899812] lowmem_reserve[]: 0 0 1194 1194
[ 4466.899819] Normal free:7692kB min:2292kB low:2864kB high:3436kB
active_anon:202852kB inactive_anon:235316kB active_file:105856kB
inactive_file:557404kB unevictable:1988kB isolated(anon):0kB
isolated(file):0kB present:1310720kB managed:1223584kB mlocked:1988kB
dirty:48kB writeback:0kB mapped:41488kB shmem:6268kB
slab_reclaimable:26280kB slab_unreclaimable:54476kB kernel_stack:2368kB
pagetables:4416kB unstable:0kB bounce:0kB free_pcp:0kB local_pcp:0kB
free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[ 4466.899821] lowmem_reserve[]: 0 0 0 0
[ 4466.899824] DMA: 1*4kB (U) 0*8kB 1*16kB (U) 0*32kB 1*64kB (U) 1*128kB
(U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15828kB
[ 4466.899836] DMA32: 3845*4kB (UME) 741*8kB (UME) 134*16kB (UME)
29*32kB (UM) 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB =
24380kB
[ 4466.899845] Normal: 875*4kB (UME) 107*8kB (UM) 218*16kB (M) 4*32kB
(UM) 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 7972kB
[ 4466.899855] Node 0 hugepages_total=0 hugepages_free=0
hugepages_surp=0 hugepages_size=2048kB
[ 4466.899857] 673295 total pagecache pages
[ 4466.899858] 586 pages in swap cache
[ 4466.899860] Swap cache stats: add 7613, delete 7027, find 938/1569
[ 4466.899861] Free swap  = 6265340kB
[ 4466.899863] Total swap = 6291452kB
[ 4466.899864] 1178918 pages RAM
[ 4466.899865] 0 pages HighMem/MovableOnly
[ 4466.899866] 40500 pages reserved
[ 4466.899867] 4096 pages cma reserved
[ 4466.899869] bcache (dm-15): IO error: decompression error


Accesing this file with zeroes throws I/O error, it looks that other
files are accesible. After removing this file with zeroes free space is
not returned.

tree is at b7a59792c9834af83b2264ea0187773adfde3e03

Marcin
