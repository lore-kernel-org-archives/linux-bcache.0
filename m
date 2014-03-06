From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: bcache questions
Date: Thu, 6 Mar 2014 09:33:57 +0000
Message-ID: <20140306093341.GA31900@sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:35967 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaCFKDL (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 6 Mar 2014 05:03:11 -0500
Received: from sits by silver.sucs.swan.ac.uk with local (Exim 4.80)
	(envelope-from <sits@sucs.org>)
	id 1WLUgf-0007uG-H9
	for linux-bcache@vger.kernel.org; Thu, 06 Mar 2014 09:33:57 +0000
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi,

I have a few bcache questions:

How does clear_stats work? For example if I do the following:
dd if=/dev/zero of=/dev/bcache0 bs=512 count=1 oflag=direct
grep -r . /sys/block/bcache0/bcache/stats_five_minute/
echo 1 > /sys/block/bcache0/bcache/clear_stats
grep -r .  /sys/block/bcache0/bcache/stats_five_minute/

the results of the grep are the same on 3.13.5-200.fc20.x86_64 . Is this
to be expected?

Is it possible to quickly invalidate the cache so that it is known that
it is empty? Will doing
echo d8c40aa6-27b8-420e-abe2-1e2e7b31e74a > /sys/block/bcache0/bcache/detach
echo d8c40aa6-27b8-420e-abe2-1e2e7b31e74a > /sys/block/bcache0/bcache/attach

throw away the contents of the caching device?

Is it possible to invalidate the cache without destroying /dev/bcache0 ?

How do I flush the cache to backing device as quickly as possible
regardless of the usual throttling?

Should attaching the same cache set multiple times be producing WARNINGs?
[ 2043.396173] ------------[ cut here ]------------
[ 2043.396223] WARNING: CPU: 1 PID: 814 at fs/sysfs/dir.c:486 sysfs_warn_dup+0x86/0xa0()
[ 2043.396291] sysfs: cannot create duplicate filename '/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:08/VMBUS:00/vmbus_0_5/host3/target3:0:0/3:0:0:4/block/sdf/bcache/cache'
[ 2043.396399] Modules linked in: iscsi_target_mod target_core_mod iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi crct10dif_pclmul crc32_pclmul ghash_clmulni_intel microcode serio_raw hyperv_keyboard snd_pcsp hv_netvsc i2c_piix4 i2c_core snd_pcm snd_page_alloc snd_timer snd soundcore hv_utils hyperv_fb bcache hid_hyperv hv_storvsc crc32c_intel ata_generic pata_acpi hv_vmbus dm_multipath
[ 2043.396791] CPU: 1 PID: 814 Comm: bash Not tainted 3.13.5-200.fc20.x86_64 #1
[ 2043.396880] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  05/23/2012
[ 2043.397006]  0000000000000009 ffff8800f3233c58 ffffffff81686fdc ffff8800f3233ca0
[ 2043.397113]  ffff8800f3233c90 ffffffff8106d47d ffff8800e403f000 ffff8800e403f000
[ 2043.397218]  ffff88007ec5f620 0000000000000001 0000000000000000 ffff8800f3233cf0
[ 2043.397319] Call Trace:
[ 2043.397365]  [<ffffffff81686fdc>] dump_stack+0x45/0x56
[ 2043.397440]  [<ffffffff8106d47d>] warn_slowpath_common+0x7d/0xa0
[ 2043.397525]  [<ffffffff8106d4ec>] warn_slowpath_fmt+0x4c/0x50
[ 2043.397634]  [<ffffffff812307a6>] sysfs_warn_dup+0x86/0xa0
[ 2043.397710]  [<ffffffff81230800>] sysfs_add_one+0x40/0x50
[ 2043.397786]  [<ffffffff81231371>] sysfs_do_create_link_sd.isra.2+0xc1/0x1f0
[ 2043.397883]  [<ffffffff812314c5>] sysfs_create_link+0x25/0x50
[ 2043.397976]  [<ffffffffa005cf2e>] bcache_device_link+0x9e/0xf0 [bcache]
[ 2043.398080]  [<ffffffffa005e832>] bch_cached_dev_attach+0x212/0x450 [bcache]
[ 2043.398184]  [<ffffffffa00643cb>] bch_cached_dev_store+0x6db/0x770 [bcache]
[ 2043.398252]  [<ffffffff8122f260>] ? sysfs_write_file+0x60/0x1c0
[ 2043.398299]  [<ffffffff8122f328>] sysfs_write_file+0x128/0x1c0
[ 2043.398344]  [<ffffffff811b8ab4>] vfs_write+0xb4/0x1f0
[ 2043.398383]  [<ffffffff811b94e9>] SyS_write+0x49/0xa0
[ 2043.398423]  [<ffffffff81695fa9>] system_call_fastpath+0x16/0x1b
[ 2043.398466] ---[ end trace e55ca2066db90472 ]---
[ 2043.398502] ------------[ cut here ]------------
[ 2043.398545] WARNING: CPU: 1 PID: 814 at drivers/md/bcache/super.c:689 bcache_device_link+0xbc/0xf0 [bcache]()
[ 2043.398651] Couldn't create device <-> cache set symlinks
[ 2043.398717] Modules linked in:
[ 2043.400814]  iscsi_target_mod target_core_mod iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi crct10dif_pclmul crc32_pclmul ghash_clmulni_intel microcode serio_raw hyperv_keyboard snd_pcsp hv_netvsc i2c_piix4 i2c_core snd_pcm snd_page_alloc snd_timer snd soundcore hv_utils hyperv_fb bcache hid_hyperv hv_storvsc crc32c_intel ata_generic pata_acpi hv_vmbus dm_multipath
[ 2043.407935] CPU: 1 PID: 814 Comm: bash Tainted: G        W    3.13.5-200.fc20.x86_64 #1
[ 2043.409841] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  05/23/2012
[ 2043.413376]  0000000000000009 ffff8800f3233d00 ffffffff81686fdc ffff8800f3233d48
[ 2043.415145]  ffff8800f3233d38 ffffffff8106d47d ffff8800f073008c ffff8800f0730040
[ 2043.416965]  ffff88007eec0040 ffffffffa006ac98 ffff88007eec0cd0 ffff8800f3233d98
[ 2043.418686] Call Trace:
[ 2043.420428]  [<ffffffff81686fdc>] dump_stack+0x45/0x56
[ 2043.422112]  [<ffffffff8106d47d>] warn_slowpath_common+0x7d/0xa0
[ 2043.423784]  [<ffffffff8106d4ec>] warn_slowpath_fmt+0x4c/0x50
[ 2043.425478]  [<ffffffffa005cf4c>] bcache_device_link+0xbc/0xf0 [bcache]
[ 2043.427298]  [<ffffffffa005e832>] bch_cached_dev_attach+0x212/0x450 [bcache]
[ 2043.428963]  [<ffffffffa00643cb>] bch_cached_dev_store+0x6db/0x770 [bcache]
[ 2043.430563]  [<ffffffff8122f260>] ? sysfs_write_file+0x60/0x1c0
[ 2043.432145]  [<ffffffff8122f328>] sysfs_write_file+0x128/0x1c0
[ 2043.433743]  [<ffffffff811b8ab4>] vfs_write+0xb4/0x1f0
[ 2043.435335]  [<ffffffff811b94e9>] SyS_write+0x49/0xa0
[ 2043.436877]  [<ffffffff81695fa9>] system_call_fastpath+0x16/0x1b
[ 2043.438434] ---[ end trace e55ca2066db90473 ]---
[ 2043.439973] bcache: bch_cached_dev_attach() Caching sdf as bcache0 on set d8c40aa6-27b8-420e-abe2-1e2e7b31e74a
[ 2112.863194] bcache: bch_cached_dev_attach() Can't attach sdf: already attached
[ 2112.863256] bcache: __cached_dev_store() Can't attach d8c40aa6-27b8-420e-abe2-1e2e7b31e74a

Finally, is it possible to limit the amount of cache a particular
backing device can use?

-- 
Sitsofe | http://sucs.org/~sits/
