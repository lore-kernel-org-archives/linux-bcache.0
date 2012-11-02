From: James Sefton <james-3k2nYdb70uTQXOPxS62xeg@public.gmane.org>
Subject: Partitions?
Date: Fri, 2 Nov 2012 03:24:13 +0000 (UTC)
Message-ID: <loom.20121102T041855-678@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi,

I have got my /dev/bcache0 device showing up and attached the cache.

I then used fdisk to add a single partition to it but it gave an error on exit:

WARNING: Re-reading the partition table failed with error 22: Invalid argument.
The kernel still uses the old table. The new table will be used at
the next reboot or after you run partprobe(8) or kpartx(8)


I have had this before quite a bit and often have to run partprobe after leaving 
fdisk for the partition table to be read and partitions populated in /dev.

However, when running partprobe (or partprobe /dev/bcache0) I get the following:

Error: Error informing the kernel about modifications to partition 
/dev/bcache0p1 -- Invalid argument.  This means Linux won't know about any 
changes you made to /dev/bcache0p1 until you reboot -- so you shouldn't mount it 
or use it in any way before rebooting.
Error: Failed to add partition 1 (Invalid argument)


I checked /dev and confirmed that bcache0p1 was not present.


What did I do wrong?

Many thanks,

James
