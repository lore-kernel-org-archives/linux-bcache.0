From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: bcache and hibernation
Date: Sun, 30 Nov 2014 15:24:45 -0800
Message-ID: <20141130232445.GA4327@kmo-pixel>
References: <87h9y3xl6l.fsf@bluescreen303.nl>
 <20141113221134.GA15711@kmo-pixel>
 <874mtg7dhc.fsf@bluescreen303.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:39736 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbaK3XW2 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sun, 30 Nov 2014 18:22:28 -0500
Received: by mail-pd0-f172.google.com with SMTP id y13so9641835pdi.31
        for <linux-bcache@vger.kernel.org>; Sun, 30 Nov 2014 15:22:27 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <874mtg7dhc.fsf@bluescreen303.nl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Mathijs Kwik <mathijs@bluescreen303.nl>
Cc: linux-bcache@vger.kernel.org

On Sun, Nov 30, 2014 at 07:25:03PM +0100, Mathijs Kwik wrote:
> Kent Overstreet <kmo@daterainc.com> writes:
> 
> > On Thu, Nov 13, 2014 at 02:52:02PM +0100, Mathijs Kwik wrote:
> >> The kernel documentation on suspend is VERY clear you should NOT touch
> >> anything on disk between suspend and resume. So activating luks and LVM
> >> is probably risky already, but it apppears both luks and LVM do not make
> >> any on-disk changes when activated and any in-memory state (within the
> >> resumed image) is still valid. The benefit of activating luks and LVM
> >> before resume seems to be that it allows resuming from encrypted/lvm
> >> volumes. 
> >
> > Yeah, this is handled for in kernel stuff with the freezing mechanism, which
> > bcache uses.
> >
> >> 
> >
> > So, userspace shouldn't have to do anything to tell bcache about
> > hibernation.
> 
> I understand bcache knows when the system hibernates so it can do some
> bookkeeping/flushing. What I don't get, is how this will protect the
> system in the short phase before resume, when my initrd activates bcache
> and lvm, _before_ it checks for a resume image.

Wait what? Ohh... you must be talking about hibernate, not suspend...

> I guess bcache will just start running as usual. Maybe flushing some
> dirty buckets, cache some new stuff (when lvm searches for volumes and
> udev reads labels & more).
> 
> Then finally the resume mechanism loads the old hibernated system, while
> the cache has changed in the mean time! Won't this cause issues?

I have no idea how hibernate works, but yeah, quite possibly...

> > The dev branch is getting a true read only mode (still in progress), but this
> > isn't relevant to hibernation.
> >
> > bcache kernel threads (allocator thread, gc thread) should be correct w.r.t.
> > hibernation, but - maybe the workqueue usage isn't.
> >
> > I'm probably not going to be able to get to this in the next couple days, but
> > this is a pretty serious issue. Can you ping me again every couple days until I
> > get a fix out for this, and myabe file a bug somewhere? (i think
> > bugzilla.kernel.org has been used for bcache bugs before...)
> 
> I will file a report once I'm sure what the exact cause for my data-loss
> was. If I understand you correctly, all should be safe and well, no
> matter what (initramfs) userspace does in between and the only thing
> that might not be safe is the workqueue?

I was thinking suspend to ram, not hibernate. gonna have to look into how
hibernate works now.
