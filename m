From: Mathijs Kwik <mathijs@bluescreen303.nl>
Subject: Re: bcache and hibernation
Date: Mon, 01 Dec 2014 09:48:28 +0100
Message-ID: <87zjb769ib.fsf@bluescreen303.nl>
References: <87h9y3xl6l.fsf@bluescreen303.nl>
	<20141113221134.GA15711@kmo-pixel> <874mtg7dhc.fsf@bluescreen303.nl>
	<20141130232959.GA8123@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:36152 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbaLAIsb (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 1 Dec 2014 03:48:31 -0500
Received: by mail-wg0-f45.google.com with SMTP id b13so13453541wgh.4
        for <linux-bcache@vger.kernel.org>; Mon, 01 Dec 2014 00:48:30 -0800 (PST)
In-Reply-To: <20141130232959.GA8123@kmo-pixel> (Kent Overstreet's message of
	"Sun, 30 Nov 2014 15:29:59 -0800")
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-bcache@vger.kernel.org

Kent Overstreet <kmo@daterainc.com> writes:
>
> BTW - it sounds like you're ahead of me on how this is put together - could you
> point me at the userspace side of hibernate that you're using (those initramfs
> scripts, and in particular whatever device mapper does)? that'll help a lot.

Please see
https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/system/boot/stage-1-init.sh 
lines 128 onward. I'm just using the in-kernel suspend/hibernate
functionality (swsusp) but the same probably applies to tuxonice and
other solutions as well.

As far as I understand the events leading up to hibernation are very
similar to suspend. The kernel will notify processes and kernel threads
they will be frozen. Then, when everything has prepared for suspension,
instead of just putting the system to suspend, the kernel will write the
full contents of the system RAM to a swap device. 

I'm pretty sure that's all still OK and things are in a consistent
state. However, when resuming the system, some basic initialization is
performed in initrd. At least SCSI/SATA controller modules and other
stuff needed to find the hibernated RAM image are needed of course, but
most distributions will include more stuff and use udev to find hardware
and load the appropriate modules.

This is where things might get nasty though. On nixos, we normally
initialize bcache using udev rules. Modern versions of udev will do a
quick scan of block devices when found to find their labels/types. So
while waiting for stuff like disks/usb/whatever to appear, my bcache
partitions get found and activated. I'm pretty sure bcache will take
over from here and do some bookkeeping / flush dirty buckets, whatever.
Even without writeback, things might change on-disk: udev and tools like
vgscan (lvm) and "btrfs scan" might probe some magic sectors inside the
newly-activated bcache device. If those aren't in the cache, they will
be put there, once again changing the on-disk state.

Then finally (line 190) the kernel gets instructed to check if the swap
device contains a hibernated RAM image and restore that. For everything
running "inside the RAM image", it's just like waking up from a normal
suspend.

From this explanation, it should be clear that it is vital that no
on-disk state is changed in the brief period that the initrd is setting
up the system, or bcache's in-memory state (inside the resumed RAM
image) will be corrupted, probably leading to disasters. Either that, or
bcache should assume nothing on resume and make sure to reassemble its
entire in-memory state from disk.

The temporary solution I found was to not include the udev rules in the
initrd so it will not get found and activated before resume. Then for
normal booting (I have my root on bcache) I manually load and activate
bcache _after_ seeing there is no resume image. However, this solution
is ugly, because I need to repeat all other initialization steps
(lvm/btrfs) afterwards. 

Hope this helps,
Mathijs
