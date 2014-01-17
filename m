From: Jose Manuel dos Santos Calhariz <jose.calhariz@tecnico.ulisboa.pt>
Subject: kernel BUG at drivers/md/bcache/btree.c:1168
Date: Fri, 17 Jan 2014 12:34:17 +0000
Message-ID: <52D92349.9040709@tecnico.ulisboa.pt>
Reply-To: jose.calhariz@tecnico.ulisboa.pt
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from smtp2.ist.utl.pt ([193.136.128.22]:59995 "EHLO smtp2.ist.utl.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbaAQMnP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 17 Jan 2014 07:43:15 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: "ns-list@dsi.ist.utl.pt" <ns-list@dsi.ist.utl.pt>


Hi, is the second time I get this BUG.

The first was during boot from an old 3.13.0-rc2 to a 3.13.0-rc7. The=20
second time was when running tests.

=46ollow the two stack trace:

Jan 14 17:33:59 xxxxx kernel: ------------[ cut here ]------------
Jan 14 17:33:59 xxxxx kernel: kernel BUG at drivers/md/bcache/btree.c:1=
168!
Jan 14 17:33:59 xxxxx kernel: invalid opcode: 0000 [#1] SMP
Jan 14 17:33:59 xxxxx kernel: Modules linked in: lp parport_pc parport=20
joydev st sr_mod cdrom xt_multiport iptable_filter ip_tables x_tables=20
xfs libcrc32c ipmi_devintf loop snd_pcm mgag200 snd_page_alloc snd_time=
r=20
ttm x86_pkg_temp_thermal drm_kms_helper drm snd i2c_algo_bit coretemp=20
soundcore kvm_intel kvm
+crc32c_intel ghash_clmulni_intel ioatdma aesni_intel aes_x86_64=20
iTCO_wdt sb_edac iTCO_vendor_support mei_me mei ablk_helper edac_core=20
cryptd psmouse i2c_i801 lpc_ich serio_raw i2c_core pcspkr lrw mfd_core=20
gf128mul ipmi_si ipmi_msghandler glue_helper evdev processor wmi=20
thermal_sys button ext3 mbcache jbd dm_mod
+raid1 md_mod hid_generic usbhid hid bcache sg sd_mod ses crc_t10dif=20
enclosure crct10dif_common microcode ahci libahci libata ehci_pci=20
ehci_hcd mpt2sas raid_class usbcore megaraid_sas scsi_transport_sas=20
usb_common scsi_mod ixgbe dca ptp pps_core mdio [last unloaded: parport=
_pc]
Jan 14 17:33:59 xxxxx kernel: CPU: 6 PID: 700 Comm: bcache_gc Not=20
tainted 3.13.0-rc7-dsi #3
Jan 14 17:33:59 xxxxx kernel: Hardware name: Supermicro=20
X9SRH-7F/7TF/X9SRH-7F/7TF, BIOS 3.00 07/05/2013
Jan 14 17:33:59 xxxxx kernel: task: ffff88101371a050 ti:=20
ffff88100ea56000 task.ti: ffff88100ea56000
Jan 14 17:33:59 xxxxx kernel: RIP: 0010:[<ffffffffa01ce41e>]=20
[<ffffffffa01ce41e>] __bch_btree_mark_key+0x171/0x1a8 [bcache]
Jan 14 17:33:59 xxxxx kernel: RSP: 0018:ffff88100ea57cb8  EFLAGS: 00010=
246
Jan 14 17:33:59 xxxxx kernel: RAX: 0000000000000002 RBX:=20
ffff880fab8001e8 RCX: 0000000000002000
Jan 14 17:33:59 xxxxx kernel: RDX: 0000000000000002 RSI:=20
ffff880fab8001e8 RDI: ffff881028d60000
Jan 14 17:33:59 xxxxx kernel: RBP: 0000000000000000 R08:=20
0000000000000001 R09: ffff88101003c000
Jan 14 17:33:59 xxxxx kernel: R10: 0000000000001000 R11:=20
ffff880fce594400 R12: 0000000000000000
Jan 14 17:33:59 xxxxx kernel: R13: ffff881028d60000 R14:=20
0000000000000001 R15: ffffc90016d93678
Jan 14 17:33:59 xxxxx kernel: FS:  0000000000000000(0000)=20
GS:ffff88107fcc0000(0000) knlGS:0000000000000000
Jan 14 17:33:59 xxxxx kernel: CS:  0010 DS: 0000 ES: 0000 CR0:=20
0000000080050033
Jan 14 17:33:59 xxxxx kernel: CR2: 00007fe31614ccf8 CR3:=20
000000000160c000 CR4: 00000000000407e0
Jan 14 17:33:59 xxxxx kernel: Stack:
Jan 14 17:33:59 xxxxx kernel: ffff880fab8001e8 0000000188a000fb=20
ffff880fce594400 ffff880fce594400
Jan 14 17:33:59 xxxxx kernel: ffff880fab8001e8 0000000000000013=20
0000000000000001 ffff88100ea57dc8
Jan 14 17:33:59 xxxxx kernel: ffff88100ea57d18 ffffffffa01ce72a=20
ffff88101371a050 0000000200000000
Jan 14 17:33:59 xxxxx kernel: Call Trace:
Jan 14 17:33:59 xxxxx kernel: [<ffffffffa01ce72a>] ?=20
btree_gc_mark_node+0x4c/0x16d [bcache]
Jan 14 17:33:59 xxxxx kernel: [<ffffffff811e8e63>] ?=20
call_rwsem_down_write_failed+0x13/0x20
Jan 14 17:33:59 xxxxx kernel: [<ffffffffa01d005e>] ?=20
bch_btree_gc+0x187/0x3a7 [bcache]
Jan 14 17:33:59 xxxxx kernel: [<ffffffff8106ffde>] ?=20
idle_balance+0x12b/0x166
Jan 14 17:33:59 xxxxx kernel: [<ffffffff81066b18>] ? mmdrop+0xd/0x1c
Jan 14 17:33:59 xxxxx kernel: [<ffffffffa01d02ab>] ?=20
bch_gc_thread+0x2d/0xe5 [bcache]
Jan 14 17:33:59 xxxxx kernel: [<ffffffffa01d027e>] ?=20
bch_btree_gc+0x3a7/0x3a7 [bcache]
Jan 14 17:33:59 xxxxx kernel: [<ffffffffa01d027e>] ?=20
bch_btree_gc+0x3a7/0x3a7 [bcache]
Jan 14 17:33:59 xxxxx kernel: [<ffffffff8105f77a>] ? kthread+0x99/0xa1
Jan 14 17:33:59 xxxxx kernel: [<ffffffff8105f6e1>] ?=20
__kthread_parkme+0x59/0x59
Jan 14 17:33:59 xxxxx kernel: [<ffffffff813b58cc>] ? ret_from_fork+0x7c=
/0xb0
Jan 14 17:33:59 xxxxx kernel: [<ffffffff8105f6e1>] ?=20
__kthread_parkme+0x59/0x59
Jan 14 17:33:59 xxxxx kernel: Code: 00 01 c1 b8 ff 3f 00 00 81 f9 ff 3f=
=20
00 00 0f 46 c1 66 81 e2 03 80 25 ff 1f 00 00 c1 e0 02 09 d0 66 a9 fc 7f=
=20
66 41 89 47 0a 75 02 <0f> 0b ff c5 eb 05 31 ed 45 31 e4 48 8b 03 89 ea=20
48 c1 e8 3c 83
Jan 14 17:33:59 xxxxx kernel: RIP  [<ffffffffa01ce41e>]=20
__bch_btree_mark_key+0x171/0x1a8 [bcache]
Jan 14 17:33:59 xxxxx kernel: RSP <ffff88100ea57cb8>
Jan 14 17:33:59 xxxxx kernel: ---[ end trace 6a29ce0fa7816b54 ]---


Jan 16 12:16:00 xxxxx kernel: ------------[ cut here ]------------
Jan 16 12:16:00 xxxxx kernel: kernel BUG at drivers/md/bcache/btree.c:1=
168!
Jan 16 12:16:00 xxxxx kernel: invalid opcode: 0000 [#1] SMP
Jan 16 12:16:00 xxxxx kernel: Modules linked in: lp parport_pc parport=20
joydev st sr_mod cdrom xt_multiport iptable_filter ip_tables x_tables=20
xfs libcrc32c ipmi_devintf loop iTCO_wdt x86_pkg_temp_thermal coretemp=20
kvm_intel kvm sb_edac iTCO_vendor_support mgag200 ioatdma snd_pcm=20
snd_page_alloc snd_timer snd i2c_i801
+ttm soundcore crc32c_intel ghash_clmulni_intel aesni_intel lpc_ich=20
aes_x86_64 drm_kms_helper drm i2c_algo_bit i2c_core mfd_core ablk_helpe=
r=20
cryptd lrw gf128mul mei_me mei glue_helper psmouse edac_core serio_raw=20
pcspkr evdev wmi ipmi_si ipmi_msghandler processor thermal_sys button=20
ext3 mbcache jbd dm_mod raid1
+md_mod hid_generic usbhid hid bcache sg sd_mod ses crc_t10dif enclosur=
e=20
crct10dif_common microcode ehci_pci ehci_hcd usbcore ahci mpt2sas=20
libahci usb_common raid_class libata scsi_transport_sas megaraid_sas=20
ixgbe scsi_mod dca ptp pps_core mdio [last unloaded: parport_pc]
Jan 16 12:16:00 xxxxx kernel: CPU: 8 PID: 707 Comm: bcache_gc Not=20
tainted 3.13.0-rc7-dsi #3
Jan 16 12:16:00 xxxxx kernel: Hardware name: Supermicro=20
X9SRH-7F/7TF/X9SRH-7F/7TF, BIOS 3.00 07/05/2013
Jan 16 12:16:00 xxxxx kernel: task: ffff88102c30f800 ti:=20
ffff88100e44c000 task.ti: ffff88100e44c000
Jan 16 12:16:00 xxxxx kernel: RIP: 0010:[<ffffffffa01f341e>]=20
[<ffffffffa01f341e>] __bch_btree_mark_key+0x171/0x1a8 [bcache]
Jan 16 12:16:00 xxxxx kernel: RSP: 0018:ffff88100e44da78  EFLAGS: 00010=
246
Jan 16 12:16:00 xxxxx kernel: RAX: 0000000000000000 RBX:=20
ffff880fed4037b8 RCX: 0000000000002000
Jan 16 12:16:00 xxxxx kernel: RDX: 0000000000000000 RSI:=20
ffff880fed4037b8 RDI: ffff881028ce0000
Jan 16 12:16:00 xxxxx kernel: RBP: 0000000000000000 R08:=20
0000000000000001 R09: ffff8810109ea000
Jan 16 12:16:00 xxxxx kernel: R10: 0000000000001000 R11:=20
ffff880fee906400 R12: 0000000000000000
Jan 16 12:16:00 xxxxx kernel: R13: ffff881028ce0000 R14:=20
0000000000000000 R15: ffffc900168dc660
Jan 16 12:16:00 xxxxx kernel: FS:  0000000000000000(0000)=20
GS:ffff88107fd00000(0000) knlGS:0000000000000000
Jan 16 12:16:00 xxxxx kernel: CS:  0010 DS: 0000 ES: 0000 CR0:=20
0000000080050033
Jan 16 12:16:00 xxxxx kernel: CR2: 0000000000619570 CR3:=20
000000000160c000 CR4: 00000000000407e0
Jan 16 12:16:00 xxxxx kernel: Stack:
Jan 16 12:16:00 xxxxx kernel: ffff88100e44dad8 0000000108801efc=20
ffffffffa01f0c31 ffff880fee906400
Jan 16 12:16:00 xxxxx kernel: ffff880fed4037b8 0000000000000251=20
0000000000000000 ffff88100e44ddc8
Jan 16 12:16:00 xxxxx kernel: ffff88100e44dad8 ffffffffa01f372a=20
ffffffffa01f5bb1 00000251b5f80000
Jan 16 12:16:00 xxxxx kernel: Call Trace:
Jan 16 12:16:00 xxxxx kernel: [<ffffffffa01f0c31>] ?=20
bch_cut_back+0x41/0x41 [bcache]
Jan 16 12:16:00 xxxxx kernel: [<ffffffffa01f372a>] ?=20
btree_gc_mark_node+0x4c/0x16d [bcache]
Jan 16 12:16:00 xxxxx kernel: [<ffffffffa01f5bb1>] ?=20
tree_to_bkey+0x13/0x3c [bcache]
Jan 16 12:16:00 xxxxx kernel: [<ffffffffa01f64b8>] ?=20
bch_ptr_invalid+0x1a/0x1a [bcache]
Jan 16 12:16:00 xxxxx kernel: [<ffffffffa01f4cbf>] ?=20
btree_gc_recurse+0x677/0x88f [bcache]
Jan 16 12:16:00 xxxxx kernel: [<ffffffffa01f6398>] ?=20
bch_btree_ptr_invalid+0x46/0xb0 [bcache]
Jan 16 12:16:00 xxxxx kernel: [<ffffffff813ae20a>] ? __schedule+0x48f/0=
x555
Jan 16 12:16:00 xxxxx kernel: [<ffffffff810680ad>] ? resched_task+0x15/=
0x4b
Jan 16 12:16:00 xxxxx kernel: [<ffffffffa01f7ab0>] ?=20
bch_btree_iter_next_filter+0x18/0x38 [bcache]
Jan 16 12:16:00 xxxxx kernel: [<ffffffffa01f379c>] ?=20
btree_gc_mark_node+0xbe/0x16d [bcache]
Jan 16 12:16:00 xxxxx kernel: [<ffffffff811e8e63>] ?=20
call_rwsem_down_write_failed+0x13/0x20
Jan 16 12:16:00 xxxxx kernel: [<ffffffffa01f50df>] ?=20
bch_btree_gc+0x208/0x3a7 [bcache]
Jan 16 12:16:00 xxxxx kernel: [<ffffffff8106ffde>] ?=20
idle_balance+0x12b/0x166
Jan 16 12:16:00 xxxxx kernel: [<ffffffff81066b18>] ? mmdrop+0xd/0x1c
Jan 16 12:16:00 xxxxx kernel: [<ffffffffa01f52ab>] ?=20
bch_gc_thread+0x2d/0xe5 [bcache]
Jan 16 12:16:00 xxxxx kernel: [<ffffffffa01f527e>] ?=20
bch_btree_gc+0x3a7/0x3a7 [bcache]
Jan 16 12:16:00 xxxxx kernel: [<ffffffffa01f527e>] ?=20
bch_btree_gc+0x3a7/0x3a7 [bcache]
Jan 16 12:16:00 xxxxx kernel: [<ffffffff8105f77a>] ? kthread+0x99/0xa1
Jan 16 12:16:00 xxxxx kernel: [<ffffffff8105f6e1>] ?=20
__kthread_parkme+0x59/0x59
Jan 16 12:16:00 xxxxx kernel: [<ffffffff813b58cc>] ? ret_from_fork+0x7c=
/0xb0
Jan 16 12:16:00 xxxxx kernel: [<ffffffff8105f6e1>] ?=20
__kthread_parkme+0x59/0x59
Jan 16 12:16:00 xxxxx kernel: Code: 00 01 c1 b8 ff 3f 00 00 81 f9 ff 3f=
=20
00 00 0f 46 c1 66 81 e2 03 80 25 ff 1f 00 00 c1 e0 02 09 d0 66 a9 fc 7f=
=20
66 41 89 47 0a 75 02 <0f> 0b ff c5 eb 05 31 ed 45 31 e4 48 8b 03 89 ea=20
48 c1 e8 3c 83
Jan 16 12:16:00 xxxxx kernel: RIP  [<ffffffffa01f341e>]=20
__bch_btree_mark_key+0x171/0x1a8 [bcache]
Jan 16 12:16:00 xxxxx kernel: RSP <ffff88100e44da78>
Jan 16 12:16:00 xxxxx kernel: ---[ end trace 14e7f7c11d82ef2f ]---





--=20
--
Um rep=C3=B3rter de rock =C3=A9 um jornalista que n=C3=A3o sabe escreve=
r, entrevistando gente
que n=C3=A3o sabe falar, para pessoas que n=C3=A3o sabem ler.
