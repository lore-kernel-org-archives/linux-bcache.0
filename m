From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: About physically swapping backing and cache device
Date: Tue, 7 Jan 2014 13:35:58 -0800
Message-ID: <20140107213558.GK9037@kmo>
References: <CAPBO7TYjki0s4-cMxS1ztvO=WT-8+ScH6mfZrE+YkTLuFcBqAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:52217 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbaAGVgC (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 7 Jan 2014 16:36:02 -0500
Received: by mail-pb0-f42.google.com with SMTP id uo5so671407pbc.29
        for <linux-bcache@vger.kernel.org>; Tue, 07 Jan 2014 13:36:01 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAPBO7TYjki0s4-cMxS1ztvO=WT-8+ScH6mfZrE+YkTLuFcBqAA@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Josep Lladonosa <jlladono@gmail.com>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On Tue, Jan 07, 2014 at 09:52:50AM +0100, Josep Lladonosa wrote:
> Hello,
> 
> 
> I have been using bcache for some months. Now I am with 3.12.6 kernel
> (stable! :)
> Thanks and congratulations for the good work.
> 
> I have in the laptop this configuration:
> 
> /dev/sda7 as backing device (hard drive partition)
> /dev/sdb as cache device (SSD)
> 
> 1) I would like to physically swap sda and sdb (a matter of different
> bus speeds) in order to improve ata speed for SSD. The fact is that in
> a case of this, would I have to "reregister" anything in bcache, or it
> will run referenced to UUIDs and so?

Everything's referenced with UUIDs, so it'll all just work.

> 2) I think I would have to install GRUB into /dev/sdb (it has no
> partitions defined). Would it be safe installing GRUB in a cache
> device? Future configuration would be /dev/sda for the cache (SSD) and
> /dev/sdb for the backing device (hard drive).

Bcache doesn't touch the first 4k of the device, so if it's just grub's MBR (512
bytes) that should be fine. I would verify that grub isn't touching more than
the first 4k of the device though.
