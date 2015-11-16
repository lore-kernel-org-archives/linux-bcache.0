From: "Yannis Aribaud" <bugs@d6bell.net>
Subject: Re: bcache_gc: BUG: soft lockup
Date: Mon, 16 Nov 2015 10:26:18 +0000
Message-ID: <00dfbe23dbb94c22c8873ecaf5d1dfbc@rcube.hebserv.net>
References: <1447661397.2726.1.camel@suse.de>
 <2f979d1d6e991272cebc8ff40a955c8a@rcube.hebserv.net>
 <1447419912.2616.19.camel@suse.de> <1447418245.2616.15.camel@suse.de>
 <648d9a0567372b10a3861eee8320328c@rcube.hebserv.net>
 <7d53afb3c7a34bb1022f0d9b6c079022@rcube.hebserv.net>
 <9c96132d5fce4a5a77b1b086f7c6095d@rcube.hebserv.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from dbmail.hebserv.net ([78.40.121.80]:38518 "EHLO
	dbmail.hebserv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbbKPK0X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 16 Nov 2015 05:26:23 -0500
In-Reply-To: <1447661397.2726.1.camel@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, linux-bcache@vger.kernel.org

Hi,

I got this stack trace on an other node running the same 4.1.12 kernel, but this time on a live node (not during shutdown).


[1181894.806808] Modules linked in: cbc rbd libceph ipmi_si mpt2sas raid_class scsi_transport_sas ipmi_devintf dell_rbu tun nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc bridge 8021q garp mrp stp llc bonding xfs libcrc32c bcache uhci_hcd ohci_hcd joydev hid_generic usbhid hid iTCO_wdt iTCO_vendor_support x86_pkg_temp_thermal coretemp kvm_intel dcdbas kvm shpchp aesni_intel aes_x86_64 ablk_helper cryptd lrw gf128mul glue_helper microcode evdev ehci_pci ehci_hcd sb_edac usbcore edac_core usb_common lpc_ich ipmi_msghandler mfd_core acpi_cpufreq processor wmi thermal_sys acpi_power_meter button ext4 crc16 mbcache jbd2 btrfs xor raid6_pq dm_mod sg sd_mod crc32c_intel igb megaraid_sas i2c_algo_bit i2c_core dca ptp scsi_mod pps_core [last unloaded: ipmi_si]
[1181894.806839] CPU: 13 PID: 74 Comm: migration/13 Tainted: G             L  4.1.12-ig1 #2
[1181894.806840] Hardware name: Dell Inc. PowerEdge R730xd/0H21J3, BIOS 1.1.4 11/03/2014
[1181894.806841] task: ffff8820786894b0 ti: ffff882078698000 task.ti: ffff882078698000
[1181894.806842] RIP: 0010:[<ffffffff810a72e6>]  [<ffffffff810a72e6>] multi_cpu_stop+0x52/0x99
[1181894.806846] RSP: 0000:ffff88207869bdb8  EFLAGS: 00000293
[1181894.806847] RAX: 0000000000000000 RBX: 0000000000000187 RCX: ffff88207eccfd18
[1181894.806848] RDX: 0000000000000001 RSI: 0000000000000282 RDI: ffff88202f1e3bc0
[1181894.806849] RBP: 0000000000000001 R08: ffff882078698000 R09: ffff882078698000
[1181894.806850] R10: 0000000000000000 R11: ffff8820361280d0 R12: 0000000000000000
[1181894.806851] R13: ffff88207ecd4f00 R14: 0000000d00000004 R15: ffff88107f454f00
[1181894.806853] FS:  0000000000000000(0000) GS:ffff88207ecc0000(0000) knlGS:0000000000000000
[1181894.806854] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[1181894.806855] CR2: 0000000016053400 CR3: 000000000160b000 CR4: 00000000001406e0
[1181894.806856] Stack:
[1181894.806857]  ffff8820361280d0 ffff88207eccfd10 ffff88202f1e3be8 ffff88202f1e3bc0
[1181894.806859]  ffffffff810a7294 ffffffff810a718a ffff882078689a08 ffff8820786894b0
[1181894.806860]  ffff88207ecd4f00 ffffffff8105bae5 ffff88207ecd4f00 ffff8820786894b0
[1181894.806862] Call Trace:
[1181894.806865]  [<ffffffff810a7294>] ? cpu_stop_should_run+0x3d/0x3d
[1181894.806866]  [<ffffffff810a718a>] ? cpu_stopper_thread+0x68/0xde
[1181894.806868]  [<ffffffff8105bae5>] ? finish_task_switch+0x51/0xcb
[1181894.806871]  [<ffffffff8138ff4f>] ? console_conditional_schedule+0xf/0xf
[1181894.806872]  [<ffffffff8138e43f>] ? __schedule+0x3f5/0x4e0
[1181894.806875]  [<ffffffff81058604>] ? sort_range+0x19/0x19
[1181894.806877]  [<ffffffff8105872a>] ? smpboot_thread_fn+0x126/0x13e
[1181894.806878]  [<ffffffff81056225>] ? kthread+0x99/0xa1
[1181894.806880]  [<ffffffff8105618c>] ? __kthread_parkme+0x58/0x58
[1181894.806882]  [<ffffffff81390d12>] ? ret_from_fork+0x42/0x70
[1181894.806883]  [<ffffffff8105618c>] ? __kthread_parkme+0x58/0x58
[1181894.806884] Code: 02 00 00 e8 51 60 12 00 39 c5 41 0f 94 c4 eb 0e 89 ed 48 0f a3 28 19 ed 85 ed 41 0f 95 c4 31 c0 31 d2 eb 02 89 ea f3 90 8b 6b 20 <39> d5 74 20 83 fd 02 74 07 83 fd 03 75 10 eb 03 fa eb 0b 45 84 

dmesg keeps filling with such message and devices are unresponsive. Forced to reboot.

Regards,
-- 
Open is better
