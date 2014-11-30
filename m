From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: bcache and hibernation
Date: Sun, 30 Nov 2014 15:29:59 -0800
Message-ID: <20141130232959.GA8123@kmo-pixel>
References: <87h9y3xl6l.fsf@bluescreen303.nl>
 <20141113221134.GA15711@kmo-pixel>
 <874mtg7dhc.fsf@bluescreen303.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:38760 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbaK3X1l (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sun, 30 Nov 2014 18:27:41 -0500
Received: by mail-pa0-f49.google.com with SMTP id eu11so9802219pac.22
        for <linux-bcache@vger.kernel.org>; Sun, 30 Nov 2014 15:27:41 -0800 (PST)
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
> 
> I guess bcache will just start running as usual. Maybe flushing some
> dirty buckets, cache some new stuff (when lvm searches for volumes and
> udev reads labels & more).
> 
> Then finally the resume mechanism loads the old hibernated system, while
> the cache has changed in the mean time! Won't this cause issues?

BTW - it sounds like you're ahead of me on how this is put together - could you
point me at the userspace side of hibernate that you're using (those initramfs
scripts, and in particular whatever device mapper does)? that'll help a lot.
