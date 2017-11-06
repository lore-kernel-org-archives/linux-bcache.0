From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: WARNING: CPU: 1 PID: 143 at kernel/workqueue.c:2035
 process_one_work+0x44/0x310
Date: Mon, 6 Nov 2017 03:40:13 -0500
Message-ID: <20171106084013.vh3ytmsurxh53fxn@kmo-pixel>
References: <20171106093200.0e163cbe@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qt0-f181.google.com ([209.85.216.181]:49499 "EHLO
        mail-qt0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752003AbdKFIkR (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 6 Nov 2017 03:40:17 -0500
Received: by mail-qt0-f181.google.com with SMTP id k31so9953453qta.6
        for <linux-bcache@vger.kernel.org>; Mon, 06 Nov 2017 00:40:17 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20171106093200.0e163cbe@jupiter.sol.kaishome.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kai Krakow <hurikhan77@gmail.com>
Cc: linux-bcache@vger.kernel.org

On Mon, Nov 06, 2017 at 09:32:00AM +0100, Kai Krakow wrote:
> From time to time during IO load I see the following warning probably
> related to bcache:
> 
> [61206.106503] ------------[ cut here ]------------
> [61206.106509] WARNING: CPU: 1 PID: 143 at kernel/workqueue.c:2035 process_one_work+0x44/0x310
> [61206.106510] Modules linked in: bridge stp llc veth rfcomm fuse bnep cachefiles snd_hda_codec_realtek snd_hda_codec_hdmi btusb btintel bluetooth snd_hda_codec_generic rfkill ecdh_generic snd_hda_intel snd_hda_codec snd_hda_core snd_pcm snd_timer af_packet iTCO_wdt iTCO_vendor_support snd tun lpc_ich soundcore rtc_cmos kvm_intel kvm irqbypass uas usb_storage r8168(O) nvidia_drm(PO) vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) nvidia_uvm(PO) nvidia_modeset(PO) nvidia(PO) nct6775 hwmon_vid coretemp hwmon efivarfs
> [61206.106528] CPU: 1 PID: 143 Comm: bcache Tainted: P           O    4.13.11-ck #1
> [61206.106529] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./Z68 Pro3, BIOS L2.16A 02/22/2013
> [61206.106532] task: ffff880419459880 task.stack: ffffc90000584000
> [61206.106533] RIP: 0010:process_one_work+0x44/0x310
> [61206.106534] RSP: 0018:ffffc90000587e78 EFLAGS: 00210097
> [61206.106534] RAX: 0000000000000001 RBX: ffff880419a6c0c0 RCX: ffff88042f297f60
> [61206.106535] RDX: ffff88042f297f58 RSI: ffff880036d155f8 RDI: ffff880419a6c0c0
> [61206.106535] RBP: ffff88042f297f40 R08: 0000000000000000 R09: 0000000000000000
> [61206.106536] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> [61206.106536] R13: ffff88042f2a1800 R14: ffff88042f2a1880 R15: ffff880419a6c0f0
> [61206.106537] FS:  0000000000000000(0000) GS:ffff88042f240000(0000) knlGS:0000000000000000
> [61206.106537] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [61206.106538] CR2: 00000000000000b0 CR3: 0000000002c0a000 CR4: 00000000001406e0
> [61206.106538] Call Trace:
> [61206.106540]  ? rescuer_thread+0x20b/0x370
> [61206.106542]  ? kthread+0xf2/0x130
> [61206.106542]  ? process_one_work+0x310/0x310
> [61206.106543]  ? kthread_create_on_node+0x40/0x40
> [61206.106545]  ? ret_from_fork+0x22/0x30
> [61206.106546] Code: 04 b8 00 00 00 00 4c 0f 44 e8 49 8b 45 08 44 8b a0 00 01 00 00 41 83 e4 20 f6 45 10 04 75 0e 65 8b 05 b9 0c f7 7e 3b 45 04 74 02 <0f> ff 48 ba eb 83 b5 80 46 86 c8 61 48 0f af d6 48 c1 ea 3a 48
> [61206.106559] ---[ end trace 4e29a063c356211b ]---
> 
> When I compile the kernel with transparent huge pages support and/or do
> not blacklist the floppy.ko module, this warning usually has a
> more severe impact and damages the file system and the system itself
> becomes unresponsive.
> 
> This time the system seems to have survived (it's responsive, memory
> allocations seem to be fine, IO is working across all devices).
> 
> I've seen this previously and first disabled transparent huge pages
> because memory allocations were involved (and then there were following
> backtraces with btrfs involved). Next time it hit me, the floppy module
> was involved in the backtrace (tho I don't see why, I have no floppy
> controller, the module becomes loaded nevertheless), so I blacklisted
> it. By that time, btrfs was also involved into following backtraces.
> 
> Now, with both disabled, I only see "Comm: bcache", the only clue
> bcache related. And I'm seeing only this backtrace and not a whole
> bunch of backtraces eventually leading up to filesystem corruption.
> 
> Can you make any use of this?

What kernel version?
