From: Nikolay Borisov <n.borisov@siteground.com>
Subject: bcache causes RCU stalls/bcache_gc hogs CPU
Date: Tue, 14 Apr 2015 17:52:40 +0300
Message-ID: <552D29B8.9040704@siteground.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail.siteground.com ([67.19.240.234]:57681 "EHLO
	mail.siteground.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472AbbDNPdz (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 14 Apr 2015 11:33:55 -0400
Received: from [78.130.157.130] (port=33015 helo=localhost.localdomain)
	by mail.siteground.com with esmtpsa (UNKNOWN:DHE-RSA-AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <n.borisov@siteground.com>)
	id 1Yi2CU-0004JN-Rw
	for linux-bcache@vger.kernel.org; Tue, 14 Apr 2015 09:52:31 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello list,


I'm currently testing bcache with the following setup:

NAME MAJ:MIN RM SIZE RO TYPE MOUNTPOINT

sda                   8:0    0   1.8T  0 disk
=E2=94=9C=E2=94=80sda1                8:1    0     2M  0 part
=E2=94=9C=E2=94=80sda2                8:2    0   191M  0 part
=E2=94=94=E2=94=80sda3                8:3    0   1.8T  0 part
   =E2=94=94=E2=94=80main-os (dm-0)  254:0    0   1.8T  0 lvm  /
sdb                   8:16   0 223.1G  0 disk
=E2=94=9C=E2=94=80sdb1                8:17   0 188.2M  0 part /boot
=E2=94=94=E2=94=80sdb2                8:18   0 222.9G  0 part
   =E2=94=9C=E2=94=80main-ssd (dm-1) 254:1    0    40G  0 lvm
   =E2=94=82 =E2=94=94=E2=94=80bcache0       253:0    0   182G  0 disk =
/sdb
   =E2=94=94=E2=94=80main-db (dm-2)  254:2    0   182G  0 lvm
     =E2=94=94=E2=94=80bcache0       253:0    0   182G  0 disk /sdb

So a 40gig ssd (main-ssd, lvm2 volume) backed by a 180gig hdd (main-db,=
 lvm 2 volume), using the writeback cache policy. Every other setting i=
s at its default. I'm running the 4.0-rc6 (!CONFIG_PREEMPT). After runn=
ing fio (using a 30gb file) with a mix of sequential and random i/o and=
 I'm getting the following RCU warn:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
INFO: rcu_sched self-detected stall on CPU
         4: (2099 ticks this GP) idle=3Dfcf/140000000000001/0 softirq=3D=
1031582/1031582 fqs=3D2100
INFO: rcu_sched detected stalls on CPUs/tasks:
         4: (2099 ticks this GP) idle=3Dfcf/140000000000001/0 softirq=3D=
1031582/1031582 fqs=3D2100
         (detected by 16, t=3D2104 jiffies, g=3D2176431, c=3D2176430, q=
=3D3098)
Task dump for CPU 4:
bcache_gc	R  running task    12728 18115      2 0x00000008
  ffff880079e85720 fffffffffffffffc ffff88046c180e20 fffffffffffffffc
  ffffffff81091693 fffffffffffffffc ffff88086aa3d000 ffff88046c180000
  ffff88086aa3d000 ffff88046c180000 ffff88086aa3d060 ffff88086aa3d000
Call Trace:
  [<ffffffff81091693>] ? __wake_up+0x53/0x70
  [<ffffffffa01103d4>] ? bch_btree_gc+0x2f4/0x560 [bcache]
  [<ffffffff8100180b>] ? __switch_to+0xbb/0x5f0
  [<ffffffff810911f0>] ? woken_wake_function+0x20/0x20
  [<ffffffffa0110678>] ? bch_gc_thread+0x38/0x120 [bcache]
  [<ffffffffa0110640>] ? bch_btree_gc+0x560/0x560 [bcache]
  [<ffffffffa0110640>] ? bch_btree_gc+0x560/0x560 [bcache]
  [<ffffffff81070a9e>] ? kthread+0xce/0xf0
  [<ffffffff810709d0>] ? kthread_freezable_should_stop+0x70/0x70
  [<ffffffff815b8818>] ? ret_from_fork+0x58/0x90
  [<ffffffff810709d0>] ? kthread_freezable_should_stop+0x70/0x70
          (t=3D2228 jiffies g=3D2176431 c=3D2176430 q=3D3161)
Task dump for CPU 4:
bcache_gc	R  running task    12728 18115      2 0x00000008
  0000000000000005 ffff88046fc83ca8 ffffffff8107720b 0000000000000004
  ffffffff8183d040 ffff88046fc83cc8 ffffffff810772af ffff88046fc83cc8
  ffffffff8183d100 ffff88046fc83cf8 ffffffff810a5101 ffff88046fc94500
Call Trace:
  <IRQ>  [<ffffffff8107720b>] sched_show_task+0xcb/0x130
  [<ffffffff810772af>] dump_cpu_task+0x3f/0x50
  [<ffffffff810a5101>] rcu_dump_cpu_stacks+0x91/0xd0
  [<ffffffff810a68cf>] rcu_check_callbacks+0x65f/0xc30
  [<ffffffff81080ecc>] ? account_process_tick+0x6c/0x170
  [<ffffffff810acf29>] update_process_times+0x39/0x70
  [<ffffffff810beba0>] tick_sched_handle+0x40/0x50
  [<ffffffff810bedb2>] tick_sched_timer+0x52/0xa0
  [<ffffffff810afa16>] __run_hrtimer+0x86/0x1d0
  [<ffffffff810bed60>] ? tick_nohz_handler+0xc0/0xc0
  [<ffffffff810afd92>] hrtimer_interrupt+0x102/0x240
  [<ffffffffa0109920>] ? bch_ptr_invalid+0x10/0x10 [bcache]
  [<ffffffff81032e79>] local_apic_timer_interrupt+0x39/0x60
  [<ffffffff815bb355>] smp_apic_timer_interrupt+0x45/0x59
  [<ffffffffa0109920>] ? bch_ptr_invalid+0x10/0x10 [bcache]
  [<ffffffff815b972d>] apic_timer_interrupt+0x6d/0x80
  <EOI>  [<ffffffffa01117c5>] ? __bch_extent_invalid+0xa5/0xd0 [bcache]
  [<ffffffffa0111721>] ? __bch_extent_invalid+0x1/0xd0 [bcache]
  [<ffffffffa0111802>] ? bch_extent_invalid+0x12/0x20 [bcache]
  [<ffffffffa011183d>] bch_extent_bad+0x2d/0x1c0 [bcache]
  [<ffffffffa010992a>] bch_ptr_bad+0xa/0x10 [bcache]
  [<ffffffffa01098f9>] bch_btree_iter_next_filter+0x39/0x50 [bcache]
  [<ffffffffa0109c80>] btree_gc_count_keys+0x50/0x70 [bcache]
  [<ffffffffa010ffbf>] btree_gc_recurse+0x1bf/0x2e0 [bcache]
  [<ffffffffa010c4ac>] ? btree_gc_mark_node+0xdc/0x210 [bcache]
  [<ffffffff81091693>] ? __wake_up+0x53/0x70
  [<ffffffffa01103d4>] bch_btree_gc+0x2f4/0x560 [bcache]
  [<ffffffff8100180b>] ? __switch_to+0xbb/0x5f0
  [<ffffffff810911f0>] ? woken_wake_function+0x20/0x20
  [<ffffffffa0110678>] bch_gc_thread+0x38/0x120 [bcache]
  [<ffffffffa0110640>] ? bch_btree_gc+0x560/0x560 [bcache]
  [<ffffffffa0110640>] ? bch_btree_gc+0x560/0x560 [bcache]
  [<ffffffff81070a9e>] kthread+0xce/0xf0
  [<ffffffff810709d0>] ? kthread_freezable_should_stop+0x70/0x70
  [<ffffffff815b8818>] ret_from_fork+0x58/0x90

Naturally, checking /sys/fs/bcache/b9bcddd1-7a9a-4f2f-88e6-cb5bef6abcf2=
/internal/btree_gc_max_duration_ms shows: 31593  Clearly at some point =
the GC overhead becomes so large that it causes RCU grace period stalls=
=2E I'm puzzled since bch_btree_gc_finish(...) is not listed and this i=
s the only function that pertains to bcache gc AND executes code in RCU=
 critical read section.

In addition to that I also observed that the after this RCU stall warn =
occurs the bcache_gc thread hogs the machine at 100% rendering it unusa=
ble. I managed to get 2 call stack dumps via magic sysrq as follows:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
NMI backtrace for cpu 4
CPU: 4 PID: 18115 Comm: bcache_gc Not tainted 4.0.0-rc6bcache1-nikbor #=
4
Hardware name: Supermicro X9DRD-iF/LF/X9DRD-iF, BIOS 3.0b 12/05/2013
task: ffff88086ab093e0 ti: ffff880868024000 task.ti: ffff880868024000
RIP: 0010:[<ffffffffa01098cb>]  [<ffffffffa01098cb>] bch_btree_iter_nex=
t_filter+0xb/0x50 [bcache]
RSP: 0018:ffff880868027bd8  EFLAGS: 00000202
RAX: 0000000000000001 RBX: 0000000000002034 RCX: 000000000000000a
RDX: ffffffffa0109920 RSI: ffff88086aa3dcd0 RDI: ffff880868027c08
RBP: ffff880868027bf8 R08: 0000000000000001 R09: 0000000000000001
R10: 000007ffffffffff R11: 0000000000000008 R12: ffff88086aa3dcd0
R13: ffff880868027c08 R14: ffff880868027cf8 R15: ffff880868027dd8
=46S:  0000000000000000(0000) GS:ffff88046fc80000(0000) knlGS:000000000=
0000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4f6b410008 CR3: 000000000180e000 CR4: 00000000001406e0
Stack:
  0000000000002034 ffff88086aa3dcd0 ffff880868027c08 ffff880868027cf8
  ffff880868027c78 ffffffffa0109c80 0000000000000004 0000000000000001
  ffff8807740101c0 ffff88077402a9f8 ffff88086aa3dc00 ffff88086aa3d000
Call Trace:
  [<ffffffffa0109c80>] btree_gc_count_keys+0x50/0x70 [bcache]
  [<ffffffffa010ffbf>] btree_gc_recurse+0x1bf/0x2e0 [bcache]
  [<ffffffffa010c4ac>] ? btree_gc_mark_node+0xdc/0x210 [bcache]
  [<ffffffff81091693>] ? __wake_up+0x53/0x70
  [<ffffffffa01103d4>] bch_btree_gc+0x2f4/0x560 [bcache]
  [<ffffffff8100180b>] ? __switch_to+0xbb/0x5f0
  [<ffffffff810911f0>] ? woken_wake_function+0x20/0x20
  [<ffffffffa0110678>] bch_gc_thread+0x38/0x120 [bcache]
  [<ffffffffa0110640>] ? bch_btree_gc+0x560/0x560 [bcache]
  [<ffffffffa0110640>] ? bch_btree_gc+0x560/0x560 [bcache]
  [<ffffffff81070a9e>] kthread+0xce/0xf0
  [<ffffffff810709d0>] ? kthread_freezable_should_stop+0x70/0x70
  [<ffffffff815b8818>] ret_from_fork+0x58/0x90
  [<ffffffff810709d0>] ? kthread_freezable_should_stop+0x70/0x70
Code: ff 48 89 d7 4c 29 cf eb a7 48 29 f2 48 89 d6 e9 18 ff ff ff 66 66=
 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 56 41 55 41 54 53 <0f> 1f=
 44 00 00 48 89 fb 49 89 f4 49 89 d6 0f 1f 80 00 00 00 00


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

NMI backtrace for cpu 4
CPU: 4 PID: 18115 Comm: bcache_gc Not tainted 4.0.0-rc6bcache1-nikbor #=
4
Hardware name: Supermicro X9DRD-iF/LF/X9DRD-iF, BIOS 3.0b 12/05/2013
task: ffff88086ab093e0 ti: ffff880868024000 task.ti: ffff880868024000
RIP: 0010:[<ffffffffa0111916>]  [<ffffffffa0111916>] bch_extent_bad+0x1=
06/0x1c0 [bcache]
RSP: 0018:ffff880868027ba8  EFLAGS: 00000202
RAX: 000000000000bd2a RBX: ffff88077400a550 RCX: 000000000000000a
RDX: 0000000000000004 RSI: 00000000fc390004 RDI: ffff88046c180000
RBP: ffff880868027bb8 R08: 0000000000000001 R09: 0000000000000000
R10: 000007ffffffffff R11: 0000000000000008 R12: ffff88086aa3dcd0
R13: ffff88077400a550 R14: ffffffffa0109920 R15: ffff880868027dd8
=46S:  0000000000000000(0000) GS:ffff88046fc80000(0000) knlGS:000000000=
0000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4f6b410008 CR3: 000000000180e000 CR4: 00000000001406e0
Stack:
  ffff880868027c08 ffff88086aa3dcd0 ffff880868027bc8 ffffffffa010992a
  ffff880868027bf8 ffffffffa01098f9 00000000000014a6 ffff88086aa3dcd0
  ffff880868027c08 ffff880868027cf8 ffff880868027c78 ffffffffa0109c80
Call Trace:
  [<ffffffffa010992a>] bch_ptr_bad+0xa/0x10 [bcache]
  [<ffffffffa01098f9>] bch_btree_iter_next_filter+0x39/0x50 [bcache]
  [<ffffffffa0109c80>] btree_gc_count_keys+0x50/0x70 [bcache]
  [<ffffffffa010ffbf>] btree_gc_recurse+0x1bf/0x2e0 [bcache]
  [<ffffffffa010c4ac>] ? btree_gc_mark_node+0xdc/0x210 [bcache]
  [<ffffffff81091693>] ? __wake_up+0x53/0x70
  [<ffffffffa01103d4>] bch_btree_gc+0x2f4/0x560 [bcache]
  [<ffffffff8100180b>] ? __switch_to+0xbb/0x5f0
  [<ffffffff810911f0>] ? woken_wake_function+0x20/0x20
  [<ffffffffa0110678>] bch_gc_thread+0x38/0x120 [bcache]
  [<ffffffffa0110640>] ? bch_btree_gc+0x560/0x560 [bcache]
  [<ffffffffa0110640>] ? bch_btree_gc+0x560/0x560 [bcache]
  [<ffffffff81070a9e>] kthread+0xce/0xf0
  [<ffffffff810709d0>] ? kthread_freezable_should_stop+0x70/0x70
  [<ffffffff815b8818>] ret_from_fork+0x58/0x90
  [<ffffffff810709d0>] ? kthread_freezable_should_stop+0x70/0x70
Code: 33 25 ff 0f 00 00 48 8b 94 c7 40 0c 00 00 48 89 f0 48 8b 92 d8 0a=
 00 00 48 c1 e8 08 4c 21 d0 48 d3 e8 48 8d 04 40 0f b6 54 82 06 <40> 28=
 f2 80 fa 80 0f 87 7e 00 00 00 0f b6 d2 83 fa 60 76 66 31


In the mean time I'm running the stable 4.0.0 where I observe better re=
sults ( no bcache_gc thread hog but still the occasional stall warn)

Regards,
Nikolay
