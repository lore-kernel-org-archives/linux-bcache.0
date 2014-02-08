From: Josep Lladonosa <jlladono@gmail.com>
Subject: Fwd: bcache and memory at boot. Bug?
Date: Sat, 8 Feb 2014 09:53:19 +0100
Message-ID: <CAPBO7TbEAf7Bhb-kTFQ00CmBih5CdsXRHeOSf4STxQ+ndy66dQ@mail.gmail.com>
References: <CAPBO7TYBMn=oU8K-6EGzw2LofwHPHm742GbzgGYmdbHt5g7sNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:43954 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbaBHIxU (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sat, 8 Feb 2014 03:53:20 -0500
Received: by mail-oa0-f43.google.com with SMTP id h16so5425921oag.16
        for <linux-bcache@vger.kernel.org>; Sat, 08 Feb 2014 00:53:19 -0800 (PST)
In-Reply-To: <CAPBO7TYBMn=oU8K-6EGzw2LofwHPHm742GbzgGYmdbHt5g7sNQ@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Hello,

I am using bcache in my laptop (RAM 32 GiB). I have been using it
perfectly for a month. ext4 + bcache.

Yesterday, system did not want do to a normal startup. Messages where
from udev out of memory (and udevadm killed?) and system was not
mounting / (/dev/bcache0).

After verifying/trying some things I found that:

bcache tries to prepare /dev/bcache0 but something happens (udev
related?) and the caching device is slave of it. If bcache can go on,
then prepares /dev/bcache1 with the same caching device and the
backing device.

# ls /sys/block/bcache?/slaves
/sys/block/bcache0/slaves:
sda1

/sys/block/bcache1/slaves:
sda1  sdb7

# cat /sys/block/bcache?/stat
     418        0     3344        0        0        0        0
0        0        0        0
  137372        0  2151740   456928     2476        0   138440
46252        0        0        0


so mounting /dev/bcache1 allows normal startup, but with something
messed up, I guess.

I got two ways for booting:

1) If I boot with only 16 GiB of RAM, it runs O.K. (physically only 16
GiB or with boot parameter mem=16G - mem=17G also boots; mem=20G does
not boot well)

2) booting with /dev/bcache1 as the root filesystem.

In this second case, I can see dmesg, so here it goes:

[    3.619572] bcache: bch_journal_replay() journal replay done, 754
keys in 46 entries, seq 443121
[    6.746571] bcache-register invoked oom-killer: gfp_mask=0x82d2,
order=0, oom_score_adj=0
[    6.746575] bcache-register cpuset=/ mems_allowed=0
[    6.746578] CPU: 1 PID: 296 Comm: bcache-register Not tainted 3.12.9 #1
[    6.746580] Hardware name: Micro-Star International Co., Ltd.
GT60/MS-16F3, BIOS E16F3IMS.10U 01/21/2013
[    6.746581]  0000ebc8000000e3 ffffffff8137e021 ffff8800371ab0c0
ffffffff8137c481
[    6.746584]  ffffffff8138110e ffffffff8138038b 0000000000000020
ffffffff810363f2
[    6.746587]  ffffffff81099f9b ffff880803afa040 ffffffff814fb060
0000000000000000
[    6.746589] Call Trace:
[    6.746596]  [<ffffffff8137e021>] ? dump_stack+0x41/0x51
[    6.746599]  [<ffffffff8137c481>] ? dump_header+0x70/0x1a2
[    6.746601]  [<ffffffff8138110e>] ? _cond_resched+0x5/0x14
[    6.746604]  [<ffffffff8138038b>] ? mutex_lock+0x9/0x25
[    6.746608]  [<ffffffff810363f2>] ? put_online_cpus+0x1e/0x64
[    6.746612]  [<ffffffff81099f9b>] ? rcu_oom_notify+0xc0/0xd2
[    6.746614]  [<ffffffff810bee32>] ? oom_kill_process+0x6f/0x2c0
[    6.746616]  [<ffffffff810bf590>] ? out_of_memory+0x3d8/0x3f1
[    6.746619]  [<ffffffff810c365d>] ? __alloc_pages_nodemask+0x64e/0x7d0
[    6.746624]  [<ffffffff810f0f15>] ? alloc_pages_current+0xef/0x109
[    6.746627]  [<ffffffff810e70aa>] ? __vmalloc_node_range+0x143/0x1de
[    6.746635]  [<ffffffffa01d7d1c>] ? bcache_device_init+0x81/0x241 [bcache]
[    6.746637]  [<ffffffff810e7171>] ? __vmalloc_node+0x2c/0x31
[    6.746642]  [<ffffffffa01d7d1c>] ? bcache_device_init+0x81/0x241 [bcache]
[    6.746645]  [<ffffffff810e71ab>] ? vzalloc+0x21/0x22
[    6.746649]  [<ffffffffa01d7d1c>] ? bcache_device_init+0x81/0x241 [bcache]
[    6.746653]  [<ffffffffa01d805e>] ? flash_dev_run+0x7d/0x12b [bcache]
[    6.746658]  [<ffffffffa01d988b>] ? run_cache_set+0x5c4/0x695 [bcache]
[    6.746664]  [<ffffffffa01dae47>] ? register_bcache+0x10a0/0x12d9 [bcache]
[    6.746666]  [<ffffffff810f0f15>] ? alloc_pages_current+0xef/0x109
[    6.746670]  [<ffffffff81159855>] ? sysfs_write_file+0xcf/0x103
[    6.746674]  [<ffffffff81106a23>] ? vfs_write+0xa8/0x10b
[    6.746677]  [<ffffffff8110705e>] ? SyS_write+0x41/0x74
[    6.746680]  [<ffffffff81386ca2>] ? system_call_fastpath+0x16/0x1b
[    6.746682] Mem-Info:
[    6.746683] Node 0 DMA per-cpu:
[    6.746685] CPU    0: hi:    0, btch:   1 usd:   0
[    6.746686] CPU    1: hi:    0, btch:   1 usd:   0
[    6.746687] CPU    2: hi:    0, btch:   1 usd:   0
[    6.746688] CPU    3: hi:    0, btch:   1 usd:   0
[    6.746689] CPU    4: hi:    0, btch:   1 usd:   0
[    6.746691] CPU    5: hi:    0, btch:   1 usd:   0
[    6.746692] CPU    6: hi:    0, btch:   1 usd:   0
[    6.746693] CPU    7: hi:    0, btch:   1 usd:   0
[    6.746694] Node 0 DMA32 per-cpu:
[    6.746695] CPU    0: hi:  186, btch:  31 usd: 157
[    6.746697] CPU    1: hi:  186, btch:  31 usd:  94
[    6.746698] CPU    2: hi:  186, btch:  31 usd:  96
[    6.746699] CPU    3: hi:  186, btch:  31 usd:  81
[    6.746700] CPU    4: hi:  186, btch:  31 usd: 169
[    6.746701] CPU    5: hi:  186, btch:  31 usd:  50
[    6.746702] CPU    6: hi:  186, btch:  31 usd:  40
[    6.746704] CPU    7: hi:  186, btch:  31 usd:  84
[    6.746704] Node 0 Normal per-cpu:
[    6.746706] CPU    0: hi:  186, btch:  31 usd: 108
[    6.746707] CPU    1: hi:  186, btch:  31 usd: 112
[    6.746708] CPU    2: hi:  186, btch:  31 usd: 127
[    6.746709] CPU    3: hi:  186, btch:  31 usd: 176
[    6.746710] CPU    4: hi:  186, btch:  31 usd: 166
[    6.746711] CPU    5: hi:  186, btch:  31 usd: 169
[    6.746712] CPU    6: hi:  186, btch:  31 usd: 117
[    6.746714] CPU    7: hi:  186, btch:  31 usd: 174
[    6.746717] active_anon:2478 inactive_anon:19 isolated_anon:0
[    6.746717]  active_file:364 inactive_file:271 isolated_file:0
[    6.746717]  unevictable:10512 dirty:0 writeback:0 unstable:0
[    6.746717]  free:51389 slab_reclaimable:1259 slab_unreclaimable:3625
[    6.746717]  mapped:328 shmem:32 pagetables:490 bounce:0
[    6.746717]  free_cma:0
[    6.746720] Node 0 DMA free:15896kB min:32kB low:40kB high:48kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15984kB
managed:15900kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB
shmem:0kB slab_reclaimable:0kB slab_unreclaimable:4kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? yes
[    6.746725] lowmem_reserve[]: 0 3146 32125 32125
[    6.746727] Node 0 DMA32 free:123128kB min:6616kB low:8268kB
high:9924kB active_anon:1508kB inactive_anon:0kB active_file:0kB
inactive_file:0kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:3296400kB managed:3224152kB mlocked:0kB
dirty:0kB writeback:0kB mapped:4kB shmem:12kB slab_reclaimable:192kB
slab_unreclaimable:556kB kernel_stack:24kB pagetables:144kB
unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0
all_unreclaimable? yes
[    6.746732] lowmem_reserve[]: 0 0 28978 28978
[    6.746734] Node 0 Normal free:66532kB min:60932kB low:76164kB
high:91396kB active_anon:8404kB inactive_anon:76kB active_file:1084kB
inactive_file:1084kB unevictable:42632kB isolated(anon):0kB
isolated(file):0kB present:30136320kB managed:29673756kB mlocked:0kB
dirty:0kB writeback:0kB mapped:1308kB shmem:116kB
slab_reclaimable:4844kB slab_unreclaimable:13940kB kernel_stack:1088kB
pagetables:1816kB unstable:0kB bounce:0kB free_cma:0kB
writeback_tmp:0kB pages_scanned:192 all_unreclaimable? no
[    6.746739] lowmem_reserve[]: 0 0 0 0
[    6.746741] Node 0 DMA: 0*4kB 1*8kB (U) 1*16kB (U) 0*32kB 2*64kB
(U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (R) 3*4096kB
(M) = 15896kB
[    6.746750] Node 0 DMA32: 2*4kB (EM) 4*8kB (UEM) 1*16kB (U) 2*32kB
(E) 2*64kB (UM) 2*128kB (UM) 3*256kB (U) 6*512kB (UM) 6*1024kB (EM)
7*2048kB (UEMR) 24*4096kB (MR) = 123128kB
[    6.746759] Node 0 Normal: 7*4kB (M) 15*8kB (UEM) 14*16kB (UM)
11*32kB (UEM) 3*64kB (UM) 1*128kB (M) 6*256kB (UE) 4*512kB (UEM)
4*1024kB (UM) 3*2048kB (UEM) 13*4096kB (MR) = 68116kB
[    6.746770] Node 0 hugepages_total=0 hugepages_free=0
hugepages_surp=0 hugepages_size=2048kB
[    6.746771] 11149 total pagecache pages
[    6.746773] 0 pages in swap cache
[    6.746774] Swap cache stats: add 0, delete 0, find 0/0
[    6.746775] Free swap  = 0kB
[    6.746776] Total swap = 0kB
[    6.814488] 8386047 pages RAM
[    6.814490] 157595 pages reserved
[    6.814491] 4560 pages shared
[    6.814492] 8169064 pages non-shared
[    6.814493] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents
oom_score_adj name
[    6.814501] [   90]     0    90     1202      159       8        0
           0 udev
[    6.814503] [   92]     0    92     6261      340      17        0
       -1000 systemd-udevd
[    6.814505] [   94]     0    94     6162      214      17        0
           0 systemd-udevd
[    6.814507] [   96]     0    96     6228      238      17        0
           0 systemd-udevd
[    6.814508] [   97]     0    97     6228      257      17        0
           0 systemd-udevd
[    6.814510] [   99]     0    99     6228      238      17        0
           0 systemd-udevd
[    6.814512] [  100]     0   100     6228      259      17        0
           0 systemd-udevd
[    6.814514] [  101]     0   101     6228      258      17        0
           0 systemd-udevd
[    6.814516] [  103]     0   103     6228      229      17        0
           0 systemd-udevd
[    6.814517] [  105]     0   105     6228      222      17        0
           0 systemd-udevd
[    6.814519] [  106]     0   106     6228      223      17        0
           0 systemd-udevd
[    6.814521] [  107]     0   107     6228      232      17        0
           0 systemd-udevd
[    6.814523] [  112]     0   112     6228      244      17        0
           0 systemd-udevd
[    6.814525] [  113]     0   113     6228      244      17        0
           0 systemd-udevd
[    6.814526] [  116]     0   116     6228      235      17        0
           0 systemd-udevd
[    6.814528] [  117]     0   117     6228      241      17        0
           0 systemd-udevd
[    6.814530] [  119]     0   119     5931      241      17        0
           0 udevadm
[    6.814532] [  120]     0   120     6228      235      17        0
           0 systemd-udevd
[    6.814534] [  121]     0   121     6228      235      17        0
           0 systemd-udevd
[    6.814535] [  123]     0   123     6228      236      17        0
           0 systemd-udevd
[    6.814537] [  126]     0   126     6228      236      17        0
           0 systemd-udevd
[    6.814539] [  127]     0   127     6228      236      17        0
           0 systemd-udevd
[    6.814541] [  129]     0   129     6228      236      17        0
           0 systemd-udevd
[    6.814542] [  130]     0   130     6228      236      17        0
           0 systemd-udevd
[    6.814544] [  133]     0   133     6228      236      17        0
           0 systemd-udevd
[    6.814546] [  137]     0   137     6228      242      17        0
           0 systemd-udevd
[    6.814548] [  139]     0   139     6228      243      17        0
           0 systemd-udevd
[    6.814552] [  296]     0   296     1202      160       8        0
           0 bcache-register
[    6.814554] [  319]     0   319     1202      160       8        0
           0 bcache-register
[    6.814556] Out of memory: Kill process 90 (udev) score 0 or sacrifice child
[    6.814612] Killed process 119 (udevadm) total-vm:23724kB,
anon-rss:204kB, file-rss:760kB
[    6.823222] bcache-register invoked oom-killer: gfp_mask=0x82d2,
order=0, oom_score_adj=0
[    6.823226] bcache-register cpuset=/ mems_allowed=0
[    6.823229] CPU: 1 PID: 296 Comm: bcache-register Not tainted 3.12.9 #1



Thanks,
Josep


-- 
--
Salutacions...Josep
--



-- 
--
Salutacions...Josep
--
