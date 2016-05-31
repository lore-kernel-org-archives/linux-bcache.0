From: Vojtech Pavlik <vojtech@suse.com>
Subject: Re: hang/stuck loop in bch_ptr_bad/bch_btree_iter_next_filter
Date: Tue, 31 May 2016 14:28:38 +0200
Message-ID: <20160531122838.GA14900@suse.cz>
References: <574D8185.5070105@scalableinformatics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34119 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943AbcEaM2l (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 31 May 2016 08:28:41 -0400
Content-Disposition: inline
In-Reply-To: <574D8185.5070105@scalableinformatics.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Joe Landman <landman@scalableinformatics.com>
Cc: linux-bcache@vger.kernel.org

Hello Joe,

this was fixed by commit 627ccd20b4ad3ba836472468208e2ac4dfadbf03.

Vojtech

On Tue, May 31, 2016 at 08:20:21AM -0400, Joe Landman wrote:
> Hi folks:
> 
>   3.8.20 kernel on a system with 256GB ram, Xeon E5-2680 v3 cpus (2x
> 6 cores).  (Debian 7) OS booted from PXE into a ramdisk
> 
> df -h /
> Filesystem      Size  Used Avail Use% Mounted on
> tmpfs           8.0G  3.8G  4.3G  47% /
> 
> Swap set up on a file:
> 
> swapon -s
> Filename                Type        Size    Used    Priority
> /data/swap/swapfile                     file        33554428    0 0
> 
> 
> Bcache set up atop the devices (SSD /dev/sdb and spinning disk RAID
> /dev/sda)
> 
> df -h /data
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/bcache0     12T  6.6T  5.3T  56% /data
> 
> (yes, swap is on top of that as well, which might be a/the problem)
> 
> This is in writeback mode.
> 
> What we are seeing is this (cpu stuck in bcache_gc, with a bad
> pointer).  I am wondering if the swap on the cache is a problem.
> Seems to occur after significant IO loads and heavy computing tasks
> have been running for a few hours.  After restart (forced), the
> dirty data is slowly dropping:
> 
> cat /sys/block/bcache0/bcache/dirty_data
> 97.9G
> 
> 
>  44 00 00 eb d8 0f 1f 00
> [1374092.191983] NMI watchdog: BUG: soft lockup - CPU#12 stuck for
> 23s! [bcache_gc:2989]
> [1374092.199907] Modules linked in: 8021q garp mrp stp llc bonding
> rdma_ucm ib_ucm ib_uverbs ib_umad ib_ipoib mlx4_ib(O) mlx_compat(O)
> af_packet ixgbe i40e igb cpufreq_ondemand cpufreq_powersave
> cpufreq_stats cpufreq_userspace cpufreq_conservative ib_iser rdma_cm
> iw_cm ib_cm ib_sa ib_mad ib_core ib_addr ipv6 nfsd dm_crypt joydev
> hid_generic usbhid hid iTCO_wdt iTCO_vendor_support
> x86_pkg_temp_thermal coretemp kvm_intel kvm crc32_pclmul
> crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 ablk_helper
> cryptd lrw gf128mul glue_helper microcode pcspkr sb_edac edac_core
> snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel
> snd_hda_controller snd_hda_codec ehci_pci ehci_hcd snd_pcm i2c_i801
> mei_me snd_timer lpc_ich usbcore snd i2c_core shpchp mfd_core
> usb_common soundcore mei ioatdma tpm_tis tpm ipmi_si rtc_cmos
> ipmi_msghandler evdev processor thermal_sys acpi_power_meter button
> dm_mirror dm_region_hash dm_log dm_mod iscsi_tcp libiscsi_tcp
> libiscsi scsi_transport_iscsi configfs e1000e raid1 md_mod sg ses
> enclosure sd_mod vxlan ip6_udp_tunnel dca udp_tunnel ptp ahci
> libahci libata aacraid scsi_mod pps_core [last unloaded: cpuid]
> [1374092.314940] CPU: 12 PID: 2989 Comm: bcache_gc Tainted: G W  O L
> 3.18.20.scalable #1
> [1374092.323475] Hardware name: Supermicro X10DRG-Q/X10DRG-Q, BIOS
> 1.0b 01/07/2015
> [1374092.330876] task: ffff883fd0e34960 ti: ffff883fa3cb0000
> task.ti: ffff883fa3cb0000
> [1374092.338621] RIP: 0010:[<ffffffff81634625>] [<ffffffff81634625>]
> bch_extent_bad+0x135/0x1c0
> [1374092.347297] RSP: 0000:ffff883fa3cb3ae8  EFLAGS: 00000206
> [1374092.352859] RAX: 0000000000000007 RBX: ffffffff816344b5 RCX:
> 000000000000000b
> [1374092.360258] RDX: ffff881fa3ff8000 RSI: 00000165a662b007 RDI:
> 0000000000000001
> [1374092.367657] RBP: ffff883fa3cb3b08 R08: ffff881f9f040000 R09:
> 0000000000000000
> [1374092.375056] R10: 000007ffffffffff R11: 0000000000000001 R12:
> ffff881f9f040000
> [1374092.382457] R13: ffff883d942c4dd8 R14: ffff883fa3cb3a58 R15:
> ffff883fa3cb3cf0
> [1374092.389857] FS:  0000000000000000(0000)
> GS:ffff883ffde00000(0000) knlGS:0000000000000000
> [1374092.398212] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [1374092.404207] CR2: 00007f61fba73ec0 CR3: 0000000001c14000 CR4:
> 00000000001407e0
> [1374092.411605] Stack:
> [1374092.413862]  ffffffff00000001 ffff883d942c4dd8 ffff883fa3cb3b58
> ffffffff8162b560
> [1374092.421757]  ffff883fa3cb3b18 ffffffff8162b56a ffff883fa3cb3b48
> ffffffff8162b389
> [1374092.429650]  00000000000009b7 ffff883bc4a679c8 ffff883fa3cb3cf0
> ffff881fa93bc1c8
> [1374092.437545] Call Trace:
> [1374092.440236]  [<ffffffff8162b560>] ? bch_ptr_invalid+0x10/0x10
> [1374092.446231]  [<ffffffff8162b56a>] bch_ptr_bad+0xa/0x10
> [1374092.451616]  [<ffffffff8162b389>] bch_btree_iter_next_filter+0x39/0x50
> [1374092.458393]  [<ffffffff8162b7d1>] btree_gc_count_keys+0x51/0x70
> [1374092.464561]  [<ffffffff816314af>] btree_gc_recurse+0x1bf/0x330
> [1374092.470640]  [<ffffffff8162cc23>] ? btree_gc_mark_node+0x63/0x240
> [1374092.476985]  [<ffffffff8109a071>] ? down_write_nested+0x91/0xb0
> [1374092.483152]  [<ffffffff81631752>] ? bch_btree_gc+0x132/0x5d0
> [1374092.489060]  [<ffffffff81631abd>] bch_btree_gc+0x49d/0x5d0
> [1374092.494792]  [<ffffffff81093c80>] ? __init_waitqueue_head+0x60/0x60
> [1374092.501309]  [<ffffffff81631c28>] bch_gc_thread+0x38/0x140
> [1374092.507043]  [<ffffffff81631bf0>] ? bch_btree_gc+0x5d0/0x5d0
> [1374092.512950]  [<ffffffff81073244>] kthread+0xe4/0x100
> [1374092.518163]  [<ffffffff81073160>] ? __init_kthread_worker+0x70/0x70
> [1374092.524680]  [<ffffffff8178f898>] ret_from_fork+0x58/0x90
> [1374092.530327]  [<ffffffff81073160>] ? __init_kthread_worker+0x70/0x70
> [1374092.536839] Code: 0f 00 00 49 8b 94 c0 d0 0c 00 00 48 89 f0 48
> c1 e8 08 4c 21 d0 48 d3 e8 4c 8b a2 08 0b 00 00 48 8d 04 40 49 8d 04
> 84 0f b6 40 06 <29> f0 3c 80 77 85 0f b6 d0 83 fa 60 0f 86 71 ff ff
> ff 41 0f b6
> 
> Thanks in advance for any guidance/advice
> 
> -- 
> Joseph Landman, Ph.D
> Founder and CEO
> Scalable Informatics, Inc.
> e: landman@scalableinformatics.com
> w: http://scalableinformatics.com
> t: @scalableinfo
> p: +1 734 786 8423 x121
> c: +1 734 612 4615
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Vojtech Pavlik
Director SUSE Labs
