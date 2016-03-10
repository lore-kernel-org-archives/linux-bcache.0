From: Marc MERLIN <marc@merlins.org>
Subject: Re: sysrq-o for safe bcache shutdown, what about reboot?
Date: Thu, 10 Mar 2016 09:46:17 -0800
Message-ID: <20160310174617.GT14112@merlins.org>
References: <CA+nZN+i0fmEc0Uz1X5k0DJaNB_sNu2EP0dEUy32_ipsW66MFmA@mail.gmail.com>
 <alpine.LRH.2.11.1603090344040.15354@mail.ewheeler.net>
 <alpine.LRH.2.11.1603100125110.13488@mail.ewheeler.net>
 <20160310021516.GM14112@merlins.org>
 <alpine.LRH.2.11.1603100557150.13488@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:60493 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbcCJRqX (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 10 Mar 2016 12:46:23 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1603100557150.13488@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Richard Bade <hitrich@gmail.com>, linux-bcache@vger.kernel.org

On Thu, Mar 10, 2016 at 07:07:02AM +0000, Eric Wheeler wrote:
> It would be interesting to add a sysrq that calls all reboot notifiers, or 
> does an 'o' but reboots instead.  It would be interesting to hunt these 
> down and find out what they do, exactly.  hmmm...
> 
> http://lxr.free-electrons.com/source/Documentation/sysrq.txt
>  196 *  I want to add SysRQ key events to a module, how does it work?
>  198 In order to register a basic function with the table, you must first include
>  199 the header 'include/linux/sysrq.h' [...]
> 
> Hey, try this and see if it works.  Use '.' as the sysrq key for reboot or 
> `echo . > /proc/sysrq-trigger`.  Not sure if that's a valid key from 
> sysrq, but if it does what you like, I'll post to lmkl and see what they 
> have to say about it:

Eh, talk about extra credit, thanks much for that.

I changed the key to 'x' because '.' didn't work, but otherwise it seems
to have worked fine, so thanks a bunch for that.
I'm surprised that we'd be the first people to notice this need, but
it's never too late to make linux better :) so thanks for your patch,
and indeed I think it's worth sending upstream for consideration.
 
[  622.392830] sysrq: SysRq : HELP : loglevel(0-9) reboot(b) crash(c) terminate-all-tasks(e) memory-full-oom-kill(f) kill-all-tasks(i) thaw-filesystems(j) sak(k) show-backtrace-all-active-cpus(l) show-memory-usage(m) nice-all-RT-tasks(n) poweroff(o) show-registers(p) show-all-timers(q) unraw(r) sync(s) show-task-states(t) unmount(u) force-fb(V) show-blocked-tasks(w) kernel_restart(x) dump-ftrace-buffer(z) 
[  630.587827] sysrq: SysRq : Gracefullish Restart
[  653.840897] bcache: bcache_reboot() Stopping all devices:
[  653.857210] bcache: bcache_device_free() bcache0 stopped
[  655.841896] bcache: bcache_reboot() Timeout waiting for devices to be closed
[  655.863099] kvm: exiting hardware virtualization
[  655.877707] sd 17:0:0:0: [sdr] Synchronizing SCSI cache
[  655.897948] sd 16:0:0:0: [sdq] Synchronizing SCSI cache
[  655.917940] sd 15:0:0:0: [sdp] Synchronizing SCSI cache
[  655.937941] sd 14:0:0:0: [sdo] Synchronizing SCSI cache
[  655.957938] sd 13:0:0:0: [sdn] Synchronizing SCSI cache
[  655.973718] sd 11:4:0:0: [sdm] Synchronizing SCSI cache
[  655.991024] sd 11:3:0:0: [sdl] Synchronizing SCSI cache
[  656.008218] sd 11:2:0:0: [sdk] Synchronizing SCSI cache
[  656.025367] sd 11:1:0:0: [sdj] Synchronizing SCSI cache
[  656.042531] sd 11:0:0:0: [sdi] Synchronizing SCSI cache
[  656.059546] sd 9:0:0:0: [sdh] Synchronizing SCSI cache
[  656.076342] sd 8:0:0:0: [sdg] Synchronizing SCSI cache
[  656.167161] sd 3:0:0:0: [sdf] Synchronizing SCSI cache
[  656.184725] sd 2:0:0:0: [sde] Synchronizing SCSI cache
[  656.202491] sd 1:0:1:0: [sdd] Synchronizing SCSI cache
[  656.219932] sd 1:0:0:0: [sdc] Synchronizing SCSI cache
[  656.237140] sd 0:0:1:0: [sdb] Synchronizing SCSI cache
[  656.254206] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  656.271897] reboot: Restarting system
[  656.284158] reboot: machine restart
[  656.296061] ACPI MEMORY or I/O RESET_REG.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
