From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: Mount log message
Date: Tue, 29 Nov 2016 12:53:33 -0800 (PST)
Message-ID: <alpine.LRH.2.11.1611291249540.1914@mail.ewheeler.net>
References: <57cda780-0404-7100-23b5-aa6fee445a58@posteo.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:36116 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752706AbcK2Uxd (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 29 Nov 2016 15:53:33 -0500
In-Reply-To: <57cda780-0404-7100-23b5-aa6fee445a58@posteo.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Karl-Philipp Richter <krichter@posteo.de>
Cc: linux-bcache@vger.kernel.org

On Fri, 25 Nov 2016, Karl-Philipp Richter wrote:

> Hi,
> After upgrade to origin-258172-g2b438fb I see
> 
>     [   14.941949] ------------[ cut here ]------------
>     [   14.941957] WARNING: CPU: 4 PID: 8566 at mm/page_alloc.c:3421
> __alloc_pages_nodemask+0xa48/0xe70
>     [   14.941958] Modules linked in: ghash_clmulni_intel aesni_intel
> aes_x86_64 glue_helper arc4 lrw ablk_helper cryptd iwldvm intel_cstate
> mac80211 cdc_ether usbnet r8152 btusb btrtl intel_rapl_perf uvcvideo
> btbcm btintel bluetooth videobuf2_vmalloc videobuf2_memops
> videobuf2_v4l2 iwlwifi videobuf2_core videodev hid_multitouch joydev
> input_leds media cfg80211 serio_raw ideapad_laptop sparse_keymap wmi
> mei_me mei shpchp mac_hid lpc_ich sunrpc parport_pc ppdev lp parport
> coda ip_tables x_tables autofs4 btrfs xor raid6_pq rtsx_usb_sdmmc
> rtsx_usb hid_generic usbhid hid i915 psmouse i2c_algo_bit drm_kms_helper
> syscopyarea sysfillrect sysimgblt fb_sys_fops drm video fjes r8169 ahci
> libahci mii
>     [   14.942001] CPU: 4 PID: 8566 Comm: mount Not tainted 5.8.0+ #6
>     [   14.942002] Hardware name: LENOVO 20221/INVALID, BIOS
> 71CN51WW(V1.21) 07/12/2013
>     [   14.942004]  0000000000000286 000000004736e4c6 ffff8e39a411fa30
> ffffffff9800bed3
>     [   14.942006]  0000000000000000 0000000000000000 ffff8e39a411fa70
> ffffffff97c82e61
>     [   14.942009]  00000d5d00000000 000000000000000b ffff8e39a9bfd580
> 00000000024040c0
>     [   14.942011] Call Trace:
>     [   14.942017]  [<ffffffff9800bed3>] dump_stack+0x63/0x90
>     [   14.942020]  [<ffffffff97c82e61>] __warn+0xd1/0xf0
>     [   14.942023]  [<ffffffff97c82f8d>] warn_slowpath_null+0x1d/0x20
>     [   14.942026]  [<ffffffff97da6c98>] __alloc_pages_nodemask+0xa48/0xe70
>     [   14.942028]  [<ffffffff97da63be>] ?
> __alloc_pages_nodemask+0x16e/0xe70
>     [   14.942031]  [<ffffffff97de5cc2>] ? alloc_vmap_area+0x92/0x3a0
>     [   14.942034]  [<ffffffff97e0618b>] ?
> kmem_cache_alloc_node_trace+0x13b/0x1d0
>     [   14.942036]  [<ffffffff97de5f5f>] ? alloc_vmap_area+0x32f/0x3a0
>     [   14.942038]  [<ffffffff97df989c>] alloc_pages_current+0x8c/0x110
>     [   14.942041]  [<ffffffff97dc7458>] kmalloc_order+0x18/0x40
>     [   14.942043]  [<ffffffff97dc74a4>] kmalloc_order_trace+0x24/0xa0
>     [   14.942046]  [<ffffffff97e069a2>] ? __kmalloc+0x1a2/0x210
>     [   14.942048]  [<ffffffff97e069a2>] __kmalloc+0x1a2/0x210
>     [   14.942050]  [<ffffffff983043db>] cache_alloc+0x57b/0x930
>     [   14.942053]  [<ffffffff98307523>] bch_register_cache_set+0x1f3/0x2e0
>     [   14.942055]  [<ffffffff97e06973>] ? __kmalloc+0x173/0x210
>     [   14.942057]  [<ffffffff982e8f71>] ? bch_mount+0x111/0x500
>     [   14.942058]  [<ffffffff982e8fd9>] bch_mount+0x179/0x500
>     [   14.942062]  [<ffffffff97e31c88>] mount_fs+0x38/0x170
>     [   14.942063]  [<ffffffff97dc5a95>] ? __alloc_percpu+0x15/0x20
>     [   14.942066]  [<ffffffff97e4f5b7>] vfs_kern_mount+0x67/0x110
>     [   14.942068]  [<ffffffff97e51cf5>] do_mount+0x1e5/0xcb0
>     [   14.942072]  [<ffffffff97e29911>] ? __check_object_size+0x111/0x1e2
>     [   14.942075]  [<ffffffff97dbfdff>] ? memdup_user+0x4f/0x70
>     [   14.942077]  [<ffffffff97e52ac4>] SyS_mount+0x94/0xd0
>     [   14.942079]  [<ffffffff984af5b6>] entry_SYSCALL_64_fastpath+0x1e/0xa8
>     [   14.942081] ---[ end trace 30b883f5ea0d9503 ]---
> 
> After every boot which has no apparent consequence (no read or write
> errors or performance issues).
> 
> Maybe another message to be silenced?
> 

This message comes from the kernel memory manager, so it probably was a 
failed allocation and bcache succeeded to allocate by some other means 
(e.g. vmalloc vs kmalloc). I don't think the message cannot be supressed 
from bcache.

--
Eric Wheeler

> -Kalle
> 
> 
