From: Marc MERLIN <marc@merlins.org>
Subject: Re: Bcache still unstable for me (memory problems)
Date: Wed, 9 Mar 2016 18:15:16 -0800
Message-ID: <20160310021516.GM14112@merlins.org>
References: <CA+nZN+i0fmEc0Uz1X5k0DJaNB_sNu2EP0dEUy32_ipsW66MFmA@mail.gmail.com>
 <alpine.LRH.2.11.1603090344040.15354@mail.ewheeler.net>
 <alpine.LRH.2.11.1603100125110.13488@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:51430 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932719AbcCJCPY (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 9 Mar 2016 21:15:24 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1603100125110.13488@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Richard Bade <hitrich@gmail.com>, linux-bcache@vger.kernel.org

On Thu, Mar 10, 2016 at 01:34:56AM +0000, Eric Wheeler wrote:
> Hi Richard, Marc,
> 
> >>> [290623.673871] bcache-register: page allocation failure: order:7, mode:0x24080c0
> 
> Do you still have the backtraces that show the function call stack for 
> errors that look like this?
> 	%s: page allocation failure: order:%d, mode:0x%x 
> 
> Please send as many relevant OOM failure traces that you can.  I would 
> like to see which memory allocation(s) are failing and if they are always 
> the same stack trace.
 
It's the same one I already sent you, just from syslog instead of serial
console (I was looking for other relevant cronjobs or errors per your
request)

> In the example above, order 7 means 2^7 of 4k pages, so it means the 
> kernel can't find 512k of contiguous memory that can be allocated.
> 
> It looks like the OOM is triggered in bch_cache_set_alloc, but might be 
> cache_alloc too.  I'm not sure if an alternate allocation mechanism can be 
> used safely, but thats what I want to look into.

That was before your patches of course, so I'll report back further
crashes if any.

By the way, slightly related question. If I have a slightly hung system
that will not reboot with 'reboot', if I use sysrq - e + u + s + b, I
get:
[213056.198133] sysrq: SysRq : Emergency Remount R/O
[213058.266112] sysrq: SysRq : Emergency Sync
[213061.704158] sysrq: SysRq : Resetting
[213061.716559] ACPI MEMORY or I/O RESET_REG.

This does not properly stop bcache (I believe) or sw raid, or flush
things properly.
Instead of 'b', I usually use 'o', it does properly shut everything
down, flush all IO and everything, but then also turns off my machine,
and I have to rely on wake on lan to bring it back up, which mostly
works, until maybe it won't one day :)

'o' gives me the much reassuring:
[ 1744.758691] sysrq: SysRq : Emergency Remount R/O
[ 1745.867719] sysrq: SysRq : Emergency Sync
[ 1747.482890] sysrq: SysRq : Power Off
[ 1754.242984] Emergency Remount complete
[ 1758.535234] bcache: bcache_reboot() Stopping all devices:
[ 1758.551562] bcache: bcache_device_free() bcache0 stopped
[ 1760.539050] bcache: bcache_reboot() Timeout waiting for devices to be closed
[ 1760.560249] kvm: exiting hardware virtualization
[ 1760.574844] sd 17:0:0:0: [sdr] Synchronizing SCSI cache
[ 1760.590730] sd 17:0:0:0: [sdr] Stopping disk
[ 1760.891076] sd 16:0:0:0: [sdq] Synchronizing SCSI cache
[ 1760.911070] sd 16:0:0:0: [sdq] Stopping disk
[ 1761.219149] sd 15:0:0:0: [sdp] Synchronizing SCSI cache
[ 1761.235053] sd 15:0:0:0: [sdp] Stopping disk
[ 1761.535120] sd 14:0:0:0: [sdo] Synchronizing SCSI cache
[ 1761.555095] sd 14:0:0:0: [sdo] Stopping disk
[ 1761.855112] sd 13:0:0:0: [sdn] Synchronizing SCSI cache
[ 1761.870920] sd 13:0:0:0: [sdn] Stopping disk
[ 1762.751983] sd 11:4:0:0: [sdm] Synchronizing SCSI cache
[ 1762.767882] sd 11:4:0:0: [sdm] Stopping disk
[ 1763.191203] sd 11:3:0:0: [sdl] Synchronizing SCSI cache
[ 1763.207428] sd 11:3:0:0: [sdl] Stopping disk
[ 1763.631534] sd 11:2:0:0: [sdk] Synchronizing SCSI cache
[ 1763.647524] sd 11:2:0:0: [sdk] Stopping disk
[ 1764.071512] sd 11:1:0:0: [sdj] Synchronizing SCSI cache
[ 1764.087396] sd 11:1:0:0: [sdj] Stopping disk
[ 1764.510467] sd 11:0:0:0: [sdi] Synchronizing SCSI cache
[ 1764.526819] sd 11:0:0:0: [sdi] Stopping disk
[ 1764.950319] sd 9:0:0:0: [sdh] Synchronizing SCSI cache
[ 1764.966079] sd 9:0:0:0: [sdh] Stopping disk
[ 1765.960508] sd 8:0:0:0: [sdg] Synchronizing SCSI cache
[ 1765.978370] sd 8:0:0:0: [sdg] Stopping disk
[ 1766.278896] r8169 0000:05:00.0: System wakeup enabled by ACPI
[ 1766.442869] sd 3:0:0:0: [sdf] Synchronizing SCSI cache
[ 1766.519912] sd 3:0:0:0: [sdf] Stopping disk
[ 1767.014799] sd 2:0:0:0: [sde] Synchronizing SCSI cache
[ 1767.042979] sd 2:0:0:0: [sde] Stopping disk
[ 1767.864325] sd 1:0:1:0: [sdd] Synchronizing SCSI cache
[ 1767.976656] sd 1:0:1:0: [sdd] Stopping disk
[ 1768.754903] sd 1:0:0:0: [sdc] Synchronizing SCSI cache
[ 1770.197116] sd 1:0:0:0: [sdc] Stopping disk
[ 1771.084250] sd 0:0:1:0: [sdb] Synchronizing SCSI cache
[ 1771.125229] sd 0:0:1:0: [sdb] Stopping disk
[ 1771.558552] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 1771.574145] sd 0:0:0:0: [sda] Stopping disk
[ 1772.008787] ACPI: Preparing to enter system sleep state S5
[ 1772.026660] reboot: Power down
[ 1772.037064] acpi_power_off called

Is there another way to get a proper flush of everything and still
reboot instead of powering off?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
