From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: layering question.
Date: Wed, 05 Aug 2015 08:28:04 +0200
Message-ID: <k0n89c-dgn.ln1@hurikhan77.spdns.de>
References: <55C0E63F.2030007@fsck.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38967 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbbHEG2O (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 5 Aug 2015 02:28:14 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1ZMsBP-0001RO-PK
	for linux-bcache@vger.kernel.org; Wed, 05 Aug 2015 08:28:11 +0200
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Wed, 05 Aug 2015 08:28:11 +0200
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Wed, 05 Aug 2015 08:28:11 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

A. James Lewis <james@fsck.co.uk> schrieb:

> I've heard rumours that layering bcache with other block device drivers
> might not be recommended... I wonder what the truth really is... perhaps
> someone can advise.

I think this is not just rumours. Multiple people reported problems when 
layering caching or backing devices on top of MD devices. This may be an 
implementation problem in MD which is gone in later kernel versions and had 
to do with correctly passing discards through the layers. If you want to use 
that, I'd at least recommend to disable discards, and to disable write-back 
caching (just use write-through or write-around which is obviously slower 
but might fit you workload).

> I was planning to use 2 SSD's... combined with 4 large spinning drives
> to create a large filesystem with BTRFS...  my questions are as follows.

Using one SSD with 3 spinning drives here.

> 1. Is there a way to use 2 SSD's directly, or would it be OK to use MD
> to stripe them?... then used the MD array as the cache device?

I think currently you can only add on caching device to a cache set. I think 
it is planned to allow that in a later development stage but currently your 
only way to go would be a MD array if you want to use MD. I'd better suggest 
to use hardware RAID for that.

> 2. I would be using BTRFS, so would it be better to create 4 separate
> bcache devices each attached to the single cache device, and then use
> BTRFS to raid 4 bcache devices... obviously this would be more flexible,
> or would I need to make an MD raid of the 4 devices, and then use that
> to create a single bcache device and build a BTRFS filesystem on top of
> that.

You can just attach multiple backing devices (each sub device of your btrfs 
pool) to the same cache set - so you caching device would cache all backing 
devices.

> Hope that's clear, any clarification would be appreciated...

I'd go with the following setup:

I'm not sure which btrfs RAID level you are going to use. Maybe RAID 10, 
probably RAID 0. This means, btrfs tries to evenly spread writes and reads 
across all devices.

I suggest using 2 cache sets. One bcache for btrfs pool member 1 and 2, one 
bcache or btrfs pool member 3 and 4. If you add more members to the pool 
later, just attach them in alternating order to the first or second cache 
set.

This should give you most value out of your current setup.

If you plan to use 2 SSDs for improved reboustness (combined into RAID 1), 
you obviously don't have this option. You could try with MDRAID tho I 
wouldn't recommend this without doing your tests and backups. Better use 
hardware RAID then, tho most controllers will disable the ability to use 
discard then so you probably want to leave some spare space unused on your 
SSDs for improved life time and long-term performance.

> Also, there's talk about a pending on-disk cache format change some time
> around 3.19, but no details... is this over with, or still pending?

No idea, I'm on 4.1 now and used bcache since 3.18 or 3.19 - not sure. It 
worked well.

PS: Disable "autodefrag" if you use btrfs+bcache... ;-) It helps performance 
a bit but it eats SSD lifetime (used 20% of my proposed SSD lifetime in only 
2 months - according to smartctl). Better just defragment meta data from 
time to time (read: use btrfs defrag on directories only) if you want to 
defrag.

-- 
Replies to list only preferred.
