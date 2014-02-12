From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [NS] kernel BUG at drivers/md/bcache/btree.c:1168
Date: Tue, 11 Feb 2014 18:06:32 -0800
Message-ID: <20140212020632.GA30642@birch.djwong.org>
References: <CALJ65zm0n=Dnk_w91r5PfHR62rp=LRHndNt1kA46_qXcACQ3PA@mail.gmail.com>
 <4c6d-52fa2700-1-11857a40@208368243>
 <CAN6-qxbZ7k=G=vtmf-uwDPKPq1p67x-XVME6YUnnHCK13ZGrPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41801 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaBLCGu (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 11 Feb 2014 21:06:50 -0500
Content-Disposition: inline
In-Reply-To: <CAN6-qxbZ7k=G=vtmf-uwDPKPq1p67x-XVME6YUnnHCK13ZGrPA@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Ryan Tucker <rtucker@gmail.com>
Cc: Vladimir Elisseev <vovan@vovan.nl>, Kent Overstreet <kmo@daterainc.com>, ns-list@dsi.ist.utl.pt, =?iso-8859-1?Q?Jo=E3o?= Trindade <trindade.joao@gmail.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, jose.calhariz@tecnico.ulisboa.pt

On Tue, Feb 11, 2014 at 09:42:43AM -0500, Ryan Tucker wrote:
> I believe this is the commit:
>=20
> http://evilpiepirate.org/git/linux-bcache.git/commit/?h=3Dbcache-for-=
3.14&id=3D947174476701fbc84ea8c7ec9664270f9d80b076
>=20
> I had the crash twice in as many days after moving to 3.13.x.  I
> cherry-picked that commit onto kernel v3.13.2 last night and have not=
 had a
> crash in 0.59 days.  :-)

Yes, that's the one I've sent.  Been running bcache crash-free since I =
stuck in
that patch.

--D
>=20
>=20
>=20
> On Tue, Feb 11, 2014 at 8:35 AM, Vladimir Elisseev <vovan@vovan.nl> w=
rote:
>=20
> > Where can I find the actual patch? I see the same bug on the system=
 with
> > plain btrfs on bcache device.
> >
> > Regards,
> > Vlad.
> >
> > On Friday, February 7, 2014 22:10 CET, Kent Overstreet <kmo@daterai=
nc.com>
> > wrote:
> >
> > > I sent off the pull request - after it hits mainline I'll make su=
re it
> > > goes into 3.13.x
> > >
> > > On Fri, Feb 7, 2014 at 12:44 PM, Jose Manuel dos Santos Calhariz
> > > <jose.calhariz@tecnico.ulisboa.pt> wrote:
> > > > On 29-01-2014 00:54, Darrick J. Wong wrote:
> > > >>
> > > >> [adding Mr. Trinidade because he seems to have the same proble=
m]
> > > >>
> > > >> I /think/ I have a patch to fix this bug -- the clamp on
> > > >> SET_GC_SECTORS_USED in
> > > >> the line before the BUG_ON seems partially ineffectual.  I'm a=
bout to
> > send
> > > >> everyone a patch; can you put that into a kernel and test it o=
ut?
> > > >>
> > > >> The "easiest" way I've found to reproduce this bug is to creat=
e a
> > bcache,
> > > >> mkfs.ext4 it, run fsstress on the ext4 FS until the cache is f=
ull,
> > then
> > > >> umount
> > > >> and re-run mkfs.ext4, which discards the device before formatt=
ing.
> > > >> Eventually
> > > >> it'll BUG().
> > > >
> > > > It's to tell that your fix works for me. It's possible to push =
your
> > fix into
> > > > kernel 3.13.x?
> > > >
> > > >      Jose Calhariz
> > > >
> > > >>
> > > >> --D
> > > >>
> > > >> On Fri, Jan 24, 2014 at 10:28:03PM -0800, Darrick J. Wong wrot=
e:
> > > >>>
> > > >>> On Fri, Jan 17, 2014 at 12:34:17PM +0000, Jose Manuel dos San=
tos
> > Calhariz
> > > >>> wrote:
> > > >>>>
> > > >>>> Hi, is the second time I get this BUG.
> > > >>>>
> > > >>>> The first was during boot from an old 3.13.0-rc2 to a 3.13.0=
-rc7.
> > > >>>> The second time was when running tests.
> > > >>>
> > > >>> Yeah, I also saw this tonight on 3.13.  Running on ext4 -> LV=
M ->
> > LUKS ->
> > > >>> bcache -> ssd/disk.
> > > >>>
> > > >>> [81881.815077] ------------[ cut here ]------------
> > > >>> [81881.815108] kernel BUG at drivers/md/bcache/btree.c:1168!
> > > >>> [81881.815123] invalid opcode: 0000 [#1] PREEMPT SMP
> > > >>> [81881.815140] Modules linked in: hfsplus hfs msdos ipt_MASQU=
ERADE
> > > >>> iptable_nat nf_nat_ipv4 xt_conntrack xt_CHECKSUM iptable_mang=
le tun
> > bridge
> > > >>> stp llc fuse af_packet microcode bnep rfcomm nfsd nfs_acl exp=
ortfs
> > > >>> auth_rpcgss nfs lockd sunrpc xt_physdev xt_hl uvcvideo ip6t_r=
t
> > > >>> videobuf2_core videodev nf_conntrack_ipv6 nf_defrag_ipv6
> > videobuf2_vmalloc
> > > >>> videobuf2_memops ipt_REJECT xt_sctp xt_limit xt_tcpudp xt_add=
rtype
> > > >>> nf_conntrack_ipv4 nf_defrag_ipv4 xt_state ip6table_filter ip6=
_tables
> > > >>> nf_conntrack_netbios_ns nf_conntrack_broadcast nf_nat_ftp nf_=
nat
> > > >>> nf_conntrack_ftp nf_conntrack iptable_filter ip_tables x_tabl=
es
> > eeprom
> > > >>> sch_fq_codel nls_iso8859_1 nls_cp437 vfat fat lpc_ich mfd_cor=
e loop
> > bcache
> > > >>> zlib_deflate libcrc32c
> > > >>> [81881.815346] CPU: 2 PID: 1418 Comm: bcache_gc Not tainted
> > > >>> 3.13.0-60-birch #1
> > > >>> [81881.815365] Hardware name: LENOVO 2349E51/2349E51, BIOS G1=
ET69WW
> > (2.05
> > > >>> ) 09/12/2012
> > > >>> [81881.815385] task: ffff880402038000 ti: ffff8804043c6000 ta=
sk.ti:
> > > >>> ffff8804043c6000
> > > >>> [81881.815405] RIP: 0010:[<ffffffffa0017a01>]  [<ffffffffa001=
7a01>]
> > > >>> __bch_btree_mark_key+0x251/0x290 [bcache]
> > > >>> [81881.815438] RSP: 0018:ffff8804043c7c78  EFLAGS: 00010246
> > > >>> [81881.815453] RAX: 0000000000000002 RBX: ffffc90004397dac RC=
X:
> > > >>> 0000000000000200
> > > >>> [81881.815471] RDX: 0000000000000002 RSI: 0000000000000001 RD=
I:
> > > >>> ffffc90004397dac
> > > >>> [81881.815490] RBP: ffff8804043c7cc8 R08: 000007ffffffffff R0=
9:
> > > >>> 0000000000000001
> > > >>> [81881.815509] R10: 0000000000003fff R11: 0000001000000000 R1=
2:
> > > >>> 0000000000000000
> > > >>> [81881.815527] R13: ffff8800532002c0 R14: ffff8804017a0000 R1=
5:
> > > >>> 0000000000000000
> > > >>> [81881.815546] FS:  0000000000000000(0000) GS:ffff88041e30000=
0(0000)
> > > >>> knlGS:0000000000000000
> > > >>> [81881.815568] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050=
033
> > > >>> [81881.815583] CR2: 00007f467f76b000 CR3: 0000000001c0c000 CR=
4:
> > > >>> 00000000001407e0
> > > >>> [81881.815602] Stack:
> > > >>> [81881.815609]  ffff8804043c7ce8 ffff880408fb2000 ffff8804043=
c7c98
> > > >>> ffffffffa0014be5
> > > >>> [81881.815632]  ffff8804043c7cc8 ffff880408fb2000 ffff8804043=
c7de0
> > > >>> ffff8800532002c0
> > > >>> [81881.815653]  0000000000000000 000000000000001c ffff8804043=
c7d68
> > > >>> ffffffffa0017e41
> > > >>> [81881.815675] Call Trace:
> > > >>> [81881.815690]  [<ffffffffa0014be5>] ? bch_ptr_invalid+0x25/0=
x30
> > [bcache]
> > > >>> [81881.815713]  [<ffffffffa0017e41>] btree_gc_mark_node+0x81/=
0x210
> > > >>> [bcache]
> > > >>> [81881.815736]  [<ffffffffa001a2e2>] bch_btree_gc+0x252/0x5d0
> > [bcache]
> > > >>> [81881.815759]  [<ffffffffa001a698>] bch_gc_thread+0x38/0x120
> > [bcache]
> > > >>> [81881.815781]  [<ffffffffa001a660>] ? bch_btree_gc+0x5d0/0x5=
d0
> > [bcache]
> > > >>> [81881.815801]  [<ffffffff810e4b79>] kthread+0xc9/0xe0
> > > >>> [81881.815816]  [<ffffffff810e4ab0>] ? flush_kthread_worker+0=
xb0/0xb0
> > > >>> [81881.815835]  [<ffffffff817f63ec>] ret_from_fork+0x7c/0xb0
> > > >>> [81881.815851]  [<ffffffff810e4ab0>] ? flush_kthread_worker+0=
xb0/0xb0
> > > >>> [81881.815868] Code: c8 44 89 55 b8 4c 89 5d b0 e8 5c 21 01 0=
0 4c 8b
> > 45
> > > >>> c0 84 c0 44 8b 4d c8 44 8b 55 b8 4c 8b 5d b0 75 13 0f b7 43 0=
a e9 28
> > ff ff
> > > >>> ff <0f> 0b 48 89 df e9 ec fe ff ff 4c 89 45 c0 44 89 4d c8 44=
 89 55
> > > >>> [81881.815956] RIP  [<ffffffffa0017a01>]
> > __bch_btree_mark_key+0x251/0x290
> > > >>> [bcache]
> > > >>> [81881.815982]  RSP <ffff8804043c7c78>
> > > >>> [81881.820218] ---[ end trace f9ade3bfa4c277bf ]---
> > > >>>
> > > >>> --D
> > > >>>>
> > > >>>> Follow the two stack trace:
> > > >>>>
> > > >>>> Jan 14 17:33:59 xxxxx kernel: ------------[ cut here ]------=
------
> > > >>>> Jan 14 17:33:59 xxxxx kernel: kernel BUG at
> > > >>>> drivers/md/bcache/btree.c:1168!
> > > >>>> Jan 14 17:33:59 xxxxx kernel: invalid opcode: 0000 [#1] SMP
> > > >>>> Jan 14 17:33:59 xxxxx kernel: Modules linked in: lp parport_=
pc
> > > >>>> parport joydev st sr_mod cdrom xt_multiport iptable_filter i=
p_tables
> > > >>>> x_tables xfs libcrc32c ipmi_devintf loop snd_pcm mgag200
> > > >>>> snd_page_alloc snd_timer ttm x86_pkg_temp_thermal drm_kms_he=
lper drm
> > > >>>> snd i2c_algo_bit coretemp soundcore kvm_intel kvm
> > > >>>> +crc32c_intel ghash_clmulni_intel ioatdma aesni_intel aes_x8=
6_64
> > > >>>> iTCO_wdt sb_edac iTCO_vendor_support mei_me mei ablk_helper
> > > >>>> edac_core cryptd psmouse i2c_i801 lpc_ich serio_raw i2c_core=
 pcspkr
> > > >>>> lrw mfd_core gf128mul ipmi_si ipmi_msghandler glue_helper ev=
dev
> > > >>>> processor wmi thermal_sys button ext3 mbcache jbd dm_mod
> > > >>>> +raid1 md_mod hid_generic usbhid hid bcache sg sd_mod ses cr=
c_t10dif
> > > >>>> enclosure crct10dif_common microcode ahci libahci libata ehc=
i_pci
> > > >>>> ehci_hcd mpt2sas raid_class usbcore megaraid_sas scsi_transp=
ort_sas
> > > >>>> usb_common scsi_mod ixgbe dca ptp pps_core mdio [last unload=
ed:
> > > >>>> parport_pc]
> > > >>>> Jan 14 17:33:59 xxxxx kernel: CPU: 6 PID: 700 Comm: bcache_g=
c Not
> > > >>>> tainted 3.13.0-rc7-dsi #3
> > > >>>> Jan 14 17:33:59 xxxxx kernel: Hardware name: Supermicro
> > > >>>> X9SRH-7F/7TF/X9SRH-7F/7TF, BIOS 3.00 07/05/2013
> > > >>>> Jan 14 17:33:59 xxxxx kernel: task: ffff88101371a050 ti:
> > > >>>> ffff88100ea56000 task.ti: ffff88100ea56000
> > > >>>> Jan 14 17:33:59 xxxxx kernel: RIP: 0010:[<ffffffffa01ce41e>]
> > > >>>> [<ffffffffa01ce41e>] __bch_btree_mark_key+0x171/0x1a8 [bcach=
e]
> > > >>>> Jan 14 17:33:59 xxxxx kernel: RSP: 0018:ffff88100ea57cb8  EF=
LAGS:
> > > >>>> 00010246
> > > >>>> Jan 14 17:33:59 xxxxx kernel: RAX: 0000000000000002 RBX:
> > > >>>> ffff880fab8001e8 RCX: 0000000000002000
> > > >>>> Jan 14 17:33:59 xxxxx kernel: RDX: 0000000000000002 RSI:
> > > >>>> ffff880fab8001e8 RDI: ffff881028d60000
> > > >>>> Jan 14 17:33:59 xxxxx kernel: RBP: 0000000000000000 R08:
> > > >>>> 0000000000000001 R09: ffff88101003c000
> > > >>>> Jan 14 17:33:59 xxxxx kernel: R10: 0000000000001000 R11:
> > > >>>> ffff880fce594400 R12: 0000000000000000
> > > >>>> Jan 14 17:33:59 xxxxx kernel: R13: ffff881028d60000 R14:
> > > >>>> 0000000000000001 R15: ffffc90016d93678
> > > >>>> Jan 14 17:33:59 xxxxx kernel: FS:  0000000000000000(0000)
> > > >>>> GS:ffff88107fcc0000(0000) knlGS:0000000000000000
> > > >>>> Jan 14 17:33:59 xxxxx kernel: CS:  0010 DS: 0000 ES: 0000 CR=
0:
> > > >>>> 0000000080050033
> > > >>>> Jan 14 17:33:59 xxxxx kernel: CR2: 00007fe31614ccf8 CR3:
> > > >>>> 000000000160c000 CR4: 00000000000407e0
> > > >>>> Jan 14 17:33:59 xxxxx kernel: Stack:
> > > >>>> Jan 14 17:33:59 xxxxx kernel: ffff880fab8001e8 0000000188a00=
0fb
> > > >>>> ffff880fce594400 ffff880fce594400
> > > >>>> Jan 14 17:33:59 xxxxx kernel: ffff880fab8001e8 0000000000000=
013
> > > >>>> 0000000000000001 ffff88100ea57dc8
> > > >>>> Jan 14 17:33:59 xxxxx kernel: ffff88100ea57d18 ffffffffa01ce=
72a
> > > >>>> ffff88101371a050 0000000200000000
> > > >>>> Jan 14 17:33:59 xxxxx kernel: Call Trace:
> > > >>>> Jan 14 17:33:59 xxxxx kernel: [<ffffffffa01ce72a>] ?
> > > >>>> btree_gc_mark_node+0x4c/0x16d [bcache]
> > > >>>> Jan 14 17:33:59 xxxxx kernel: [<ffffffff811e8e63>] ?
> > > >>>> call_rwsem_down_write_failed+0x13/0x20
> > > >>>> Jan 14 17:33:59 xxxxx kernel: [<ffffffffa01d005e>] ?
> > > >>>> bch_btree_gc+0x187/0x3a7 [bcache]
> > > >>>> Jan 14 17:33:59 xxxxx kernel: [<ffffffff8106ffde>] ?
> > > >>>> idle_balance+0x12b/0x166
> > > >>>> Jan 14 17:33:59 xxxxx kernel: [<ffffffff81066b18>] ? mmdrop+=
0xd/0x1c
> > > >>>> Jan 14 17:33:59 xxxxx kernel: [<ffffffffa01d02ab>] ?
> > > >>>> bch_gc_thread+0x2d/0xe5 [bcache]
> > > >>>> Jan 14 17:33:59 xxxxx kernel: [<ffffffffa01d027e>] ?
> > > >>>> bch_btree_gc+0x3a7/0x3a7 [bcache]
> > > >>>> Jan 14 17:33:59 xxxxx kernel: [<ffffffffa01d027e>] ?
> > > >>>> bch_btree_gc+0x3a7/0x3a7 [bcache]
> > > >>>> Jan 14 17:33:59 xxxxx kernel: [<ffffffff8105f77a>] ?
> > kthread+0x99/0xa1
> > > >>>> Jan 14 17:33:59 xxxxx kernel: [<ffffffff8105f6e1>] ?
> > > >>>> __kthread_parkme+0x59/0x59
> > > >>>> Jan 14 17:33:59 xxxxx kernel: [<ffffffff813b58cc>] ?
> > > >>>> ret_from_fork+0x7c/0xb0
> > > >>>> Jan 14 17:33:59 xxxxx kernel: [<ffffffff8105f6e1>] ?
> > > >>>> __kthread_parkme+0x59/0x59
> > > >>>> Jan 14 17:33:59 xxxxx kernel: Code: 00 01 c1 b8 ff 3f 00 00 =
81 f9 ff
> > > >>>> 3f 00 00 0f 46 c1 66 81 e2 03 80 25 ff 1f 00 00 c1 e0 02 09 =
d0 66 a9
> > > >>>> fc 7f 66 41 89 47 0a 75 02 <0f> 0b ff c5 eb 05 31 ed 45 31 e=
4 48 8b
> > > >>>> 03 89 ea 48 c1 e8 3c 83
> > > >>>> Jan 14 17:33:59 xxxxx kernel: RIP  [<ffffffffa01ce41e>]
> > > >>>> __bch_btree_mark_key+0x171/0x1a8 [bcache]
> > > >>>> Jan 14 17:33:59 xxxxx kernel: RSP <ffff88100ea57cb8>
> > > >>>> Jan 14 17:33:59 xxxxx kernel: ---[ end trace 6a29ce0fa7816b5=
4 ]---
> > > >>>>
> > > >>>>
> > > >>>> Jan 16 12:16:00 xxxxx kernel: ------------[ cut here ]------=
------
> > > >>>> Jan 16 12:16:00 xxxxx kernel: kernel BUG at
> > > >>>> drivers/md/bcache/btree.c:1168!
> > > >>>> Jan 16 12:16:00 xxxxx kernel: invalid opcode: 0000 [#1] SMP
> > > >>>> Jan 16 12:16:00 xxxxx kernel: Modules linked in: lp parport_=
pc
> > > >>>> parport joydev st sr_mod cdrom xt_multiport iptable_filter i=
p_tables
> > > >>>> x_tables xfs libcrc32c ipmi_devintf loop iTCO_wdt
> > > >>>> x86_pkg_temp_thermal coretemp kvm_intel kvm sb_edac
> > > >>>> iTCO_vendor_support mgag200 ioatdma snd_pcm snd_page_alloc s=
nd_timer
> > > >>>> snd i2c_i801
> > > >>>> +ttm soundcore crc32c_intel ghash_clmulni_intel aesni_intel =
lpc_ich
> > > >>>> aes_x86_64 drm_kms_helper drm i2c_algo_bit i2c_core mfd_core
> > > >>>> ablk_helper cryptd lrw gf128mul mei_me mei glue_helper psmou=
se
> > > >>>> edac_core serio_raw pcspkr evdev wmi ipmi_si ipmi_msghandler
> > > >>>> processor thermal_sys button ext3 mbcache jbd dm_mod raid1
> > > >>>> +md_mod hid_generic usbhid hid bcache sg sd_mod ses crc_t10d=
if
> > > >>>> enclosure crct10dif_common microcode ehci_pci ehci_hcd usbco=
re ahci
> > > >>>> mpt2sas libahci usb_common raid_class libata scsi_transport_=
sas
> > > >>>> megaraid_sas ixgbe scsi_mod dca ptp pps_core mdio [last unlo=
aded:
> > > >>>> parport_pc]
> > > >>>> Jan 16 12:16:00 xxxxx kernel: CPU: 8 PID: 707 Comm: bcache_g=
c Not
> > > >>>> tainted 3.13.0-rc7-dsi #3
> > > >>>> Jan 16 12:16:00 xxxxx kernel: Hardware name: Supermicro
> > > >>>> X9SRH-7F/7TF/X9SRH-7F/7TF, BIOS 3.00 07/05/2013
> > > >>>> Jan 16 12:16:00 xxxxx kernel: task: ffff88102c30f800 ti:
> > > >>>> ffff88100e44c000 task.ti: ffff88100e44c000
> > > >>>> Jan 16 12:16:00 xxxxx kernel: RIP: 0010:[<ffffffffa01f341e>]
> > > >>>> [<ffffffffa01f341e>] __bch_btree_mark_key+0x171/0x1a8 [bcach=
e]
> > > >>>> Jan 16 12:16:00 xxxxx kernel: RSP: 0018:ffff88100e44da78  EF=
LAGS:
> > > >>>> 00010246
> > > >>>> Jan 16 12:16:00 xxxxx kernel: RAX: 0000000000000000 RBX:
> > > >>>> ffff880fed4037b8 RCX: 0000000000002000
> > > >>>> Jan 16 12:16:00 xxxxx kernel: RDX: 0000000000000000 RSI:
> > > >>>> ffff880fed4037b8 RDI: ffff881028ce0000
> > > >>>> Jan 16 12:16:00 xxxxx kernel: RBP: 0000000000000000 R08:
> > > >>>> 0000000000000001 R09: ffff8810109ea000
> > > >>>> Jan 16 12:16:00 xxxxx kernel: R10: 0000000000001000 R11:
> > > >>>> ffff880fee906400 R12: 0000000000000000
> > > >>>> Jan 16 12:16:00 xxxxx kernel: R13: ffff881028ce0000 R14:
> > > >>>> 0000000000000000 R15: ffffc900168dc660
> > > >>>> Jan 16 12:16:00 xxxxx kernel: FS:  0000000000000000(0000)
> > > >>>> GS:ffff88107fd00000(0000) knlGS:0000000000000000
> > > >>>> Jan 16 12:16:00 xxxxx kernel: CS:  0010 DS: 0000 ES: 0000 CR=
0:
> > > >>>> 0000000080050033
> > > >>>> Jan 16 12:16:00 xxxxx kernel: CR2: 0000000000619570 CR3:
> > > >>>> 000000000160c000 CR4: 00000000000407e0
> > > >>>> Jan 16 12:16:00 xxxxx kernel: Stack:
> > > >>>> Jan 16 12:16:00 xxxxx kernel: ffff88100e44dad8 0000000108801=
efc
> > > >>>> ffffffffa01f0c31 ffff880fee906400
> > > >>>> Jan 16 12:16:00 xxxxx kernel: ffff880fed4037b8 0000000000000=
251
> > > >>>> 0000000000000000 ffff88100e44ddc8
> > > >>>> Jan 16 12:16:00 xxxxx kernel: ffff88100e44dad8 ffffffffa01f3=
72a
> > > >>>> ffffffffa01f5bb1 00000251b5f80000
> > > >>>> Jan 16 12:16:00 xxxxx kernel: Call Trace:
> > > >>>> Jan 16 12:16:00 xxxxx kernel: [<ffffffffa01f0c31>] ?
> > > >>>> bch_cut_back+0x41/0x41 [bcache]
> > > >>>> Jan 16 12:16:00 xxxxx kernel: [<ffffffffa01f372a>] ?
> > > >>>> btree_gc_mark_node+0x4c/0x16d [bcache]
> > > >>>> Jan 16 12:16:00 xxxxx kernel: [<ffffffffa01f5bb1>] ?
> > > >>>> tree_to_bkey+0x13/0x3c [bcache]
> > > >>>> Jan 16 12:16:00 xxxxx kernel: [<ffffffffa01f64b8>] ?
> > > >>>> bch_ptr_invalid+0x1a/0x1a [bcache]
> > > >>>> Jan 16 12:16:00 xxxxx kernel: [<ffffffffa01f4cbf>] ?
> > > >>>> btree_gc_recurse+0x677/0x88f [bcache]
> > > >>>> Jan 16 12:16:00 xxxxx kernel: [<ffffffffa01f6398>] ?
> > > >>>> bch_btree_ptr_invalid+0x46/0xb0 [bcache]
> > > >>>> Jan 16 12:16:00 xxxxx kernel: [<ffffffff813ae20a>] ?
> > > >>>> __schedule+0x48f/0x555
> > > >>>> Jan 16 12:16:00 xxxxx kernel: [<ffffffff810680ad>] ?
> > > >>>> resched_task+0x15/0x4b
> > > >>>> Jan 16 12:16:00 xxxxx kernel: [<ffffffffa01f7ab0>] ?
> > > >>>> bch_btree_iter_next_filter+0x18/0x38 [bcache]
> > > >>>> Jan 16 12:16:00 xxxxx kernel: [<ffffffffa01f379c>] ?
> > > >>>> btree_gc_mark_node+0xbe/0x16d [bcache]
> > > >>>> Jan 16 12:16:00 xxxxx kernel: [<ffffffff811e8e63>] ?
> > > >>>> call_rwsem_down_write_failed+0x13/0x20
> > > >>>> Jan 16 12:16:00 xxxxx kernel: [<ffffffffa01f50df>] ?
> > > >>>> bch_btree_gc+0x208/0x3a7 [bcache]
> > > >>>> Jan 16 12:16:00 xxxxx kernel: [<ffffffff8106ffde>] ?
> > > >>>> idle_balance+0x12b/0x166
> > > >>>> Jan 16 12:16:00 xxxxx kernel: [<ffffffff81066b18>] ? mmdrop+=
0xd/0x1c
> > > >>>> Jan 16 12:16:00 xxxxx kernel: [<ffffffffa01f52ab>] ?
> > > >>>> bch_gc_thread+0x2d/0xe5 [bcache]
> > > >>>> Jan 16 12:16:00 xxxxx kernel: [<ffffffffa01f527e>] ?
> > > >>>> bch_btree_gc+0x3a7/0x3a7 [bcache]
> > > >>>> Jan 16 12:16:00 xxxxx kernel: [<ffffffffa01f527e>] ?
> > > >>>> bch_btree_gc+0x3a7/0x3a7 [bcache]
> > > >>>> Jan 16 12:16:00 xxxxx kernel: [<ffffffff8105f77a>] ?
> > kthread+0x99/0xa1
> > > >>>> Jan 16 12:16:00 xxxxx kernel: [<ffffffff8105f6e1>] ?
> > > >>>> __kthread_parkme+0x59/0x59
> > > >>>> Jan 16 12:16:00 xxxxx kernel: [<ffffffff813b58cc>] ?
> > > >>>> ret_from_fork+0x7c/0xb0
> > > >>>> Jan 16 12:16:00 xxxxx kernel: [<ffffffff8105f6e1>] ?
> > > >>>> __kthread_parkme+0x59/0x59
> > > >>>> Jan 16 12:16:00 xxxxx kernel: Code: 00 01 c1 b8 ff 3f 00 00 =
81 f9 ff
> > > >>>> 3f 00 00 0f 46 c1 66 81 e2 03 80 25 ff 1f 00 00 c1 e0 02 09 =
d0 66 a9
> > > >>>> fc 7f 66 41 89 47 0a 75 02 <0f> 0b ff c5 eb 05 31 ed 45 31 e=
4 48 8b
> > > >>>> 03 89 ea 48 c1 e8 3c 83
> > > >>>> Jan 16 12:16:00 xxxxx kernel: RIP  [<ffffffffa01f341e>]
> > > >>>> __bch_btree_mark_key+0x171/0x1a8 [bcache]
> > > >>>> Jan 16 12:16:00 xxxxx kernel: RSP <ffff88100e44da78>
> > > >>>> Jan 16 12:16:00 xxxxx kernel: ---[ end trace 14e7f7c11d82ef2=
f ]---
> > > >>>>
> > > >>>>
> > > >>>>
> > > >>>>
> > > >>>>
> > > >>>> --
> > > >>>> --
> > > >>>> Um rep=F3rter de rock =E9 um jornalista que n=E3o sabe escre=
ver,
> > entrevistando
> > > >>>> gente
> > > >>>> que n=E3o sabe falar, para pessoas que n=E3o sabem ler.
> > > >>>>
> > > >>>>
> > > >>>> --
> > > >>>> To unsubscribe from this list: send the line "unsubscribe
> > linux-bcache"
> > > >>>> in
> > > >>>> the body of a message to majordomo@vger.kernel.org
> > > >>>> More majordomo info at  http://vger.kernel.org/majordomo-inf=
o.html
> > > >>>
> > > >>> --
> > > >>> To unsubscribe from this list: send the line "unsubscribe
> > linux-bcache"
> > > >>> in
> > > >>> the body of a message to majordomo@vger.kernel.org
> > > >>> More majordomo info at  http://vger.kernel.org/majordomo-info=
=2Ehtml
> > > >>
> > > >> _______________________________________________
> > > >> ns-list mailing list
> > > >> ns-list@dsi.ist.utl.pt
> > > >> https://mlists.ist.utl.pt/mailman/listinfo/groups.ciist.ns-lis=
t
> > > >>
> > > >>
> > > >
> > > >
> > > > --
> > > > --
> > > >
> > > > Nenhum p=E1ssaro voa alto demais, se voa com suas pr=F3prias as=
as
> > > >
> > > > --William Blake
> > > >
> > > >
> > > >
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe
> > linux-bcache" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.h=
tml
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-b=
cache"
> > in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.htm=
l
> >
> >
> >
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-bca=
che" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
>=20
>=20
>=20
> --=20
> Ryan Tucker <rtucker@gmail.com>
