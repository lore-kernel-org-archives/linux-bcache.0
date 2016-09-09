From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: Re: [bcachefs] bcache: bch_open_as_blockdevs() register_cache_set err
 Bad checksum
Date: Fri, 9 Sep 2016 12:32:04 +0200
Message-ID: <455d0d4c-024c-a0b2-06cd-84e3070cbc42@mejor.pl>
References: <18fba014-c2d9-2685-cf6d-b1ee0de35bda@mejor.pl>
 <20160909091548.j5h4axfpghzznux2@kmo-pixel>
 <281a2205-9a59-ac55-a5a8-7ebe66d52d03@mejor.pl>
 <20160909100158.gz6rcogyqoi2zu5t@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:42916 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752035AbcIIKc4 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 9 Sep 2016 06:32:56 -0400
In-Reply-To: <20160909100158.gz6rcogyqoi2zu5t@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

W dniu 09.09.2016 o 12:01, Kent Overstreet pisze:
> On Fri, Sep 09, 2016 at 11:30:06AM +0200, Marcin Mirosław wrote:
>> W dniu 09.09.2016 o 11:15, Kent Overstreet pisze:
>>> On Fri, Sep 09, 2016 at 09:36:59AM +0200, Marcin Mirosław wrote:
>>>> Hi!
>>>> Today I launched host at my job. When I tried to mount bcachefs I got:
>>>> bcache: bch_open_as_blockdevs() register_cache_set err Bad checksum
>>>>
>>>> This is simple, not tieres fs. I don't have idea what to do next to help
>>>> debug this. Data on this fs are completely unimportant.
>>>
>>> The superblock checksum is bad (I'm going to improve that error message)... what
>>> in the heck...
>>>
>>> Anything remotely unusual about the machine or how you were using it?
>>
>>
>> It's a desktop with KDE, I used this fs for keeping portage tree & i put
>> compilation tmp dir on it (with lz4 compression). Stack is:
>> lvm->raid10->4 x HDD
> 
> That is the kind of setup that would make torn writes much more likely.
> 
>> This is physical machine, I turned it off gracefully. Does image of
>> block device be usefull for you?
> 
> I don't think so. Regardless of what it is, I'm gonna need to work on some kind
> of logged superblock or backup superblocks.
> 
> Assuming it is just a torn write (which I think is pretty likely), you should be
> able to just disable that check and it should work fine - a torn write would
> mostl likely only cause a superblock that's actually invalid if the size of the
> superblock was changing (which is pretty much just when we're allocating the
> journal, or when we're adding or removing devices).
> 
> The check is on super.c line 415 - just change the goto err to a printk and try
> it, I bet it'll work.

I used pr_info(""). Now I'm getting:
[  110.317089] bcache: read_super() Bad checksum
[  110.317107] bcache: bch_open_as_blockdevs() register_cache_set err
Superblock block size smaller than device block size

I looked at system logs. I didn't mentioned that machine was hibernated,
if I recoll correctly I run copying from one fs to bcachefs, next
hibernated machine. Next day I used bcachefs and today I've got
mentioned error.
Also I see in logs many messages with
 events_unbound bch_bio_decompress_work [bcache]:

> Sep  8 11:55:40 localhost kernel: [67173.375639] kworker/u8:2: page allocation failure: order:4, mode:0x2404000(GFP_NOIO|__GFP_COMP)
> Sep  8 11:55:40 localhost kernel: [67173.375645] CPU: 1 PID: 14112 Comm: kworker/u8:2 Tainted: P           O    4.7.0-bcache+ #1
> Sep  8 11:55:40 localhost kernel: [67173.375648] Hardware name:                  /D975XBX, BIOS BX97510J.86A.1487.2007.0902.1724 09/02/2007
> Sep  8 11:55:40 localhost kernel: [67173.375676] Workqueue: events_unbound bch_bio_decompress_work [bcache]
> Sep  8 11:55:40 localhost kernel: [67173.375680]  0000000000000286 000000003c876dc8 ffff88000b34fa68 ffffffff812cbe0d
> Sep  8 11:55:40 localhost kernel: [67173.375685]  0000000000000000 0000000000000004 ffff88000b34faf8 ffffffff8113256c
> Sep  8 11:55:40 localhost kernel: [67173.375690]  024040003c876dc8 0000000000000040 0000000000000004 ffff8800c2f3d1c0
> Sep  8 11:55:40 localhost kernel: [67173.375695] Call Trace:
> Sep  8 11:55:40 localhost kernel: [67173.375700]  [<ffffffff812cbe0d>] dump_stack+0x4f/0x72
> Sep  8 11:55:40 localhost kernel: [67173.375706]  [<ffffffff8113256c>] warn_alloc_failed+0xfc/0x160
> Sep  8 11:55:40 localhost kernel: [67173.375710]  [<ffffffff81132161>] ? __alloc_pages_direct_compact+0x51/0x120
> Sep  8 11:55:40 localhost kernel: [67173.375713]  [<ffffffff81132abf>] __alloc_pages_nodemask+0x4ef/0xed0
> Sep  8 11:55:40 localhost kernel: [67173.375717]  [<ffffffff81298a02>] ? chksum_update+0x12/0x20
> Sep  8 11:55:40 localhost kernel: [67173.375721]  [<ffffffff8113377d>] alloc_kmem_pages+0x1d/0x90
> Sep  8 11:55:40 localhost kernel: [67173.375724]  [<ffffffff8114ee69>] kmalloc_order_trace+0x29/0xf0
> Sep  8 11:55:40 localhost kernel: [67173.375727]  [<ffffffff8117e17b>] __kmalloc+0x1db/0x240
> Sep  8 11:55:40 localhost kernel: [67173.375744]  [<ffffffffc07a83a9>] __bounce_alloc+0x29/0xe0 [bcache]
> Sep  8 11:55:40 localhost kernel: [67173.375760]  [<ffffffffc07ab8a2>] __bch_read_endio+0x3d2/0x6a0 [bcache]
> Sep  8 11:55:40 localhost kernel: [67173.375764]  [<ffffffff8108f486>] ? set_next_entity+0x46/0x960
> Sep  8 11:55:40 localhost kernel: [67173.375767]  [<ffffffff8156fed9>] ? _raw_spin_unlock_irq+0x9/0x10
> Sep  8 11:55:40 localhost kernel: [67173.375772]  [<ffffffff8107db4e>] ? finish_task_switch+0x7e/0x200
> Sep  8 11:55:40 localhost kernel: [67173.375788]  [<ffffffffc07ac18c>] bch_bio_decompress_work+0x3c/0x50 [bcache]
> Sep  8 11:55:40 localhost kernel: [67173.375791]  [<ffffffff810722a6>] process_one_work+0x156/0x440
> Sep  8 11:55:40 localhost kernel: [67173.375794]  [<ffffffff810725d9>] worker_thread+0x49/0x480
> Sep  8 11:55:40 localhost kernel: [67173.375798]  [<ffffffff81072590>] ? process_one_work+0x440/0x440
> Sep  8 11:55:40 localhost kernel: [67173.375802]  [<ffffffff81077a93>] kthread+0xd3/0xf0
> Sep  8 11:55:40 localhost kernel: [67173.375806]  [<ffffffff8157053f>] ret_from_fork+0x1f/0x40
> Sep  8 11:55:40 localhost kernel: [67173.375809]  [<ffffffff810779c0>] ? kthread_worker_fn+0x150/0x150
> Sep  8 11:55:40 localhost kernel: [67173.375812] Mem-Info:
> Sep  8 11:55:40 localhost kernel: [67173.375818] active_anon:145089 inactive_anon:211363 isolated_anon:0
> Sep  8 11:55:40 localhost kernel: [67173.375818]  active_file:230683 inactive_file:342294 isolated_file:32
> Sep  8 11:55:40 localhost kernel: [67173.375818]  unevictable:1912 dirty:15764 writeback:3 unstable:0
> Sep  8 11:55:40 localhost kernel: [67173.375818]  slab_reclaimable:42112 slab_unreclaimable:23427
> Sep  8 11:55:40 localhost kernel: [67173.375818]  mapped:32645 shmem:2139 pagetables:5269 bounce:0
> Sep  8 11:55:40 localhost kernel: [67173.375818]  free:11105 free_pcp:17 free_cma:0
> Sep  8 11:55:40 localhost kernel: [67173.375828] DMA free:15900kB min:28kB low:40kB high:52kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15992kB managed:15908kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
> Sep  8 11:55:40 localhost kernel: [67173.375831] lowmem_reserve[]: 0 3223 4417 4417
> Sep  8 11:55:40 localhost kernel: [67173.375841] DMA32 free:18376kB min:6192kB low:9492kB high:12792kB active_anon:472452kB inactive_anon:523696kB active_file:703060kB inactive_file:1046724kB unevictable:5176kB isolated(anon):0kB isolated(file):0kB present:3389356kB managed:3314052kB mlocked:5176kB dirty:44764kB writeback:0kB mapped:102896kB shmem:5976kB slab_reclaimable:107280kB slab_unreclaimable:61608kB kernel_stack:4880kB pagetables:14956kB unstable:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
> Sep  8 11:55:40 localhost kernel: [67173.375843] lowmem_reserve[]: 0 0 1194 1194
> Sep  8 11:55:40 localhost kernel: [67173.375853] Normal free:10144kB min:2296kB low:3516kB high:4736kB active_anon:107904kB inactive_anon:321756kB active_file:219672kB inactive_file:322452kB unevictable:2472kB isolated(anon):0kB isolated(file):128kB present:1310720kB managed:1223568kB mlocked:2472kB dirty:18292kB writeback:12kB mapped:27684kB shmem:2580kB slab_reclaimable:61168kB slab_unreclaimable:32092kB kernel_stack:3600kB pagetables:6120kB unstable:0kB bounce:0kB free_pcp:52kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
> Sep  8 11:55:40 localhost kernel: [67173.375856] lowmem_reserve[]: 0 0 0 0
> Sep  8 11:55:40 localhost kernel: [67173.375861] DMA: 1*4kB (U) 1*8kB (U) 1*16kB (U) 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15900kB
> Sep  8 11:55:40 localhost kernel: [67173.375882] DMA32: 3773*4kB (UMEH) 71*8kB (UMEH) 56*16kB (UMEH) 4*32kB (H) 4*64kB (H) 4*128kB (H) 0*256kB 0*512kB 1*1024kB (H) 0*2048kB 0*4096kB = 18476kB
> Sep  8 11:55:40 localhost kernel: [67173.375903] Normal: 1593*4kB (UMEH) 238*8kB (UMEH) 63*16kB (UMEH) 12*32kB (UEH) 2*64kB (H) 1*128kB (H) 1*256kB (H) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 10180kB
> Sep  8 11:55:40 localhost kernel: [67173.375926] Node 0 hugepages_total=30 hugepages_free=30 hugepages_surp=0 hugepages_size=2048kB
> Sep  8 11:55:40 localhost kernel: [67173.375928] 583379 total pagecache pages
> Sep  8 11:55:40 localhost kernel: [67173.375931] 8252 pages in swap cache
> Sep  8 11:55:40 localhost kernel: [67173.375933] Swap cache stats: add 351464, delete 343212, find 134496/200283
> Sep  8 11:55:40 localhost kernel: [67173.375935] Free swap  = 756592kB
> Sep  8 11:55:40 localhost kernel: [67173.375937] Total swap = 1048572kB
> Sep  8 11:55:40 localhost kernel: [67173.375939] 1179017 pages RAM
> Sep  8 11:55:40 localhost kernel: [67173.375941] 0 pages HighMem/MovableOnly
> Sep  8 11:55:40 localhost kernel: [67173.375943] 40635 pages reserved
