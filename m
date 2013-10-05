From: David Humphreys <dave-Ni3nFjXdSsm9FHfhHBbuYA@public.gmane.org>
Subject: SDD Failure - What to do?
Date: Sat, 05 Oct 2013 09:12:11 +0100
Message-ID: <524FC9DB.5080608@datatone.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

The first bit of this is by way of scene setting...

I have been operating a machine with a bcache configuration for the root
filesystem.

The SDD part is a SanDisk Extreme 120G drive; the main drive is a 1T
Seagate; both 2.5" SATA on 6Gb/s interfaces.

Last week the computer hung, and on attempted reboot, the SDD (which was
the boot drive) had disappeared.

Unplugging and replugging the drive brought it back, so I thought that
I'd suffered from a poorly mated cable.

All started to boot OK, but BTRFS would not mount, and I had to zero the
log.

Therefore, as may have been expected, the failure of the SDD had left
the filesystem somewhat corrupted, but recoverable.

Now...

The computer has just crashed again, this time, the SDD has clearly
failed 'hard'. It has disappeared and cannot be made to return.

I have replaced the SDD with a new, identical, device. This now appears
at boot time.

I can boot the machine to a sensible recovery state from a different
drive in the machine.

What is the best procedure to recover?

What I really want to do is to get the new SDD working as the cache for
the original main drive, then boot from the pair as normal.

I don't really want to experiment without taking advice, because this
seems to me like a good way to risk loosing everything.


I then have a subsidiary question:

This total failure of the drive to even appear at boot time does not
seem to me to be a likely symptom of SDD failure through repeated erase
cycles. Agreed?

I am assuming that it is just one of those unfortunate early mortality
failures of the drive electronics.

This is an important point, because it would be a bit of a disaster if
it were a repeatable failure brought about by the pattern of use using
bcache. I will return the SDD to SanDisk under warranty and see what
happens.

Regards,
David Humphreys
