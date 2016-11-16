From: Karl-Philipp Richter <krichter@posteo.de>
Subject: __bch_btree_iter_unlock+0x6a/0xb0 or OpenAFS bug?
Date: Wed, 16 Nov 2016 12:21:05 +0100
Message-ID: <2bb548a4-cce9-e854-e6e8-4cb3fe86af58@posteo.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="KeNsJe2rSXUbPNj9vb8QwM5VdMmwmDC8f"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mout01.posteo.de ([185.67.36.65]:54752 "EHLO mout01.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750868AbcKPL2q (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 16 Nov 2016 06:28:46 -0500
Received: from submission (posteo.de [89.146.220.130])
        by mout01.posteo.de (Postfix) with ESMTPS id D3DCB20BB3
        for <linux-bcache@vger.kernel.org>; Wed, 16 Nov 2016 12:21:06 +0100 (CET)
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 3tJhdt2Xbkz109N
        for <linux-bcache@vger.kernel.org>; Wed, 16 Nov 2016 12:21:05 +0100 (CET)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KeNsJe2rSXUbPNj9vb8QwM5VdMmwmDC8f
Content-Type: multipart/mixed; boundary="QEI9meKtGhP1gwaqJ21aJeFVmc5fGtCx0";
 protected-headers="v1"
From: Karl-Philipp Richter <krichter@posteo.de>
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Message-ID: <2bb548a4-cce9-e854-e6e8-4cb3fe86af58@posteo.de>
Subject: __bch_btree_iter_unlock+0x6a/0xb0 or OpenAFS bug?

--QEI9meKtGhP1gwaqJ21aJeFVmc5fGtCx0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,
Is

    [   67.449496] BUG: unable to handle kernel NULL pointer dereference
at           (null)
    [   67.450138] IP: [<ffffffffc0b02d97>] osi_get_fh+0x37/0x100 [openaf=
s]
    [   67.450783] PGD 0
    [   67.451426] Oops: 0000 [#1] SMP
    [   67.452053] Modules linked in: snd_hda_codec_hdmi
snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_codec
snd_hwdep snd_hda_core snd_pcm snd_timer snd soundcore openafs(POE)
iptable_filter bridge stp llc pci_stub vboxpci(OE) vboxnetadp(OE)
vboxnetflt(OE) vboxdrv(OE) bnep binfmt_misc rtsx_usb_ms memstick
intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel
nls_iso8859_1 kvm arc4 irqbypass crct10dif_pclmul crc32_pclmul iwldvm
ghash_clmulni_intel aesni_intel aes_x86_64 glue_helper lrw ablk_helper
cryptd intel_cstate mac80211 btusb btrtl btbcm btintel intel_rapl_perf
cdc_ether uvcvideo usbnet bluetooth r8152 videobuf2_vmalloc
videobuf2_memops input_leds videobuf2_v4l2 iwlwifi joydev videobuf2_core
videodev hid_multitouch serio_raw media cfg80211 ideapad_laptop
sparse_keymap
    [   67.455055]  wmi mei_me mei mac_hid shpchp lpc_ich sunrpc coda
parport_pc ppdev lp parport ip_tables x_tables autofs4 btrfs xor
raid6_pq rtsx_usb_sdmmc rtsx_usb hid_generic usbhid hid i915 psmouse
i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt
fb_sys_fops drm r8169 video mii fjes ahci libahci
    [   67.457524] CPU: 5 PID: 15383 Comm: afsd Tainted: P        W  OE
 5.8.0+ #4
    [   67.458361] Hardware name: LENOVO 20221/INVALID, BIOS
71CN51WW(V1.21) 07/12/2013
    [   67.459202] task: ffff950fa9304740 task.stack: ffff950fa6c3c000
    [   67.460024] RIP: 0010:[<ffffffffc0b02d97>]  [<ffffffffc0b02d97>]
osi_get_fh+0x37/0x100 [openafs]
    [   67.460892] RSP: 0018:ffff950fa6c3fc38  EFLAGS: 00010286
    [   67.461726] RAX: 0000000000000000 RBX: ffff950fa9304740 RCX:
0000000000000000
    [   67.462568] RDX: 000000000000000a RSI: ffffffffc0b2b9a0 RDI:
ffff950f5b809840
    [   67.463449] RBP: ffff950fa6c3fc48 R08: 000000000001cb00 R09:
ffffffff8ec3dc24
    [   67.464298] R10: ffff950fbf35cb00 R11: ffffea000f58ca00 R12:
0000561ce8ca4680
    [   67.465152] R13: ffff950f75923800 R14: 0000000000000007 R15:
0000000000000000
    [   67.466001] FS:  00007fcdfde66700(0000) GS:ffff950fbf340000(0000)
knlGS:0000000000000000
    [   67.466859] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    [   67.467739] CR2: 0000000000000000 CR3: 00000003dce61000 CR4:
00000000001406e0
    [   67.468607] Stack:
    [   67.469481]  0000000a75923800 0000000015c5fb9b ffff950fa6c3fc70
ffffffffc0b0322e
    [   67.470381]  00000000720a7000 ffff950f5b809840 0000000015c5fb9b
ffff950fa6c3fcb0
    [   67.471318]  ffffffffc0ab2727 0000000000000000 ffff950fa6c3fc98
ffffffffc0ab90a0
    [   67.472219] Call Trace:
    [   67.473117]  [<ffffffffc0b0322e>] osi_InitCacheInfo+0x5e/0xa0
[openafs]
    [   67.474032]  [<ffffffffc0ab2727>] afs_InitCacheInfo+0x37/0x130
[openafs]
    [   67.474952]  [<ffffffffc0ab90a0>] ?
afs_osi_Alloc.part.0+0x20/0x30 [openafs]
    [   67.475883]  [<ffffffffc0b0f93d>] afs_syscall_call+0xe0d/0x1be0
[openafs]
    [   67.476810]  [<ffffffff8ec38154>] ? terminate_walk+0x64/0xd0
    [   67.477707]  [<ffffffff8ec3c8e9>] ? path_openat+0x419/0x15e0
    [   67.478607]  [<ffffffff8f0d04ea>] ?
    [   67.479550]  [<ffffffffc0abf629>] afs_syscall+0x319/0x5b0 [openafs=
]
    [   67.480444]  [<ffffffff8ec428a0>] ? iterate_dir+0x190/0x190
    [   67.481337]  [<ffffffffc0b057e6>] afs_unlocked_ioctl+0x76/0xd0
[openafs]
    [   67.482224]  [<ffffffff8eca0988>] proc_reg_unlocked_ioctl+0x48/0x7=
0
    [   67.483136]  [<ffffffff8ec4212f>] do_vfs_ioctl+0x9f/0x5f0
    [   67.484031]  [<ffffffff8ec3dc24>] ? putname+0x54/0x60
    [   67.484925]  [<ffffffff8ec426f9>] SyS_ioctl+0x79/0x90
    [   67.485826]  [<ffffffff8f2ae5b6>] entry_SYSCALL_64_fastpath+0x1e/0=
xa8
    [   67.486698] Code: 89 e5 48 83 ec 10 65 48 8b 04 25 28 00 00 00 48
89 45 f8 31 c0 8b 05 f9 5c 02 00 85 c0 0f 4e c2 89 45 f4 48 8b 47 68 48
8b 40 48 <48> 8b 00 48 85 c0 74 45 31 c9 48 8b 7f 30 48 8d 55 f4 ff d0 3d=

    [   67.488707] RIP  [<ffffffffc0b02d97>] osi_get_fh+0x37/0x100 [opena=
fs]
    [   67.489652]  RSP <ffff950fa6c3fc38>
    [   67.490574] CR2: 0000000000000000
    [   67.491537] ---[ end trace f3581cabbf420593 ]---

A bcachefs or an OpenAFS bug? I only experience this with the OpenAFS
cache on a one-partition bcachefs mount.

experienced with origin-258162-gda3dd9e on Ubuntu 16.10

-Kalle

-Kalle


--QEI9meKtGhP1gwaqJ21aJeFVmc5fGtCx0--

--KeNsJe2rSXUbPNj9vb8QwM5VdMmwmDC8f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEcBAEBCAAGBQJYLEEhAAoJEGadKJ8eJ7ZGBRUH/20nUrU6SRIpFDubilc33Hps
szkdKnOrnqjoBu3sbcAF2NxH+zGpuGsi1njPB7dqghAcnJBmblz01LMRVlNvfrAO
9adcPEAYAo3l6zKGLW6cHLFZHv382zqoFP7F5Ws/Rt35s9JnKLmJUOK74r14nx3L
ZD4eeKghoJSQuD/dael0B9M7yxELGr0HobwjE50UfiD0JtC0no3NP/UJVJpCYeq7
S4vRZCTD9w2w2QVwvevx+M8XdyHEgJegoCMpJUhagphG3zeEjrCjzlhOay7dMlAA
1iSDGrUrLIlbLA6TnV6Fh4v9ElK+LY5XfeK5KkQJRLdZ9TRwK/YTm+1Pz2JCiHU=
=PKv/
-----END PGP SIGNATURE-----

--KeNsJe2rSXUbPNj9vb8QwM5VdMmwmDC8f--
