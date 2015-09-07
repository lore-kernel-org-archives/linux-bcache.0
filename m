From: Vojtech Pavlik <vojtech@suse.com>
Subject: Re: Bcache stuck at writeback of a key, consuming 100% CPU, not
 possible to detach
Date: Mon, 7 Sep 2015 17:52:17 +0200
Message-ID: <20150907155217.GA27227@suse.com>
References: <20150830085442.GA31722@suse.com>
 <20150905130658.Horde.bdSqYx_a293KuFa5vdTuajm@www3.nde.ag>
 <20150905112955.GA4078@suse.com>
 <20150907171318.Horde.LCssHlKH7jqwmHt1ENeCSCd@www3.nde.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jablonecka.jablonka.cz ([91.219.244.36]:56043 "EHLO
	jablonecka.jablonka.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbbIGPwU (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 7 Sep 2015 11:52:20 -0400
Content-Disposition: inline
In-Reply-To: <20150907171318.Horde.LCssHlKH7jqwmHt1ENeCSCd@www3.nde.ag>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org

On Mon, Sep 07, 2015 at 05:13:18PM +0200, Jens-U. Mozdzen wrote:

> and the patches
> 
> bcache001.eml:Subject: [PATCH] bcache: [BUG] clear
> BCACHE_DEV_UNLINK_DONE flag when attaching a backing device
> bcache002.eml:Subject: [PATCH] bcache: fix a livelock in btree lock
> bcache003.eml:Subject: [PATCH] bcache: unregister reboot notifier
> when bcache fails to register a block device
> bcache004.eml:Subject: [PATCH] fix a leak in bch_cached_dev_run()
> bcache005.eml:Subject: [PATCH] bcache: Fix writeback_thread never
> writing back incomplete stripes.
> 
> I can confirm that running with writeback_percent to zero now works
> much smoother (or "at all", for certain circumstances).

I'm glad to hear that.

> >>PS: We're still facing random reboots (of unknown cause), which may
> >>correlate with bcache's "amount dirty" being near the limit set by
> >>writeback_percent.
> 
> For a test, after a few hours running the latest patch, I switched
> from writeback_percent==0 to writeback_percent==1, and had a full
> kernel crash within an hour! Luckily, I still had a console open on
> the machine, so I could for the first time see a hint (but not much
> more) of what is going on:

I'm running the openSUSE most recent stable kernel, available here:

	http://download.opensuse.org/repositories/Kernel:/stable/standard/

It's currently at 4.2.0 and contains all of the above patches. I've
seen crashes in __find_stripe a couple times a few months apart on older
kernels, but these aren't likely related to bcache. Similar to this:

	https://bugzilla.kernel.org/show_bug.cgi?id=100321

But except for these, the system has been running stable (at
writeback_percent=40 the last few months), so I would bet on a different
source of your crashes than bcache.

> --- cut here ---
> Message from syslogd@san02 at Sep  7 14:56:15 ...
>  kernel:[74182.424659] Kernel panic - not syncing: stack-protector:
> Kernel stack is corrupted in: ffffffffa001a815
> 
> Message from syslogd@san02 at Sep  7 14:56:15 ...
>  kernel:[74182.424659]
> 
> Message from syslogd@san02 at Sep  7 14:56:15 ...
>  kernel:[74182.474050] Kernel Offset: 0x0 from 0xffffffff81000000
> (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
> --- cut here ---

Maybe you could set up a serial console? That way you'd be able to catch
all the kernel messages.

> Since there's no stack trace, this lets much room for speculation.
> But at least I now have an idea where the reboots (and two other
> "full stops") might stem from: stack corruption. I have run
> scripts/checkstack.pl on the bcache module and found no excessive
> stack use, but checking for memset() and memcpy() in bcache's code
> gave a number of hits - I'll have to have a look at them, one by
> one, and hope to find my way around.
> 
> I'll give my servers at least two weeks to run with your patch and
> writeback_percent==0 to see if we're hit by reboots with that code
> as well. If not, I'll take that as an indicator that the
> implementation of the "PID regulator" may need a closer look.
>
> Kent, do you remember having fixed anything that might explain this
> stack corruption behavior, in code later than what's included in
> kernel 3.18.8?

-- 
Vojtech Pavlik
Director SUSE Labs
