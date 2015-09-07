From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: Re: Bcache stuck at writeback of a key, consuming 100% CPU, not
 possible to detach
Date: Mon, 07 Sep 2015 17:13:18 +0200
Message-ID: <20150907171318.Horde.LCssHlKH7jqwmHt1ENeCSCd@www3.nde.ag>
References: <20150830085442.GA31722@suse.com>
 <20150905130658.Horde.bdSqYx_a293KuFa5vdTuajm@www3.nde.ag>
 <20150905112955.GA4078@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.183]:58716 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbbIGPN3 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 7 Sep 2015 11:13:29 -0400
In-Reply-To: <20150905112955.GA4078@suse.com>
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Vojtech Pavlik <vojtech@suse.com>, Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

Hi Vojtech,

Zitat von Vojtech Pavlik <vojtech@suse.com>:
> This matches my situation and behavior exactly. Including the fact that
> the backing device is a md raid.
> [...]
> I've sent an one-liner patch to the mailing list a few moments ago that
> fixes the issue.

I've added your patch to our kernel. Just for your reference, the  
system is running Opensuse 13.1, with the kernel from

--- cut here ---
Information for package kernel-source:
--------------------------------------
Repository: conecenter
Name: kernel-source
Version: 3.18.8-5.1
Arch: noarch
Vendor: obs://build.opensuse.org/home:conecenter
Installed: Yes
Status: up-to-date
Installed Size: 471.5 MiB
Summary: The Linux Kernel Sources
Description:
Linux kernel sources with many fixes and improvements.


Source Timestamp: 2015-02-06 23:35:46 +0200
GIT Revision: ec2a744f14f988690583c04bd910145cd5a1f3c9
GIT Branch: stable
--- cut here ---

and the patches

bcache001.eml:Subject: [PATCH] bcache: [BUG] clear  
BCACHE_DEV_UNLINK_DONE flag when attaching a backing device
bcache002.eml:Subject: [PATCH] bcache: fix a livelock in btree lock
bcache003.eml:Subject: [PATCH] bcache: unregister reboot notifier when  
bcache fails to register a block device
bcache004.eml:Subject: [PATCH] fix a leak in bch_cached_dev_run()
bcache005.eml:Subject: [PATCH] bcache: Fix writeback_thread never  
writing back incomplete stripes.

I can confirm that running with writeback_percent to zero now works  
much smoother (or "at all", for certain circumstances).

>> PS: We're still facing random reboots (of unknown cause), which may
>> correlate with bcache's "amount dirty" being near the limit set by
>> writeback_percent.

For a test, after a few hours running the latest patch, I switched  
from writeback_percent==0 to writeback_percent==1, and had a full  
kernel crash within an hour! Luckily, I still had a console open on  
the machine, so I could for the first time see a hint (but not much  
more) of what is going on:

--- cut here ---
Message from syslogd@san02 at Sep  7 14:56:15 ...
  kernel:[74182.424659] Kernel panic - not syncing: stack-protector:  
Kernel stack is corrupted in: ffffffffa001a815

Message from syslogd@san02 at Sep  7 14:56:15 ...
  kernel:[74182.424659]

Message from syslogd@san02 at Sep  7 14:56:15 ...
  kernel:[74182.474050] Kernel Offset: 0x0 from 0xffffffff81000000  
(relocation range: 0xffffffff80000000-0xffffffff9fffffff)
--- cut here ---

Since there's no stack trace, this lets much room for speculation. But  
at least I now have an idea where the reboots (and two other "full  
stops") might stem from: stack corruption. I have run  
scripts/checkstack.pl on the bcache module and found no excessive  
stack use, but checking for memset() and memcpy() in bcache's code  
gave a number of hits - I'll have to have a look at them, one by one,  
and hope to find my way around.

I'll give my servers at least two weeks to run with your patch and  
writeback_percent==0 to see if we're hit by reboots with that code as  
well. If not, I'll take that as an indicator that the implementation  
of the "PID regulator" may need a closer look.

Kent, do you remember having fixed anything that might explain this  
stack corruption behavior, in code later than what's included in  
kernel 3.18.8?

Regards,
Jens
