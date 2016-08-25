From: Marcin <marcin@mejor.pl>
Subject: [bcachefs]  mount: page allocation failure: order:7,
 mode:0x24000c0(GFP_KERNEL)  /   BUG: unable to handle kernel NULL pointer
 dereference at 0000000000000008
Date: Thu, 25 Aug 2016 19:16:41 +0200
Message-ID: <a8d0676a968c4901e94ab74be158c1e4@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:64248 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754446AbcHYRRF (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 25 Aug 2016 13:17:05 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi again,
I created tiered filesystem (tier 1 device has 1.4TB, tier 0 device has 
10GB) but mounting failed (host has 1GB of RAM):

[ 1736.551707] mount: page allocation failure: order:7, 
mode:0x24000c0(GFP_KERNEL)
[ 1736.551714] CPU: 1 PID: 2609 Comm: mount Not tainted 4.7.0+ #5
[ 1736.551716] Hardware name: Gigabyte Technology Co., Ltd. 
965P-DS3/965P-DS3, BIOS F14 06/25/2009
[ 1736.551719]  0000000000000000 ffff88002bd1bac0 ffffffff81275f68 
0000000000000007
[ 1736.551724]  0000000000000000 ffff88002bd1bb48 ffffffff81111da6 
024000c000000200
[ 1736.551727]  0000000000000007 0000000000000040 ffff88002bd1bbd4 
00000000024000c0
[ 1736.551731] Call Trace:
[ 1736.551739]  [<ffffffff81275f68>] dump_stack+0x4d/0x65
[ 1736.551743]  [<ffffffff81111da6>] warn_alloc_failed+0xd6/0x130
[ 1736.551746]  [<ffffffff81111a33>] ? 
__alloc_pages_direct_compact+0xe3/0x110
[ 1736.551749]  [<ffffffff8111219d>] __alloc_pages_nodemask+0x39d/0xce0
[ 1736.551753]  [<ffffffff8110d03e>] ? mempool_init_node+0x4e/0xc0
[ 1736.551757]  [<ffffffff8110cdf2>] mempool_alloc_pages+0x12/0x20
[ 1736.551760]  [<ffffffff8110d059>] mempool_init_node+0x69/0xc0
[ 1736.551763]  [<ffffffff8110d0ca>] mempool_init+0x1a/0x20
[ 1736.551793]  [<ffffffffc02b4d66>] bch_cache_set_alloc+0x866/0xb30 
[bcache]
[ 1736.551812]  [<ffffffffc02b7eb2>] bch_register_cache_set+0x1c2/0x2e0 
[bcache]
[ 1736.551831]  [<ffffffffc029bf65>] bch_mount+0x2c5/0x490 [bcache]
[ 1736.551836]  [<ffffffff8116368f>] mount_fs+0xf/0x90
[ 1736.551840]  [<ffffffff8117d682>] vfs_kern_mount+0x62/0x100
[ 1736.551843]  [<ffffffff8117f969>] do_mount+0x1e9/0xd10
[ 1736.551847]  [<ffffffff8115990c>] ? __kmalloc_track_caller+0x2c/0x170
[ 1736.551851]  [<ffffffff8112567d>] ? memdup_user+0x3d/0x70
[ 1736.551853]  [<ffffffff811807c0>] SyS_mount+0x90/0xd0
[ 1736.551857]  [<ffffffff8146ae9f>] entry_SYSCALL_64_fastpath+0x17/0x93
[ 1736.551860] Mem-Info:
[ 1736.551865] active_anon:11674 inactive_anon:12793 isolated_anon:13
[ 1736.551865]  active_file:67085 inactive_file:67153 isolated_file:14
[ 1736.551865]  unevictable:1271 dirty:70 writeback:0 unstable:0
[ 1736.551865]  slab_reclaimable:80331 slab_unreclaimable:5121
[ 1736.551865]  mapped:5766 shmem:103 pagetables:830 bounce:0
[ 1736.551865]  free:5817 free_pcp:0 free_cma:0
[ 1736.551876] DMA free:4008kB min:60kB low:72kB high:84kB 
active_anon:492kB inactive_anon:672kB active_file:2028kB 
inactive_file:2088kB unevictable:108kB is
olated(anon):0kB isolated(file):0kB present:15984kB managed:15900kB 
mlocked:108kB dirty:8kB writeback:0kB mapped:300kB shmem:4kB 
slab_reclaimable:5124kB slab
_unreclaimable:484kB kernel_stack:16kB pagetables:136kB unstable:0kB 
bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB 
pages_scanned:0 all
_unreclaimable? no
[ 1736.551879] lowmem_reserve[]: 0 970 970 970
[ 1736.551889] DMA32 free:19260kB min:3952kB low:4944kB high:5936kB 
active_anon:46204kB inactive_anon:50500kB active_file:266312kB 
inactive_file:266524kB une
victable:4976kB isolated(anon):52kB isolated(file):56kB 
present:1031040kB managed:1004424kB mlocked:4976kB dirty:272kB 
writeback:0kB mapped:22764kB shmem:408
kB slab_reclaimable:316200kB slab_unreclaimable:20000kB 
kernel_stack:2048kB pagetables:3184kB unstable:0kB bounce:0kB 
free_pcp:0kB local_pcp:0kB free_cma:0kB
  writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[ 1736.551892] lowmem_reserve[]: 0 0 0 0
[ 1736.551896] DMA: 174*4kB (UME) 157*8kB (UME) 85*16kB (UME) 22*32kB 
(UME) 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 4016kB
[ 1736.551910] DMA32: 1130*4kB (UMEH) 410*8kB (UMEH) 280*16kB (UME) 
116*32kB (UMH) 30*64kB (M) 11*128kB (M) 0*256kB 0*512kB 0*1024kB 
0*2048kB 0*4096kB = 1932
0kB
[ 1736.551925] Node 0 hugepages_total=0 hugepages_free=0 
hugepages_surp=0 hugepages_size=2048kB
[ 1736.551927] 135324 total pagecache pages
[ 1736.551930] 3 pages in swap cache
[ 1736.551932] Swap cache stats: add 70, delete 67, find 0/0
[ 1736.551933] Free swap  = 3145444kB
[ 1736.551935] Total swap = 3145724kB
[ 1736.551937] 261756 pages RAM
[ 1736.551938] 0 pages HighMem/MovableOnly
[ 1736.551940] 6675 pages reserved
[ 1736.551959] BUG: unable to handle kernel NULL pointer dereference at 
0000000000000008
[ 1736.552012] IP: [<ffffffff811281e0>] bdi_exit+0x60/0xb0
[ 1736.552045] PGD 0
[ 1736.552070] Oops: 0002 [#1] SMP
[ 1736.552094] Modules linked in: bcache lz4_compress zlib_deflate 
libcrc32c lz4_decompress sha1_generic cpufreq_ondemand msr af_packet 
fuse pcrypt nf_nat_ftp nf_conntrack_ftp nf_nat nf_conntrack ipv6 
coretemp hwmon kvm_intel kvm irqbypass sky2 hpsa scsi_transport_sas 
i2c_i801 i2c_core acpi_cpufreq button processor raid1 md_mod 
pata_jmicron ehci_pci ehci_hcd dm_mod
[ 1736.552314] CPU: 1 PID: 2609 Comm: mount Not tainted 4.7.0+ #5
[ 1736.552342] Hardware name: Gigabyte Technology Co., Ltd. 
965P-DS3/965P-DS3, BIOS F14 06/25/2009
[ 1736.552391] task: ffff88003cbf4f80 ti: ffff88002bd18000 task.ti: 
ffff88002bd18000
[ 1736.552436] RIP: 0010:[<ffffffff811281e0>]  [<ffffffff811281e0>] 
bdi_exit+0x60/0xb0
[ 1736.552485] RSP: 0018:ffff88002bd1bc58  EFLAGS: 00010246
[ 1736.552513] RAX: 0000000000000000 RBX: ffff880002600558 RCX: 
00000000000010c1
[ 1736.552544] RDX: 00001ffffffffffe RSI: 0000000000000006 RDI: 
0000000000000000
[ 1736.552574] RBP: ffff88002bd1bc60 R08: 0000000000018fe0 R09: 
ffffffff8110cfb2
[ 1736.552604] R10: ffff88003f5efa40 R11: ffffffff819b7e4d R12: 
0000000000041748
[ 1736.552635] R13: 0000000000000200 R14: 00000000000000ff R15: 
0000000000000000
[ 1736.552666] FS:  00007f6e84f81780(0000) GS:ffff88003fc80000(0000) 
knlGS:0000000000000000
[ 1736.552713] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1736.552741] CR2: 0000000000000008 CR3: 000000001760b000 CR4: 
00000000000006e0
[ 1736.552771] Stack:
[ 1736.552792]  ffff880002600558 ffff88002bd1bc78 ffffffff81128245 
ffff880002600000
[ 1736.552846]  ffff88002bd1bc90 ffffffffc02b2f50 ffff880002600000 
ffff88002bd1bce0
[ 1736.552899]  ffffffffc02b501a ff00000000005000 ffffffffffffff00 
ca45ffffffffffff
[ 1736.552952] Call Trace:
[ 1736.552976]  [<ffffffff81128245>] bdi_destroy+0x15/0x20
[ 1736.553021]  [<ffffffffc02b2f50>] cache_set_free+0x70/0x180 [bcache]
[ 1736.553067]  [<ffffffffc02b501a>] bch_cache_set_alloc+0xb1a/0xb30 
[bcache]
[ 1736.553114]  [<ffffffffc02b7eb2>] bch_register_cache_set+0x1c2/0x2e0 
[bcache]
[ 1736.553162]  [<ffffffffc029bf65>] bch_mount+0x2c5/0x490 [bcache]
[ 1736.553191]  [<ffffffff8116368f>] mount_fs+0xf/0x90
[ 1736.553219]  [<ffffffff8117d682>] vfs_kern_mount+0x62/0x100
[ 1736.553247]  [<ffffffff8117f969>] do_mount+0x1e9/0xd10
[ 1736.553275]  [<ffffffff8115990c>] ? __kmalloc_track_caller+0x2c/0x170
[ 1736.553306]  [<ffffffff8112567d>] ? memdup_user+0x3d/0x70
[ 1736.553334]  [<ffffffff811807c0>] SyS_mount+0x90/0xd0
[ 1736.553362]  [<ffffffff8146ae9f>] entry_SYSCALL_64_fastpath+0x17/0x93
[ 1736.553390] Code: 48 8d bb 00 01 00 00 e8 ff f1 16 00 48 8d bb 28 01 
00 00 e8 f3 f1 16 00 48 8d bb 90 01 00 00 e8 47 e5 14 00 48 8b bb 50 01 
00 00 <f0> ff 4f 08 74 03 5b 5d c3 e8 12 fa 02 00 5b 5d c3 80 3d 84 e6
[ 1736.553619] RIP  [<ffffffff811281e0>] bdi_exit+0x60/0xb0
[ 1736.553649]  RSP <ffff88002bd1bc58>
[ 1736.553673] CR2: 0000000000000008
[ 1736.553972] ---[ end trace 189d3c6dccf23b2f ]---
