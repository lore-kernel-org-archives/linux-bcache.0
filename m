From: Eric Wheeler <linux-bcache@lists.ewheeler.net>
Subject: 3.17-rc6: bcache_gc: BUG: soft lockup - CPU#2 stuck for 23s!
Date: Sun, 28 Sep 2014 17:25:37 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1409281651340.15834@ware.dreamhost.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from homie.mail.dreamhost.com ([208.97.132.208]:58867 "EHLO
	homiemail-a61.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752485AbaI2ALe (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sun, 28 Sep 2014 20:11:34 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: Kent Overstreet <kmo@daterainc.com>, Ross Anderson <rosander@dsotm.net>, Stefan Priebe <s.priebe@profihost.ag>

Hello Kent, Ross, all:

We're getting bcache_gc backtraces and soft lockups; the system continues 
to be responsive and eventually recovers.  We are running 3.17-rc6. (This 
appears to be a continuation of the thread from 2014-09-15)

Please see the following two backtraces.  The first shows up in 
btree_gc_count_keys(), the other is triggered somehow by rcu_sched.  We 
will test with -rc7 this week, though I didn't see any bcache commits in 
rc7.

The server is quite busy:
   dd in userspace from dm-thinp snapshots to another server
   two DRBD verify's active backed by dm-thinp volumes
   note that, dd fills up the buffers so this could be operating with few
   pages free. (Though we have min-mem set to 256MB.)

I see we are hitting functions like bch_ptr_bad() and bch_extent_bad(). 
Could that indicate a cache corruption on our volume?

I'm happy to test patches if you have any suggestions or tests that I 
should run it through.

-Eric

(note that 5251 is the bcache_gc pid)

[131110.478867] NMI watchdog: BUG: soft lockup - CPU#2 stuck for 23s! [bcache_gc:5251]
[131110.479313] Modules linked in: dm_thin_pool dm_bio_prison 
dm_persistent_data dm_bufio sch_sfq nf_conntrack_ipv4 nf_defrag_ipv4 
xt_conntrack ipt_REJECT zram xt_c omment iptable_filter ip_tables drbd(OE) 
libcrc32c bnx2fc cnic uio fcoe libfcoe libfc bridge stp llc 8021q 
ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_ conntrack 
ip6table_filter ip6_tables ipv6 ext3 jbd vhost_net macvtap macvlan vhost 
tun kvm_intel kvm crc32c_intel bcache aesni_intel ablk_helper cryptd lrw 
gf128mul glue_helper aes_x86_64 iTCO_wdt iTCO_vendor_support serio_raw 
pcspkr i2c_i801 i2ccore lpc_ich mfd_core e1000e ptp pps_core bna sg 
sr_mod(E) cdrom(E) ext4(E) jbd2(E ) mbcache(E) usb_storage(E) sd_mod(E) 
crc_t10dif(E) crct10dif_common(E) video(E) ahci(E) libahci(E) bfa(E) 
scsi_transport_fc(E) arcmsr(E) dm_mirror(E) dm_region_has h(E) dm_log(E) 
dm_mod(E)

[131110.481865] CPU: 2 PID: 5251 Comm: bcache_gc Tainted: G           OEL 3.17.0-rc6 #1
[131110.482287] Hardware name: Supermicro X9SCL/X9SCM/X9SCL/X9SCM, BIOS 2.10 01/09/2014
[131110.482714] task: ffff8807f4b08e20 ti: ffff8807e51f8000 task.ti: ffff8807e51f8000
[131110.483148] RIP: 0010:[<ffffffffa03a7a13>]  [<ffffffffa03a7a13>] bch_extent_bad+0xf3/0x1c0 [bcache]
[131110.483576] RSP: 0018:ffff8807e51fbb68  EFLAGS: 00000246
[131110.483794] RAX: 00000004eb93f476 RBX: ffff8807e51fbe08 RCX: 000000000000000a
[131110.484235] RDX: ffffc90017145000 RSI: 00000004eb93f476 RDI: ffff8807ec8c0000
[131110.484657] RBP: ffff8807e51fbb78 R08: 0000000000000001 R09: 0000000000000000
[131110.485096] R10: 000007ffffffffff R11: 000000000000000c R12: 000007ffffffffff
[131110.485524] R13: ffff8807e51fbb58 R14: ffffffffa03a78d5 R15: ffff8807e51fbb48
[131110.485969] FS:  0000000000000000(0000) GS:ffff88082fc80000(0000) knlGS:0000000000000000
[131110.486393] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[131110.486609] CR2: 00007f5ff8e6c000 CR3: 0000000001a14000 CR4: 00000000001427e0
[131110.487051] Stack:
[131110.487261]  ffff8807e51fbbc8 ffff8807eccf64d0 ffff8807e51fbb88 ffffffffa039fa5a
[131110.487694]  ffff8807e51fbbb8 ffffffffa039fa29 0000000000000dad ffff8807eccf64d0
[131110.488140]  ffff8807e51fbbc8 ffff8807e51fbcb8 ffff8807e51fbc38 ffffffffa039fdc0
[131110.488583] Call Trace:
[131110.488803]  [<ffffffffa039fa5a>] bch_ptr_bad+0xa/0x10 [bcache]
[131110.489037]  [<ffffffffa039fa29>] bch_btree_iter_next_filter+0x39/0x50 [bcache]
[131110.489453]  [<ffffffffa039fdc0>] btree_gc_count_keys+0x50/0x70 [bcache]
[131110.489677]  [<ffffffffa03a60bf>] btree_gc_recurse+0x1bf/0x2e0 [bcache]
[131110.489923]  [<ffffffffa03a1d2c>] ? btree_gc_mark_node+0xdc/0x210 [bcache]
[131110.490146]  [<ffffffffa03a62e1>] bch_btree_gc_root+0x101/0x110 [bcache]
[131110.490371]  [<ffffffffa03a64db>] bch_btree_gc+0x1eb/0x460 [bcache]
[131110.490597]  [<ffffffff81096f60>] ? bit_waitqueue+0xa0/0xa0
[131110.490821]  [<ffffffffa03a6788>] bch_gc_thread+0x38/0x120 [bcache]
[131110.491062]  [<ffffffffa03a6750>] ? bch_btree_gc+0x460/0x460 [bcache]
[131110.491284]  [<ffffffff8107812e>] kthread+0xce/0xf0
[131110.491505]  [<ffffffff81078060>] ? kthread_freezable_should_stop+0x70/0x70
[131110.491732]  [<ffffffff815c52bc>] ret_from_fork+0x7c/0xb0
[131110.491970]  [<ffffffff81078060>] ? kthread_freezable_should_stop+0x70/0x70
[131110.492194] Code: 0f 1f 84 00 00 00 00 00 48 8b 74 c3 10 48 89 f0 48 c1 e8 33 25 ff 0f 00 00 48 8b 94 c7 40 0c 00 00 48 89 f0 48 8b 92 d8 0a 00 00 <48> c1 e8 08 4c 21 d0 48 d3 e8 48 8d 04 40 0f b6 54 82 06 40 28


Second backtrace:

[131146.469270] INFO: rcu_sched self-detected stall on CPU { 2}  (t=11613552 jiffies g=3817860 c=3817859 q=24121607)
[131146.469724] Task dump for CPU 2:
[131146.469943] bcache_gc       R  running task        0  5251      2 0x00000088
[131146.470168]  0000000000000003 ffff88082fc83d18 ffffffff8107ef97 0000000000000002
[131146.470625]  ffffffff81a4cc80 ffff88082fc83d38 ffffffff8107f03f ffff88082fc83d38
[131146.471058]  ffffffff81a4cc80 ffff88082fc83d68 ffffffff810b5b41 ffffffff81a4cc80
[131146.471507] Call Trace:
[131146.471718]  <IRQ>  [<ffffffff8107ef97>] sched_show_task+0xa7/0x110
[131146.471948]  [<ffffffff8107f03f>] dump_cpu_task+0x3f/0x50
[131146.472167]  [<ffffffff810b5b41>] rcu_dump_cpu_stacks+0x91/0xd0
[131146.472406]  [<ffffffff810b5c5e>] print_cpu_stall+0xde/0x140
[131146.472630]  [<ffffffff810b610e>] __rcu_pending+0x1fe/0x210
[131146.472855]  [<ffffffff810b73fd>] rcu_check_callbacks+0xdd/0x190
[131146.473077]  [<ffffffff810bad28>] update_process_times+0x48/0x80
[131146.473321]  [<ffffffff810cc1e9>] tick_sched_handle+0x39/0x80
[131146.473540]  [<ffffffff810cc434>] tick_sched_timer+0x54/0x90
[131146.473764]  [<ffffffff810bd384>] __run_hrtimer+0x74/0x1d0
[131146.473986]  [<ffffffff810cc3e0>] ? tick_nohz_handler+0xc0/0xc0
[131146.474208]  [<ffffffff810bd716>] hrtimer_interrupt+0x106/0x280
[131146.474453]  [<ffffffffa039fa50>] ? bch_ptr_invalid+0x10/0x10 [bcache]
[131146.474668]  [<ffffffff810387cb>] local_apic_timer_interrupt+0x3b/0x60
[131146.474884]  [<ffffffff815c7ec5>] smp_apic_timer_interrupt+0x45/0x60
[131146.475100]  [<ffffffffa039fa50>] ? bch_ptr_invalid+0x10/0x10 [bcache]
[131146.475332]  [<ffffffff815c61dd>] apic_timer_interrupt+0x6d/0x80
[131146.475544]  <EOI>  [<ffffffffa03a7951>] ? bch_extent_bad+0x31/0x1c0 [bcache]
[131146.475967]  [<ffffffffa03a794d>] ? bch_extent_bad+0x2d/0x1c0 [bcache]
[131146.476183]  [<ffffffffa039fa5a>] bch_ptr_bad+0xa/0x10 [bcache]
[131146.476418]  [<ffffffffa039fa29>] bch_btree_iter_next_filter+0x39/0x50 [bcache]
[131146.476845]  [<ffffffffa039fdc0>] btree_gc_count_keys+0x50/0x70 [bcache]
[131146.477064]  [<ffffffffa03a60bf>] btree_gc_recurse+0x1bf/0x2e0 [bcache]
[131146.477302]  [<ffffffffa03a1d2c>] ? btree_gc_mark_node+0xdc/0x210 [bcache]
[131146.477521]  [<ffffffffa03a62e1>] bch_btree_gc_root+0x101/0x110 [bcache]
[131146.477747]  [<ffffffffa03a64db>] bch_btree_gc+0x1eb/0x460 [bcache]
[131146.477964]  [<ffffffff81096f60>] ? bit_waitqueue+0xa0/0xa0
[131146.478182]  [<ffffffffa03a6788>] bch_gc_thread+0x38/0x120 [bcache]
[131146.478416]  [<ffffffffa03a6750>] ? bch_btree_gc+0x460/0x460 [bcache]
[131146.478634]  [<ffffffff8107812e>] kthread+0xce/0xf0
[131146.478847]  [<ffffffff81078060>] ? kthread_freezable_should_stop+0x70/0x70
[131146.479066]  [<ffffffff815c52bc>] ret_from_fork+0x7c/0xb0
[131146.479302]  [<ffffffff81078060>] ? kthread_freezable_should_stop+0x70/0x70



--
Eric Wheeler, President           eWheeler, Inc. dba Global Linux Security
888-LINUX26 (888-546-8926)        Fax: 503-716-3878           PO Box 25107
www.GlobalLinuxSecurity.pro       Linux since 1996!     Portland, OR 97298
