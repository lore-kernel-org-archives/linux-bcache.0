From: Kai Krakow <hurikhan77@gmail.com>
Subject: [4.14.9] WARNING at kernel/workqueue.c:2035
 process_one_work+0x43/0x330
Date: Fri, 29 Dec 2017 14:25:33 +0100
Message-ID: <dbshhe-elm.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:47546 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750814AbdL2NZq (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 29 Dec 2017 08:25:46 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <glbd-linux-bcache@m.gmane.org>)
        id 1eUudO-0002Fl-Ea
        for linux-bcache@vger.kernel.org; Fri, 29 Dec 2017 14:23:38 +0100
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello!

I'm seeing the following backtrace rarely which seems to be bcache
related:

[ 8996.665841] ------------[ cut here ]------------
[ 8996.665847] WARNING: CPU: 5 PID: 152 at kernel/workqueue.c:2035 process_one_work+0x43/0x330
[ 8996.665848] Modules linked in: cifs ccm rfcomm fuse bridge stp llc xfs cachefiles bnep snd_hda_codec_hdmi snd_hda_codec_realtek btusb snd_hda_codec_generic btintel bluetooth snd_hda_intel iTCO_wdt snd_hda_codec snd_hda_core snd_pcm snd_timer rfkill ecdh_generic af_packet snd iTCO_vendor_support kvm_intel kvm soundcore lpc_ich rtc_cmos irqbypass uas usb_storage r8168(O) nvidia_drm(PO) vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) nvidia_uvm(PO) nvidia_modeset(PO) nvidia(PO) nct6775 hwmon_vid coretemp hwmon efivarfs
[ 8996.665872] CPU: 5 PID: 152 Comm: bcache Tainted: P           O    4.14.9-ck #1
[ 8996.665873] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./Z68 Pro3, BIOS L2.16A 02/22/2013
[ 8996.665880] task: ffff880419bbd5c0 task.stack: ffffc900003b4000
[ 8996.665882] RIP: 0010:process_one_work+0x43/0x330
[ 8996.665883] RSP: 0018:ffffc900003b7e78 EFLAGS: 00010006
[ 8996.665884] RAX: 0000000000000005 RBX: ffff88041905d540 RCX: ffff88042f21b0a0
[ 8996.665884] RDX: ffff88042f21b098 RSI: ffff880411008f08 RDI: ffff88041905d540
[ 8996.665885] RBP: ffff88042f21b080 R08: fffffffffffffffc R09: 0000000000000000
[ 8996.665886] R10: 0000000000000000 R11: 0000000000000017 R12: ffff88042f224200
[ 8996.665886] R13: 0000000000000000 R14: ffff88042f224280 R15: ffff880411008f08
[ 8996.665887] FS:  0000000000000000(0000) GS:ffff88042f340000(0000) knlGS:0000000000000000
[ 8996.665888] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 8996.665889] CR2: 00000000000000b0 CR3: 0000000002c0a004 CR4: 00000000001606e0
[ 8996.665889] Call Trace:
[ 8996.665894]  rescuer_thread+0x20d/0x380
[ 8996.665895]  kthread+0xf2/0x130
[ 8996.665897]  ? worker_thread+0x3e0/0x3e0
[ 8996.665898]  ? kthread_create_on_node+0x40/0x40
[ 8996.665901]  ret_from_fork+0x1f/0x30
[ 8996.665902] Code: c0 41 83 e4 04 4c 0f 45 e0 49 8b 44 24 08 44 8b a8 00 01 00 00 41 83 e5 20 f6 45 10 04 75 0e 65 8b 05 aa 13 f7 7e 3b 45 04 74 02 <0f> ff 48 b9 eb 83 b5 80 46 86 c8 61 49 0f af cf 48 c1 e9 3a 48
[ 8996.665923] ---[ end trace 97ac64ac8121d8c7 ]---


This was also seen with 4.13, maybe earlier.

It may be related to using the ck patchset but first, I'd like to ask
here.


-- 
Regards,
Kai

Replies to list-only preferred.
