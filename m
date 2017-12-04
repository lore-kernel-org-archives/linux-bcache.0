From: =?UTF-8?Q?=C5=81ukasz_Magiera?= <lmagiera@protonmail.com>
Subject: Panic from bcache/request.c/search_free
Date: Mon, 04 Dec 2017 08:20:45 -0500
Message-ID: <cFuA9lwpLcOnF4q-dUULKtxR41xDIWAXnJN-f4uPrV8-fvTPTnjTUkOMvPNFilXgilD4wv9019S5-JcGTJ_t8H9g51mtQ0tIsnVXd8tsKQ8=@protonmail.com>
Reply-To: =?UTF-8?Q?=C5=81ukasz_Magiera?= <lmagiera@protonmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail4.protonmail.ch ([185.70.40.27]:13002 "EHLO
        mail4.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753157AbdLDNU6 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 4 Dec 2017 08:20:58 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Hey all,=0A=0AI'm getting random kernel panics that seem to originate from =
Bcache.=0AMy setup is as follows:=0A=0Abacking device: 2x sata hdd, sd[ab] =
-> md0(raid1) -> lvm volume=0Acache device: m.2 sata ssd, sdc -> gpt partit=
ion=0ALinux 4.13.12=0A=0Abcache is running in writeback mode, 2M bucket, 4k=
 blocks, it's used directly by qemu with these parameters:=0A=0A-object iot=
hread,id=3Diothread0 \=0A-device virtio-blk-pci,drive=3Ddrive0,scsi=3Doff,i=
othread=3Diothread0 \=0A-drive if=3Dnone,id=3Ddrive0,cache=3Ddirectsync,for=
mat=3Draw,aio=3Dnative,file=3D"/dev/bcache/by-uuid/..."=0A=0AThis happens a=
fter some time under light reading loads with low cache hit ratio=0A=0ANetc=
onsole output:=0A[11449.333341] ------------[ cut here ]------------=0A[114=
49.333354] kernel BUG at block/bio.c:560!=0A[11449.333361] invalid opcode: =
0000 [#1] PREEMPT SMP=0A[11449.333364] Modules linked in: cfg80211 rfkill n=
etconsole fuse ebtable_filter ebtables ip6table_filter ip6_tables iptable_f=
ilter devlink tun wireguard(O) ip6_udp_tunnel udp_tunnel nct6775 hwmon_vid =
intel_rapl usblp x86_pkg_temp_thermal input_leds led_class intel_powerclamp=
 joydev mousedev nls_iso8859_1 nls_cp437 coretemp vfat fat kvm_intel iTCO_w=
dt 8021q mrp evdev mxm_wmi iTCO_vendor_support xfs mac_hid kvm crct10dif_pc=
lmul crc32_pclmul libcrc32c crc32c_generic ghash_clmulni_intel pcbc aesni_i=
ntel aes_x86_64 snd_hda_codec_realtek snd_hda_codec_hdmi i915 crypto_simd s=
nd_hda_codec_generic glue_helper cryptd intel_cstate intel_rapl_perf bridge=
 snd_hda_intel snd_hda_codec snd_hda_core snd_hwdep snd_pcm snd_timer snd a=
lx i2c_algo_bit pcspkr intel_gtt tpm_infineon tpm_tis tpm_tis_core tpm soun=
dcore thermal=0A[11449.333388]  battery mei_me mdio stp llc wmi intel_smart=
connect i2c_i801 shpchp lpc_ich mei video acpi_pad button fan nfsd auth_rpc=
gss oid_registry nfs_acl sch_fq_codel lockd vboxnetflt(O) vboxnetadp(O) gra=
ce sunrpc pci_stub vboxpci(O) vboxdrv(O) sg crypto_user ip_tables x_tables =
btrfs xor raid6_pq dm_mod dax raid1 md_mod sd_mod hid_generic usbhid hid bc=
ache ahci libahci crc32c_intel libata xhci_pci ehci_pci xhci_hcd ehci_hcd s=
csi_mod usbcore nvme usb_common nvme_core serio nvidia_drm(PO) drm_kms_help=
er syscopyarea sysfillrect sysimgblt fb_sys_fops drm agpgart nvidia_uvm(PO)=
 nvidia_modeset(PO) nvidia(PO) vfio_pci irqbypass vfio_virqfd vfio_iommu_ty=
pe1 vfio=0A[11449.333412] CPU: 0 PID: 15215 Comm: qemu-system-x86 Tainted: =
P           O    4.13.12-2-vfio #1=0A[11449.333414] Hardware name: MSI MS-7=
917/Z97 GAMING 5 (MS-7917), BIOS V1.811/06/2014=0A[11449.333416] task: ffff=
8b6456ae6900 task.stack: ffffa6210fd24000=0A[11449.333419] RIP: 0010:bio_pu=
t+0x2b/0x30=0A[11449.333420] RSP: 0018:ffff8b65cfa03b80 EFLAGS: 00010246=0A=
[11449.333422] RAX: 0000000000000000 RBX: ffff8b626d9610d8 RCX: 00000000000=
00000=0A[11449.333423] RDX: 00000a69c1719ee2 RSI: 0000000000000246 RDI: fff=
fa6210cbb7b60=0A[11449.333424] RBP: ffff8b65cfa03b90 R08: ffffffff86812d20 =
R09: 0000000000000001=0A[11449.333426] R10: 000000000000008c R11: 000000000=
0000067 R12: ffff8b626d9610d8=0A[11449.333427] R13: ffff8b65ad69e000 R14: 0=
000000000000000 R15: ffff8b65ad69e000=0A[11449.333428] FS:  00007f10a182970=
0(0000) GS:ffff8b65cfa00000(0000) knlGS:000000a2af6a4000=0A[11449.333430] C=
S:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=0A[11449.333431] CR2: 0000=
01f864f0003c CR3: 00000002bfa2a000 CR4: 00000000001426f0=0A[11449.333432] C=
all Trace:=0A[11449.333434]  <IRQ>=0A[11449.333439]  ? search_free+0x23/0x4=
0 [bcache]=0A[11449.333443]  cached_dev_write_complete+0x32/0x60 [bcache]=
=0A[11449.333446]  closure_put+0x8b/0xc0 [bcache]=0A[11449.333449]  request=
_endio+0x30/0x40 [bcache]=0A[11449.333452]  bio_endio+0xbe/0x140=0A[11449.3=
33456]  dec_pending+0x11d/0x250 [dm_mod]=0A[11449.333460]  clone_endio+0x85=
/0x150 [dm_mod]=0A[11449.333462]  bio_endio+0xbe/0x140=0A[11449.333466]  ca=
ll_bio_endio+0x2d/0x60 [raid1]=0A[11449.333468]  raid_end_bio_io+0x2e/0xd0 =
[raid1]=0A[11449.333471]  r1_bio_write_done+0x2f/0x40 [raid1]=0A[11449.3334=
74]  raid1_end_write_request+0x12c/0x2c0 [raid1]=0A[11449.333480]  ? ata_sc=
si_qc_complete+0x91/0x450 [libata]=0A[11449.333483]  bio_endio+0xbe/0x140=
=0A[11449.333486]  blk_update_request+0x8e/0x2f0=0A[11449.333492]  scsi_end=
_request+0x36/0x1d0 [scsi_mod]=0A[11449.333496]  scsi_io_completion+0x25b/0=
x640 [scsi_mod]=0A[11449.333500]  scsi_finish_command+0xd3/0xf0 [scsi_mod]=
=0A[11449.333504]  scsi_softirq_done+0x10a/0x120 [scsi_mod]=0A[11449.333506=
]  blk_done_softirq+0x8b/0xb0=0A[11449.333509]  __do_softirq+0xde/0x2d7=0A[=
11449.333512]  irq_exit+0xb6/0xc0=0A[11449.333513]  do_IRQ+0x80/0xd0=0A[114=
49.333516]  common_interrupt+0x89/0x89=0A[11449.333525] RIP: 0010:apic_has_=
interrupt_for_ppr+0xc/0x90 [kvm]=0A[11449.333526] RSP: 0018:ffffa6210fd27c5=
8 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff9d=0A[11449.333528] RAX: fffffff=
fc19f3000 RBX: ffff8b6276539400 RCX: 0000000000000000=0A[11449.333529] RDX:=
 ffff8b623f96e000 RSI: 0000000000000000 RDI: ffff8b6276539400=0A[11449.3335=
30] RBP: ffffa6210fd27c78 R08: 0000000000000000 R09: 00000000ffffffff=0A[11=
449.333531] R10: ffffa6210fd27d30 R11: 0000000000000000 R12: 00000a69c7bc07=
e0=0A[11449.333533] R13: 00000a69c7be2d59 R14: 00000a69c7bb2007 R15: ffff8b=
623fad92c8=0A[11449.333534]  </IRQ>=0A[11449.333543]  ? kvm_apic_has_interr=
upt+0x45/0x90 [kvm]=0A[11449.333551]  kvm_cpu_has_interrupt+0x41/0x50 [kvm]=
=0A[11449.333558]  kvm_arch_vcpu_runnable+0xfc/0x120 [kvm]=0A[11449.333564]=
  kvm_vcpu_check_block+0x12/0x50 [kvm]=0A[11449.333570]  kvm_vcpu_block+0x2=
4b/0x320 [kvm]=0A[11449.333576]  kvm_arch_vcpu_ioctl_run+0x15c/0x15f0 [kvm]=
=0A[11449.333584]  ? kvm_arch_vcpu_load+0x69/0x230 [kvm]=0A[11449.333590]  =
? kvm_arch_vcpu_load+0x84/0x230 [kvm]=0A[11449.333595]  kvm_vcpu_ioctl+0x2a=
6/0x640 [kvm]=0A[11449.333601]  ? kvm_vcpu_ioctl+0x2a6/0x640 [kvm]=0A[11449=
.333605]  ? __switch_to+0x479/0x4d0=0A[11449.333607]  ? __switch_to+0x479/0=
x4d0=0A[11449.333610]  do_vfs_ioctl+0xa5/0x600=0A[11449.333613]  ? __fget+0=
x6e/0x90=0A[11449.333615]  SyS_ioctl+0x79/0x90=0A[11449.333619]  entry_SYSC=
ALL_64_fastpath+0x1a/0xa5=0A[11449.333621] RIP: 0033:0x7f10b0e2b337=0A[1144=
9.333622] RSP: 002b:00007f10a1827168 EFLAGS: 00000246 ORIG_RAX: 00000000000=
00010=0A[11449.333625] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX: 000=
07f10b0e2b337=0A[11449.333627] RDX: 0000000000000000 RSI: 000000000000ae80 =
RDI: 0000000000000019=0A[11449.333628] RBP: 00007f10a3ce6040 R08: 00005562e=
2e156d0 R09: 00000000ffffffff=0A[11449.333630] R10: 00007f10a1826f50 R11: 0=
000000000000246 R12: 0000000000000000=0A[11449.333632] R13: 00007f10b808400=
0 R14: 0000000000000006 R15: 00007f10a3ce6040=0A[11449.333634] Code: 0f 1f =
440000 f6 47190174158b 878400000085 c0 7416 f0 ff 8f 840000007402 f3 c3 554=
889 e5 e8 67 ff ff ff 5d c3 <0f> 0b 0f 1f 000f 1f 440000554889 e5 415741564=
15541 =0A[11449.333654] RIP: bio_put+0x2b/0x30 RSP: ffff8b65cfa03b80=0A[114=
49.333663] ---[ end trace af53a7e5529bb671 ]---=0A[11449.333665] Kernel pan=
ic - not syncing: Fatal exception in interrupt=0A[11449.333672] Kernel Offs=
et: 0x5000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000=
-0xffffffffbfffffff)=0A[11449.333675] ---[ end Kernel panic - not syncing: =
Fatal exception in interrupt=0A=0A=E2=80=8BThanks=0A=C5=81ukasz=0A=0A=
=E2=80=8B=0A=0A
