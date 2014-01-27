From: Ross Anderson <rosander@dsotm.net>
Subject: Kernel Panic 3.13
Date: Mon, 27 Jan 2014 06:50:29 -0600
Message-ID: <52E65615.4050308@dsotm.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from smtprelay0014.b.hostedemail.com ([64.98.42.14]:46741 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751431AbaA0M7k (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 27 Jan 2014 07:59:40 -0500
Received: from smtprelay.b.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
	by smtpgrave02.b.hostedemail.com (Postfix) with ESMTP id B62B113E8DA
	for <linux-bcache@vger.kernel.org>; Mon, 27 Jan 2014 12:49:25 +0000 (UTC)
Received: from filter.hostedemail.com (b-bigip1 [10.5.19.254])
	by smtprelay01.b.hostedemail.com (Postfix) with ESMTP id D352F2D2B5E
	for <linux-bcache@vger.kernel.org>; Mon, 27 Jan 2014 12:49:14 +0000 (UTC)
Received: from [192.168.2.200] (c-24-118-251-104.hsd1.mn.comcast.net [24.118.251.104])
	(Authenticated sender: rosander@dsotm.net)
	by omf07.b.hostedemail.com (Postfix) with ESMTPA
	for <linux-bcache@vger.kernel.org>; Mon, 27 Jan 2014 12:49:14 +0000 (UTC)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Greetings,

The following kernel panic occured on a new 3.13 kernel version running 
SCST on top of bcache.
Gcc  x86_64-pc-linux-gnu-4.7.3

The system has been running version 3.11.6 and 3.12.2 for sometime 
without errors.


[365057.392767] ------------[ cut here ]------------
[365057.392855] kernel BUG at drivers/md/bcache/btree.c:1168!
[365057.392943] invalid opcode: 0000 [#1] SMP
[365057.393018] Modules linked in: zfs(PO) zunicode(PO) zavl(PO) 
zcommon(PO) znvpair(PO) spl(O) qla2x00tgt(O) w83792d w83627hf hwmon_vid 
qla2xxx iscsi_scst(O) scst_vdisk(O) scst(O) ipv6 p4_clockmod 
speedstep_lib e1000e ptp e100 mii pps_core coretemp snd_ca0106 
snd_ac97_codec ac97_bus snd_rawmidi arcmsr(O) [last unloaded: zfs]
[365057.393797] CPU: 4 PID: 2269 Comm: bcache_gc Tainted: P           O 
3.13.0 #1
[365057.393900] Hardware name: Supermicro X7DVL/X7DVL, BIOS 2.1a 12/20/2008
[365057.394000] task: ffff88041cc38050 ti: ffff880418d62000 task.ti: 
ffff880418d62000
[365057.394115] RIP: 0010:[<ffffffff8166c083>] [<ffffffff8166c083>] 
__bch_btree_mark_key+0x263/0x2a0
[365057.394271] RSP: 0018:ffff880418d63ca8  EFLAGS: 00010246
[365057.394354] RAX: 0000000000000002 RBX: 0000000000000000 RCX: 
0000000000001e00
[365057.394456] RDX: 0000000000000002 RSI: 0000000000000001 RDI: 
0000000000000000
[365057.394559] RBP: ffff880419700578 R08: ffffc90002f75b28 R09: 
0000000000003fff
[365057.394662] R10: 0000001000000000 R11: 0000000000000001 R12: 
ffff8800cb1e0000
[365057.394765] R13: 0000000000000000 R14: 000007ffffffffff R15: 
0000000000000001
[365057.394869] FS:  0000000000000000(0000) GS:ffff88042fd00000(0000) 
knlGS:0000000000000000
[365057.394991] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[365057.395074] CR2: 00007ffecbebb000 CR3: 0000000416871000 CR4: 
00000000000007e0
[365057.395177] Stack:
[365057.395218]  ffff88041b567800 ffff880418d63d18 ffffffff81668880 
ffff880419700578
[365057.395380]  ffff880418d63d18 ffff88041b567800 ffff880418d63dd8 
0000000000000001
[365057.395542]  0000000000000039 0000000000000000 ffff880419700578 
ffffffff8166c462
[365057.395705] Call Trace:
[365057.395750]  [<ffffffff81668880>] ? bch_cache_allocator_init+0x70/0x70
[365057.395848]  [<ffffffff8166c462>] ? btree_gc_mark_node+0x72/0x1e0
[365057.395947]  [<ffffffff8136c213>] ? 
call_rwsem_down_write_failed+0x13/0x20
[365057.396057]  [<ffffffff8166e4dd>] ? bch_btree_gc+0x1bd/0x4c0
[365057.396137]  [<ffffffff81067fe5>] ? try_to_wake_up+0x1e5/0x280
[365057.396226]  [<ffffffff8166e808>] ? bch_gc_thread+0x28/0xf0
[365057.396318]  [<ffffffff8166e7e0>] ? bch_btree_gc+0x4c0/0x4c0
[365057.396398]  [<ffffffff8105df5c>] ? kthread+0xbc/0xe0
[365057.396473]  [<ffffffff8105dea0>] ? __kthread_parkme+0x70/0x70
[365057.396563]  [<ffffffff8183487c>] ? ret_from_fork+0x7c/0xb0
[365057.396655]  [<ffffffff8105dea0>] ? __kthread_parkme+0x70/0x70
[365057.396742] Code: 89 4c 24 10 4c 89 54 24 08 e8 9a ff 00 00 4c 8b 44 
24 18 84 c0 44 8b 4c 24 10 4c 8b 54 24 08 75 0c 41 0f b7 40 0a e9 c5 fe 
ff ff <0f> 0b 4c 89 44 24 18 44 89 4c 24 10 4c 89 54 24 08 e8 73 bc 1b
[365057.397528] RIP  [<ffffffff8166c083>] __bch_btree_mark_key+0x263/0x2a0
[365057.397640]  RSP <ffff880418d63ca8>
[365057.422535] ---[ end trace 0677b5ad54c8ddaa ]---

thanks,
