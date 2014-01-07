From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: About physically swapping backing and cache device
Date: Tue, 7 Jan 2014 15:07:56 -0800
Message-ID: <20140107230756.GD9234@birch.djwong.org>
References: <CAPBO7TYjki0s4-cMxS1ztvO=WT-8+ScH6mfZrE+YkTLuFcBqAA@mail.gmail.com>
 <20140107213558.GK9037@kmo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25688 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426AbaAGXIG (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 7 Jan 2014 18:08:06 -0500
Content-Disposition: inline
In-Reply-To: <20140107213558.GK9037@kmo>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>
Cc: Josep Lladonosa <jlladono@gmail.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On Tue, Jan 07, 2014 at 01:35:58PM -0800, Kent Overstreet wrote:
> On Tue, Jan 07, 2014 at 09:52:50AM +0100, Josep Lladonosa wrote:
> > Hello,
> > 
> > 
> > I have been using bcache for some months. Now I am with 3.12.6 kernel
> > (stable! :)
> > Thanks and congratulations for the good work.
> > 
> > I have in the laptop this configuration:
> > 
> > /dev/sda7 as backing device (hard drive partition)
> > /dev/sdb as cache device (SSD)
> > 
> > 1) I would like to physically swap sda and sdb (a matter of different
> > bus speeds) in order to improve ata speed for SSD. The fact is that in
> > a case of this, would I have to "reregister" anything in bcache, or it
> > will run referenced to UUIDs and so?
> 
> Everything's referenced with UUIDs, so it'll all just work.
> 
> > 2) I think I would have to install GRUB into /dev/sdb (it has no
> > partitions defined). Would it be safe installing GRUB in a cache
> > device? Future configuration would be /dev/sda for the cache (SSD) and
> > /dev/sdb for the backing device (hard drive).
> 
> Bcache doesn't touch the first 4k of the device, so if it's just grub's MBR (512
> bytes) that should be fine. I would verify that grub isn't touching more than
> the first 4k of the device though.

On a BIOS system, Grub generally uses the next ~31K of the disk (space between
the end of the MBR and the start of cylinder 1) to store its extra stages.
Unfortunately, you can't really overwrite that.

You might just try switching the disk cables and seeing if the BIOS will still
boot off the spinning disk, since that usually works...

Ofc if you have UEFI then it simply stuffs it on the EFI system partition.

--D
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
