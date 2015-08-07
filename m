From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: Re: layering question.
Date: Fri, 07 Aug 2015 14:43:44 +0200
Message-ID: <20150807144344.Horde.5xyJhwIOzk_C5q__CpHL4IV@www3.nde.ag>
References: <55C0E63F.2030007@fsck.co.uk>
 <k0n89c-dgn.ln1@hurikhan77.spdns.de>
 <20150805090446.Horde.VMReCuJzW3PwyI8Gh_BZ_yJ@www3.nde.ag>
 <poha9c-rh4.ln1@hurikhan77.spdns.de> <55C2B034.2090404@fsck.co.uk>
 <u76d9c-m19.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.180]:44191 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbbHGMnw (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 7 Aug 2015 08:43:52 -0400
Received: from hh2-mail.hh.nde.ag (gw-hh2.hh.nde.ag [85.183.17.20])
	by post.strato.de (RZmta 37.8 AUTH)
	with ESMTPA id L0469dr77Chnaou
	for <linux-bcache@vger.kernel.org>;
	Fri, 7 Aug 2015 14:43:49 +0200 (CEST)
Received: from www3.nde.ag (hh2-www.hh.nde.ag [192.168.102.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by hh2-mail.hh.nde.ag (Postfix) with ESMTPS id BCAC31C05C
	for <linux-bcache@vger.kernel.org>; Fri,  7 Aug 2015 14:43:46 +0200 (CEST)
In-Reply-To: <u76d9c-m19.ln1@hurikhan77.spdns.de>
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi *,

Zitat von Kai Krakow <hurikhan77@gmail.com>:
> Hi!
>
> A. James Lewis <james@fsck.co.uk> schrieb:
>
>> The problem is tho... with a very large backing store, I'm not really
>> happy with a single point of failure in the cache... is there another
>> way to mirror the cache device?
>
> Well, AFAIR there are plans to add such capabilities into bcache itself -
> read: make it possible to add more than one caching device to a cache set.
> It will use some sort of hybrid mirror / striping to get the best
> combination of speed and safety - at least that's what the idea is about. I
> just don't remember where I've read about it, neither do I know the status
> of it.
>
> If you want to eliminate the single point of failure, you may want to try
> mdadm with its write-mostly option instead of using bcache. It's slower for
> writes obviously but gracefully falls back if the SSD fails. Obviously, you
> can also not benefit from having a huge storage because it's classic RAID-1
> and thus the smallest member will limit your storage size.
>
> Bcache also has countermeasures for a failing caching device but I didn't
> really look into that yet. You should read the documentation about it in
> Documentation/bcache.txt (Error Handling). The safest mode to use here is
> writethrough.

A work of caution here: At least in my layered (kernel 3.18.8)  
situation, the upper layers from time to time run into some sort of  
time-out situation when writing to (bcached) disk. Teh writes abort  
(bad, but tolerable in my circumstances), but on top this makes MD  
mark the current disk faulty, degrading your RAID.

When using "writeback", the likeliness for this to happen is  
relatively small (not more than once every few days), probably because  
the writes to SSD are fairly quick. These hit then have always been on  
the caching device (MD-RAID1 in my case).

When using "writethrough", the likeliness was extremely higher (I've  
seen 2 hits within 6 hours, not later than 28 hours after switching to  
"writethrough") and the hit was on the data device (MD-RAID6 in my  
case).

Had I only set up RAID5, my data array would have dropped dead then.

After switching back to "writeback", I've had *one* further incident,  
again on the caching device, within 6 days.

I would definitely not call "writethrough" "the safest mode" when  
using MD-RAID for the bcache devices, on kernel 3.18.8.

Regards,
Jens
