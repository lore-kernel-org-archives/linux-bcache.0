From: Pavel Goran <via-bcache@pvgoran.name>
Subject: Re: BUG: soft lockup - CPU#0 stuck for 22s! [bcache_gc:....]
Date: Thu, 11 Sep 2014 14:35:00 +0700
Message-ID: <1435187476.20140911143500@pvgoran.name>
References: <539F4414.7070509@nethuis.nl>
Reply-To: Pavel Goran <via-bcache@pvgoran.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from pvgoran2.xen.prgmr.com ([71.19.149.48]:47209 "EHLO
	v2.pvgoran.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaIKHkk (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 11 Sep 2014 03:40:40 -0400
In-Reply-To: <539F4414.7070509@nethuis.nl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello Pim,

Tuesday, June 17, 2014, 2:23:00 AM, you wrote:

> But more important, afer a while I run into a soft lockup. I've not been
> able to run this kernel more than a couple of hours.

> I'm running 3.14.6, plus these patches from this mailinglist:
> - bcache: fix uninterruptible sleep in writeback thread
> - bcache: fix crash on shutdown in passthrough mode

> I've also tried running this 3.14.6 kernel plus all bcache related
> patches from 3.15. This makes no difference, same behavior.

> [37903.477806] BUG: soft lockup - CPU#0 stuck for 23s! [bcache_gc:1842]

Seems like I was just hit by this bug.

I'm  running pf-kernel (http://pf.natalenko.name) version 3.16-pf1 (it's based
on  vanilla  3.16.1,  as  far as I remember) with the same two patches (fixing
uninterruptible   sleep   and   fixing  crash  on  shutdown).  Cache  mode  is
"writearound",  CPU  scheduler  is  BFS  (from  -ck  patchset  by Con Kolivas,
included in pf-kernel).

The following happened: I was doing some not-so-heavy IO on a bcached disk (an
update of portage snapshot by means of emerge-delta-webrsync), and my terminal
application stopped responding. X was still running (I could move windows, and
the load indicators kept updating). However, everything stopped in a minute or
so.  I  waited  for several minutes and then I had to shut down the laptop the
hard way.

Kernel  messages  were logged by syslog this time (I had several hangs before,
but I couldn't see anything in logs). Here is the summary:

Sep 11 13:19:23 aurora kernel: BUG: soft lockup - CPU#1 stuck for 22s! [bcache_gc:973]
Sep 11 13:19:51 aurora kernel: BUG: soft lockup - CPU#1 stuck for 23s! [bcache_gc:973]
Sep 11 13:19:57 aurora kernel: INFO: rcu_sched self-detected stall on CPU { 1}  (t=18000 jiffies g=24035340 c=24035339 q=40933)
Sep 11 13:20:27 aurora kernel: BUG: soft lockup - CPU#0 stuck for 22s! [bcache_gc:973]
Sep 11 13:20:55 aurora kernel: BUG: soft lockup - CPU#0 stuck for 22s! [bcache_gc:973]
Sep 11 13:21:01 aurora kernel: INFO: rcu_sched self-detected stall on CPU { 0}  (t=18000 jiffies g=24035358 c=24035357 q=17722)
Sep 11 13:21:19 aurora kernel: INFO: task qemu-system-x86:16118 blocked for more than 120 seconds.
Sep 11 13:21:19 aurora kernel: INFO: task qemu-system-x86:16831 blocked for more than 120 seconds.
Sep 11 13:21:19 aurora kernel: INFO: task qemu-system-x86:16832 blocked for more than 120 seconds.
Sep 11 13:21:19 aurora kernel: INFO: task qemu-system-x86:16833 blocked for more than 120 seconds.
Sep 11 13:21:19 aurora kernel: INFO: task qemu-system-x86:16844 blocked for more than 120 seconds.
Sep 11 13:21:19 aurora kernel: INFO: task qemu-system-x86:16848 blocked for more than 120 seconds.
Sep 11 13:21:19 aurora kernel: INFO: task qemu-system-x86:16855 blocked for more than 120 seconds.
Sep 11 13:21:19 aurora kernel: INFO: task qemu-system-x86:16846 blocked for more than 120 seconds.
Sep 11 13:21:19 aurora kernel: INFO: task qemu-system-x86:16847 blocked for more than 120 seconds.
Sep 11 13:21:27 aurora kernel: BUG: soft lockup - CPU#0 stuck for 22s! [bcache_gc:973]
Sep 11 13:21:55 aurora kernel: BUG: soft lockup - CPU#0 stuck for 22s! [bcache_gc:973]
Sep 11 13:22:23 aurora kernel: BUG: soft lockup - CPU#0 stuck for 22s! [bcache_gc:973]
Sep 11 13:22:51 aurora kernel: BUG: soft lockup - CPU#0 stuck for 22s! [bcache_gc:973]
(shutdown)

Detailed  logs  for the first "soft lockup" event and the first "self-detected
stall" event:

Sep 11 13:19:23 aurora kernel: BUG: soft lockup - CPU#1 stuck for 22s! [bcache_gc:973]
Sep 11 13:19:23 aurora kernel: Modules linked in: ctr ccm ipt_REJECT xt_TCPMSS xt_limit xt_multiport xt_conntrack iptabl
e_filter ipt_MASQUERADE xt_nat iptable_nat bnep nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tabl
es btusb usbhid uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core b43 bcma mac80211 ssb_hcd dell_laptop dcdbas 
coretemp kvm_intel joydev pcspkr kvm b44 wl(PO) i2c_i801 microcode cfg80211 mii uhci_hcd libphy sdhci_pci sdhci intel_ag
p ehci_pci intel_gtt ehci_hcd snd_hda_codec_idt snd_hda_codec_generic ssb mmc_core pcmcia pcmcia_core snd_hda_intel snd_
hda_controller snd_hda_codec snd_hwdep acpi_cpufreq
Sep 11 13:19:23 aurora kernel: CPU: 1 PID: 973 Comm: bcache_gc Tainted: P           O  3.16.0-pf1 #1
Sep 11 13:19:23 aurora kernel: Hardware name: Dell Inc. Inspiron 1720                   /0UK437, BIOS A09 07/11/2008
Sep 11 13:19:23 aurora kernel: task: ffff8800d96a96c0 ti: ffff880194548000 task.ti: ffff880194548000
Sep 11 13:19:23 aurora kernel: RIP: 0010:[<ffffffff817476af>]  [<ffffffff817476af>] __bch_btree_iter_next+0x1bb/0x214
Sep 11 13:19:23 aurora kernel: RSP: 0018:ffff88019454bb98  EFLAGS: 00000202
Sep 11 13:19:23 aurora kernel: RAX: 0000000000000101 RBX: ffff880195c14400 RCX: 0000000000000000
Sep 11 13:19:23 aurora kernel: RDX: ffff88000c19b2c0 RSI: ffff88000c1a0da0 RDI: ffff88000c1a0d40
Sep 11 13:19:23 aurora kernel: RBP: ffff88019454bbd8 R08: 0000000000000001 R09: 0000000000000400
Sep 11 13:19:23 aurora kernel: R10: 0000000000000400 R11: 0000000000000008 R12: ffff88019454bcc8
Sep 11 13:19:23 aurora kernel: R13: ffff880195c14400 R14: 0000000000000000 R15: ffffffff8174ef5d
Sep 11 13:19:23 aurora kernel: FS:  0000000000000000(0000) GS:ffff88019fd00000(0000) knlGS:0000000000000000
Sep 11 13:19:23 aurora kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Sep 11 13:19:23 aurora kernel: CR2: 00007f260f06cea8 CR3: 000000008edca000 CR4: 00000000000027f0
Sep 11 13:19:23 aurora kernel: Stack:
Sep 11 13:19:23 aurora kernel: ffff88019454bbd8 ffff88000c19b2a8 0000000000000400 000000000000364e
Sep 11 13:19:23 aurora kernel: ffffffff817492b4 ffff8800da1a30d8 ffff88019454bc28 0000000000000001
Sep 11 13:19:23 aurora kernel: ffff88019454bbe8 ffffffff81747718 ffff88019454bc18 ffffffff8174910d
Sep 11 13:19:23 aurora kernel: Call Trace:
Sep 11 13:19:23 aurora kernel: [<ffffffff817492b4>] ? bch_ptr_invalid+0xc/0xc
Sep 11 13:19:23 aurora kernel: [<ffffffff81747718>] bch_btree_iter_next+0x10/0x12
Sep 11 13:19:23 aurora kernel: [<ffffffff8174910d>] bch_btree_iter_next_filter+0x1c/0x3d
Sep 11 13:19:23 aurora kernel: [<ffffffff8174944e>] btree_gc_count_keys+0x45/0x57
Sep 11 13:19:23 aurora kernel: [<ffffffff8174d9be>] btree_gc_recurse+0xf2/0x2ab
Sep 11 13:19:23 aurora kernel: [<ffffffff81749e1b>] ? btree_gc_mark_node+0xb8/0x1a4
Sep 11 13:19:23 aurora kernel: [<ffffffff81071cb2>] ? spin_unlock_irqrestore+0x9/0xb
Sep 11 13:19:23 aurora kernel: [<ffffffff81749c58>] ? __bch_btree_mark_key+0xa9/0x1b4
Sep 11 13:19:23 aurora kernel: [<ffffffff8174ddb3>] bch_btree_gc+0x23c/0x39a
Sep 11 13:19:23 aurora kernel: [<ffffffff81072088>] ? abort_exclusive_wait+0x8a/0x8a
Sep 11 13:19:23 aurora kernel: [<ffffffff8174df43>] bch_gc_thread+0x32/0xe9
Sep 11 13:19:23 aurora kernel: [<ffffffff8174df11>] ? bch_btree_gc+0x39a/0x39a
Sep 11 13:19:23 aurora kernel: [<ffffffff8106593d>] kthread+0xa0/0xa8
Sep 11 13:19:23 aurora kernel: [<ffffffff8106589d>] ? __kthread_parkme+0x5c/0x5c
Sep 11 13:19:23 aurora kernel: [<ffffffff818ce67c>] ret_from_fork+0x7c/0xb0
Sep 11 13:19:23 aurora kernel: [<ffffffff8106589d>] ? __kthread_parkme+0x5c/0x5c
Sep 11 13:19:23 aurora kernel: Code: 4d 8d 6f 01 49 ff c4 49 c1 e4 04 49 c1 e5 04 49 01 dc 49 01 dd 49 8b 14 24 49 8b 4c 24 08 49 8b 7d 00 49 8b 75 08 41 ff d6 84 c0 <75> 44 49 8b 0c 24 49 8b 55 00 49 8b 45 08 49 89 4d 00 49 8b 4c 

And:

Sep 11 13:19:57 aurora kernel: INFO: rcu_sched self-detected stall on CPU { 1}  (t=18000 jiffies g=24035340 c=24035339 q
=40933)
Sep 11 13:19:57 aurora kernel: sending NMI to all CPUs:
Sep 11 13:19:57 aurora kernel: NMI backtrace for cpu 1
Sep 11 13:19:57 aurora kernel: CPU: 1 PID: 973 Comm: bcache_gc Tainted: P           O  3.16.0-pf1 #1
Sep 11 13:19:57 aurora kernel: Hardware name: Dell Inc. Inspiron 1720                   /0UK437, BIOS A09 07/11/2008
Sep 11 13:19:57 aurora kernel: task: ffff8800d96a96c0 ti: ffff880194548000 task.ti: ffff880194548000
Sep 11 13:19:57 aurora kernel: RIP: 0010:[<ffffffff8146d957>]  [<ffffffff8146d957>] delay_tsc+0x2a/0x6a
Sep 11 13:19:57 aurora kernel: RSP: 0018:ffff88019fd03d78  EFLAGS: 00000002
Sep 11 13:19:57 aurora kernel: RAX: 0002d8eddf7c6464 RBX: 0000000000260ae7 RCX: 0000000000000046
Sep 11 13:19:57 aurora kernel: RDX: 0002d8eddf7c6464 RSI: 0000000000000c00 RDI: 0000000000260ae7
Sep 11 13:19:57 aurora kernel: RBP: ffff88019fd03d98 R08: 0000000000000400 R09: 0000000000000000
Sep 11 13:19:57 aurora kernel: R10: 0000000000000000 R11: 0000000000000006 R12: 00000000df7c6464
Sep 11 13:19:57 aurora kernel: R13: 0000000000000001 R14: ffffffff820341c0 R15: 0000000000000001
Sep 11 13:19:57 aurora kernel: FS:  0000000000000000(0000) GS:ffff88019fd00000(0000) knlGS:0000000000000000
Sep 11 13:19:57 aurora kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Sep 11 13:19:57 aurora kernel: CR2: 00007f260f06cea8 CR3: 000000008edca000 CR4: 00000000000027f0
Sep 11 13:19:57 aurora kernel: Stack:
Sep 11 13:19:57 aurora kernel: 0000000000002710 ffff88019fd0e350 0000000000000001 ffffffff820341c0
Sep 11 13:19:57 aurora kernel: ffff88019fd03da8 ffffffff8146d8e4 ffff88019fd03db8 ffffffff8146d90a
Sep 11 13:19:57 aurora kernel: ffff88019fd03dd8 ffffffff81036210 ffff88019fd0fa30 ffffffff820341c0
Sep 11 13:19:57 aurora kernel: Call Trace:
Sep 11 13:19:57 aurora kernel: <IRQ> 
Sep 11 13:19:57 aurora kernel: [<ffffffff8146d8e4>] __delay+0xa/0xc
Sep 11 13:19:57 aurora kernel: [<ffffffff8146d90a>] __const_udelay+0x24/0x26
Sep 11 13:19:57 aurora kernel: [<ffffffff81036210>] arch_trigger_all_cpu_backtrace+0xa0/0xb0
Sep 11 13:19:57 aurora kernel: [<ffffffff81096b17>] rcu_check_callbacks+0x1d7/0x509
Sep 11 13:19:57 aurora kernel: [<ffffffff8104f79e>] ? raise_softirq+0x29/0x30
Sep 11 13:19:57 aurora kernel: [<ffffffff8109ebd6>] ? tick_sched_do_timer+0x2a/0x2a
Sep 11 13:19:57 aurora kernel: [<ffffffff81056256>] update_process_times+0x3a/0x63
Sep 11 13:19:57 aurora kernel: [<ffffffff8109e8d9>] tick_sched_handle+0x45/0x4a
Sep 11 13:19:57 aurora kernel: [<ffffffff8109ec0d>] tick_sched_timer+0x37/0x57
Sep 11 13:19:57 aurora kernel: [<ffffffff81067b31>] __run_hrtimer+0xa9/0x14c
Sep 11 13:19:57 aurora kernel: [<ffffffff81068410>] hrtimer_interrupt+0xbc/0x1a5
Sep 11 13:19:57 aurora kernel: [<ffffffff81034d4a>] local_apic_timer_interrupt+0x51/0x56
Sep 11 13:19:57 aurora kernel: [<ffffffff8103520f>] smp_apic_timer_interrupt+0x2d/0x40
Sep 11 13:19:57 aurora kernel: [<ffffffff818cf59d>] apic_timer_interrupt+0x6d/0x80
Sep 11 13:19:57 aurora kernel: <EOI> 
Sep 11 13:19:57 aurora kernel: [<ffffffff8174f40a>] ? ptr_stale+0x16/0x4d
Sep 11 13:19:57 aurora kernel: [<ffffffff8174f880>] ? bch_extent_bad+0xa1/0x12d
Sep 11 13:19:57 aurora kernel: [<ffffffff817492b4>] ? bch_ptr_invalid+0xc/0xc
Sep 11 13:19:57 aurora kernel: [<ffffffff817492be>] bch_ptr_bad+0xa/0xc
Sep 11 13:19:57 aurora kernel: [<ffffffff8174911e>] bch_btree_iter_next_filter+0x2d/0x3d
Sep 11 13:19:57 aurora kernel: [<ffffffff8174944e>] btree_gc_count_keys+0x45/0x57
Sep 11 13:19:57 aurora kernel: [<ffffffff8174d9be>] btree_gc_recurse+0xf2/0x2ab
Sep 11 13:19:57 aurora kernel: [<ffffffff81749e1b>] ? btree_gc_mark_node+0xb8/0x1a4
Sep 11 13:19:57 aurora kernel: [<ffffffff81071cb2>] ? spin_unlock_irqrestore+0x9/0xb
Sep 11 13:19:57 aurora kernel: [<ffffffff81749c58>] ? __bch_btree_mark_key+0xa9/0x1b4
Sep 11 13:19:57 aurora kernel: [<ffffffff8174ddb3>] bch_btree_gc+0x23c/0x39a
Sep 11 13:19:57 aurora kernel: [<ffffffff81072088>] ? abort_exclusive_wait+0x8a/0x8a
Sep 11 13:19:57 aurora kernel: [<ffffffff8174df43>] bch_gc_thread+0x32/0xe9
Sep 11 13:19:57 aurora kernel: [<ffffffff8174df11>] ? bch_btree_gc+0x39a/0x39a
Sep 11 13:19:57 aurora kernel: [<ffffffff8106593d>] kthread+0xa0/0xa8
Sep 11 13:19:57 aurora kernel: [<ffffffff8106589d>] ? __kthread_parkme+0x5c/0x5c
Sep 11 13:19:57 aurora kernel: [<ffffffff818ce67c>] ret_from_fork+0x7c/0xb0
Sep 11 13:19:57 aurora kernel: [<ffffffff8106589d>] ? __kthread_parkme+0x5c/0x5c
Sep 11 13:19:57 aurora kernel: Code: c3 55 48 89 e5 41 56 41 55 41 54 53 89 fb 65 44 8b 2c 25 2c b0 00 00 0f 1f 00 0f ae e8 e8 52 ff ff ff 41 89 c4 0f 1f 00 0f ae e8 <e8> 44 ff ff ff 89 c2 44 29 e2 39 da 73 29 f3 90 65 44 8b 34 25 
Sep 11 13:19:57 aurora kernel: NMI backtrace for cpu 0
Sep 11 13:19:57 aurora kernel: CPU: 0 PID: 9071 Comm: qemu-system-x86 Tainted: P           O  3.16.0-pf1 #1
Sep 11 13:19:57 aurora kernel: Hardware name: Dell Inc. Inspiron 1720                   /0UK437, BIOS A09 07/11/2008
Sep 11 13:19:57 aurora kernel: task: ffff8800066cad80 ti: ffff880101410000 task.ti: ffff880101410000
Sep 11 13:19:57 aurora kernel: RIP: 0033:[<00007fff4fc04d46>]  [<00007fff4fc04d46>] 0x7fff4fc04d46
Sep 11 13:19:57 aurora kernel: RSP: 002b:00007fff4fbffd00  EFLAGS: 00000246
Sep 11 13:19:57 aurora kernel: RAX: 0000000049f1aefd RBX: 0000000000000001 RCX: 000000000000236f
Sep 11 13:19:57 aurora kernel: RDX: 0000000000000002 RSI: 00007fff4fbffd58 RDI: 0000000000000001
Sep 11 13:19:57 aurora kernel: RBP: 00007fff4fbffd30 R08: 00007fba77f40e08 R09: 0000000000000000
Sep 11 13:19:57 aurora kernel: R10: 0000000000000000 R11: 0000000000000000 R12: 000000000efb72b2
Sep 11 13:19:57 aurora kernel: R13: 001dc865bef71050 R14: 00007fba77f3fd34 R15: 0000000000000000
Sep 11 13:19:57 aurora kernel: FS:  00007fba75d8f900(0000) GS:ffff88019fc00000(0000) knlGS:0000000000000000
Sep 11 13:19:57 aurora kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Sep 11 13:19:57 aurora kernel: CR2: 0000000000d10000 CR3: 0000000103ba1000 CR4: 00000000000027f0

Pavel Goran
  
