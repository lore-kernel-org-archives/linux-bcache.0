From: "Cyril B." <cbay-SxHCd5+OuqTrt3ojHgZu+w@public.gmane.org>
Subject: Filesystem corruption caused by disk from backing device kicked out
 of RAID1 array
Date: Sun, 21 Jul 2013 18:20:16 +0200
Message-ID: <ksh1nq$dvp$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hello,

I've unfortunately experienced a filesystem corruption with bcache in 
writeback mode. The good news is I can reproduce it.

Short version: this is on stock kernel 3.10.0, bcache-tools from 
20130626. Both my backing and cache devices are in a RAID1 mdadm array. 
Writeback caching is enabled. One disk from the backing RAID1 suddenly 
has an issue and gets kicked out of the RAID. Everything continues 
smoothly, as expected.

The server is rebooted (several hours later) in order to 'reset' the 
failed disk and check if it's still functioning or needs to be replaced 
(this is a non-hot swap chassis). The disk is fine, but bcache is now 
very confused as it sees 2 devices with the same UUID. Boom, the 
filesystem is now corrupted.

Longer version: here's how to reproduce.

* create mdadm RAID1 arrays with a superblock at the end of the device 
(0.9 or 1.0):
mdadm -C /dev/md10 --metadata=1.0 -l 1 -n 2 /dev/sdc1 /dev/sdd1
mdadm -C /dev/md11 --metadata=1.0 -l 1 -n 2 /dev/sdc2 /dev/sdd2

* create your bcache device:
make-bcache -B /dev/md10 -C /dev/md11

* create a filesystem and mount it:
mkfs -t xfs /dev/bcache0
mount /dev/bcache0 /mnt

* enable writeback mode:
echo writeback > /sys/block/bcache0/bcache/cache_mode

* simulate writes on the filesystem:
iozone -a

* wait a bit, make sure data is being written on both the backing and 
cache device. At some point, simulate a failure on the disk:
mdadm -f /dev/md10 /dev/sdc1

* wait again until more data is written on the /dev/md10 backing device: 
/dev/sdc1 and /dev/sdd1 are now diverging.

* finally, reboot.

Here's what I get (relevant lines only):

[    9.759055] md: bind<sdc1>
[    9.759418] md: bind<sdd1>
[    9.759532] md: kicking non-fresh sdc1 from array!
[    9.759636] md: unbind<sdc1>
[    9.842171] md: export_rdev(sdc1)
[    9.844579] md/raid1:md10: active with 1 out of 2 mirrors
[    9.844708] md10: detected capacity change from 0 to 5379194880
[    9.844931] RAID1 conf printout:
[    9.844933]  --- wd:1 rd:2
[    9.844935]  disk 1, wo:0, o:1, dev:sdd1
[    9.845295] md: md11 stopped.
[    9.845729]  md10: unknown partition table
[    9.864962] md: bind<sdd2>
[    9.865332] md: bind<sdc2>
[    9.867314] md/raid1:md11: active with 2 out of 2 mirrors
[    9.867432] md11: detected capacity change from 0 to 1085669376
[    9.867611] RAID1 conf printout:
[    9.867613]  --- wd:2 rd:2
[    9.867615]  disk 0, wo:0, o:1, dev:sdc2
[    9.867617]  disk 1, wo:0, o:1, dev:sdd2
[    9.868148]  md11: unknown partition table

[   10.746609] bcache: register_bdev() registered backing device sdc1
[   10.855288] bcache: register_bdev() registered backing device md10
[   10.926637] bcache: bch_journal_replay() journal replay done, 547 
keys in 4 entries, seq 293
[   10.936029] bcache: bch_cached_dev_attach() Caching md10 as bcache1 
on set ba9ed0f7-c75c-401c-a841-7cc99c393b05

[   10.940232] ------------[ cut here ]------------
[   10.940342] WARNING: at fs/sysfs/dir.c:530 sysfs_add_one+0xbc/0xe0()
[   10.940450] sysfs: cannot create duplicate filename 
'/fs/bcache/ba9ed0f7-c75c-401c-a841-7cc99c393b05/bdev0'
[   10.941491] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   10.940595] Modules linked in: bcache i2c_i801(+) ioatdma(+) 
ehci_pci(+) ehci_hcd coretemp i7core_edac edac_core usbhid uhci_hcd 
usbcore usb_common megaraid_sas netconsole ixgbe mdio igb hwmon dca 
i2c_algo_bit ptp pps_core
[   10.942312] CPU: 7 PID: 5126 Comm: bcache-register Not tainted 3.10.0 #1
[   10.942450] Hardware name: Intel Corporation S5520HC/S5520HC, BIOS 
S5500.86B.01.00.0059.082320111421 08/23/2011
[   10.942597]  0000000000000212 ffff880c2dd23848 ffffffff8169349e 
ffff880c2dd23888
[   10.942974]  ffffffff81044a1b ffff880c6ac38bc0 ffff880c2f37e978 
ffff880c2dd239c8
[   10.943351]  ffff880c31795000 00000000ffffffef ffff880c2f3233c8 
ffff880c2dd23968
[   10.943728] Call Trace:
[   10.943827]  [<ffffffff8169349e>] dump_stack+0x19/0x1b
[   10.943934]  [<ffffffff81044a1b>] warn_slowpath_common+0x6b/0xa0
[   10.944041]  [<ffffffff81044b49>] warn_slowpath_fmt+0x69/0x70
[   10.944150]  [<ffffffff81408d84>] ? strlcat+0x74/0x90
[   10.944255]  [<ffffffff81408d84>] ? strlcat+0x74/0x90
[   10.944359]  [<ffffffff81408d84>] ? strlcat+0x74/0x90
[   10.944463]  [<ffffffff81408d84>] ? strlcat+0x74/0x90
[   10.944567]  [<ffffffff811a1bbc>] sysfs_add_one+0xbc/0xe0
[   10.944674]  [<ffffffff811a2ccf>] sysfs_do_create_link_sd+0xbf/0x1f0
[   10.944783]  [<ffffffff811a2e5b>] sysfs_create_link+0x2b/0x30
[   10.944895]  [<ffffffffa0227586>] bcache_device_link+0xe6/0x100 [bcache]
[   10.945009]  [<ffffffffa0229390>] bch_cached_dev_attach+0x380/0x4b0 
[bcache]
[   10.945123]  [<ffffffffa0228b6d>] ? __write_super+0x15d/0x170 [bcache]
[   10.945236]  [<ffffffffa0228cd3>] ? bcache_write_super+0x153/0x170 
[bcache]
[   10.945350]  [<ffffffffa0229ced>] run_cache_set+0x82d/0x9d0 [bcache]
[   10.945463]  [<ffffffffa022a0aa>] register_cache_set+0x21a/0x2b0 [bcache]
[   10.945576]  [<ffffffffa022a803>] register_cache+0x6c3/0x710 [bcache]
[   10.945686]  [<ffffffff81121b68>] ? kmem_cache_alloc_trace+0xb8/0x1e0
[   10.945798]  [<ffffffffa022ae48>] register_bcache+0x5f8/0xb20 [bcache]
[   10.945908]  [<ffffffff81402987>] kobj_attr_store+0x17/0x20
[   10.946014]  [<ffffffff811a092c>] sysfs_write_file+0xcc/0x150
[   10.946123]  [<ffffffff81130a02>] vfs_write+0xe2/0x1e0
[   10.946228]  [<ffffffff81130c0c>] SyS_write+0x5c/0xa0
[   10.946335]  [<ffffffff8169ea12>] system_call_fastpath+0x16/0x1b
[   10.946442] ---[ end trace 1f31f40a281dfb68 ]---
[   10.946545] ------------[ cut here ]------------
[   10.946652] WARNING: at drivers/md/bcache/super.c:689 
bcache_device_link+0xc5/0x100 [bcache]()
[   10.947846] Couldn't create device <-> cache set symlinks
[   10.947930] Modules linked in:<7>[   10.948184] ioatdma 0000:00:16.2: 
irq 122 for MSI/MSI-X

[   10.948095]  bcache i2c_i801(+) ioatdma(+) ehci_pci ehci_hcd coretemp 
i7core_edac edac_core usbhid uhci_hcd usbcore usb_common megaraid_sas 
netconsole ixgbe mdio igb hwmon dca i2c_algo_bit ptp pps_core
[   10.949635] CPU: 7 PID: 5126 Comm: bcache-register Tainted: G 
W    3.10.0 #1
[   10.949777] Hardware name: Intel Corporation S5520HC/S5520HC, BIOS 
S5500.86B.01.00.0059.082320111421 08/23/2011
[   10.949818] ioatdma 0000:00:16.6: irq 126 for MSI/MSI-X
[   10.950212] ioatdma 0000:00:16.7: irq 127 for MSI/MSI-X
[   10.949924]  00000000000002b1 ffff880c2dd238f8 ffffffff8169349e 
ffff880c2dd23938
[   10.950304]  ffffffff81044a1b ffff880c2dd23928 ffff880c32260040 
ffff880c32260010
[   10.950655] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[   10.950803]  ffff880c31f00040 ffff880c3226008c ffff880c31f00000 
ffff880c2dd23a18
[   10.951208] Call Trace:
[   10.951306]  [<ffffffff8169349e>] dump_stack+0x19/0x1b
[   10.951411]  [<ffffffff81044a1b>] warn_slowpath_common+0x6b/0xa0
[   10.951528]  [<ffffffff81044b49>] warn_slowpath_fmt+0x69/0x70
[   10.951637]  [<ffffffff811a1d85>] ? release_sysfs_dirent+0x75/0x130
[   10.951746]  [<ffffffff811a2d86>] ? sysfs_do_create_link_sd+0x176/0x1f0
[   10.951857]  [<ffffffff811a2e5b>] ? sysfs_create_link+0x2b/0x30
[   10.951969]  [<ffffffffa0227565>] bcache_device_link+0xc5/0x100 [bcache]
[   10.952083]  [<ffffffffa0229390>] bch_cached_dev_attach+0x380/0x4b0 
[bcache]
[   10.952198]  [<ffffffffa0228b6d>] ? __write_super+0x15d/0x170 [bcache]
[   10.952312]  [<ffffffffa0228cd3>] ? bcache_write_super+0x153/0x170 
[bcache]
[   10.952426]  [<ffffffffa0229ced>] run_cache_set+0x82d/0x9d0 [bcache]
[   10.952540]  [<ffffffffa022a0aa>] register_cache_set+0x21a/0x2b0 [bcache]
[   10.952653]  [<ffffffffa022a803>] register_cache+0x6c3/0x710 [bcache]
[   10.952763]  [<ffffffff81121b68>] ? kmem_cache_alloc_trace+0xb8/0x1e0
[   10.952875]  [<ffffffffa022ae48>] register_bcache+0x5f8/0xb20 [bcache]
[   10.952986]  [<ffffffff81402987>] kobj_attr_store+0x17/0x20
[   10.953093]  [<ffffffff811a092c>] sysfs_write_file+0xcc/0x150
[   10.953200]  [<ffffffff81130a02>] vfs_write+0xe2/0x1e0
[   10.953305]  [<ffffffff81130c0c>] SyS_write+0x5c/0xa0
[   10.953410]  [<ffffffff8169ea12>] system_call_fastpath+0x16/0x1b
[   10.953517] ---[ end trace 1f31f40a281dfb69 ]---
[   10.953621] bcache: bch_cached_dev_attach() Caching sdc1 as bcache0 
on set ba9ed0f7-c75c-401c-a841-7cc99c393b05
[   10.953789] bcache: register_cache() registered cache device md11

And the filesystem is now obviously corrupted:

[   14.312553] XFS (bcache0): Mounting Filesystem
[   14.413270] XFS (bcache0): Starting recovery (logdev: internal)
[   14.414033] XFS (bcache0): Internal error xlog_valid_rec_header(1) at 
line 3610 of file fs/xfs/xfs_log_recover.c.  Caller 0xffffffff812f6da2
(XFS trace)
[   14.418639] XFS (bcache0): log mount/recovery failed: error 117
[   14.418800] XFS (bcache0): log mount failed

If the RAID arrays are created with a 1.1 or 1.2 superblock, the issue 
doesn't occur, as the kicked out disk is not recognized by bcache.

I'm not sure what bcache could do to prevent this. Preventing the second 
cache device from being created wouldn't solve the problem.

Thanks,
Cyril
