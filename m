From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: bcache and hibernation
Date: Thu, 13 Nov 2014 14:11:34 -0800
Message-ID: <20141113221134.GA15711@kmo-pixel>
References: <87h9y3xl6l.fsf@bluescreen303.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:39771 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934044AbaKMWJ2 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 13 Nov 2014 17:09:28 -0500
Received: by mail-pa0-f44.google.com with SMTP id et14so1344540pad.31
        for <linux-bcache@vger.kernel.org>; Thu, 13 Nov 2014 14:09:27 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <87h9y3xl6l.fsf@bluescreen303.nl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Mathijs Kwik <mathijs@bluescreen303.nl>
Cc: linux-bcache@vger.kernel.org

On Thu, Nov 13, 2014 at 02:52:02PM +0100, Mathijs Kwik wrote:
> Hi all,
> 
> Today, I lost most my data (don't worry, got backups) after the cache
> got corrupted somehow. I suspected a recent suspend-to-disk to be the
> cause. I checked how my distribution (NixOS) handles suspend/resume and
> I have some concerns about how bcache fits into this.

Augh :(

> Normally, the kernel and initrd get loaded. The initrd loads required
> kernel modules, waits for udev to settle, activates luks&lvm, then
> finally asks the kernel to resume from the resume device.
> 
> The kernel documentation on suspend is VERY clear you should NOT touch
> anything on disk between suspend and resume. So activating luks and LVM
> is probably risky already, but it apppears both luks and LVM do not make
> any on-disk changes when activated and any in-memory state (within the
> resumed image) is still valid. The benefit of activating luks and LVM
> before resume seems to be that it allows resuming from encrypted/lvm
> volumes. 

Yeah, this is handled for in kernel stuff with the freezing mechanism, which
bcache uses.

> Now, with bcache added, things probably get a bit hairy. NixOS supports
> bcache inside the initrd and uses udev rules to activate/attach. I
> suspect this is probably unsafe. Probably bcache starts to see if any
> dirty pages exist, to write them to the backing store. Even without
> writeback caching, the activation of lvm will read some sectors, which
> might trigger the cache to update. Then after resuming the image, the
> in-memory state is corrupted and further damage occurs. 
> 
> - Does this sound plausible? 
> - Is there any way to tell bcache to make absolutely no changes to
>   either the backing device or the cache?
>   Basically like a readaround+writearound which can be triggered on
>   hibernate and switched off on resume.

So, userspace shouldn't have to do anything to tell bcache about hibernation.

The dev branch is getting a true read only mode (still in progress), but this
isn't relevant to hibernation.

bcache kernel threads (allocator thread, gc thread) should be correct w.r.t.
hibernation, but - maybe the workqueue usage isn't.

I'm probably not going to be able to get to this in the next couple days, but
this is a pretty serious issue. Can you ping me again every couple days until I
get a fix out for this, and myabe file a bug somewhere? (i think
bugzilla.kernel.org has been used for bcache bugs before...)
