From: Mathijs Kwik <mathijs@bluescreen303.nl>
Subject: Re: bcache and hibernation
Date: Sun, 30 Nov 2014 19:25:03 +0100
Message-ID: <874mtg7dhc.fsf@bluescreen303.nl>
References: <87h9y3xl6l.fsf@bluescreen303.nl>
	<20141113221134.GA15711@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:41865 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbaK3SZH (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sun, 30 Nov 2014 13:25:07 -0500
Received: by mail-wg0-f50.google.com with SMTP id k14so12367104wgh.37
        for <linux-bcache@vger.kernel.org>; Sun, 30 Nov 2014 10:25:05 -0800 (PST)
In-Reply-To: <20141113221134.GA15711@kmo-pixel> (Kent Overstreet's message of
	"Thu, 13 Nov 2014 14:11:34 -0800")
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-bcache@vger.kernel.org

Kent Overstreet <kmo@daterainc.com> writes:

> On Thu, Nov 13, 2014 at 02:52:02PM +0100, Mathijs Kwik wrote:
>> The kernel documentation on suspend is VERY clear you should NOT touch
>> anything on disk between suspend and resume. So activating luks and LVM
>> is probably risky already, but it apppears both luks and LVM do not make
>> any on-disk changes when activated and any in-memory state (within the
>> resumed image) is still valid. The benefit of activating luks and LVM
>> before resume seems to be that it allows resuming from encrypted/lvm
>> volumes. 
>
> Yeah, this is handled for in kernel stuff with the freezing mechanism, which
> bcache uses.
>
>> 
>
> So, userspace shouldn't have to do anything to tell bcache about
> hibernation.

I understand bcache knows when the system hibernates so it can do some
bookkeeping/flushing. What I don't get, is how this will protect the
system in the short phase before resume, when my initrd activates bcache
and lvm, _before_ it checks for a resume image.

I guess bcache will just start running as usual. Maybe flushing some
dirty buckets, cache some new stuff (when lvm searches for volumes and
udev reads labels & more).

Then finally the resume mechanism loads the old hibernated system, while
the cache has changed in the mean time! Won't this cause issues?


>
> The dev branch is getting a true read only mode (still in progress), but this
> isn't relevant to hibernation.
>
> bcache kernel threads (allocator thread, gc thread) should be correct w.r.t.
> hibernation, but - maybe the workqueue usage isn't.
>
> I'm probably not going to be able to get to this in the next couple days, but
> this is a pretty serious issue. Can you ping me again every couple days until I
> get a fix out for this, and myabe file a bug somewhere? (i think
> bugzilla.kernel.org has been used for bcache bugs before...)

I will file a report once I'm sure what the exact cause for my data-loss
was. If I understand you correctly, all should be safe and well, no
matter what (initramfs) userspace does in between and the only thing
that might not be safe is the workqueue?
