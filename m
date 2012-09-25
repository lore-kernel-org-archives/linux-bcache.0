From: Brad Walker <bwalker-WlSugiYO8JFBDgjK7y7TUQ@public.gmane.org>
Subject: bcache hangs..
Date: Tue, 25 Sep 2012 13:46:54 -0600
Message-ID: <CAPKZHbX86Jw6JYEkO8zSJqxXezXtEg_+mRGOSjzhz4NZHn-ueQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

I have a problem where BCache is hanging.

My hardware is:
1 - Dell PowerEdge R710 w/ 24 x Xeon processors, 96GB of ram
2 - Micron P320H SSD
3 - LSI storage device connected by a SAS interface

The steps that I take to cause this hang are:
1 - make-bcache -w4k --cache /dev/rssda1 - WORKS
2 - make-bcache --bdev /dev/mapper/largevol - WORKS
3 - echo "/dev/mapper/largevol" > /sys/fs/bcache/register - WORKS
4 - echo "/dev/rssda1" > /sys/fs/bcache/register - HANGS

When it hangs I see the following in dmesg..

[ 3268.467982] bcache: invalidating existing data

Then some time later I get the following error message..

[ 3294.938341] BUG: soft lockup - CPU#2 stuck for 22s! [kworker/2:2:6785]
[ 3294.938345] Modules linked in: binfmt_misc edd mperf fuse loop
pciehp pci_hotplug coretemp kvm crc32c_intel ghash_clmulni_intel
aesni_intel ablk_helper i7core_edac iTCO_wdt iTCO_vendor_support
cryptd edac_core lpc_ich aes_x86_64 mtip32xx(O) bnx2 wmi sg mfd_core
sr_mod joydev aes_generic hid_generic cdrom acpi_power_meter microcode
dcdbas pcspkr serio_raw button rtc_cmos mptctl dm_mirror
dm_region_hash dm_log linear usbhid hid uhci_hcd ehci_hcd qla2xxx
usbcore usb_common scsi_transport_fc sd_mod scsi_tgt crc_t10dif
processor thermal_sys hwmon scsi_dh_hp_sw scsi_dh_emc scsi_dh_alua
scsi_dh_rdac scsi_dh dm_snapshot dm_mod ext3 mbcache jbd ata_generic
ata_piix libata mptsas mptscsih mptbase mpt2sas scsi_transport_sas
raid_class scsi_mod
[ 3294.938381] CPU 2
[ 3294.938384] Pid: 6785, comm: kworker/2:2 Tainted: G           O
3.6.0-rc3-0.5-default+ #1 Dell Inc. PowerEdge R710/00NH4P
[ 3294.938385] RIP: 0010:[<ffffffff81049b70>]  [<ffffffff81049b70>]
__do_softirq+0x70/0x210
[ 3294.938392] RSP: 0018:ffff88183f243ee0  EFLAGS: 00000206
[ 3294.938393] RAX: ffff8817dc74dfd8 RBX: ffff88183f24d8c0 RCX: 0000000000000002
[ 3294.938394] RDX: 0000000000000002 RSI: 000000000000004b RDI: ffffffffff5fa380
[ 3294.938394] RBP: ffff88183f243f40 R08: 0000000000000000 R09: ffffffff816057c0
[ 3294.938395] R10: 0000000000000400 R11: ffff88183f2529a0 R12: ffff88183f243e58
[ 3294.938396] R13: ffffffff8147010a R14: ffff88183f243f40 R15: 0000000000000046
[ 3294.938397] FS:  0000000000000000(0000) GS:ffff88183f240000(0000)
knlGS:0000000000000000
[ 3294.938399] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 3294.938400] CR2: ffffe8ffffa00000 CR3: 00000017dbb00000 CR4: 00000000000007e0
[ 3294.938401] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 3294.938402] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 3294.938403] Process kworker/2:2 (pid: 6785, threadinfo
ffff8817dc74c000, task ffff8817d71ea340)
[ 3294.938403] Stack:
[ 3294.938404]  ffff88183f24d940 ffff8817dc74dfd8 ffff8817dc74dfd8
042080603f243f08
[ 3294.938407]  ffffffff8109715f 0000000a3f243f88 ffffffff00000002
ffff8817dc74dfd8
[ 3294.938410]  0000000000000046 ffff8817d6fdc000 ffff8817d6fdca10
ffff8817dc74ddc8
[ 3294.938412] Call Trace:
[ 3294.938413]  <IRQ>
[ 3294.938414]  [<ffffffff8109715f>] ? tick_program_event+0x1f/0x30
[ 3294.938424]  [<ffffffff814707fc>] call_softirq+0x1c/0x30
[ 3294.938428]  [<ffffffff810043c5>] do_softirq+0x65/0xa0
[ 3294.938429]  [<ffffffff810499c5>] irq_exit+0xc5/0xe0
[ 3294.938432]  [<ffffffff81027759>] smp_apic_timer_interrupt+0x69/0xa0
[ 3294.938434]  [<ffffffff8147010a>] apic_timer_interrupt+0x6a/0x70
[ 3294.938435]  <EOI>
[ 3294.938436]  [<ffffffff8134d23e>] ? invalidate_buckets_lru+0x2fe/0x7f0
[ 3294.938440]  [<ffffffff8134d8f5>] invalidate_buckets+0x1c5/0x1f0
[ 3294.938442]  [<ffffffff8134dc38>] bch_allocator_thread+0x318/0x690
[ 3294.938447]  [<ffffffff81064ab0>] ? wake_up_bit+0x40/0x40
[ 3294.938450]  [<ffffffff810708db>] ? complete+0x4b/0x60
[ 3294.938452]  [<ffffffff8105c8a3>] process_one_work+0x1d3/0x370
[ 3294.938454]  [<ffffffff8134d920>] ? invalidate_buckets+0x1f0/0x1f0
[ 3294.938456]  [<ffffffff8105f5e3>] worker_thread+0x133/0x390
[ 3294.938457]  [<ffffffff8105f4b0>] ? manage_workers+0x70/0x70
[ 3294.938459]  [<ffffffff810643fe>] kthread+0x9e/0xb0
[ 3294.938461]  [<ffffffff81470704>] kernel_thread_helper+0x4/0x10
[ 3294.938463]  [<ffffffff81064360>] ? kthread_freezable_should_stop+0x70/0x70
[ 3294.938465]  [<ffffffff81470700>] ? gs_change+0x13/0x13
[ 3294.938465] Code: 25 20 b0 00 00 41 89 d6 89 4d d0 c7 45 cc 0a 00
00 00 48 89 45 b0 48 89 45 a8 90 65 c7 04 25 00 05 01 00 00 00 00 00
fb 66 66 90 <66> 66 90 45 31 ed 66 2e 0f 1f 84 00 00 00 00 00 49 8d 85
80 40
[ 3300.603968] ata1: lost interrupt (Status 0x58)
[ 3300.646011] ata1: drained 65536 bytes to clear DRQ
[ 3300.646054] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[ 3300.646057] sr 2:0:0:0: CDB:
[ 3300.646058] Get event status notification: 4a 01 00 00 10 00 00 00 08 00
[ 3300.646065] ata1.00: cmd a0/00:00:00:08:00/00:00:00:00:00/a0 tag 0
pio 16392 in
[ 3300.646065]          res 40/00:02:00:08:00/00:00:00:00:00/a0 Emask
0x4 (timeout)
[ 3300.646075] ata1.00: status: { DRDY }
[ 3300.646085] ata1: hard resetting link
[ 3301.119798] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 3301.143856] ata1.00: configured for UDMA/100
[ 3301.144955] ata1: EH complete
[ 3322.926498] BUG: soft lockup - CPU#2 stuck for 22s! [kworker/2:2:6785]

This is reproducible.

Any ideas on how to proceed or what I can do to help you debug this
are most appreciated.

-brad w.
