From: James Sefton <james-3k2nYdb70uTQXOPxS62xeg@public.gmane.org>
Subject: RE: Partitions?
Date: Fri, 2 Nov 2012 19:11:25 +0000
Message-ID: <93462A6BCE1CD840B94554FBBEE4C93603075DA05E@THHS2E12BE8X.hostedservice2.net>
References: <loom.20121102T041855-678@post.gmane.org>
 <20121102153335.GD14917@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121102153335.GD14917-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Awesome.   1 byte change to the source!

I now have bcache0p1 in /dev.
Not used it yet but so far it's looking good. :)

-----Original Message-----
From: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Kent Overstreet
Sent: 02 November 2012 15:34
To: James Sefton
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: Partitions?

On Fri, Nov 02, 2012 at 03:24:13AM +0000, James Sefton wrote:
> Hi,
> 
> I have got my /dev/bcache0 device showing up and attached the cache.
> 
> I then used fdisk to add a single partition to it but it gave an error on exit:
> 
> WARNING: Re-reading the partition table failed with error 22: Invalid argument.
> The kernel still uses the old table. The new table will be used at the 
> next reboot or after you run partprobe(8) or kpartx(8)
> 
> 
> I have had this before quite a bit and often have to run partprobe 
> after leaving fdisk for the partition table to be read and partitions populated in /dev.
> 
> However, when running partprobe (or partprobe /dev/bcache0) I get the following:
> 
> Error: Error informing the kernel about modifications to partition
> /dev/bcache0p1 -- Invalid argument.  This means Linux won't know about 
> any changes you made to /dev/bcache0p1 until you reboot -- so you 
> shouldn't mount it or use it in any way before rebooting.
> Error: Failed to add partition 1 (Invalid argument)
> 
> 
> I checked /dev and confirmed that bcache0p1 was not present.
> 
> 
> What did I do wrong?

Oh, that's nothing you did... the bcache code is just creating an unpartitionalable block device.

I suppose there's no real reason for that...

I _think_ all you'd need to change is one line, in
drivers/md/bcache/super.c: if you search through the file, you'll find a call to alloc_disk(1) somewhere - change that to alloc_disk(16).


Want to try that and let me know if it works?
--
To unsubscribe from this list: send the line "unsubscribe linux-bcache" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
