From: Killian De Volder <killian.de.volder@megasoft.be>
Subject: Re: block and bucket sizes
Date: Thu, 13 Aug 2015 13:32:13 +0200
Message-ID: <55CC803D.9080700@megasoft.be>
References: <55CC7023.1010806@buttersideup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:40150 "EHLO
	slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbbHMLtw (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 13 Aug 2015 07:49:52 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
	by slow1-d.mail.gandi.net (Postfix) with ESMTP id 7B035535E0D
	for <linux-bcache@vger.kernel.org>; Thu, 13 Aug 2015 13:32:18 +0200 (CEST)
Received: from mfilter28-d.gandi.net (mfilter28-d.gandi.net [217.70.178.159])
	by relay2-d.mail.gandi.net (Postfix) with ESMTP id D0637C5A44
	for <linux-bcache@vger.kernel.org>; Thu, 13 Aug 2015 13:32:16 +0200 (CEST)
Received: from relay2-d.mail.gandi.net ([IPv6:::ffff:217.70.183.194])
	by mfilter28-d.gandi.net (mfilter28-d.gandi.net [::ffff:10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id y1fTsafxXT81 for <linux-bcache@vger.kernel.org>;
	Thu, 13 Aug 2015 13:32:15 +0200 (CEST)
Received: from [172.17.0.70] (cable-213-34-255-70.zeelandnet.nl [213.34.255.70])
	(Authenticated sender: killian.de.volder@megasoft.be)
	by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 372AEC5A3A
	for <linux-bcache@vger.kernel.org>; Thu, 13 Aug 2015 13:32:14 +0200 (CEST)
In-Reply-To: <55CC7023.1010806@buttersideup.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Well the block-size == the physical block size your bcache device will have.
(As in 4k sector disks VS 512bytes disks)

Please note that the physical-sector size (as advertised by your bcache device the OS and FS)
can have an impact on using it:
- FS might refuse to use smaller blocks then the sector size.
- When using lvm, the sector-size will the biggest of all the pv's used. (AND can change while you are doing an lvextend or pvmove)
- Possible other I don't know about.

I don't know if the block-size matters for performance, but usually the above points, trump performance.

Bucket-size should match erase size. How important is it ? Depend on how much your SSD cares about matched erase sizes.


Killian De Volder


On 13-08-15 12:23, Tim Small wrote:
> Hi,
> 
> I couldn't find much in the way of docs on the block and bucket sizes...
> 
> I created a bcache device (md 3 disk RAID5 backing, Intel S3500 cache),
> and initially used the default bucket and block sizes.
> 
> It looks like flash erase block sizes are now almost universally larger
> than the bcache default bucket size, so if this is important (and the
> man page says it is), then maybe this needs to be increased?
> 
> After a load of googling, I think that for this SSD (which uses
> Intel/Micron 20nm MLC), the page size is probably 8 kB, and the erase
> block size is probably 256 x 8 kB = 2 MB
> 
> http://www.anandtech.com/show/7147/micron-announces-16nm-128gb-mlc-nand-ssds-in-2014
> 
> - if on the other hand it uses 128 Gbit parts, then this will be 16 kB
> page size, and 8 MB erase block.
> 
> 
> So, after playing around a bit, I take it that:
> 
> The block size for the backing and cache devices must be the same (are
> there any implications e.g. file system compatibility - with block sizes
> larger than 4 kB?).
> 
> The default bucket size is smaller than the erase block size on this SSD
> (and probably most modern SSDs), and I was wondering if the default
> should be increased?
> 
> I'm assuming most users are going to be getting these parameters "wrong"
> - but I'm not sure how much impact this will have on performance and SSD
> endurance?  Does this need some sort of wiki -type table with a lookup
> between SSD model number and page/block size (which make-bcache could use)?
> 
> It'll be a bit of a pain to move everything off my 512 byte block size
> backing store, and then recreate it, so should I bother?
> 
> Tim.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
