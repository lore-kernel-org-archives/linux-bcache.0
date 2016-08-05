From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: Can't load bcache module second time
Date: Fri, 5 Aug 2016 16:03:18 +0200
Message-ID: <af228b9a-b5ac-814e-efe5-347d6780d0ab@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:22463 "EHLO jowisz.mejor.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934849AbcHEONa (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Fri, 5 Aug 2016 10:13:30 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi!
Kernel is on commit 1c99b8fdce303e0961ee982919c890bf156ed775.
Host is freshly rebooted.
# grep bcache /proc/modules
# modprobe bcache && rmmod bcache && modprobe bcache
modprobe: ERROR: could not insert 'bcache': Cannot allocate memory

In dmesg I've got:
> Aug  5 15:39:14 localhost kernel: [  249.911487] WARNING: CPU: 3 PID: 17892 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x5d/0x70
> Aug  5 15:39:14 localhost kernel: [  249.911490] sysfs: cannot create duplicate filename '/devices/virtual/bcache'
> Aug  5 15:39:14 localhost kernel: [  249.911493] Modules linked in: bcache(+) libcrc32c tun spadfs(O) mousedev vboxnetadp(O) vboxnetflt(O) nouveau vboxdrv(O) wmi video backlight i2c_algo_bit ttm fbcon bitblit softcursor font coretemp drm_kms_helper hwmon cfbfillrect syscopyarea kvm_intel snd_ens1371 snd_ac97_codec cfbimgblt kvm sysfillrect ac97_bus snd_rawmidi sysimgblt snd_pcm fb_sys_fops cfbcopyarea snd_timer snd drm 8250 8250_base e1000e irqbypass agpgart ptp fb soundcore fbdev pps_core serial_core evdev psmouse lpc_ich acpi_cpufreq button i2c_i801 i82975x_edac processor edac_core mfd_core zfs(PO) zunicode(PO) zcommon(PO) znvpair(PO) spl(O) zlib_deflate zavl(PO) sr_mod cdrom sata_sil [last unloaded: bcache]
> Aug  5 15:39:14 localhost kernel: [  249.911566] CPU: 3 PID: 17892 Comm: modprobe Tainted: P           O    4.7.0-bcache+ #4
> Aug  5 15:39:14 localhost kernel: [  249.911568] Hardware name:                  /D975XBX, BIOS BX97510J.86A.1487.2007.0902.1724 09/02/2007
> Aug  5 15:39:14 localhost kernel: [  249.911571]  0000000000000286 00000000e7ecea9b ffff88008e937998 ffffffff812cbf1d
> Aug  5 15:39:14 localhost kernel: [  249.911576]  ffff88008e9379e8 0000000000000000 ffff88008e9379d8 ffffffff810591b6
> Aug  5 15:39:14 localhost kernel: [  249.911579]  0000001f4a2f3000 ffff8800b95d1000 ffff8800cf26abc8 ffff88014a2f7ac8
> Aug  5 15:39:14 localhost kernel: [  249.911583] Call Trace:
> Aug  5 15:39:14 localhost kernel: [  249.911590]  [<ffffffff812cbf1d>] dump_stack+0x4f/0x72
> Aug  5 15:39:14 localhost kernel: [  249.911595]  [<ffffffff810591b6>] __warn+0xc6/0xe0
> Aug  5 15:39:14 localhost kernel: [  249.911598]  [<ffffffff8105922a>] warn_slowpath_fmt+0x5a/0x80
> Aug  5 15:39:14 localhost kernel: [  249.911601]  [<ffffffff81206abd>] sysfs_warn_dup+0x5d/0x70
> Aug  5 15:39:14 localhost kernel: [  249.911604]  [<ffffffff81206b92>] sysfs_create_dir_ns+0x72/0x80
> Aug  5 15:39:14 localhost kernel: [  249.911607]  [<ffffffff812ceca9>] kobject_add_internal+0x99/0x2c0
> Aug  5 15:39:14 localhost kernel: [  249.911614]  [<ffffffff8114803d>] ? kfree_const+0x1d/0x20
> Aug  5 15:39:14 localhost kernel: [  249.911617]  [<ffffffff812cef45>] kobject_add+0x75/0xd0
> Aug  5 15:39:14 localhost kernel: [  249.911621]  [<ffffffff8117def9>] ? kmem_cache_alloc_trace+0x1c9/0x1e0
> Aug  5 15:39:14 localhost kernel: [  249.911628]  [<ffffffff81382c18>] get_device_parent.isra.19+0x108/0x1c0
> Aug  5 15:39:14 localhost kernel: [  249.911631]  [<ffffffff813838c7>] device_add+0xd7/0x5c0
> Aug  5 15:39:14 localhost kernel: [  249.911634]  [<ffffffff81383fab>] device_create_groups_vargs+0xdb/0xf0
> Aug  5 15:39:14 localhost kernel: [  249.911689]  [<ffffffffc095412a>] ? bch_fs_init+0xa2/0xa2 [bcache]
> Aug  5 15:39:14 localhost kernel: [  249.911693]  [<ffffffff8138402c>] device_create+0x4c/0x70
> Aug  5 15:39:14 localhost kernel: [  249.911698]  [<ffffffff813880bc>] ? __class_create+0x4c/0x80
> Aug  5 15:39:14 localhost kernel: [  249.911716]  [<ffffffffc095412a>] ? bch_fs_init+0xa2/0xa2 [bcache]
> Aug  5 15:39:14 localhost kernel: [  249.911721]  [<ffffffff812cf6fe>] ? kobject_uevent_env+0xfe/0x500
> Aug  5 15:39:14 localhost kernel: [  249.911739]  [<ffffffffc09541d6>] bcache_init+0xac/0x14c [bcache]
> Aug  5 15:39:14 localhost kernel: [  249.911744]  [<ffffffff8100042b>] do_one_initcall+0x4b/0x170
> Aug  5 15:39:14 localhost kernel: [  249.911748]  [<ffffffff81169d4c>] ? __vunmap+0x7c/0xc0
> Aug  5 15:39:14 localhost kernel: [  249.911750]  [<ffffffff81169ded>] ? vfree+0x2d/0x80
> Aug  5 15:39:14 localhost kernel: [  249.911755]  [<ffffffff811290bb>] do_init_module+0x5a/0x1ca
> Aug  5 15:39:14 localhost kernel: [  249.911761]  [<ffffffff810db8fa>] load_module+0x20ba/0x2510
> Aug  5 15:39:14 localhost kernel: [  249.911764]  [<ffffffff810d84e0>] ? __symbol_put+0x90/0x90
> Aug  5 15:39:14 localhost kernel: [  249.911768]  [<ffffffff810dbe88>] SYSC_init_module+0x138/0x150
> Aug  5 15:39:14 localhost kernel: [  249.911772]  [<ffffffff810dbf99>] SyS_init_module+0x9/0x10
> Aug  5 15:39:14 localhost kernel: [  249.911776]  [<ffffffff8157431f>] entry_SYSCALL_64_fastpath+0x17/0x93
> Aug  5 15:39:14 localhost kernel: [  249.911780] ---[ end trace 1443a8f8ae686881 ]---
> Aug  5 15:39:14 localhost kernel: [  249.911783] ------------[ cut here ]------------
> Aug  5 15:39:14 localhost kernel: [  249.911786] WARNING: CPU: 3 PID: 17892 at lib/kobject.c:240 kobject_add_internal+0x252/0x2c0
> Aug  5 15:39:14 localhost kernel: [  249.911789] kobject_add_internal failed for bcache with -EEXIST, don't try to register things with the same name in the same directory.
> Aug  5 15:39:14 localhost kernel: [  249.911791] Modules linked in: bcache(+) libcrc32c tun spadfs(O) mousedev vboxnetadp(O) vboxnetflt(O) nouveau vboxdrv(O) wmi video backlight i2c_algo_bit ttm fbcon bitblit softcursor font coretemp drm_kms_helper hwmon cfbfillrect syscopyarea kvm_intel snd_ens1371 snd_ac97_codec cfbimgblt kvm sysfillrect ac97_bus snd_rawmidi sysimgblt snd_pcm fb_sys_fops cfbcopyarea snd_timer snd drm 8250 8250_base e1000e irqbypass agpgart ptp fb soundcore fbdev pps_core serial_core evdev psmouse lpc_ich acpi_cpufreq button i2c_i801 i82975x_edac processor edac_core mfd_core zfs(PO) zunicode(PO) zcommon(PO) znvpair(PO) spl(O) zlib_deflate zavl(PO) sr_mod cdrom sata_sil [last unloaded: bcache]
> Aug  5 15:39:14 localhost kernel: [  249.911851] CPU: 3 PID: 17892 Comm: modprobe Tainted: P        W  O    4.7.0-bcache+ #4
> Aug  5 15:39:14 localhost kernel: [  249.911853] Hardware name:                  /D975XBX, BIOS BX97510J.86A.1487.2007.0902.1724 09/02/2007
> Aug  5 15:39:14 localhost kernel: [  249.911855]  0000000000000286 00000000e7ecea9b ffff88008e9379e8 ffffffff812cbf1d
> Aug  5 15:39:14 localhost kernel: [  249.911860]  ffff88008e937a38 0000000000000000 ffff88008e937a28 ffffffff810591b6
> Aug  5 15:39:14 localhost kernel: [  249.911863]  000000f08e937a50 ffff8800ca01d180 00000000ffffffef ffff88014a305a00
> Aug  5 15:39:14 localhost kernel: [  249.911867] Call Trace:
> Aug  5 15:39:14 localhost kernel: [  249.911869]  [<ffffffff812cbf1d>] dump_stack+0x4f/0x72
> Aug  5 15:39:14 localhost kernel: [  249.911872]  [<ffffffff810591b6>] __warn+0xc6/0xe0
> Aug  5 15:39:14 localhost kernel: [  249.911875]  [<ffffffff8105922a>] warn_slowpath_fmt+0x5a/0x80
> Aug  5 15:39:14 localhost kernel: [  249.911877]  [<ffffffff81206ac5>] ? sysfs_warn_dup+0x65/0x70
> Aug  5 15:39:14 localhost kernel: [  249.911880]  [<ffffffff812cee62>] kobject_add_internal+0x252/0x2c0
> Aug  5 15:39:14 localhost kernel: [  249.911883]  [<ffffffff8114803d>] ? kfree_const+0x1d/0x20
> Aug  5 15:39:14 localhost kernel: [  249.911886]  [<ffffffff812cef45>] kobject_add+0x75/0xd0
> Aug  5 15:39:14 localhost kernel: [  249.911889]  [<ffffffff8117def9>] ? kmem_cache_alloc_trace+0x1c9/0x1e0
> Aug  5 15:39:14 localhost kernel: [  249.911894]  [<ffffffff81382c18>] get_device_parent.isra.19+0x108/0x1c0
> Aug  5 15:39:14 localhost kernel: [  249.911897]  [<ffffffff813838c7>] device_add+0xd7/0x5c0
> Aug  5 15:39:14 localhost kernel: [  249.911900]  [<ffffffff81383fab>] device_create_groups_vargs+0xdb/0xf0
> Aug  5 15:39:14 localhost kernel: [  249.911919]  [<ffffffffc095412a>] ? bch_fs_init+0xa2/0xa2 [bcache]
> Aug  5 15:39:14 localhost kernel: [  249.911922]  [<ffffffff8138402c>] device_create+0x4c/0x70
> Aug  5 15:39:14 localhost kernel: [  249.911925]  [<ffffffff813880bc>] ? __class_create+0x4c/0x80
> Aug  5 15:39:14 localhost kernel: [  249.911944]  [<ffffffffc095412a>] ? bch_fs_init+0xa2/0xa2 [bcache]
> Aug  5 15:39:14 localhost kernel: [  249.911948]  [<ffffffff812cf6fe>] ? kobject_uevent_env+0xfe/0x500
> Aug  5 15:39:14 localhost kernel: [  249.911966]  [<ffffffffc09541d6>] bcache_init+0xac/0x14c [bcache]
> Aug  5 15:39:14 localhost kernel: [  249.911969]  [<ffffffff8100042b>] do_one_initcall+0x4b/0x170
> Aug  5 15:39:14 localhost kernel: [  249.911972]  [<ffffffff81169d4c>] ? __vunmap+0x7c/0xc0
> Aug  5 15:39:14 localhost kernel: [  249.911974]  [<ffffffff81169ded>] ? vfree+0x2d/0x80
> Aug  5 15:39:14 localhost kernel: [  249.911977]  [<ffffffff811290bb>] do_init_module+0x5a/0x1ca
> Aug  5 15:39:14 localhost kernel: [  249.911980]  [<ffffffff810db8fa>] load_module+0x20ba/0x2510
> Aug  5 15:39:14 localhost kernel: [  249.911982]  [<ffffffff810d84e0>] ? __symbol_put+0x90/0x90
> Aug  5 15:39:14 localhost kernel: [  249.911987]  [<ffffffff810dbe88>] SYSC_init_module+0x138/0x150
> Aug  5 15:39:14 localhost kernel: [  249.911990]  [<ffffffff810dbf99>] SyS_init_module+0x9/0x10
> Aug  5 15:39:14 localhost kernel: [  249.911993]  [<ffffffff8157431f>] entry_SYSCALL_64_fastpath+0x17/0x93
> Aug  5 15:39:14 localhost kernel: [  249.911995] ---[ end trace 1443a8f8ae686882 ]---
> Aug  5 15:39:14 localhost kernel: [  249.912387] ------------[ cut here ]------------
> Aug  5 15:39:14 localhost kernel: [  249.912393] WARNING: CPU: 3 PID: 17892 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x5d/0x70
> Aug  5 15:39:14 localhost kernel: [  249.912394] sysfs: cannot create duplicate filename '/dev/char/249:255'
> Aug  5 15:39:14 localhost kernel: [  249.912396] Modules linked in: bcache(+) libcrc32c tun spadfs(O) mousedev vboxnetadp(O) vboxnetflt(O) nouveau vboxdrv(O) wmi video backlight i2c_algo_bit ttm fbcon bitblit softcursor font coretemp drm_kms_helper hwmon cfbfillrect syscopyarea kvm_intel snd_ens1371 snd_ac97_codec cfbimgblt kvm sysfillrect ac97_bus snd_rawmidi sysimgblt snd_pcm fb_sys_fops cfbcopyarea snd_timer snd drm 8250 8250_base e1000e irqbypass agpgart ptp fb soundcore fbdev pps_core serial_core evdev psmouse lpc_ich acpi_cpufreq button i2c_i801 i82975x_edac processor edac_core mfd_core zfs(PO) zunicode(PO) zcommon(PO) znvpair(PO) spl(O) zlib_deflate zavl(PO) sr_mod cdrom sata_sil [last unloaded: bcache]
> Aug  5 15:39:14 localhost kernel: [  249.912539] CPU: 3 PID: 17892 Comm: modprobe Tainted: P        W  O    4.7.0-bcache+ #4
> Aug  5 15:39:14 localhost kernel: [  249.912542] Hardware name:                  /D975XBX, BIOS BX97510J.86A.1487.2007.0902.1724 09/02/2007
> Aug  5 15:39:14 localhost kernel: [  249.912545]  0000000000000286 00000000e7ecea9b ffff88008e937a58 ffffffff812cbf1d
> Aug  5 15:39:14 localhost kernel: [  249.912551]  ffff88008e937aa8 0000000000000000 ffff88008e937a98 ffffffff810591b6
> Aug  5 15:39:14 localhost kernel: [  249.912555]  0000001f4a2f3078 ffff8800b95d1000 ffff88008e937b89 ffff88014a2f3168
> Aug  5 15:39:14 localhost kernel: [  249.912560] Call Trace:
> Aug  5 15:39:14 localhost kernel: [  249.912565]  [<ffffffff812cbf1d>] dump_stack+0x4f/0x72
> Aug  5 15:39:14 localhost kernel: [  249.912569]  [<ffffffff810591b6>] __warn+0xc6/0xe0
> Aug  5 15:39:14 localhost kernel: [  249.912572]  [<ffffffff8105922a>] warn_slowpath_fmt+0x5a/0x80
> Aug  5 15:39:14 localhost kernel: [  249.912575]  [<ffffffff81206abd>] sysfs_warn_dup+0x5d/0x70
> Aug  5 15:39:14 localhost kernel: [  249.912578]  [<ffffffff81206e36>] sysfs_do_create_link_sd.isra.2+0xb6/0xc0
> Aug  5 15:39:14 localhost kernel: [  249.912581]  [<ffffffff81206e60>] sysfs_create_link+0x20/0x40
> Aug  5 15:39:14 localhost kernel: [  249.912585]  [<ffffffff81383d0d>] device_add+0x51d/0x5c0
> Aug  5 15:39:14 localhost kernel: [  249.912587]  [<ffffffff81383fab>] device_create_groups_vargs+0xdb/0xf0
> Aug  5 15:39:14 localhost kernel: [  249.912616]  [<ffffffffc095412a>] ? bch_fs_init+0xa2/0xa2 [bcache]
> Aug  5 15:39:14 localhost kernel: [  249.912619]  [<ffffffff8138402c>] device_create+0x4c/0x70
> Aug  5 15:39:14 localhost kernel: [  249.912623]  [<ffffffff813880bc>] ? __class_create+0x4c/0x80
> Aug  5 15:39:14 localhost kernel: [  249.912640]  [<ffffffffc095412a>] ? bch_fs_init+0xa2/0xa2 [bcache]
> Aug  5 15:39:14 localhost kernel: [  249.912644]  [<ffffffff812cf6fe>] ? kobject_uevent_env+0xfe/0x500
> Aug  5 15:39:14 localhost kernel: [  249.912662]  [<ffffffffc09541d6>] bcache_init+0xac/0x14c [bcache]
> Aug  5 15:39:14 localhost kernel: [  249.912666]  [<ffffffff8100042b>] do_one_initcall+0x4b/0x170
> Aug  5 15:39:14 localhost kernel: [  249.912668]  [<ffffffff81169d4c>] ? __vunmap+0x7c/0xc0
> Aug  5 15:39:14 localhost kernel: [  249.912671]  [<ffffffff81169ded>] ? vfree+0x2d/0x80
> Aug  5 15:39:14 localhost kernel: [  249.912675]  [<ffffffff811290bb>] do_init_module+0x5a/0x1ca
> Aug  5 15:39:14 localhost kernel: [  249.912678]  [<ffffffff810db8fa>] load_module+0x20ba/0x2510
> Aug  5 15:39:14 localhost kernel: [  249.912681]  [<ffffffff810d84e0>] ? __symbol_put+0x90/0x90
> Aug  5 15:39:14 localhost kernel: [  249.912686]  [<ffffffff810dbe88>] SYSC_init_module+0x138/0x150
> Aug  5 15:39:14 localhost kernel: [  249.912690]  [<ffffffff810dbf99>] SyS_init_module+0x9/0x10
> Aug  5 15:39:14 localhost kernel: [  249.912693]  [<ffffffff8157431f>] entry_SYSCALL_64_fastpath+0x17/0x93
> Aug  5 15:39:14 localhost kernel: [  249.912696] ---[ end trace 1443a8f8ae686883 ]---
> Aug  5 15:39:14 localhost kernel: [  249.912857] ------------[ cut here ]------------
> Aug  5 15:39:14 localhost kernel: [  249.912863] WARNING: CPU: 3 PID: 17892 at block/genhd.c:354 unregister_blkdev+0x72/0xc0
> Aug  5 15:39:14 localhost kernel: [  249.912865] Modules linked in: bcache(+) libcrc32c tun spadfs(O) mousedev vboxnetadp(O) vboxnetflt(O) nouveau vboxdrv(O) wmi video backlight i2c_algo_bit ttm fbcon bitblit softcursor font coretemp drm_kms_helper hwmon cfbfillrect syscopyarea kvm_intel snd_ens1371 snd_ac97_codec cfbimgblt kvm sysfillrect ac97_bus snd_rawmidi sysimgblt snd_pcm fb_sys_fops cfbcopyarea snd_timer snd drm 8250 8250_base e1000e irqbypass agpgart ptp fb soundcore fbdev pps_core serial_core evdev psmouse lpc_ich acpi_cpufreq button i2c_i801 i82975x_edac processor edac_core mfd_core zfs(PO) zunicode(PO) zcommon(PO) znvpair(PO) spl(O) zlib_deflate zavl(PO) sr_mod cdrom sata_sil [last unloaded: bcache]
> Aug  5 15:39:14 localhost kernel: [  249.912919] CPU: 3 PID: 17892 Comm: modprobe Tainted: P        W  O    4.7.0-bcache+ #4
> Aug  5 15:39:14 localhost kernel: [  249.912921] Hardware name:                  /D975XBX, BIOS BX97510J.86A.1487.2007.0902.1724 09/02/2007
> Aug  5 15:39:14 localhost kernel: [  249.912923]  0000000000000286 00000000e7ecea9b ffff88008e937be0 ffffffff812cbf1d
> Aug  5 15:39:14 localhost kernel: [  249.912927]  0000000000000000 0000000000000000 ffff88008e937c20 ffffffff810591b6
> Aug  5 15:39:14 localhost kernel: [  249.912932]  0000016200000001 0000000000000000 0000000000000000 ffffffffc09255d4
> Aug  5 15:39:14 localhost kernel: [  249.912935] Call Trace:
> Aug  5 15:39:14 localhost kernel: [  249.912938]  [<ffffffff812cbf1d>] dump_stack+0x4f/0x72
> Aug  5 15:39:14 localhost kernel: [  249.912941]  [<ffffffff810591b6>] __warn+0xc6/0xe0
> Aug  5 15:39:14 localhost kernel: [  249.912944]  [<ffffffff810592d8>] warn_slowpath_null+0x18/0x20
> Aug  5 15:39:14 localhost kernel: [  249.912947]  [<ffffffff812b25a2>] unregister_blkdev+0x72/0xc0
> Aug  5 15:39:14 localhost kernel: [  249.912966]  [<ffffffffc095412a>] ? bch_fs_init+0xa2/0xa2 [bcache]
> Aug  5 15:39:14 localhost kernel: [  249.912986]  [<ffffffffc08d7366>] bch_blockdev_exit+0x26/0x30 [bcache]
> Aug  5 15:39:14 localhost kernel: [  249.913007]  [<ffffffffc0913be3>] bcache_exit+0x13/0xa0 [bcache]
> Aug  5 15:39:14 localhost kernel: [  249.913026]  [<ffffffffc0954184>] bcache_init+0x5a/0x14c [bcache]
> Aug  5 15:39:14 localhost kernel: [  249.913029]  [<ffffffff8100042b>] do_one_initcall+0x4b/0x170
> Aug  5 15:39:14 localhost kernel: [  249.913032]  [<ffffffff81169d4c>] ? __vunmap+0x7c/0xc0
> Aug  5 15:39:14 localhost kernel: [  249.913035]  [<ffffffff81169ded>] ? vfree+0x2d/0x80
> Aug  5 15:39:14 localhost kernel: [  249.913038]  [<ffffffff811290bb>] do_init_module+0x5a/0x1ca
> Aug  5 15:39:14 localhost kernel: [  249.913041]  [<ffffffff810db8fa>] load_module+0x20ba/0x2510
> Aug  5 15:39:14 localhost kernel: [  249.913044]  [<ffffffff810d84e0>] ? __symbol_put+0x90/0x90
> Aug  5 15:39:14 localhost kernel: [  249.913048]  [<ffffffff810dbe88>] SYSC_init_module+0x138/0x150
> Aug  5 15:39:14 localhost kernel: [  249.913051]  [<ffffffff810dbf99>] SyS_init_module+0x9/0x10
> Aug  5 15:39:14 localhost kernel: [  249.913054]  [<ffffffff8157431f>] entry_SYSCALL_64_fastpath+0x17/0x93
> Aug  5 15:39:14 localhost kernel: [  249.913077] ---[ end trace 1443a8f8ae686884 ]---



Have a nice day/afternoon.
Marcin
