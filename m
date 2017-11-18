From: Coly Li <colyli@suse.de>
Subject: Re: [RFC] bcache: fix a circular dead locking with dc->writeback_lock
 and bch_register_lock
Date: Sun, 19 Nov 2017 01:32:25 +0800
Message-ID: <136f0ccd-0bdb-c4a2-9b42-d76c6361ac26@suse.de>
References: <20171118081415.49669-1-colyli@suse.de>
 <a64160cc-f008-3732-4c95-818368614cbb@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53203 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936342AbdKRRcf (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 18 Nov 2017 12:32:35 -0500
In-Reply-To: <a64160cc-f008-3732-4c95-818368614cbb@lyle.org>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>, linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org

On 19/11/2017 1:01 AM, Michael Lyle wrote:
> Coly--
> 
> It's a real circular lock dep between registration (a very rare
> operation) and writeback rate calculation (a fairly rare operation).
> While it's definitely a real issue, it's a very unlikely one to be
> actually encountered.
> 
> (Encountering it requires the every-5-second periodic task of
> calculating writeback to be running, between writeback lock and register
> lock [a pretty short window], and then for the user to register a new
> cached volume)
> 

Hi Mike,

Thanks for response. It seems I can almost 100% reproduce this lockdep
warning on my simple test environment. Just compiling mainline kernel
with locking debug enabled, then attach a backing device to a cache
device, and use fio to write around 30G 4KB blocksize data on bcache
device. This is why this warning grabs my eyes.

From the lockdep warning it seems this should be very rare to happen,
but I don't know why it happens almost every time in my testing...

> This particular issue was introduced in a8394090a9129b40f9 ("bcache:
> correct cache_dirty_target in __update_writeback_rate()") as part of
> 4.14. I'm concerned that if we keep putting in small local patches like
> this (especially to lock ordering or registration/deregistration
> behavior) that we're just moving problems around.
> 
> I'm planning on working on the writeback lock this cycle to make it less
> contended.  As part of this I plan to audit overall lock order, and to
> broaden use of the registration lock to better control reg/dereg
> ordering.  That is, there's already going to be a lot of change in this
> path and I hope to catch/fix a lot of issues like this.

It seems we use many mutex locks to protect critical code pieces, not
critical shared data. And sometimes it seems some shared data is
protected by some kind of lock, indeed it was not. (E.g. the 64bit
writeback_rate.next).

This is a RFC patch, maybe after the locking reordering and clean up
gets done by you, this patch is unnecessary any more.

Another warning is the nested locking in btree levels, so far I don't
have no idea what happens here yet ....


[   51.044531] ------------[ cut here ]------------
[   51.044536] WARNING: CPU: 0 PID: 1599 at kernel/locking/lockdep.c:735
register_lock_class+0x48e/0x4e0
[   51.044537] Modules linked in: ghash_clmulni_intel(+) snd_ens1371(+)
snd_ac97_codec ac97_bus snd_pcm uvcvideo bcache(O) videobuf2_vmalloc
aesni_intel videobuf2_memops vmw_balloon videobuf2_v4l2 aes_x86_64
crypto_simd cryptd glue_helper snd_timer snd_rawmidi videobuf2_core
videodev snd e1000(+) ppdev nfit joydev pcspkr vmw_vmci libnvdimm
soundcore gameport mptctl shpchp i2c_piix4 battery parport_pc parport
button ac ext4 crc16 mbcache jbd2 sr_mod cdrom ata_generic sd_mod
hid_generic usbhid ata_piix ahci libahci vmwgfx drm_kms_helper
syscopyarea sysfillrect sysimgblt ehci_pci fb_sys_fops uhci_hcd ehci_hcd
ttm mptspi scsi_transport_spi serio_raw usbcore mptscsih mptbase drm
libata sg scsi_mod autofs4
[   51.044559] CPU: 0 PID: 1599 Comm: bcache-register Tainted: G
  O    4.14.0-1-default+ #3
[   51.044560] Hardware name: VMware, Inc. VMware Virtual Platform/440BX
Desktop Reference Platform, BIOS 6.00 05/19/2017
[   51.044560] task: ffff880223580140 task.stack: ffffc90001f3c000
[   51.044561] RIP: 0010:register_lock_class+0x48e/0x4e0
[   51.044562] RSP: 0018:ffffc90001f3f9c0 EFLAGS: 00010083
[   51.044563] RAX: ffffffff82e31240 RBX: 0000000000000000 RCX:
ffffffff8272cca0
[   51.044563] RDX: 0000000000000000 RSI: 0000000000000006 RDI:
ffffffffa0606658
[   51.044563] RBP: ffff8802151790d8 R08: 0000000000000000 R09:
0000000000000000
[   51.044564] R10: ffff880223580f80 R11: 0000000000000000 R12:
ffff8802151790d8
[   51.044564] R13: 0000000000000000 R14: 0000000000000000 R15:
0000000000000000
[   51.044565] FS:  00007f96e68ed780(0000) GS:ffff880227600000(0000)
knlGS:0000000000000000
[   51.044565] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   51.044566] CR2: 000056015e05d988 CR3: 0000000223974001 CR4:
00000000003606f0
[   51.044590] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[   51.044590] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[   51.044591] Call Trace:
[   51.044593]  ? check_prev_add+0x544/0x6d0
[   51.044594]  ? check_chain_key+0x160/0x160
[   51.044596]  __lock_acquire+0x76/0x13b0
[   51.044597]  lock_acquire+0xd4/0x220
[   51.044603]  ? mca_reap+0x4f/0x170 [bcache]
[   51.044605]  down_write_trylock+0x64/0x80
[   51.044608]  ? mca_reap+0x4f/0x170 [bcache]
[   51.044611]  mca_reap+0x4f/0x170 [bcache]
[   51.044615]  mca_alloc+0xbf/0x580 [bcache]
[   51.044618]  bch_btree_node_get+0x142/0x290 [bcache]
[   51.044623]  run_cache_set+0x22b/0x880 [bcache]
[   51.044628]  register_bcache+0xec7/0x1450 [bcache]
[   51.044631]  kernfs_fop_write+0x10e/0x1a0
[   51.044632]  __vfs_write+0x23/0x150
[   51.044634]  ? rcu_read_lock_sched_held+0x9b/0xb0
[   51.044635]  ? rcu_sync_lockdep_assert+0x2d/0x60
[   51.044636]  ? __sb_start_write+0x157/0x1e0
[   51.044637]  ? vfs_write+0x190/0x1c0
[   51.044638]  vfs_write+0xc2/0x1c0
[   51.044639]  SyS_write+0x45/0xa0
[   51.044641]  entry_SYSCALL_64_fastpath+0x23/0x9a
[   51.044642] RIP: 0033:0x7f96e5fe72d0
[   51.044643] RSP: 002b:00007fffb0860bf8 EFLAGS: 00000246 ORIG_RAX:
0000000000000001
[   51.044644] RAX: ffffffffffffffda RBX: 00007fffb0861be2 RCX:
00007f96e5fe72d0
[   51.044644] RDX: 0000000000000009 RSI: 00007f96e6915000 RDI:
0000000000000003
[   51.044644] RBP: 0000000000000008 R08: 00000000004009c0 R09:
0000000000000008
[   51.044645] R10: 00007fffb0861be2 R11: 0000000000000246 R12:
00007fffb0860c70
[   51.044645] R13: 0000000000000008 R14: 0000000000000008 R15:
00007fffb0860ec8
[   51.044646] Code: ff ff ff e8 d5 ec ff ff 85 c0 0f 1f 00 0f 84 62 fe
ff ff 48 c7 c7 b0 71 a5 81 e8 2f 64 00 00 e8 9a 8c 67 00 31 c0 e9 eb fd
ff ff <0f> ff 49 89 c4 e9 b4 fd ff ff e8 03 0a 32 00 85 c0 90 0f 84 32
[   51.044658] ---[ end trace bdc1e7194a439d0a ]---

Thanks.

Coly Li
