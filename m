From: Brad Campbell <brad-+nnirC7rrGZibQn6LdNjmg@public.gmane.org>
Subject: Re: New version up with fix for md and other block devices
Date: Tue, 29 Nov 2011 14:10:57 +0800
Message-ID: <4ED47771.9030309@fnarfbargle.com>
References: <20111121101402.GA17787@dhcp-172-18-216-138.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111121101402.GA17787-RcKxWJ4Cfj3IzGYXcIpNmNLIRw13R84JkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 21/11/11 18:14, Kent Overstreet wrote:
> I just pushed a new version, and it's only been lightly tested but
> assuming I haven't screwed anything up it should work on
> md/dm/rados/iscsi/etc. block devices.
>

Great stuff! A couple of nitpicks while I get things set up to run some 
tests..

Documentation/bcache.txt states :
<--------->
To register your bcache devices automatically, you could add something like
this to an init script:
   echo /dev/sd* > /sys/fs/bcache/register_quiet

It'll look for bcache superblocks and ignore everything that doesn't 
have one.
<--------->

However this never works for me. It bombs out on the first passed parameter

root@test:~/bin# echo /dev/sd* /dev/md* > /sys/fs/bcache/register_quiet
bash: echo: write error: Invalid argument

I need to use this :
for i in /dev/sd? /dev/md* ; do [ -n "`/sbin/probe-bcache $i`" ] && echo 
$i > /sys/fs/bcache/register_quiet ; done

Now, it does not actually need the test in there, however that stops it 
spewing "write error: Invalid argument" onto the console when you echo a 
device that does not have a bcache superblock.

It does NOT like you accidentally trying to register a device twice :

[   42.327890] ------------[ cut here ]------------
[   42.327994] WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0xb9/0xf0()
[   42.328042] Hardware name: To Be Filled By O.E.M.
[   42.328085] sysfs: cannot create duplicate filename 
'/devices/virtual/block/md10/bcache'
[   42.328132] Modules linked in: nfs ipt_MASQUERADE xt_tcpudp 
iptable_filter iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack 
nf_defrag_ipv4 ip_tables x_tables deflate zlib_deflate des_generic cbc 
ecb crypto_blkcipher sha1_generic md5 hmac crypto_hash cryptomgr aead 
crypto_algapi af_key fuse w83627ehf hwmon_vid netconsole configfs 
vhost_net powernow_k8 mperf kvm_amd kvm xhci_hcd k10temp i2c_piix4 
ohci_hcd ehci_hcd ahci usbcore libahci atl1c megaraid_sas [last 
unloaded: scsi_wait_scan]
[   42.329736] Pid: 3301, comm: bash Not tainted 3.1.0-g143cdea #1
[   42.329779] Call Trace:
[   42.329826]  [<ffffffff81034eeb>] ? warn_slowpath_common+0x7b/0xc0
[   42.329874]  [<ffffffff81034fe5>] ? warn_slowpath_fmt+0x45/0x50
[   42.329922]  [<ffffffff811210c9>] ? sysfs_add_one+0xb9/0xf0
[   42.329968]  [<ffffffff81121b69>] ? create_dir+0x79/0xe0
[   42.330048]  [<ffffffff81121c42>] ? sysfs_create_dir+0x72/0xb0
[   42.330099]  [<ffffffff811dc18f>] ? kobject_add_internal+0xaf/0x1e0
[   42.330149]  [<ffffffff811dc4c6>] ? kobject_add+0x46/0x70
[   42.330201]  [<ffffffff810995b0>] ? bdi_init+0x170/0x1c0
[   42.330247]  [<ffffffff811dbd3d>] ? kobject_init+0x2d/0xb0
[   42.330296]  [<ffffffff812a435d>] ? register_bcache+0x72d/0xac0
[   42.330344]  [<ffffffff81120222>] ? sysfs_write_file+0xd2/0x160
[   42.330391]  [<ffffffff810c7348>] ? vfs_write+0xc8/0x190
[   42.330436]  [<ffffffff810c750e>] ? sys_write+0x4e/0x90
[   42.330481]  [<ffffffff8140a87b>] ? system_call_fastpath+0x16/0x1b
[   42.330526] ---[ end trace 1183eef7ce845ca5 ]---
[   42.330573] kobject_add_internal failed for bcache with -EEXIST, 
don't try to register things with the same name in the same directory.
[   42.330628] Pid: 3301, comm: bash Tainted: G        W   3.1.0-g143cdea #1
[   42.330673] Call Trace:
[   42.330715]  [<ffffffff811dc22a>] ? kobject_add_internal+0x14a/0x1e0
[   42.330762]  [<ffffffff811dc4c6>] ? kobject_add+0x46/0x70
[   42.330808]  [<ffffffff810995b0>] ? bdi_init+0x170/0x1c0
[   42.330854]  [<ffffffff811dbd3d>] ? kobject_init+0x2d/0xb0
[   42.330901]  [<ffffffff812a435d>] ? register_bcache+0x72d/0xac0
[   42.330949]  [<ffffffff81120222>] ? sysfs_write_file+0xd2/0x160
[   42.330996]  [<ffffffff810c7348>] ? vfs_write+0xc8/0x190
[   42.331043]  [<ffffffff810c750e>] ? sys_write+0x4e/0x90
[   42.331093]  [<ffffffff8140a87b>] ? system_call_fastpath+0x16/0x1b
[   42.331153] bcache: Device md10 unregistered
[   47.909107] device vnet0 entered promiscuous mode
[   47.913482] br1: port 2(vnet0) entering forwarding state
[   47.913557] br1: port 2(vnet0) entering forwarding state
[   47.946957] br1: port 2(vnet0) entering forwarding state
[   47.947316] device vnet0 left promiscuous mode
[   47.947415] br1: port 2(vnet0) entering disabled state
[   48.174405] device vnet0 entered promiscuous mode
[   48.178681] br1: port 2(vnet0) entering forwarding state
[   48.178749] br1: port 2(vnet0) entering forwarding state
[   48.212849] br1: port 2(vnet0) entering forwarding state
[   48.213173] device vnet0 left promiscuous mode
[   48.213271] br1: port 2(vnet0) entering disabled state
[   48.910124] BUG: unable to handle kernel NULL pointer dereference at 
0000000000000018
[   48.910256] IP: [<ffffffff81041588>] get_next_timer_interrupt+0x138/0x250
[   48.910342] PGD 41df6d067 PUD 414205067 PMD 0
[   48.910482] Oops: 0000 [#1] SMP
[   48.910586] CPU 1
[   48.910622] Modules linked in: xt_state ipt_REJECT xt_CHECKSUM 
iptable_mangle nfs ipt_MASQUERADE xt_tcpudp iptable_filter iptable_nat 
nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables 
deflate zlib_deflate des_generic cbc ecb crypto_blkcipher sha1_generic 
md5 hmac crypto_hash cryptomgr aead crypto_algapi af_key fuse w83627ehf 
hwmon_vid netconsole configfs vhost_net powernow_k8 mperf kvm_amd kvm 
xhci_hcd k10temp i2c_piix4 ohci_hcd ehci_hcd ahci usbcore libahci atl1c 
megaraid_sas [last unloaded: scsi_wait_scan]
[   48.912398]
[   48.912438] Pid: 0, comm: kworker/0:0 Tainted: G        W 
3.1.0-g143cdea #1 To Be Filled By O.E.M. To Be Filled By O.E.M./890GX 
Extreme4 R2.0
[   48.912589] RIP: 0010:[<ffffffff81041588>]  [<ffffffff81041588>] 
get_next_timer_interrupt+0x138/0x250
[   48.912675] RSP: 0018:ffff88041dc9fe78  EFLAGS: 00010003
[   48.912717] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 
ffff88041dc99220
[   48.912762] RDX: 0000000000000001 RSI: 0000000000000020 RDI: 
ffff88041dc99020
[   48.912807] RBP: 00000000ffff9deb R08: 000000000000001e R09: 
0000000000ffff9e
[   48.912852] R10: ffff88041dc9fe90 R11: ffff88041dc9fea8 R12: 
ffff88041dc98000
[   48.912896] R13: 0000000000000040 R14: ffff88042fc4c480 R15: 
00000000ffff9deb
[   48.912942] FS:  00007f2a2b4f17e0(0000) GS:ffff88042fc40000(0000) 
knlGS:0000000000000000
[   48.912991] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   48.913033] CR2: 0000000000000018 CR3: 00000004142bd000 CR4: 
00000000000006e0
[   48.913078] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[   48.913121] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[   48.913167] Process kworker/0:0 (pid: 0, threadinfo ffff88041dc9e000, 
task ffff88041dc6be80)
[   48.913214] Stack:
[   48.913253]  0000000000000000 ffff88042fc4cbe0 ffff88041dc99020 
ffff88041dc99420
[   48.913427]  ffff88041dc99820 ffff88041dc99c20 ffff88042fc4cb00 
ffff88042fc4cbe0
[   48.913599]  0000000000000001 0000000000000286 0000000b6344e813 
ffffffff8105f371
[   48.913772] Call Trace:
[   48.913818]  [<ffffffff8105f371>] ? tick_nohz_stop_sched_tick+0x2d1/0x3d0
[   48.913867]  [<ffffffff8100167f>] ? cpu_idle+0x2f/0xc0
[   48.913909] Code: 00 00 48 89 44 24 28 45 89 c8 41 83 e0 3f 44 89 c6 
66 90 48 63 ce 48 c1 e1 04 48 8b 04 39 48 8d 0c 0f 48 39 c8 74 22 0f 1f 
40 00 <f6> 40 18 01 75 10 48 8b 50 10 48 39 da 48 0f 48 da ba 01 00 00
[   48.916028] RIP  [<ffffffff81041588>] 
get_next_timer_interrupt+0x138/0x250
[   48.916107]  RSP <ffff88041dc9fe78>
[   48.916146] CR2: 0000000000000018
[   48.916187] ---[ end trace 1183eef7ce845ca6 ]---
[   48.916229] Kernel panic - not syncing: Fatal exception
[   48.916273] Pid: 0, comm: kworker/0:0 Tainted: G      D W 
3.1.0-g143cdea #1
[   48.916318] Call Trace:
[   48.916368]  [<ffffffff81407679>] ? panic+0x92/0x193
[   48.916414]  [<ffffffff81035451>] ? kmsg_dump+0x41/0xf0
[   48.916461]  [<ffffffff8100504d>] ? oops_end+0x8d/0xa0
[   48.916507]  [<ffffffff81020c7b>] ? no_context+0xfb/0x260
[   48.916553]  [<ffffffff810214f9>] ? do_page_fault+0x2b9/0x430
[   48.916599]  [<ffffffff81031cda>] ? load_balance+0x8a/0x5b0
[   48.916644]  [<ffffffff8140a46f>] ? page_fault+0x1f/0x30
[   48.916690]  [<ffffffff81041588>] ? get_next_timer_interrupt+0x138/0x250
[   48.916736]  [<ffffffff8104148a>] ? get_next_timer_interrupt+0x3a/0x250
[   48.916783]  [<ffffffff8105f371>] ? tick_nohz_stop_sched_tick+0x2d1/0x3d0
[   48.916830]  [<ffffffff8100167f>] ? cpu_idle+0x2f/0xc0
[   48.916907] Rebooting in 10 seconds..

I had a bug in my init script that inadvertently registered /dev/md10 
twice. I had about a 6 second window to ssh into the machine and disable 
the init script as it just sat there in a boot/panic/reboot loop.

This happens immediately I try and attach a cache set to /dev/md10 :

[   73.287556] md: resync of RAID array md10
[   73.287614] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[   73.287620] ------------[ cut here ]------------
[   73.287628] kernel BUG at drivers/scsi/scsi_lib.c:1152!
[   73.287633] invalid opcode: 0000 [#1] SMP
[   73.287638] CPU 1
[   73.287641] Modules linked in: xt_state ipt_REJECT xt_CHECKSUM 
iptable_mangle nfs ipt_MASQUERADE xt_tcpudp iptable_filter iptable_nat 
nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables 
deflate zlib_deflate des_generic cbc ecb crypto_blkcipher sha1_generic 
md5 hmac crypto_hash cryptomgr aead crypto_algapi af_key fuse w83627ehf 
hwmon_vid netconsole configfs vhost_net powernow_k8 mperf kvm_amd kvm 
xhci_hcd k10temp i2c_piix4 ohci_hcd ehci_hcd usbcore ahci atl1c libahci 
megaraid_sas [last unloaded: scsi_wait_scan]
[   73.287694]
[   73.287700] Pid: 1428, comm: md10_raid10 Not tainted 3.1.0-g143cdea 
#1 To Be Filled By O.E.M. To Be Filled By O.E.M./890GX Extreme4 R2.0
[   73.287711] RIP: 0010:[<ffffffff812adbfe>]  [<ffffffff812adbfe>] 
scsi_setup_fs_cmnd+0xae/0xf0
[   73.287726] RSP: 0018:ffff88041bb73be0  EFLAGS: 00010046
[   73.287731] RAX: 0000000000000000 RBX: ffff88041ba5c560 RCX: 
0000000000001000
[   73.287736] RDX: 0000000000000000 RSI: ffff88041ba5c560 RDI: 
ffff88041bbf8000
[   73.287740] RBP: ffff88041bbf8000 R08: 0000000000000000 R09: 
0000000000000001
[   73.287745] R10: 4080000000000000 R11: dead000000100100 R12: 
ffff88041bbf8000
[   73.287750] R13: 0000000000000808 R14: ffff88041bbf8048 R15: 
ffff88041c029400
[   73.287756] FS:  00007fa5803717c0(0000) GS:ffff88042fc40000(0000) 
knlGS:0000000000000000
[   73.287761] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   73.287766] CR2: 0000000001b7c1b8 CR3: 0000000418a24000 CR4: 
00000000000006e0
[   73.287770] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[   73.287774] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[   73.287780] Process md10_raid10 (pid: 1428, threadinfo 
ffff88041bb72000, task ffff88041c760640)
[   73.287784] Stack:
[   73.287787]  0000000000000000 ffff88041ba5c560 ffff88041c603c30 
ffffffff812b86fc
[   73.287794]  01ff88041bbf8800 ffff880400000001 ffff880400001000 
0000000000000000
[   73.287800]  ffff88041ba5c560 ffff88041ba5c560 ffff88041ba5c560 
ffff88041c603c30
[   73.287807] Call Trace:
[   73.287816]  [<ffffffff812b86fc>] ? sd_prep_fn+0x15c/0xa50
[   73.287825]  [<ffffffff811c8be4>] ? blk_peek_request+0xb4/0x1d0
[   73.287832]  [<ffffffff812ad120>] ? scsi_request_fn+0x50/0x4a0
[   73.287840]  [<ffffffff811c9598>] ? blk_flush_plug_list+0x188/0x210
[   73.287847]  [<ffffffff811c962b>] ? blk_finish_plug+0xb/0x30
[   73.287854]  [<ffffffff812fae78>] ? raid10d+0x908/0xb50
[   73.287862]  [<ffffffff81041183>] ? lock_timer_base+0x33/0x70
[   73.287870]  [<ffffffff814089c5>] ? schedule_timeout+0x1c5/0x230
[   73.287878]  [<ffffffff8130ec8f>] ? md_thread+0x10f/0x140
[   73.287886]  [<ffffffff81050240>] ? wake_up_bit+0x40/0x40
[   73.287892]  [<ffffffff8130eb80>] ? md_register_thread+0x100/0x100
[   73.287898]  [<ffffffff8130eb80>] ? md_register_thread+0x100/0x100
[   73.287905]  [<ffffffff8104fde6>] ? kthread+0x96/0xa0
[   73.287912]  [<ffffffff8140bbf4>] ? kernel_thread_helper+0x4/0x10
[   73.287920]  [<ffffffff8104fd50>] ? kthread_worker_fn+0x120/0x120
[   73.287926]  [<ffffffff8140bbf0>] ? gs_change+0xb/0xb
[   73.287929] Code: 80 00 00 00 00 48 83 c4 08 5b 5d c3 90 48 89 ef be 
20 00 00 00 e8 73 a2 ff ff 48 85 c0 48 89 c7 74 d7 48 89 83 d8 00 00 00 
eb 8d <0f> 0b eb fe 48 8b 00 48 85 c0 0f 84 67 ff ff ff 48 8b 40 50 48
[   73.287969] RIP  [<ffffffff812adbfe>] scsi_setup_fs_cmnd+0xae/0xf0
[   73.287977]  RSP <ffff88041bb73be0>
[   73.287982] ---[ end trace 4ce4e575167cc0ff ]---
[   73.287986] Kernel panic - not syncing: Fatal exception
[   73.287993] Pid: 1428, comm: md10_raid10 Tainted: G      D 
3.1.0-g143cdea #1
[   73.287998] Call Trace:
[   73.288005]  [<ffffffff81407679>] ? panic+0x92/0x193
[   73.288012]  [<ffffffff81035451>] ? kmsg_dump+0x41/0xf0
[   73.288021]  [<ffffffff8100504d>] ? oops_end+0x8d/0xa0
[   73.288028]  [<ffffffff81002e34>] ? do_invalid_op+0x84/0xa0
[   73.288035]  [<ffffffff812adbfe>] ? scsi_setup_fs_cmnd+0xae/0xf0
[   73.288044]  [<ffffffff811d698e>] ? cfq_set_request+0x15e/0x3b0
[   73.288050]  [<ffffffff8140ba75>] ? invalid_op+0x15/0x20
[   73.288058]  [<ffffffff812adbfe>] ? scsi_setup_fs_cmnd+0xae/0xf0
[   73.288064]  [<ffffffff812b86fc>] ? sd_prep_fn+0x15c/0xa50
[   73.288071]  [<ffffffff811c8be4>] ? blk_peek_request+0xb4/0x1d0
[   73.288078]  [<ffffffff812ad120>] ? scsi_request_fn+0x50/0x4a0
[   73.288085]  [<ffffffff811c9598>] ? blk_flush_plug_list+0x188/0x210
[   73.288092]  [<ffffffff811c962b>] ? blk_finish_plug+0xb/0x30
[   73.288098]  [<ffffffff812fae78>] ? raid10d+0x908/0xb50
[   73.288104]  [<ffffffff81041183>] ? lock_timer_base+0x33/0x70
[   73.288112]  [<ffffffff814089c5>] ? schedule_timeout+0x1c5/0x230
[   73.288119]  [<ffffffff8130ec8f>] ? md_thread+0x10f/0x140
[   73.288126]  [<ffffffff81050240>] ? wake_up_bit+0x40/0x40
[   73.288132]  [<ffffffff8130eb80>] ? md_register_thread+0x100/0x100
[   73.288138]  [<ffffffff8130eb80>] ? md_register_thread+0x100/0x100
[   73.288144]  [<ffffffff8104fde6>] ? kthread+0x96/0xa0
[   73.288151]  [<ffffffff8140bbf4>] ? kernel_thread_helper+0x4/0x10
[   73.288159]  [<ffffffff8104fd50>] ? kthread_worker_fn+0x120/0x120
[   73.288165]  [<ffffffff8140bbf0>] ? gs_change+0xb/0xb
[   73.290590] Rebooting in 10 seconds..

I can attach the same cache set to /dev/sde and all is ok (the same 
config I used to run the last set of benchmarks).

Regards,
Brad
