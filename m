From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: v4.12: register_dcache lockdep problem on boot
Date: Tue, 25 Jul 2017 18:15:23 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1707251814092.9683@mail.ewheeler.net>
References: <20170725085447.GA4149@amd>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170725085447.GA4149@amd>
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>
List-Id: linux-bcache@vger.kernel.org

On Tue, 25 Jul 2017, Pavel Machek wrote:

> Hi!
> 
> I get this one during boot...
> 
> 								Pavel
> [   12.717617]  __lock_acquire+0x86/0x94a
> [   12.720466]  lock_acquire+0x4a/0x66
> [   12.723223]  ? mca_reap+0x56/0x115
> [   12.725972]  down_write_trylock+0x44/0x59
> [   12.728737]  ? mca_reap+0x56/0x115
> [   12.731454]  mca_reap+0x56/0x115
> [   12.734131]  mca_alloc+0x80/0x390
> [   12.736741]  bch_btree_node_get+0x76/0x27e
> [   12.739324]  run_cache_set+0x2c0/0x7c1
> [   12.741866]  register_bcache+0xc35/0x109b
> [   12.744356]  ? register_bcache+0xc35/0x109b
> [   12.746826]  ? x86_perf_event_set_period+0x187/0x20c
> [   12.749305]  ? __mutex_lock+0x2a/0x5d7
> [   12.751725]  ? bch_cache_set_alloc+0x577/0x577
> [   12.754138]  kobj_attr_store+0x10/0x1f
> [   12.756508]  ? kobj_attr_store+0x10/0x1f
> [   12.758906]  sysfs_kf_write+0x2f/0x41
> [   12.761258]  ? sysfs_file_ops+0x40/0x40
> [   12.763521]  kernfs_fop_write+0xd3/0x14a
> [   12.765762]  ? sysfs_file_ops+0x40/0x40
> [   12.767948]  ? kernfs_vma_page_mkwrite+0x67/0x67
> [   12.770121]  __vfs_write+0x1c/0x103
> [   12.772076]  ? vfs_write+0x93/0x13c
> [   12.774058]  ? __sb_start_write+0xeb/0x14c
> [   12.776147]  ? vfs_write+0x93/0x13c
> [   12.778135]  vfs_write+0xa1/0x13c
> [   12.780033]  SyS_write+0x3d/0x81
> [   12.781854]  do_int80_syscall_32+0x42/0x84
> [   12.783631]  entry_INT80_32+0x2e/0x2e
> [   12.785357] EIP: 0xb7758c42
> [   12.787015] EFLAGS: 00000246 CPU: 2
> [   12.788711] EAX: ffffffda EBX: 00000003 ECX: b7755000 EDX: 0000000a
> [   12.790428] ESI: 0000000a EDI: b7755000 EBP: bfca9a0c ESP: bfca9954
> [   12.792168]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
> [   12.793861] Code: 0f 85 94 00 00 00 68 da 7f e8 c4 68 f6 7d e8 c4 e8 58 e0 00 00 0f ff 83 c4 08 eb 7e 8b 47 0c 39 83 08 01 00 00 0f 84 1e 03 00 00 <0f> ff e9 17 03 00 00 85 db 74 0b 3b 43 10 74 e1 8b 1b 85 db 75
> [   12.797697] ---[ end trace 6e213ee067267bec ]---
> [   12.808884] bcache: bch_journal_replay() journal replay done, 0 keys in 2 entries, seq 4
> [   12.822321] bcache: register_cache() registered cache device sdb1
> [   13.378319] bcache: register_bdev() registered backing device sda3

It could be benign, try this patch:

-Eric

From: Liang Chen <liangchen.linux@gmail.com>

mutex_destroy does nothing most of time, but it's better to call
it to make the code future proof and it also has some meaning
for like mutex debug.

Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
Reviewed-by: Eric Wheeler <bcache@linux.ewheeler.net>
Cc: stable@vger.kernel.org
---
 drivers/md/bcache/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 48b8c20..1f84791 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2089,6 +2089,7 @@ static void bcache_exit(void)
 	if (bcache_major)
 		unregister_blkdev(bcache_major, "bcache");
 	unregister_reboot_notifier(&reboot);
+	mutex_destroy(&bch_register_lock);
 }
 
 static int __init bcache_init(void)
@@ -2106,6 +2107,7 @@ static int __init bcache_init(void)
 
 	bcache_major = register_blkdev(0, "bcache");
 	if (bcache_major < 0) {
+		mutex_destroy(&bch_register_lock);
 		unregister_reboot_notifier(&reboot);
 		return bcache_major;
 	}
-- 
1.8.3.1
