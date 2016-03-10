From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: sysrq-o for safe bcache shutdown, what about reboot?
Date: Thu, 10 Mar 2016 07:07:02 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1603100557150.13488@mail.ewheeler.net>
References: <CA+nZN+i0fmEc0Uz1X5k0DJaNB_sNu2EP0dEUy32_ipsW66MFmA@mail.gmail.com> <alpine.LRH.2.11.1603090344040.15354@mail.ewheeler.net> <alpine.LRH.2.11.1603100125110.13488@mail.ewheeler.net> <20160310021516.GM14112@merlins.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([71.19.153.34]:50722 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753174AbcCJHHK (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 10 Mar 2016 02:07:10 -0500
In-Reply-To: <20160310021516.GM14112@merlins.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: Richard Bade <hitrich@gmail.com>, linux-bcache@vger.kernel.org

On Wed, 9 Mar 2016, Marc MERLIN wrote:
> That was before your patches of course, so I'll report back further
> crashes if any.
> 
> By the way, slightly related question. If I have a slightly hung system
> that will not reboot with 'reboot', if I use sysrq - e + u + s + b, I

I use r-e-i-s-u-b, but o is better I guess if you're at the console.  In 
severe situations, o might not work where b might.

IMHO, s before u.  If u fails, s may not complete depending on how hard 
unmount(s) failed.  But if there's a counter argument for u before s then 
I'd love to hear it.

bcache does he a reboot notifier in super.c:bcache_reboot(), not sure if 
's' will sync it, but if it syncs all filesystems, it would sync all upper 
layers down through bcache.  Probably.  I'm not sure if 's' or 'u' could 
be hooked by bcache.  

It would be interesting to add a sysrq that calls all reboot notifiers, or 
does an 'o' but reboots instead.  It would be interesting to hunt these 
down and find out what they do, exactly.  hmmm...

http://lxr.free-electrons.com/source/Documentation/sysrq.txt
 196 *  I want to add SysRQ key events to a module, how does it work?
 198 In order to register a basic function with the table, you must first include
 199 the header 'include/linux/sysrq.h' [...]

Hey, try this and see if it works.  Use '.' as the sysrq key for reboot or 
`echo . > /proc/sysrq-trigger`.  Not sure if that's a valid key from 
sysrq, but if it does what you like, I'll post to lmkl and see what they 
have to say about it:

========================================
diff --git a/kernel/reboot.c b/kernel/reboot.c
index d20c85d..e680383 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -16,6 +16,7 @@
 #include <linux/syscalls.h>
 #include <linux/syscore_ops.h>
 #include <linux/uaccess.h>
+#include <linux/sysrq.h>
 
 /*
  * this indicates whether you can reboot with ctrl-alt-del: the default is yes
@@ -555,3 +556,42 @@ static int __init reboot_setup(char *str)
 	return 1;
 }
 __setup("reboot=", reboot_setup);
+
+
+/*
+ * When the user hits Sys-Rq '.' to kernel_restart the machine this is the
+ * callback we use.
+ */
+
+static void do_krestart(struct work_struct *dummy)
+{
+	/* are these two necessary? */
+	lockdep_off();
+	local_irq_enable();
+
+	/* restart */
+	kernel_restart(NULL);
+}
+
+static DECLARE_WORK(krestart_work, do_krestart);
+
+static void handle_krestart(int key)
+{
+	/* run sysrq krestart on boot cpu */
+	schedule_work_on(cpumask_first(cpu_online_mask), &krestart_work);
+}
+
+static struct sysrq_key_op	sysrq_krestart_op = {
+	.handler        = handle_krestart,
+	.help_msg       = "kernel_restart(.)",
+	.action_msg     = "Gracefullish Restart",
+	.enable_mask	= SYSRQ_ENABLE_BOOT,
+};
+
+static int __init pm_sysrq_krestart_init(void)
+{
+	register_sysrq_key('.', &sysrq_krestart_op);
+	return 0;
+}
+
+subsys_initcall(pm_sysrq_krestart_init);
========================================

-Eric



> get:
> [213056.198133] sysrq: SysRq : Emergency Remount R/O
> [213058.266112] sysrq: SysRq : Emergency Sync
> [213061.704158] sysrq: SysRq : Resetting
> [213061.716559] ACPI MEMORY or I/O RESET_REG.
> 
> This does not properly stop bcache (I believe) or sw raid, or flush
> things properly.
> Instead of 'b', I usually use 'o', it does properly shut everything
> down, flush all IO and everything, but then also turns off my machine,
> and I have to rely on wake on lan to bring it back up, which mostly
> works, until maybe it won't one day :)
> 
> 'o' gives me the much reassuring:
> [ 1744.758691] sysrq: SysRq : Emergency Remount R/O
> [ 1745.867719] sysrq: SysRq : Emergency Sync
> [ 1747.482890] sysrq: SysRq : Power Off
> [ 1754.242984] Emergency Remount complete
> [ 1758.535234] bcache: bcache_reboot() Stopping all devices:
> [ 1758.551562] bcache: bcache_device_free() bcache0 stopped
> [ 1760.539050] bcache: bcache_reboot() Timeout waiting for devices to be closed
> [ 1760.560249] kvm: exiting hardware virtualization
> [ 1760.574844] sd 17:0:0:0: [sdr] Synchronizing SCSI cache
> [ 1760.590730] sd 17:0:0:0: [sdr] Stopping disk
> [ 1760.891076] sd 16:0:0:0: [sdq] Synchronizing SCSI cache
> [ 1760.911070] sd 16:0:0:0: [sdq] Stopping disk
> [ 1761.219149] sd 15:0:0:0: [sdp] Synchronizing SCSI cache
> [ 1761.235053] sd 15:0:0:0: [sdp] Stopping disk
> [ 1761.535120] sd 14:0:0:0: [sdo] Synchronizing SCSI cache
> [ 1761.555095] sd 14:0:0:0: [sdo] Stopping disk
> [ 1761.855112] sd 13:0:0:0: [sdn] Synchronizing SCSI cache
> [ 1761.870920] sd 13:0:0:0: [sdn] Stopping disk
> [ 1762.751983] sd 11:4:0:0: [sdm] Synchronizing SCSI cache
> [ 1762.767882] sd 11:4:0:0: [sdm] Stopping disk
> [ 1763.191203] sd 11:3:0:0: [sdl] Synchronizing SCSI cache
> [ 1763.207428] sd 11:3:0:0: [sdl] Stopping disk
> [ 1763.631534] sd 11:2:0:0: [sdk] Synchronizing SCSI cache
> [ 1763.647524] sd 11:2:0:0: [sdk] Stopping disk
> [ 1764.071512] sd 11:1:0:0: [sdj] Synchronizing SCSI cache
> [ 1764.087396] sd 11:1:0:0: [sdj] Stopping disk
> [ 1764.510467] sd 11:0:0:0: [sdi] Synchronizing SCSI cache
> [ 1764.526819] sd 11:0:0:0: [sdi] Stopping disk
> [ 1764.950319] sd 9:0:0:0: [sdh] Synchronizing SCSI cache
> [ 1764.966079] sd 9:0:0:0: [sdh] Stopping disk
> [ 1765.960508] sd 8:0:0:0: [sdg] Synchronizing SCSI cache
> [ 1765.978370] sd 8:0:0:0: [sdg] Stopping disk
> [ 1766.278896] r8169 0000:05:00.0: System wakeup enabled by ACPI
> [ 1766.442869] sd 3:0:0:0: [sdf] Synchronizing SCSI cache
> [ 1766.519912] sd 3:0:0:0: [sdf] Stopping disk
> [ 1767.014799] sd 2:0:0:0: [sde] Synchronizing SCSI cache
> [ 1767.042979] sd 2:0:0:0: [sde] Stopping disk
> [ 1767.864325] sd 1:0:1:0: [sdd] Synchronizing SCSI cache
> [ 1767.976656] sd 1:0:1:0: [sdd] Stopping disk
> [ 1768.754903] sd 1:0:0:0: [sdc] Synchronizing SCSI cache
> [ 1770.197116] sd 1:0:0:0: [sdc] Stopping disk
> [ 1771.084250] sd 0:0:1:0: [sdb] Synchronizing SCSI cache
> [ 1771.125229] sd 0:0:1:0: [sdb] Stopping disk
> [ 1771.558552] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [ 1771.574145] sd 0:0:0:0: [sda] Stopping disk
> [ 1772.008787] ACPI: Preparing to enter system sleep state S5
> [ 1772.026660] reboot: Power down
> [ 1772.037064] acpi_power_off called
> 
> Is there another way to get a proper flush of everything and still
> reboot instead of powering off?
> 
> Thanks,
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
> 
