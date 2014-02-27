From: Vivek Dasmohapatra <vivek@collabora.co.uk>
Subject: Re: bcache deadlock with /dev/ramX + partition
Date: Thu, 27 Feb 2014 19:14:02 +0000 (GMT)
Message-ID: <alpine.DEB.2.02.1402271908270.17442@noise.cbg.collabora.co.uk>
References: <alpine.DEB.2.02.1402201818410.14562@noise.cbg.collabora.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:47513 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaB0TOG (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 27 Feb 2014 14:14:06 -0500
In-Reply-To: <alpine.DEB.2.02.1402201818410.14562@noise.cbg.collabora.co.uk>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

To follow up: Brought up the same kernel but with PROVE_LOCKING configured,
and initialising the bcache set triggers the following lockdep warning:

------------[ cut here ]------------

WARNING: CPU: 0 PID: 3716 at /home/kernel/linux-3.12.9/kernel/lockdep.c:708
   __lock_acquire+0x1d0f/0x1d80()

Modules linked in: brd nfsd auth_rpcgss oid_registry nfs_acl nfs
lockd fscache sunrpc loop snd_pcm snd_page_alloc snd_timer snd
soundcore i2c_piix4 i2c_core evdev virtio_balloon processor
thermal_sys pcspkr button psmouse serio_raw ext4 crc16 mbcache
jbd2 bcache sg sd_mod crc_t10dif crct10dif_common ata_generic
floppy ata_piix libata virtio_pci virtio_ring 8139too scsi_mod
uhci_hcd ehci_hcd virtio 8139cp mii usbcore usb_common

CPU: 0
PID: 3716
Comm: bcache-register Not tainted 3.12-0.bpo.2-amd64 #1 Debian 3.12.9-1~bpo70+1

Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
  00000000000002c4 ffff880214baf798 ffffffff814fe566 ffff880214b8ad00
  0000000000000000 ffff880214baf7d8 ffffffff81061cd7 ffffffff8109ada1
  ffff8800dbbac8b0 ffff880214b8ad00 0000000000000000 0000000000000001

Call Trace:
  [<ffffffff814fe566>] dump_stack+0x46/0x58
  [<ffffffff81061cd7>] warn_slowpath_common+0x87/0xb0
  [<ffffffff8109ada1>] ? select_task_rq_fair+0x51/0x7f0
  [<ffffffff81061d15>] warn_slowpath_null+0x15/0x20
  [<ffffffff810cb1bf>] __lock_acquire+0x1d0f/0x1d80
  [<ffffffff810c97a3>] ? __lock_acquire+0x2f3/0x1d80
  [<ffffffff810cc164>] ? mark_held_locks+0x74/0x140
  [<ffffffff81505c0a>] ? _raw_spin_unlock_irqrestore+0x3a/0x70
  [<ffffffffa015a42e>] ? mca_reap+0x2e/0x1f0 [bcache]
  [<ffffffff810cb844>] lock_acquire+0x94/0x130
  [<ffffffffa015a42e>] ? mca_reap+0x2e/0x1f0 [bcache]
  [<ffffffff8108ae1e>] down_write_trylock+0x5e/0x70
  [<ffffffffa015a42e>] ? mca_reap+0x2e/0x1f0 [bcache]
  [<ffffffffa015a42e>] mca_reap+0x2e/0x1f0 [bcache]
  [<ffffffffa015a692>] mca_alloc+0xa2/0x560 [bcache]
  [<ffffffffa015bb72>] bch_btree_node_alloc+0xa2/0x2a0 [bcache]
  [<ffffffffa016ff19>] run_cache_set+0x769/0x960 [bcache]
  [<ffffffff812a531b>] ? idr_get_empty_slot+0x16b/0x3e0
  [<ffffffffa0170d34>] register_cache_set+0x2b4/0x2c0 [bcache]
  [<ffffffffa01712b1>] register_cache+0x571/0x7a0 [bcache]
  [<ffffffff81184154>] ? kmem_cache_alloc_trace+0x1b4/0x1e0
  [<ffffffffa0171b45>] ? register_bcache+0x665/0xec0 [bcache]
  [<ffffffffa0171b67>] register_bcache+0x687/0xec0 [bcache]
  [<ffffffff81210438>] ? sysfs_write_file+0xc8/0x160
  [<ffffffff81159aab>] ? might_fault+0x3b/0x90
  [<ffffffff812a653f>] kobj_attr_store+0xf/0x30
  [<ffffffff81210451>] sysfs_write_file+0xe1/0x160
  [<ffffffff8119b119>] vfs_write+0xc9/0x1e0
  [<ffffffff8119b600>] SyS_write+0x50/0xa0
  [<ffffffff8150e479>] system_call_fastpath+0x16/0x1b
---[ end trace 4a908a17006489d4 ]---

And the relevant part of lockdep.c says:

list_for_each_entry(class, hash_head, hash_entry) {
     if (class->key == key) {
     /*
      * Huh! same key, different name? Did someone trample
      * on some memory? We're most confused.
      */
     WARN_ON_ONCE(class->name != lock->name);

So it looks like there's something about the btree initialisation that
isn't quite kosher, maybe?
