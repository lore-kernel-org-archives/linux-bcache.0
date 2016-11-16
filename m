From: Karl-Philipp Richter <krichter@posteo.de>
Subject: Re: __bch_btree_iter_unlock+0x6a/0xb0 or OpenAFS bug?
Date: Wed, 16 Nov 2016 16:09:56 +0100
Message-ID: <62855f9f-c1c7-859a-65b8-a378c25212f4@posteo.de>
References: <2bb548a4-cce9-e854-e6e8-4cb3fe86af58@posteo.de>
 <20161116144056.uiqyfplos6ab7ju6@kmo-pixel>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MroCiOMEk0hDAbGDRoOfgx6NsfTiDRPrW"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mout02.posteo.de ([185.67.36.66]:37433 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932385AbcKPPKB (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 16 Nov 2016 10:10:01 -0500
Received: from submission (posteo.de [89.146.220.130])
        by mout02.posteo.de (Postfix) with ESMTPS id 9440F20B30
        for <linux-bcache@vger.kernel.org>; Wed, 16 Nov 2016 16:09:58 +0100 (CET)
In-Reply-To: <20161116144056.uiqyfplos6ab7ju6@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MroCiOMEk0hDAbGDRoOfgx6NsfTiDRPrW
Content-Type: multipart/mixed; boundary="jMNGUvD7c0waK1GDu1wgExRJ624RbbpDw";
 protected-headers="v1"
From: Karl-Philipp Richter <krichter@posteo.de>
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Message-ID: <62855f9f-c1c7-859a-65b8-a378c25212f4@posteo.de>
Subject: Re: __bch_btree_iter_unlock+0x6a/0xb0 or OpenAFS bug?
References: <2bb548a4-cce9-e854-e6e8-4cb3fe86af58@posteo.de>
 <20161116144056.uiqyfplos6ab7ju6@kmo-pixel>
In-Reply-To: <20161116144056.uiqyfplos6ab7ju6@kmo-pixel>

--jMNGUvD7c0waK1GDu1wgExRJ624RbbpDw
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



Am 16.11.2016 um 15:40 schrieb Kent Overstreet:
>> A bcachefs or an OpenAFS bug? I only experience this with the OpenAFS
>> > cache on a one-partition bcachefs mount.
> Where are you getting __bch_btree_iter_unlock() from?
=46rom the right backtrace

    [   65.943980] BUG: unable to handle kernel NULL pointer dereference
at           (null)
    [   65.944607] IP: [<ffffffffc0dc9d97>] osi_get_fh+0x37/0x100 [openaf=
s]
    [   65.945234] PGD 0
    [   65.945857] Oops: 0000 [#1] SMP
    [   65.946451] Modules linked in: snd_hda_codec_hdmi
snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_codec
snd_hwdep snd_hda_core snd_pcm snd_timer snd soundcore openafs(POE)
iptable_filter bridge stp llc pci_stub vboxpci(OE) vboxnetadp(OE)
vboxnetflt(OE) bnep vboxdrv(OE) binfmt_misc rtsx_usb_ms memstick
intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp nls_iso8859_1
kvm_intel kvm arc4 irqbypass crct10dif_pclmul crc32_pclmul iwldvm
ghash_clmulni_intel aesni_intel aes_x86_64 glue_helper lrw ablk_helper
cryptd intel_cstate mac80211 cdc_ether usbnet r8152 uvcvideo btusb
intel_rapl_perf btrtl btbcm videobuf2_vmalloc videobuf2_memops btintel
videobuf2_v4l2 videobuf2_core bluetooth videodev iwlwifi media
hid_multitouch cfg80211 joydev input_leds serio_raw ideapad_laptop
sparse_keymap
    [   65.949378]  wmi mei_me mei mac_hid lpc_ich shpchp sunrpc coda
parport_pc ppdev lp parport ip_tables x_tables autofs4 btrfs xor
raid6_pq rtsx_usb_sdmmc rtsx_usb hid_generic usbhid hid i915 psmouse
r8169 i2c_algo_bit mii drm_kms_helper syscopyarea sysfillrect sysimgblt
fb_sys_fops drm video fjes ahci libahci
    [   65.951897] CPU: 7 PID: 15519 Comm: afsd Tainted: P        W  OE
 5.8.0+ #4
    [   65.952709] Hardware name: LENOVO 20221/INVALID, BIOS
71CN51WW(V1.21) 07/12/2013
    [   65.953520] task: ffff974ca389aac0 task.stack: ffff974ca9c8c000
    [   65.954347] RIP: 0010:[<ffffffffc0dc9d97>]  [<ffffffffc0dc9d97>]
osi_get_fh+0x37/0x100 [openafs]
    [   65.955180] RSP: 0018:ffff974ca9c8fc38  EFLAGS: 00010286
    [   65.956006] RAX: 0000000000000000 RBX: ffff974ca389aac0 RCX:
0000000000000000
    [   65.956844] RDX: 000000000000000a RSI: ffffffffc0df29a0 RDI:
ffff974c57177540
    [   65.957691] RBP: ffff974ca9c8fc48 R08: 000000000001cb00 R09:
ffffffff8f43dc24
    [   65.958538] R10: ffff974cbf3dcb00 R11: ffffea000f615600 R12:
0000565285b7a680
    [   65.959398] R13: ffff974ca6def400 R14: 0000000000000007 R15:
0000000000000000
    [   65.960258] FS:  00007f2a06697700(0000) GS:ffff974cbf3c0000(0000)
knlGS:0000000000000000
    [   65.961120] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    [   65.962019] CR2: 0000000000000000 CR3: 00000003eab58000 CR4:
00000000001406e0
    [   65.962925] Stack:
    [   65.963794]  0000000aa6def400 00000000c0c2219a ffff974ca9c8fc70
ffffffffc0dca22e
    [   65.964692]  00000000a44cf900 ffff974c57177540 00000000c0c2219a
ffff974ca9c8fcb0
    [   65.965587]  ffffffffc0d79727 0000000000000000 ffff974ca9c8fc98
ffffffffc0d800a0
    [   65.966492] Call Trace:
    [   65.967393]  [<ffffffffc0dca22e>] osi_InitCacheInfo+0x5e/0xa0
[openafs]
    [   65.968310]  [<ffffffffc0d79727>] afs_InitCacheInfo+0x37/0x130
[openafs]
    [   65.969224]  [<ffffffffc0d800a0>] ?
afs_osi_Alloc.part.0+0x20/0x30 [openafs]
    [   65.970161]  [<ffffffffc0dd693d>] afs_syscall_call+0xe0d/0x1be0
[openafs]
    [   65.971082]  [<ffffffff8f438154>] ? terminate_walk+0x64/0xd0
    [   65.971980]  [<ffffffff8f43c8e9>] ? path_openat+0x419/0x15e0
    [   65.972874]  [<ffffffff8f8d04ea>] ? __bch_btree_iter_unlock+0x6a/0=
xb0
    [   65.973777]  [<ffffffffc0d86629>] afs_syscall+0x319/0x5b0 [openafs=
]
    [   65.974671]  [<ffffffff8f4428a0>] ? iterate_dir+0x190/0x190
    [   65.975565]  [<ffffffffc0dcc7e6>] afs_unlocked_ioctl+0x76/0xd0
[openafs]
    [   65.976457]  [<ffffffff8f4a0988>] proc_reg_unlocked_ioctl+0x48/0x7=
0
    [   65.977350]  [<ffffffff8f44212f>] do_vfs_ioctl+0x9f/0x5f0
    [   65.978273]  [<ffffffff8f43dc24>] ? putname+0x54/0x60
    [   65.979167]  [<ffffffff8f4426f9>] SyS_ioctl+0x79/0x90
    [   65.980090]  [<ffffffff8faae5b6>] entry_SYSCALL_64_fastpath+0x1e/0=
xa8
    [   65.980970] Code: 89 e5 48 83 ec 10 65 48 8b 04 25 28 00 00 00 48
89 45 f8 31 c0 8b 05 f9 5c 02 00 85 c0 0f 4e c2 89 45 f4 48 8b 47 68 48
8b 40 48 <48> 8b 00 48 85 c0 74 45 31 c9 48 8b 7f 30 48 8d 55 f4 ff d0 3d=

    [   65.983011] RIP  [<ffffffffc0dc9d97>] osi_get_fh+0x37/0x100 [opena=
fs]
    [   65.983954]  RSP <ffff974ca9c8fc38>
    [   65.984873] CR2: 0000000000000000
    [   65.985816] ---[ end trace c635bc3382137541 ]---

Sorry for the confusion.

-Kalle


--jMNGUvD7c0waK1GDu1wgExRJ624RbbpDw--

--MroCiOMEk0hDAbGDRoOfgx6NsfTiDRPrW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEcBAEBCAAGBQJYLHbFAAoJEGadKJ8eJ7ZGXWEH/1MLnhGg42WB4yN6mB0w0Jra
IgxGBbCny13mr49wfHzlDP+ExbzznlqOo+PBmutRbA6eurU2YXBX9hh7JXDdO8nR
HFQ2vygOsZQ47Wf2suHXqmSFLelxsChKjvLjIf1V/fWCD3lfptqLfG4q26WYP/0G
aCQM53gWfpupxU9YUtbijtQzeIeFmPeOTLdcyLiXUGNzwllowSQcsL4tJs86edZu
woyfMIkKCqjpRdWy8JYf/gtTTQIlx0fyPpaNcCgDImOcoOJPCy0DVEsvh9vM20Pm
UQL3sRI/atd6i51LcuNhpd3E575H+FeckxDPPpngca1J+PCCUsWMdQcrK2ZbfDY=
=OXxW
-----END PGP SIGNATURE-----

--MroCiOMEk0hDAbGDRoOfgx6NsfTiDRPrW--
