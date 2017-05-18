From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: hang during suspend to RAM when bcache cache device is
 attached
Date: Thu, 18 May 2017 17:03:33 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1705181701520.19359@mail.ewheeler.net>
References: <87pof8rmqb.fsf@karlt.net> <87ziebqhjf.fsf@karlt.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1641074820-1575238545-1495127013=:19359"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:40758 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932938AbdERRDf (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 18 May 2017 13:03:35 -0400
In-Reply-To: <87ziebqhjf.fsf@karlt.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Karl Tomlinson <bugs+kernel@karlt.net>
Cc: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1641074820-1575238545-1495127013=:19359
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


On Thu, 18 May 2017, Karl Tomlinson wrote:

> When not panicing on the hung task, some more info is available on
> the console about the blocked sh task, which is detected after the
> kworker/0:0:4 task hang in the previous message.
> 
> Transcripting from the display with no_console_suspend:
> 
> task sh ... blocked for more than 120 seconds.
> 
> ? __schedule
> schedule
> blk_mq_freeze_queue_wait
> ? wake_up_atomic_t
> blk_mq_queue_reinit_work
> blk_mq_queue_reinit_dead
> cpuhp_invoke_callback
> _cpu_down
> freeze_secondary_cpus
> suspend_devices_and_enter
> pm_suspend
> state_store
> kobj_attr_store
> sysfs_kf_write
> kernfs_fop_write
> __vfs_write
> ? ...
> ? ...
> ? ...
> vfs_write
> SyS_write
> entry_SYSCALL_64_fastpath


Try the patch below, this is the only deadlock fix that isn't upstream 
that I'm aware of.  Your trace above doesn't indicate any bcache 
functions, so this could be hard to troubleshoot.


--
Eric Wheeler

-------------------------------------------------------------------
[PATCH] md/bcache: Fix a deadlock while calculating writeback rate

A bcache foreground write holds a read lock on the writeback_lock
rwsem. In order to complete and release the lock after the actual
write, it needs to update the index, which runs out of a workqueue.

If the bch_writeback_thread is starting to write back dirty data while
the foreground write still holds the lock, it tries to get a write
lock on the writeback lock, thus blocking until the foreground write
completes.

If at this moment a workqueue worker starts an update of the write-
back rate, while foreground write completions are queued behind it,
the update thread will try to get a read lock, which blocks, because
the writeback thread is trying to get a write lock. This blocks the
foreground writes behind it and locks up all writeback and foreground
writes.

Removing the read lock from the writeback rate update thread is the
simplest solution: the worst thing that will happen when the scan
for dirty data is inconsistent is a wrong P-factor in the PID controller.

Signed-off-by: Phillipp Röll <phillipp.roell@trafficplex.de>
---
 drivers/md/bcache/writeback.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 6ac2e48..90da3bd 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -75,14 +75,10 @@ static void update_writeback_rate(struct work_struct *work)
 					     struct cached_dev,
 					     writeback_rate_update);
 
-	down_read(&dc->writeback_lock);
-
 	if (atomic_read(&dc->has_dirty) &&
 	    dc->writeback_percent)
 		__update_writeback_rate(dc);
 
-	up_read(&dc->writeback_lock);
-
 	schedule_delayed_work(&dc->writeback_rate_update,
 			      dc->writeback_rate_update_seconds * HZ);
 }
-- 
2.10.0




> 
> The locks held are the same as reported with the kworker/0:0:4
> task hang, including both tasks holding a cpu_hotplug.lock.
> 
> The oops below looks like it may also be related.  This was with
> "echo devices > /sys/power/pm_test" and all modules loaded.
> A mem > state seemed to succeed, but may have led to some
> corruption as the subsequent freeze > state failed.  With a
> minimal set of modules, as for the previous stacks, having devices
> in pm_test detected no problems.
> 
> <6>[12239.045257] PM: Syncing filesystems ... done.
> <7>[12239.081011] PM: Preparing system for sleep (mem)
> <6>[12239.084967] Freezing user space processes ... (elapsed 0.023 seconds) done.
> <6>[12239.113587] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
> <7>[12239.117910] PM: Suspending system (mem)
> <4>[12239.121179] Suspending console(s) (use no_console_suspend to debug)
> <5>[12239.124860] sd 3:0:0:0: [sda] Synchronizing SCSI cache
> <5>[12239.124906] sd 3:0:0:0: [sda] Stopping disk
> <6>[12239.150415] e1000e: EEE TX LPI TIMER: 00000011
> <6>[12239.180905] [drm] probing gen 2 caps for device 8086:1901 = 261ad03/e
> <6>[12239.180908] [drm] PCIE gen 3 link speeds already enabled
> <6>[12239.187387] [drm] PCIE GART of 2048M enabled (table at 0x00000000001D6000).
> <6>[12239.187524] radeon 0000:01:00.0: WB enabled
> <6>[12239.187528] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 0x0000000080000c00 and cpu addr 0xffff88085ca83c00
> <6>[12239.187531] radeon 0000:01:00.0: fence driver on ring 1 use gpu addr 0x0000000080000c04 and cpu addr 0xffff88085ca83c04
> <6>[12239.187533] radeon 0000:01:00.0: fence driver on ring 2 use gpu addr 0x0000000080000c08 and cpu addr 0xffff88085ca83c08
> <6>[12239.187535] radeon 0000:01:00.0: fence driver on ring 3 use gpu addr 0x0000000080000c0c and cpu addr 0xffff88085ca83c0c
> <6>[12239.187537] radeon 0000:01:00.0: fence driver on ring 4 use gpu addr 0x0000000080000c10 and cpu addr 0xffff88085ca83c10
> Oops#1 Part8
> <6>[12239.187743] radeon 0000:01:00.0: fence driver on ring 5 use gpu addr 0x0000000000075a18 and cpu addr 0xffffc90003235a18
> <3>[12239.197907] radeon 0000:01:00.0: failed VCE resume (-22).
> <6>[12239.258802] ACPI : EC: event blocked
> <6>[12239.504784] [drm] ring test on 0 succeeded in 2 usecs
> <6>[12239.504787] [drm] ring test on 1 succeeded in 1 usecs
> <6>[12239.504790] [drm] ring test on 2 succeeded in 1 usecs
> <6>[12239.504801] [drm] ring test on 3 succeeded in 8 usecs
> <6>[12239.504806] [drm] ring test on 4 succeeded in 3 usecs
> <6>[12239.681909] [drm] ring test on 5 succeeded in 2 usecs
> <6>[12239.681912] [drm] UVD initialized successfully.
> <6>[12239.681977] [drm] ib test on ring 0 succeeded in 0 usecs
> <6>[12239.682000] [drm] ib test on ring 1 succeeded in 0 usecs
> <6>[12239.682019] [drm] ib test on ring 2 succeeded in 0 usecs
> <6>[12239.682159] [drm] ib test on ring 3 succeeded in 0 usecs
> <6>[12239.682312] [drm] ib test on ring 4 succeeded in 0 usecs
> <3>[12240.848914] [drm:uvd_v1_0_ib_test [radeon]] *ERROR* radeon: fence wait timed out.
> <3>[12240.848929] [drm:radeon_ib_ring_tests [radeon]] *ERROR* radeon: failed testing IB on ring 5 (-110).
> <3>[12240.848934] radeon 0000:01:00.0: scheduling IB failed (-12).
> <3>[12240.848943] [drm:radeon_vce_get_create_msg [radeon]] *ERROR* radeon: failed to schedule ib (-12).
> <3>[12240.848954] [drm:radeon_vce_ib_test [radeon]] *ERROR* radeon: failed to get create msg (-12).
> <3>[12240.848964] [drm:radeon_ib_ring_tests [radeon]] *ERROR* radeon: failed testing IB on ring 6 (-12).
> <3>[12240.848965] radeon 0000:01:00.0: scheduling IB failed (-12).
> <3>[12240.848974] [drm:radeon_vce_get_create_msg [radeon]] *ERROR* radeon: failed to schedule ib (-12).
> Oops#1 Part7
> <3>[12240.848983] [drm:radeon_vce_ib_test [radeon]] *ERROR* radeon: failed to get create msg (-12).
> <3>[12240.848993] [drm:radeon_ib_ring_tests [radeon]] *ERROR* radeon: failed testing IB on ring 7 (-12).
> <6>[12240.853464] snd_hda_intel 0000:01:00.1: Enabling via vga_switcheroo
> <6>[12241.409056] PM: suspend of devices complete after 2284.327 msecs
> <6>[12241.409057] suspend debug: Waiting for 5 second(s).
> <6>[12246.410628] ACPI : EC: event unblocked
> <4>[12246.410784] ACPI : button: The lid device is not compliant to SW_LID.
> <6>[12246.412679] rtc_cmos 00:02: System wakeup disabled by ACPI
> <6>[12246.418677] [drm] GuC firmware load skipped
> <5>[12246.420764] sd 3:0:0:0: [sda] Starting disk
> <6>[12246.458897] [drm] probing gen 2 caps for device 8086:1901 = 261ad03/e
> <6>[12246.458899] [drm] PCIE gen 3 link speeds already enabled
> <6>[12246.462268] [drm] PCIE GART of 2048M enabled (table at 0x00000000001D6000).
> <6>[12246.462353] radeon 0000:01:00.0: WB enabled
> <6>[12246.462354] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 0x0000000080000c00 and cpu addr 0xffff88085ca83c00
> <6>[12246.462355] radeon 0000:01:00.0: fence driver on ring 1 use gpu addr 0x0000000080000c04 and cpu addr 0xffff88085ca83c04
> <6>[12246.462356] radeon 0000:01:00.0: fence driver on ring 2 use gpu addr 0x0000000080000c08 and cpu addr 0xffff88085ca83c08
> <6>[12246.462356] radeon 0000:01:00.0: fence driver on ring 3 use gpu addr 0x0000000080000c0c and cpu addr 0xffff88085ca83c0c
> <6>[12246.462357] radeon 0000:01:00.0: fence driver on ring 4 use gpu addr 0x0000000080000c10 and cpu addr 0xffff88085ca83c10
> <6>[12246.462530] radeon 0000:01:00.0: fence driver on ring 5 use gpu addr 0x0000000000075a18 and cpu addr 0xffffc90003235a18
> Oops#1 Part6
> <3>[12246.472645] radeon 0000:01:00.0: failed VCE resume (-22).
> <6>[12246.742457] ata2: SATA link down (SStatus 0 SControl 300)
> <6>[12246.742601] ata4: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> <6>[12246.755723] ata4.00: configured for UDMA/133
> <6>[12246.791325] [drm] ring test on 0 succeeded in 3 usecs
> <6>[12246.791328] [drm] ring test on 1 succeeded in 1 usecs
> <6>[12246.791331] [drm] ring test on 2 succeeded in 1 usecs
> <6>[12246.791342] [drm] ring test on 3 succeeded in 8 usecs
> <6>[12246.791347] [drm] ring test on 4 succeeded in 3 usecs
> <6>[12246.968475] [drm] ring test on 5 succeeded in 2 usecs
> <6>[12246.968478] [drm] UVD initialized successfully.
> <6>[12246.968514] [drm] ib test on ring 0 succeeded in 0 usecs
> <6>[12246.968536] [drm] ib test on ring 1 succeeded in 0 usecs
> <6>[12246.968560] [drm] ib test on ring 2 succeeded in 0 usecs
> <6>[12246.968591] [drm] ib test on ring 3 succeeded in 0 usecs
> <6>[12246.968639] [drm] ib test on ring 4 succeeded in 0 usecs
> <3>[12248.128804] [drm:uvd_v1_0_ib_test [radeon]] *ERROR* radeon: fence wait timed out.
> <3>[12248.128838] [drm:radeon_ib_ring_tests [radeon]] *ERROR* radeon: failed testing IB on ring 5 (-110).
> <6>[12248.165985] PM: resume of devices complete after 1755.555 msecs
> <7>[12248.360886] PM: Finishing wakeup.
> <6>[12248.363224] Restarting tasks ... done.
> <6>[12248.368768] [drm] RC6 on
> <4>[12248.395739] thermal thermal_zone9: failed to read out thermal zone (-5)
> <6>[12248.683438] e1000e: enp0s31f6 NIC Link is Down
> <6>[12248.693459] IPv6: ADDRCONF(NETDEV_UP): wlp2s0: link is not ready
> <6>[12248.702186] iwlwifi 0000:02:00.0: L1 Enabled - LTR Enabled
> <6>[12248.709770] iwlwifi 0000:02:00.0: L1 Enabled - LTR Enabled
> <6>[12248.846378] iwlwifi 0000:02:00.0: L1 Enabled - LTR Enabled
> Oops#1 Part5
> <6>[12248.854054] iwlwifi 0000:02:00.0: L1 Enabled - LTR Enabled
> <6>[12248.949987] IPv6: ADDRCONF(NETDEV_UP): wlp2s0: link is not ready
> <6>[12248.967035] iwlwifi 0000:02:00.0: L1 Enabled - LTR Enabled
> <6>[12248.973426] iwlwifi 0000:02:00.0: L1 Enabled - LTR Enabled
> <6>[12249.104762] iwlwifi 0000:02:00.0: L1 Enabled - LTR Enabled
> <6>[12249.111913] iwlwifi 0000:02:00.0: L1 Enabled - LTR Enabled
> <6>[12249.210769] IPv6: ADDRCONF(NETDEV_UP): wlp2s0: link is not ready
> <6>[12249.218765] IPv6: ADDRCONF(NETDEV_UP): enp0s31f6: link is not ready
> <6>[12249.442367] IPv6: ADDRCONF(NETDEV_UP): enp0s31f6: link is not ready
> <6>[12249.491581] IPv6: ADDRCONF(NETDEV_UP): wlp2s0: link is not ready
> <6>[12252.061560] e1000e: enp0s31f6 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
> <6>[12252.065757] IPv6: ADDRCONF(NETDEV_CHANGE): enp0s31f6: link becomes ready
> <6>[12253.488873] snd_hda_intel 0000:01:00.1: Disabling via vga_switcheroo
> <6>[12352.023516] iwlwifi 0000:02:00.0: L1 Enabled - LTR Enabled
> <6>[12352.035082] iwlwifi 0000:02:00.0: L1 Enabled - LTR Enabled
> <6>[12352.167021] iwlwifi 0000:02:00.0: L1 Enabled - LTR Enabled
> <6>[12352.173974] iwlwifi 0000:02:00.0: L1 Enabled - LTR Enabled
> <6>[12352.271843] IPv6: ADDRCONF(NETDEV_UP): wlp2s0: link is not ready
> <6>[12671.021844] iwlwifi 0000:02:00.0: L1 Enabled - LTR Enabled
> <6>[12671.025361] iwlwifi 0000:02:00.0: L1 Enabled - LTR Enabled
> <6>[12671.157153] iwlwifi 0000:02:00.0: L1 Enabled - LTR Enabled
> <6>[12671.164139] iwlwifi 0000:02:00.0: L1 Enabled - LTR Enabled
> <6>[12671.262792] IPv6: ADDRCONF(NETDEV_UP): wlp2s0: link is not ready
> <6>[12987.024094] iwlwifi 0000:02:00.0: L1 Enabled - LTR Enabled
> <6>[12987.028675] iwlwifi 0000:02:00.0: L1 Enabled - LTR Enabled
> <6>[12987.159947] iwlwifi 0000:02:00.0: L1 Enabled - LTR Enabled
> Oops#1 Part4
> <6>[12987.163760] iwlwifi 0000:02:00.0: L1 Enabled - LTR Enabled
> <6>[12987.258137] IPv6: ADDRCONF(NETDEV_UP): wlp2s0: link is not ready
> <6>[13303.024167] iwlwifi 0000:02:00.0: L1 Enabled - LTR Enabled
> <6>[13303.028507] iwlwifi 0000:02:00.0: L1 Enabled - LTR Enabled
> <6>[13303.159618] iwlwifi 0000:02:00.0: L1 Enabled - LTR Enabled
> <6>[13303.163628] iwlwifi 0000:02:00.0: L1 Enabled - LTR Enabled
> <6>[13303.253698] IPv6: ADDRCONF(NETDEV_UP): wlp2s0: link is not ready
> <6>[13360.547037] PM: Syncing filesystems ... done.
> <7>[13360.576184] PM: Preparing system for sleep (freeze)
> <6>[13360.582656] Freezing user space processes ... (elapsed 0.001 seconds) done.
> <6>[13360.589304] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
> <7>[13360.595787] PM: Suspending system (freeze)
> <4>[13360.601037] Suspending console(s) (use no_console_suspend to debug)
> <5>[13360.606821] sd 3:0:0:0: [sda] Synchronizing SCSI cache
> <5>[13360.606882] sd 3:0:0:0: [sda] Stopping disk
> <6>[13360.616997] e1000e: EEE TX LPI TIMER: 00000011
> <6>[13360.646031] [drm] probing gen 2 caps for device 8086:1901 = 261ad03/e
> <6>[13360.646033] [drm] PCIE gen 3 link speeds already enabled
> <6>[13360.651489] [drm] PCIE GART of 2048M enabled (table at 0x00000000001D6000).
> <6>[13360.651618] radeon 0000:01:00.0: WB enabled
> <6>[13360.651621] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 0x0000000080000c00 and cpu addr 0xffff88085ca83c00
> <6>[13360.651623] radeon 0000:01:00.0: fence driver on ring 1 use gpu addr 0x0000000080000c04 and cpu addr 0xffff88085ca83c04
> <6>[13360.651625] radeon 0000:01:00.0: fence driver on ring 2 use gpu addr 0x0000000080000c08 and cpu addr 0xffff88085ca83c08
> <6>[13360.651626] radeon 0000:01:00.0: fence driver on ring 3 use gpu addr 0x0000000080000c0c and cpu addr 0xffff88085ca83c0c
> Oops#1 Part3
> <6>[13360.651628] radeon 0000:01:00.0: fence driver on ring 4 use gpu addr 0x0000000080000c10 and cpu addr 0xffff88085ca83c10
> <6>[13360.651811] radeon 0000:01:00.0: fence driver on ring 5 use gpu addr 0x0000000000075a18 and cpu addr 0xffffc90003235a18
> <3>[13360.661995] radeon 0000:01:00.0: failed VCE resume (-22).
> <6>[13360.711612] ACPI : EC: event blocked
> <4>[13360.721621] ------------[ cut here ]------------
> <2>[13360.721621] kernel BUG at block/blk-mq.c:474!
> <4>[13360.721622] invalid opcode: 0000 [#1] PREEMPT SMP
> <4>[13360.721642] Modules linked in: uvcvideo videobuf2_vmalloc videobuf2_memops btusb videobuf2_v4l2 videobuf2_core btintel videodev bluetooth media crc16 dell_wmi sparse_keymap iTCO_wdt mei_wdt rtsx_pci_sdmmc mmc_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crc32_pclmul intel_cstate dell_laptop dell_smbios dcdbas intel_uncore dell_smm_hwmon intel_rapl_perf efi_pstore psmouse pcspkr efivars tpm_crb snd_hda_codec_hdmi snd_hda_codec_generic arc4 vfat fat e1000e ptp pps_core iwlmvm i2c_i801 i2c_smbus mac80211 iwlwifi cfg80211 rtsx_pci snd_hda_intel snd_hda_codec snd_hda_core radeon snd_pcm snd_timer snd ttm xhci_pci soundcore xhci_hcd mei_me usbcore processor_thermal_device mei intel_soc_dts_iosf usb_common wmi battery int3403_thermal 8250 8250_base serial_co
 re dell_smo8800
> <4>[13360.721648]  pinctrl_sunrisepoint pinctrl_intel intel_lpss_acpi intel_lpss mfd_core i2c_hid int3402_thermal int340x_thermal_zone int3400_thermal acpi_thermal_rel dell_rbtn rfkill acpi_pad ac evdev tpm_tis tpm_tis_core acpi_als tpm kfifo_buf industrialio sch_fq_codel efivarfs
> <4>[13360.721650] CPU: 0 PID: 3819 Comm: kworker/u16:5 Not tainted 4.9.25-gentoo #11
> Oops#1 Part2
> <4>[13360.721650] Hardware name: Dell Inc. Precision 7710/0PMJX2, BIOS 1.10.7 02/09/2017
> <4>[13360.721653] Workqueue: events_unbound async_run_entry_fn
> <4>[13360.721654] task: ffff88085a6b8000 task.stack: ffffc90008d34000
> <4>[13360.721656] RIP: 0010:[<ffffffff812e0b25>]  [<ffffffff812e0b25>] blk_mq_requeue_request+0x25/0x30
> <4>[13360.721656] RSP: 0018:ffffc90008d37b40  EFLAGS: 00010212
> <4>[13360.721657] RAX: ffff880865330408 RBX: ffff880865330600 RCX: 0000000000002328
> <4>[13360.721657] RDX: 0000000000000007 RSI: ffff880865330600 RDI: ffff880865330600
> <4>[13360.721657] RBP: ffffc90008d37b48 R08: ffffffffffffffff R09: 0000000000000000
> <4>[13360.721658] R10: 0000000000000000 R11: 000000000000001d R12: ffff880867abf800
> <4>[13360.721658] R13: 0000000000000000 R14: ffff880869640b00 R15: 0000000000000300
> <4>[13360.721659] FS:  0000000000000000(0000) GS:ffff88088dc00000(0000) knlGS:0000000000000000
> <4>[13360.721659] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> <4>[13360.721660] CR2: 0000000001c640b8 CR3: 0000000001c07000 CR4: 00000000003406f0
> <4>[13360.721660] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> <4>[13360.721661] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> <4>[13360.721661] Stack:
> <4>[13360.721662]  ffff880865330600 ffffc90008d37b68 ffffffff81517d4f ffff880865330600
> <4>[13360.721664]  ffff880867abf800 ffffc90008d37b90 ffffffff8151b219 ffff880865330600
> <4>[13360.721665]  ffff88088dc5f200 0000000000000000 ffffc90008d37bb8 ffffffff812e09aa
> <4>[13360.721665] Call Trace:
> <4>[13360.721668]  [<ffffffff81517d4f>] nvme_requeue_req+0xf/0x50
> <4>[13360.721669]  [<ffffffff8151b219>] nvme_complete_rq+0xe9/0x140
> <4>[13360.721671]  [<ffffffff812e09aa>] __blk_mq_complete_request+0x7a/0x100
> Oops#1 Part1
> <4>[13360.721673]  [<ffffffff812e0a47>] blk_mq_complete_request+0x17/0x20
> <4>[13360.721674]  [<ffffffff81517c9d>] nvme_cancel_request+0x3d/0x40
> <4>[13360.721675]  [<ffffffff812e2b75>] bt_tags_for_each+0x95/0xe0
> <4>[13360.721676]  [<ffffffff81517c60>] ? nvme_sysfs_rescan+0x30/0x30
> <4>[13360.721677]  [<ffffffff81517c60>] ? nvme_sysfs_rescan+0x30/0x30
> <4>[13360.721678]  [<ffffffff812e2f6c>] blk_mq_tagset_busy_iter+0x6c/0x80
> <4>[13360.721679]  [<ffffffff8151b3d2>] nvme_dev_disable+0x102/0x330
> <4>[13360.721680]  [<ffffffff8151b615>] nvme_suspend+0x15/0x20
> <4>[13360.721682]  [<ffffffff8133c5e1>] pci_pm_suspend+0x71/0x140
> <4>[13360.721683]  [<ffffffff8133c570>] ? pci_pm_freeze+0xe0/0xe0
> <4>[13360.721684]  [<ffffffff814f2679>] dpm_run_callback.isra.8+0x29/0x70
> <4>[13360.721685]  [<ffffffff814f3103>] __device_suspend+0x113/0x2a0
> <4>[13360.721686]  [<ffffffff814f32aa>] async_suspend+0x1a/0x90
> <4>[13360.721687]  [<ffffffff8108d902>] async_run_entry_fn+0x32/0xe0
> <4>[13360.721689]  [<ffffffff8108583d>] process_one_work+0x12d/0x310
> <4>[13360.721689]  [<ffffffff81085a69>] worker_thread+0x49/0x480
> <4>[13360.721690]  [<ffffffff81085a20>] ? process_one_work+0x310/0x310
> <4>[13360.721691]  [<ffffffff8108ad62>] kthread+0xd2/0xf0
> <4>[13360.721692]  [<ffffffff8108ac90>] ? kthread_create_on_node+0x40/0x40
> <4>[13360.721694]  [<ffffffff816a5392>] ret_from_fork+0x22/0x30
> <4>[13360.721708] Code: 84 00 00 00 00 00 55 48 89 e5 53 48 89 fb e8 83 ea ff ff 48 8b 03 48 39 c3 75 10 48 89 df be 01 00 00 00 e8 3e ff ff ff 5b 5d c3 <0f> 0b 66 0f 1f 84 00 00 00 00 00 55 48 81 c7 98 07 00 00 48 89 
> <1>[13360.721709] RIP  [<ffffffff812e0b25>] blk_mq_requeue_request+0x25/0x30
> <4>[13360.721709]  RSP <ffffc90008d37b40>
> <4>[13360.721710] ---[ end trace 5487c29d0b451133 ]---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--1641074820-1575238545-1495127013=:19359--
