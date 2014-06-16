From: Pim van den Berg <pim.vandenberg@nethuis.nl>
Subject: BUG: soft lockup - CPU#0 stuck for 22s! [bcache_gc:....]
Date: Mon, 16 Jun 2014 21:23:00 +0200
Message-ID: <539F4414.7070509@nethuis.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from heemstate.nethuis.nl ([83.161.148.110]:38778 "EHLO
	vc-mail2.heemstate.nethuis.nl" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754045AbaFPTXC (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 16 Jun 2014 15:23:02 -0400
Received: from apple.heemstate.nethuis.nl (heemstate.nethuis.nl [83.161.148.110])
	by vc-mail2.heemstate.nethuis.nl (Postfix) with ESMTPSA id CF93F103A
	for <linux-bcache@vger.kernel.org>; Mon, 16 Jun 2014 21:23:00 +0200 (CEST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi,

I'm trying to upgrade from a 3.12.8 kernel to 3.14.6.

Unfortunately my load average doesn't go below 2.00 (as mentioned
earlier on this list). The "bcache: fix uninterruptible sleep in
writeback thread" patch by Slava Pestov doesn't fix that for me.

But more important, afer a while I run into a soft lockup. I've not been
able to run this kernel more than a couple of hours.

I'm running 3.14.6, plus these patches from this mailinglist:
- bcache: fix uninterruptible sleep in writeback thread
- bcache: fix crash on shutdown in passthrough mode

I've also tried running this 3.14.6 kernel plus all bcache related
patches from 3.15. This makes no difference, same behavior.

[37903.477806] BUG: soft lockup - CPU#0 stuck for 23s! [bcache_gc:1842]
[37903.477838] CPU: 0 PID: 1842 Comm: bcache_gc Not tainted 3.14.6-kvm #2
[37903.477861] Hardware name:                  /DH67CF, BIOS
BLH6710H.86A.0156.2012.0615.1908 06/15/2012
[37903.477899] task: ffff88021ebc6dd0 ti: ffff8800d514a000 task.ti:
ffff8800d514a000
[37903.477935] RIP: 0010:[<ffffffff81464557>]  [<ffffffff81464557>]
bch_btree_iter_next+0x250/0x272
[37903.477978] RSP: 0018:ffff8800d514bbd8  EFLAGS: 00000297
[37903.477999] RAX: 0000000000000000 RBX: ffffffff8146a78c RCX:
0000000009000001
[37903.478023] RDX: ffff88000a32ed60 RSI: ffff880214b874c8 RDI:
ffff8800d514bc28
[37903.478047] RBP: ffff8800d514bbe8 R08: ffff880213440000 R09:
ffff8800d50a8000
[37903.478071] R10: 0000000000000800 R11: 0000000000000008 R12:
ffff880214b874c8
[37903.478095] R13: ffff88000a31c778 R14: ffff88000a30ecc0 R15:
0000000000000000
[37903.478120] FS:  0000000000000000(0000) GS:ffff88021fa00000(0000)
knlGS:0000000000000000
[37903.478156] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[37903.478178] CR2: 00007fb61d572000 CR3: 0000000001c0b000 CR4:
00000000000427e0
[37903.478202] Stack:
[37903.478217]  0000000000003894 ffffffff814648c9 ffff8800d514bc18
ffffffff81464595
[37903.478256]  0000000000003894 ffff880214b874c8 ffff8800d514bc28
ffff8800d514bdb0
[37903.478294]  ffff8800d514bc98 ffffffff81464aeb 0000000000000004
0000000000000002
[37903.478333] Call Trace:
[37903.478352]  [<ffffffff814648c9>] ? bch_ptr_invalid+0xc/0xc
[37903.478374]  [<ffffffff81464595>] bch_btree_iter_next_filter+0x1c/0x3d
[37903.478398]  [<ffffffff81464aeb>] btree_gc_count_keys+0x45/0x57
[37903.478422]  [<ffffffff81468f08>] btree_gc_recurse+0xe3/0x2ba
[37903.478445]  [<ffffffff81464595>] ? bch_btree_iter_next_filter+0x1c/0x3d
[37903.478469]  [<ffffffff8146594e>] ? btree_gc_mark_node+0xc1/0x1c1
[37903.478494]  [<ffffffff810b4db8>] ? __wake_up+0x3f/0x48
[37903.478516]  [<ffffffff810b5056>] ? finish_wait+0x5a/0x60
[37903.478538]  [<ffffffff8146930f>] bch_btree_gc+0x230/0x389
[37903.478561]  [<ffffffff810b4c1c>] ? __wake_up_common+0x80/0x80
[37903.478584]  [<ffffffff8146949a>] bch_gc_thread+0x32/0xe0
[37903.478606]  [<ffffffff81469468>] ? bch_btree_gc+0x389/0x389
[37903.478629]  [<ffffffff810a0ae5>] kthread+0xcd/0xd5
[37903.478650]  [<ffffffff810a0a18>] ? __kthread_parkme+0x5c/0x5c
[37903.478674]  [<ffffffff81603f3c>] ret_from_fork+0x7c/0xb0
[37903.478696]  [<ffffffff810a0a18>] ? __kthread_parkme+0x5c/0x5c
[37903.478717] Code: 4a 01 48 ff c0 48 c1 e0 04 48 c1 e1 04 48 01 d8 48
01 d9 4c 8b 08 4c 89 09 48 8b 40 08 48 89 41 08 48 89 d0 4c 89 07 48 89
77 08 <48> 8b 73 08 48 8d 0c 00 48 8d 51 01 48 39 f2 0f 82 29 ff ff ff
[37931.494997] BUG: soft lockup - CPU#0 stuck for 22s! [bcache_gc:1842]
[37931.495028] CPU: 0 PID: 1842 Comm: bcache_gc Not tainted 3.14.6-kvm #2
[37931.495051] Hardware name:                  /DH67CF, BIOS
BLH6710H.86A.0156.2012.0615.1908 06/15/2012
[37931.495090] task: ffff88021ebc6dd0 ti: ffff8800d514a000 task.ti:
ffff8800d514a000
[37931.495125] RIP: 0010:[<ffffffff8146a856>]  [<ffffffff8146a856>]
bch_extent_bad+0x75/0x15d
[37931.495168] RSP: 0018:ffff8800d514bbc8  EFLAGS: 00000a06
[37931.495189] RAX: 0000000000000001 RBX: ffff880214b874c8 RCX:
0000000009000000
[37931.495214] RDX: 0000000000000001 RSI: 0000000000000001 RDI:
0000000000000001
[37931.495238] RBP: ffff8800d514bbd8 R08: ffff880213440000 R09:
ffff8800d50a8000
[37931.495262] R10: 0000000000000800 R11: 0000000000000008 R12:
ffffffff814686bd
[37931.495286] R13: ffff8800d514bc98 R14: ffff8800cf97b800 R15:
ffff8800d514bdd8
[37931.495311] FS:  0000000000000000(0000) GS:ffff88021fa00000(0000)
knlGS:0000000000000000
[37931.495347] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[37931.495369] CR2: 00007fb61d572000 CR3: 0000000001c0b000 CR4:
00000000000427e0
[37931.495393] Stack:
[37931.495408]  ffff88000a306368 ffffffff814648c9 ffff8800d514bbe8
ffffffff814648d3
[37931.495447]  ffff8800d514bc18 ffffffff814645a6 0000000000000c54
ffff880214b874c8
[37931.495486]  ffff8800d514bc28 ffff8800d514bdb0 ffff8800d514bc98
ffffffff81464aeb
[37931.495524] Call Trace:
[37931.495542]  [<ffffffff814648c9>] ? bch_ptr_invalid+0xc/0xc
[37931.495565]  [<ffffffff814648d3>] bch_ptr_bad+0xa/0xc
[37931.495587]  [<ffffffff814645a6>] bch_btree_iter_next_filter+0x2d/0x3d
[37931.495611]  [<ffffffff81464aeb>] btree_gc_count_keys+0x45/0x57
[37931.495634]  [<ffffffff81468f08>] btree_gc_recurse+0xe3/0x2ba
[37931.495657]  [<ffffffff81464595>] ? bch_btree_iter_next_filter+0x1c/0x3d
[37931.495681]  [<ffffffff8146594e>] ? btree_gc_mark_node+0xc1/0x1c1
[37931.495706]  [<ffffffff810b4db8>] ? __wake_up+0x3f/0x48
[37931.495728]  [<ffffffff810b5056>] ? finish_wait+0x5a/0x60
[37931.495751]  [<ffffffff8146930f>] bch_btree_gc+0x230/0x389
[37931.495773]  [<ffffffff810b4c1c>] ? __wake_up_common+0x80/0x80
[37931.495796]  [<ffffffff8146949a>] bch_gc_thread+0x32/0xe0
[37931.495818]  [<ffffffff81469468>] ? bch_btree_gc+0x389/0x389
[37931.495841]  [<ffffffff810a0ae5>] kthread+0xcd/0xd5
[37931.495863]  [<ffffffff810a0a18>] ? __kthread_parkme+0x5c/0x5c
[37931.495886]  [<ffffffff81603f3c>] ret_from_fork+0x7c/0xb0
[37931.495908]  [<ffffffff810a0a18>] ? __kthread_parkme+0x5c/0x5c
[37931.495930] Code: 00 48 83 f8 07 77 0f 31 ff 49 83 bc c0 40 0c 00 00
00 40 0f 95 c7 85 ff 0f 84 ee 00 00 00 ff c2 89 d0 48 39 f0 72 c5 48 c1
e9 24 <31> c0 80 e1 01 0f 85 d8 00 00 00 49 ba ff ff ff ff ff 07 00 00
[37939.347814] INFO: rcu_sched self-detected stall on CPU { 0}  (t=15001
jiffies g=934378 c=934377 q=13108)
[37939.347864] sending NMI to all CPUs:
[37939.347886] NMI backtrace for cpu 0
[37939.347906] CPU: 0 PID: 1842 Comm: bcache_gc Not tainted 3.14.6-kvm #2
[37939.347929] Hardware name:                  /DH67CF, BIOS
BLH6710H.86A.0156.2012.0615.1908 06/15/2012
[37939.347968] task: ffff88021ebc6dd0 ti: ffff8800d514a000 task.ti:
ffff8800d514a000
[37939.348003] RIP: 0010:[<ffffffff812f281a>]  [<ffffffff812f281a>]
delay_tsc+0x0/0x4b
[37939.348043] RSP: 0018:ffff88021fa03db0  EFLAGS: 00000887
[37939.348065] RAX: 00000000a69f7e00 RBX: 0000000000002710 RCX:
0000000000000007
[37939.348089] RDX: 0000000000274448 RSI: 0000000000000002 RDI:
0000000000274449
[37939.348113] RBP: ffff88021fa03db8 R08: 0000000000000000 R09:
0000000000000000
[37939.348137] R10: ffffffff81863f10 R11: ffff88021e81d400 R12:
ffff88021fa0d330
[37939.348161] R13: 0000000000000000 R14: ffffffff81c25a80 R15:
0000000000000000
[37939.348185] FS:  0000000000000000(0000) GS:ffff88021fa00000(0000)
knlGS:0000000000000000
[37939.348222] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[37939.348244] CR2: 00007fb61d572000 CR3: 0000000001c0b000 CR4:
00000000000427e0
[37939.348267] Stack:
[37939.348283]  ffffffff812f28a6 ffff88021fa03dc8 ffffffff812f28cc
ffff88021fa03de8
[37939.348321]  ffffffff8104f52e ffff88021fa0d848 ffffffff81c25a80
ffff88021fa03e48
[37939.348360]  ffffffff810c33f6 0000000000003334 ffffffff81c76c10
0000000000000000
[37939.348398] Call Trace:
[37939.348415]  <IRQ>
[37939.348419]  [<ffffffff812f28a6>] ? __delay+0xa/0xc
[37939.348454]  [<ffffffff812f28cc>] __const_udelay+0x24/0x26
[37939.348479]  [<ffffffff8104f52e>]
arch_trigger_all_cpu_backtrace+0x65/0x6f
[37939.348505]  [<ffffffff810c33f6>] rcu_check_callbacks+0x1cc/0x4ed
[37939.348530]  [<ffffffff810ac259>] ? account_system_time+0x104/0x14c
[37939.348554]  [<ffffffff81092f1a>] update_process_times+0x3a/0x63
[37939.348578]  [<ffffffff810caf3d>] tick_sched_handle+0x45/0x4a
[37939.349917]  [<ffffffff810cb0e7>] tick_sched_timer+0x37/0x56
[37939.349940]  [<ffffffff810a2d38>] __run_hrtimer.isra.24+0x71/0xca
[37939.349964]  [<ffffffff810a34a0>] hrtimer_interrupt+0xe8/0x1d7
[37939.349987]  [<ffffffff8104e1da>] local_apic_timer_interrupt+0x50/0x54
[37939.350012]  [<ffffffff8104e542>] smp_apic_timer_interrupt+0x3c/0x4f
[37939.350037]  [<ffffffff81604b0a>] apic_timer_interrupt+0x6a/0x70
[37939.350058]  <EOI>
[37939.350063]  [<ffffffff8146a134>] ? bch_debug_exit+0x23/0x23
[37939.350101]  [<ffffffff8146a78c>] ? bch_extent_invalid+0x31/0x86
[37939.350124]  [<ffffffff8146a7fe>] bch_extent_bad+0x1d/0x15d
[37939.350147]  [<ffffffff814648c9>] ? bch_ptr_invalid+0xc/0xc
[37939.350169]  [<ffffffff814648d3>] bch_ptr_bad+0xa/0xc
[37939.350191]  [<ffffffff814645a6>] bch_btree_iter_next_filter+0x2d/0x3d
[37939.350215]  [<ffffffff81464aeb>] btree_gc_count_keys+0x45/0x57
[37939.350238]  [<ffffffff81468f08>] btree_gc_recurse+0xe3/0x2ba
[37939.350261]  [<ffffffff81464595>] ? bch_btree_iter_next_filter+0x1c/0x3d
[37939.350285]  [<ffffffff8146594e>] ? btree_gc_mark_node+0xc1/0x1c1
[37939.350309]  [<ffffffff810b4db8>] ? __wake_up+0x3f/0x48
[37939.350331]  [<ffffffff8146930f>] bch_btree_gc+0x230/0x389
[37939.350354]  [<ffffffff810b4c1c>] ? __wake_up_common+0x80/0x80
[37939.350377]  [<ffffffff8146949a>] bch_gc_thread+0x32/0xe0
[37939.350399]  [<ffffffff81469468>] ? bch_btree_gc+0x389/0x389
[37939.350421]  [<ffffffff810a0ae5>] kthread+0xcd/0xd5
[37939.350442]  [<ffffffff810a0a18>] ? __kthread_parkme+0x5c/0x5c
[37939.350465]  [<ffffffff81603f3c>] ret_from_fork+0x7c/0xb0
[37939.350487]  [<ffffffff810a0a18>] ? __kthread_parkme+0x5c/0x5c
[37939.350508] Code: 90 55 48 89 f8 48 89 e5 48 85 c0 74 19 eb 02 66 90
eb 0e 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 48 ff c8 75 fb 48 ff c8
5d c3 <55> 48 89 e5 65 8b 34 25 1c b0 00 00 0f 1f 00 0f ae e8 0f 31 89
[37939.350623] NMI backtrace for cpu 1
[37939.350625] INFO: NMI handler
(arch_trigger_all_cpu_backtrace_handler) took too long to run: 2.736 msecs
[37939.350685] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.14.6-kvm #2
[37939.350708] Hardware name:                  /DH67CF, BIOS
BLH6710H.86A.0156.2012.0615.1908 06/15/2012
[37939.350746] task: ffff88021e900950 ti: ffff88021e904000 task.ti:
ffff88021e904000
[37939.350782] RIP: 0010:[<ffffffff8131cfde>]  [<ffffffff8131cfde>]
intel_idle+0xbd/0x10b
[37939.350822] RSP: 0018:ffff88021e905e28  EFLAGS: 00000046
[37939.350843] RAX: 0000000000000001 RBX: 0000000000000002 RCX:
0000000000000001
[37939.350867] RDX: 0000000000000000 RSI: ffff88021e905fd8 RDI:
0000000000000001
[37939.350891] RBP: ffff88021e905e58 R08: 0000000000000009 R09:
000000000000030d
[37939.350915] R10: 0000000000000006 R11: 0000000000000400 R12:
0000000000000002
[37939.350939] R13: 0000000000000001 R14: 0000000000000001 R15:
0000000000000000
[37939.350963] FS:  0000000000000000(0000) GS:ffff88021fb00000(0000)
knlGS:0000000000000000
[37939.351000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[37939.351022] CR2: 00007fff5b76bfe8 CR3: 00000000cff86000 CR4:
00000000000427e0
[37939.351045] Stack:
[37939.351060]  ffff88021e905e58 00000001810c42e5 ffff88021fb15d00
ffffffff81c3c188
[37939.351099]  0000227bfbc05f82 ffff88021e905f00 ffff88021e905eb8
ffffffff81498f06
[37939.351137]  0000000000000002 ffffffff81c3c0c0 0000000000000000
00000000001ef3a2
[37939.351176] Call Trace:
[37939.351195]  [<ffffffff81498f06>] cpuidle_enter_state+0x3a/0xac
[37939.351218]  [<ffffffff81499040>] cpuidle_idle_call+0xc8/0x111
[37939.351243]  [<ffffffff810354c8>] arch_cpu_idle+0x9/0x18
[37939.351265]  [<ffffffff810bcdd2>] cpu_startup_entry+0xae/0x118
[37939.351289]  [<ffffffff8104d212>] start_secondary+0x1b2/0x1b7
[37939.351310] Code: 31 d2 65 48 8b 34 25 a0 b7 00 00 48 8d 86 38 e0 ff
ff 48 89 d1 0f 01 c8 48 8b 86 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f
01 c9 <65> 48 8b 0c 25 a0 b7 00 00 83 a1 3c e0 ff ff fb 0f ae f0 48 8b

-- 
Regards,
Pim
