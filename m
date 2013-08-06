From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: bcache hang on suspend? sometimes?
Date: Tue, 6 Aug 2013 13:56:50 -0700
Message-ID: <20130806205650.GA5878@blackbox.djwong.org>
References: <20130806053403.GB7998@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130806053403.GB7998-yuuUpGxbzT9UbpRmUfBrXUB+6BGkLq7r@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Ok, I've narrowed it down a little bit --

It's not caused by any of the fixes that went into 3.10.[1-5].  It doesn't seem
to be specific to any particular storage bus, controller, disk, or even cache
set -- the same bcache'd usb stick will crash my laptop and not crash my test
box.  The 4k/512b sector thing was a red herring; you can ignore that.

The test box is a boring old Core2 box; the laptop is an Ivy Bridge.  I'll try
to enable more verbose PM debugging to see if I can determine what exactly's
going on at sleep time.  (Again, shooting in the dark...)

--D

On Mon, Aug 05, 2013 at 10:34:03PM -0700, Darrick J. Wong wrote:
> Hi,
> 
> Lately (i.e. 3.10.5) I thought I'd give bcache a try on my work laptop.  I
> paired up a boring SATA SSD with one of those newfangled 4k "advanced format"
> drives, and formatted the whole stack with dm-crypt + lvm + ext4 on top of
> bcache.  Things were looking pretty good -- LKML loads much faster in mutt, and
> all was well with the world, even suspend/resume worked fine.
> 
> Then I rebooted the machine.  After the reboot, the machine will hang every
> time I suspend.  I set up netconsole and set no_console_suspend=1, but nothing
> interesting showed up in dmesg.  I see that SCSI managed to flush the disks,
> but everything seems to stop dead.  No lockup messages or anything.
> 
> Curiously, if I set up a bcache between that SSD and a 512-byte-sector old
> school disk, suspend/resume seem fine even after a reboot.  My bcache test
> machine also suspends/resumes just fine.  I tried simulating a 4k disk with
> qemu to see if I could arrange an easier testcase, but I couldn't reproduce the
> hang there either.  (Yes, I do have bcache debugging turned on.)
> 
> I'll keep plugging away on this as time permits, but I was wondering -- has
> anyone else seen this before?  Is this my own little crazy party?  I was
> careful to make sure everything on the AF drive lined up on a 4k alignment.
> 
> <shrug>
> 
> --D
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
