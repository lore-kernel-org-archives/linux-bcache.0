From: Karl-Philipp Richter <krichter@posteo.de>
Subject: bcachefs bug during file creation and removal
Date: Fri, 11 Nov 2016 16:52:42 +0100
Message-ID: <99daab89-f7ba-25cb-f20d-503f171e2699@posteo.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0uS100VXGJqPrn8VqNKUaQSeicNFvgh9m"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mout02.posteo.de ([185.67.36.66]:43213 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756493AbcKKPwq (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 11 Nov 2016 10:52:46 -0500
Received: from submission (posteo.de [89.146.220.130])
        by mout02.posteo.de (Postfix) with ESMTPS id 4DE6720B3D
        for <linux-bcache@vger.kernel.org>; Fri, 11 Nov 2016 16:52:44 +0100 (CET)
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 3tFkvb57ZXz106Q
        for <linux-bcache@vger.kernel.org>; Fri, 11 Nov 2016 16:52:43 +0100 (CET)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0uS100VXGJqPrn8VqNKUaQSeicNFvgh9m
Content-Type: multipart/mixed; boundary="N6EhuXhwEdjvIeW2Ti09AKgqEbDDFrTR5";
 protected-headers="v1"
From: Karl-Philipp Richter <krichter@posteo.de>
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Message-ID: <99daab89-f7ba-25cb-f20d-503f171e2699@posteo.de>
Subject: bcachefs bug during file creation and removal

--N6EhuXhwEdjvIeW2Ti09AKgqEbDDFrTR5
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,
During creation of an OpenAFS cache on a bcachefs mount (ca. 1 M files
and directories) I probably got the error

    [   15.436031] ------------[ cut here ]------------
    [   15.436037] WARNING: CPU: 6 PID: 9147 at mm/page_alloc.c:3421
__alloc_pages_nodemask+0xa48/0xe70
    [   15.436038] Modules linked in: bcache btusb btrtl btbcm btintel
bluetooth arc4 nls_iso8859_1 uvcvideo iwldvm lz4_compress libcrc32c
videobuf2_vmalloc intel_rapl x86_pkg_temp_thermal videobuf2_memops
videobuf2_v4l2 intel_powerclamp videobuf2_core coretemp videodev
cdc_ether mac80211 usbnet r8152 media hid_multitouch kvm_intel kvm
iwlwifi irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel
aesni_intel cfg80211 aes_x86_64 glue_helper lrw ablk_helper cryptd
intel_cstate intel_rapl_perf joydev input_leds mei_me ideapad_laptop
serio_raw mei wmi mac_hid lpc_ich sparse_keymap shpchp coda sunrpc
parport_pc ppdev lp parport ip_tables x_tables autofs4 btrfs xor
raid6_pq rtsx_usb_sdmmc rtsx_usb hid_generic usbhid hid i915 psmouse
i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops=

    [   15.436071]  drm r8169 video mii fjes ahci libahci
    [   15.436076] CPU: 6 PID: 9147 Comm: mount Not tainted 10.8.0+ #2
    [   15.436076] Hardware name: LENOVO 20221/INVALID, BIOS
71CN51WW(V1.21) 07/12/2013
    [   15.436078]  0000000000000286 00000000b885e0f1 ffff8c812635ba30
ffffffffaba0c9d3
    [   15.436080]  0000000000000000 0000000000000000 ffff8c812635ba70
ffffffffab682e51
    [   15.436081]  00000d5d00000000 000000000000000b ffff8c812bb88000
00000000024040c0
    [   15.436083] Call Trace:
    [   15.436088]  [<ffffffffaba0c9d3>] dump_stack+0x63/0x90
    [   15.436091]  [<ffffffffab682e51>] __warn+0xd1/0xf0
    [   15.436093]  [<ffffffffab682f7d>] warn_slowpath_null+0x1d/0x20
    [   15.436094]  [<ffffffffab7a6c88>] __alloc_pages_nodemask+0xa48/0xe=
70
    [   15.436096]  [<ffffffffab7a63ae>] ?
__alloc_pages_nodemask+0x16e/0xe70
    [   15.436099]  [<ffffffffab80617b>] ?
kmem_cache_alloc_node_trace+0x13b/0x1d0
    [   15.436101]  [<ffffffffab7e5f4f>] ? alloc_vmap_area+0x32f/0x3a0
    [   15.436102]  [<ffffffffab7f988c>] alloc_pages_current+0x8c/0x110
    [   15.436104]  [<ffffffffab7c7448>] kmalloc_order+0x18/0x40
    [   15.436106]  [<ffffffffab7c7494>] kmalloc_order_trace+0x24/0xa0
    [   15.436107]  [<ffffffffab806992>] ? __kmalloc+0x1a2/0x210
    [   15.436109]  [<ffffffffab806992>] __kmalloc+0x1a2/0x210
    [   15.436127]  [<ffffffffc0d56c6b>] cache_alloc+0x57b/0x950 [bcache]=

    [   15.436139]  [<ffffffffc0d59c5d>]
bch_register_cache_set+0x1fd/0x2d0 [bcache]
    [   15.436141]  [<ffffffffab806963>] ? __kmalloc+0x173/0x210
    [   15.436151]  [<ffffffffc0d3d111>] ? bch_mount+0x111/0x4d0 [bcache]=

    [   15.436159]  [<ffffffffc0d3d179>] bch_mount+0x179/0x4d0 [bcache]
    [   15.436162]  [<ffffffffab831c78>] mount_fs+0x38/0x170
    [   15.436163]  [<ffffffffab7c5a85>] ? __alloc_percpu+0x15/0x20
    [   15.436165]  [<ffffffffab84f5a7>] vfs_kern_mount+0x67/0x110
    [   15.436166]  [<ffffffffab851ce5>] do_mount+0x1e5/0xcb0
    [   15.436168]  [<ffffffffab829901>] ? __check_object_size+0x111/0x1e=
2
    [   15.436170]  [<ffffffffab7bfdef>] ? memdup_user+0x4f/0x70
    [   15.436171]  [<ffffffffab852ab4>] SyS_mount+0x94/0xd0
    [   15.436174]  [<ffffffffabe544f6>] entry_SYSCALL_64_fastpath+0x1e/0=
xa8
    [   15.436175] ---[ end trace 7ef640984da60e52 ]---

which seems to result in the error

    [   97.560655] ------------[ cut here ]------------
    [   97.560677] WARNING: CPU: 6 PID: 1802 at
drivers/md/bcache/fs.c:78 __bch_write_inode+0x2d4/0x2e0 [bcache]
    [   97.560685] inode 506338 not found when updating
    [   97.560687] Modules linked in:
    [   97.560688]  rfcomm snd_hrtimer snd_seq snd_seq_device
snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic
snd_hda_intel snd_hda_codec snd_hwdep snd_hda_core snd_pcm snd_timer snd
soundcore openafs(POE) iptable_filter bridge stp llc bnep bbswitch(OE)
binfmt_misc rtsx_usb_ms memstick usblp intel_rapl x86_pkg_temp_thermal
intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul
crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 glue_helper lrw
ablk_helper cryptd bcache arc4 iwldvm intel_cstate nls_iso8859_1
mac80211 lz4_compress libcrc32c btusb btrtl btbcm joydev btintel
bluetooth cdc_ether usbnet intel_rapl_perf uvcvideo input_leds serio_raw
videobuf2_vmalloc iwlwifi videobuf2_memops r8152 videobuf2_v4l2
videobuf2_core videodev cfg80211 hid_multitouch media lpc_ich ideapad_lap=
top
    [   97.560719]  wmi sparse_keymap mei_me mei mac_hid shpchp sunrpc
coda parport_pc ppdev lp parport ip_tables x_tables autofs4 btrfs xor
raid6_pq rtsx_usb_sdmmc rtsx_usb hid_generic usbhid hid i915 psmouse
r8169 mii i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt
fb_sys_fops drm video fjes ahci libahci
    [   97.560737] CPU: 6 PID: 1802 Comm: kworker/u16:7 Tainted: P
D W  OE   10.8.0+ #2
    [   97.560738] Hardware name: LENOVO 20221/INVALID, BIOS
71CN51WW(V1.21) 07/12/2013
    [   97.560742] Workqueue: writeback wb_workfn (flush-bcache-2)
    [   97.560744]  0000000000000286 0000000003c847b4 ffff915c5be4b870
ffffffffae80c9d3
    [   97.560746]  ffff915c5be4b8c0 0000000000000000 ffff915c5be4b8b0
ffffffffae482e51
    [   97.560748]  0000004ec0ace646 ffff915c5be4ba18 ffff915c5be4b9d0
0000000000000000
    [   97.560750] Call Trace:
    [   97.560754]  [<ffffffffae80c9d3>] dump_stack+0x63/0x90
    [   97.560757]  [<ffffffffae482e51>] __warn+0xd1/0xf0
    [   97.560758]  [<ffffffffae482ecf>] warn_slowpath_fmt+0x5f/0x80
    [   97.560768]  [<ffffffffc0ae3084>] __bch_write_inode+0x2d4/0x2e0
[bcache]
    [   97.560777]  [<ffffffffc0ae8ef3>] ? bch_writepages+0x163/0x590
[bcache]
    [   97.560779]  [<ffffffffae80c7b0>] ? cpumask_next_and+0x30/0x50
    [   97.560781]  [<ffffffffae4c03c7>] ? update_sd_lb_stats+0x147/0x570=

    [   97.560789]  [<ffffffffc0ae3311>] bch_vfs_write_inode+0x41/0x90
[bcache]
    [   97.560790]  [<ffffffffae65d7c5>]
__writeback_single_inode+0x265/0x330
    [   97.560792]  [<ffffffffae65ddc6>] writeback_sb_inodes+0x286/0x580
    [   97.560793]  [<ffffffffae65e14f>] __writeback_inodes_wb+0x8f/0xc0
    [   97.560795]  [<ffffffffae65e4d2>] wb_writeback+0x282/0x310
    [   97.560796]  [<ffffffffae65eeaa>] wb_workfn+0x2ca/0x3f0
    [   97.560799]  [<ffffffffae49d546>] process_one_work+0x156/0x400
    [   97.560801]  [<ffffffffae49e03e>] worker_thread+0x4e/0x4b0
    [   97.560803]  [<ffffffffae49dff0>] ? rescuer_thread+0x380/0x380
    [   97.560804]  [<ffffffffae49dff0>] ? rescuer_thread+0x380/0x380
    [   97.560806]  [<ffffffffae4a3538>] kthread+0xd8/0xf0
    [   97.560809]  [<ffffffffaec5471f>] ret_from_fork+0x1f/0x40
    [   97.560810]  [<ffffffffae4a3460>] ? kthread_park+0x60/0x60
    [   97.560817] ---[ end trace 5a2feb1315f23e6d ]---

when removing the left over files.

experienced with origin-258148-g4dff01e


--N6EhuXhwEdjvIeW2Ti09AKgqEbDDFrTR5--

--0uS100VXGJqPrn8VqNKUaQSeicNFvgh9m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEcBAEBCAAGBQJYJelLAAoJEGadKJ8eJ7ZGvkQH/jwShHeRFN0Zg+OAgYi1CUG+
GTeXR+OvGRcV3l0IF5hlWALg9EWbEMd4+vRdg6fjflBKA1eJndbjYNFgl1a4B4lG
OoW0Jct56xzKy9ByEr9vvq/QthCJzEM3VrI2ykYXTaBgski8KqC3jvq9g9JKS9Sl
h2kj1RWWjEb/tFgWymyX5gYSM77t6+lPhNWH6qu9zCVR/QFSX2okMMCKfYvjha3G
E8avtM7mRlyknz8uIeEBrkWFjOkBMGz5hn40k0jr1/W71n0ehE4BUpF0PlYJ9v0O
oMq+sQyFS39M/i8acOu9Kl0gBogPkzkIiklMCSFWi1dZVuQPFTLqLS/1Xww+/1w=
=E1vw
-----END PGP SIGNATURE-----

--0uS100VXGJqPrn8VqNKUaQSeicNFvgh9m--
