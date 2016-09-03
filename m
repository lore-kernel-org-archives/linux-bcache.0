From: Marcin <marcin@mejor.pl>
Subject: [bcachefs]  BUG: soft lockup - CPU#0 stuck for 22s!
 [bch_copygc_read:5328]
Date: Sat, 03 Sep 2016 23:29:49 +0200
Message-ID: <5e794b2230e3af7ec0a06eaceaf7a6fc@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:16834 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753962AbcICVam (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 3 Sep 2016 17:30:42 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi!
Kernel at commit c820493652e830dc050e1418301e1bdec5691a1e

I createt to devices, fast has size
# blockdev --getsz /dev/sde1
20971520
and slower device:
# blockdev --getsz /dev/sdd1
2930209551

I was copying files from one disk to bcache, after some time I got:
  BUG: soft lockup - CPU#0 stuck for 22s! [bch_copygc_read:5328]

# cat 
/sys/fs/bcache/5ad3d751-cb40-4bb7-9546-3e5b48ccd3cf/cache0/dirty_bytes  
/sys/fs/bcache/5ad3d751-cb40-4bb7-9546-3e5b48ccd3cf/cache1/dirty_bytes
9269264384
2540163072

dmesg says:
[ 9088.110001] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s! 
[bch_copygc_read:5328]
[ 9088.110001] Modules linked in: bcache lz4_compress zlib_deflate 
libcrc32c lz4_decompress sha1_generic cpufreq_ondemand msr af_packet 
fuse pcrypt nf_nat_ftp nf_conntrack_ftp nf_nat nf_conntrack ipv6 
coretemp hwmon kvm_intel kvm irqbypass i2c_i801 i2c_core sky2 hpsa 
acpi_cpufreq scsi_transport_sas processor button raid1 md_mod 
pata_jmicron ehci_pci ehci_hcd dm_mod
[ 9088.110001] CPU: 0 PID: 5328 Comm: bch_copygc_read Not tainted 4.7.0+ 
#2
[ 9088.110001] Hardware name: Gigabyte Technology Co., Ltd. 
965P-DS3/965P-DS3, BIOS F14 06/25/2009
[ 9088.110001] task: ffff88001b561a80 ti: ffff880002810000 task.ti: 
ffff880002810000
[ 9088.110001] RIP: 0010:[<ffffffffc028795b>]  [<ffffffffc028795b>] 
bch_moving_gc+0xcb/0xd90 [bcache]
[ 9088.110001] RSP: 0018:ffff880002813d20  EFLAGS: 00000287
[ 9088.110001] RAX: ffffc900001f6e78 RBX: ffff8800102c5000 RCX: 
000000000003c000
[ 9088.110001] RDX: ffffc9000027f000 RSI: ffff8800102c5000 RDI: 
ffff8800102c5608
[ 9088.110001] RBP: ffff880002813e40 R08: ffff880002813d90 R09: 
0000000002000000
[ 9088.110001] R10: 0000000000000bc6 R11: 0000000000064000 R12: 
ffff8800014d0000
[ 9088.110001] R13: ffff8800102c5000 R14: 0000000000027800 R15: 
0000000001b6c6e0
[ 9088.110001] FS:  0000000000000000(0000) GS:ffff88003fc00000(0000) 
knlGS:0000000000000000
[ 9088.110001] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 9088.110001] CR2: 000056048ce06f62 CR3: 000000003d0ce000 CR4: 
00000000000006f0
[ 9088.110001] Stack:
[ 9088.110001]  0000000000015f00 0000000000015f00 ffffffff8107bd3f 
ffff8800102c5000
[ 9088.110001]  ffff880002813de0 0000000000000000 ffff880002813e68 
ffff880002813e40
[ 9088.110001]  0000000000000002 0000000000064000 ffff8800102c5608 
000000000000000f
[ 9088.110001] Call Trace:
[ 9088.110001]  [<ffffffff8107bd3f>] ? sched_clock_cpu+0x7f/0xa0
[ 9088.110001]  [<ffffffffc028878c>] bch_moving_gc_thread+0x16c/0x180 
[bcache]
[ 9088.110001]  [<ffffffffc0288620>] ? bch_moving_gc+0xd90/0xd90 
[bcache]
[ 9088.110001]  [<ffffffff8106e874>] kthread+0xc4/0xe0
[ 9088.110001]  [<ffffffff8146b0bf>] ret_from_fork+0x1f/0x40
[ 9088.110001]  [<ffffffff8106e7b0>] ? kthread_worker_fn+0x150/0x150
[ 9088.110001] Code: 00 48 8b 8b a8 02 00 00 48 8b 93 a8 05 00 00 48 8d 
04 40 48 8d 0c 49 48 8d 04 82 48 8d 14 8a 48 39 d0 0f 83 7e 08 00 00 48 
89 de <44> 8b 48 04 c6 40 09 00 45 85 c9 74 2e f7 40 04 01 00 01 00 75


Compression wasn't turned on.

Marcin
