From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: layering question.
Date: Thu, 06 Aug 2015 01:10:49 +0200
Message-ID: <poha9c-rh4.ln1@hurikhan77.spdns.de>
References: <55C0E63F.2030007@fsck.co.uk> <k0n89c-dgn.ln1@hurikhan77.spdns.de> <20150805090446.Horde.VMReCuJzW3PwyI8Gh_BZ_yJ@www3.nde.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42498 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbbHEXK5 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 5 Aug 2015 19:10:57 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1ZN7pn-0002Lp-C5
	for linux-bcache@vger.kernel.org; Thu, 06 Aug 2015 01:10:55 +0200
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Thu, 06 Aug 2015 01:10:55 +0200
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Thu, 06 Aug 2015 01:10:55 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Jens-U. Mozdzen <jmozdzen@nde.ag> schrieb:

> Zitat von Kai Krakow <hurikhan77@gmail.com>:
>> A. James Lewis <james@fsck.co.uk> schrieb:
>>
>>> I've heard rumours that layering bcache with other block device drivers
>>> might not be recommended... I wonder what the truth really is... perhaps
>>> someone can advise.
>>
>> I think this is not just rumours. Multiple people reported problems when
>> layering caching or backing devices on top of MD devices. This may be an
>> implementation problem in MD which is gone in later kernel versions [...]
> 
> being rather new to bcache, I did only browse the last few months of
> mailing list history - are you saying that these problems were fixed
> (or simply vanished) some point after 3.18.8? Because if so, I'd of
> course try to upgrade our servers to a more recent kernel :)

Latest posts imply it is still a problem. It fits with earlier reports: 
Caching on native device, backing on md device... Bcache breaks within the 
caching device (although this is not on md). There seem to still be bugs 
with bcache and md to properly interact.

It was suspected that bcache uses a faulty discard implementation. Some 
reports miss details about this setting. However, my setups are working fine 
with discards fully enabled on SSD - but without using MD. And it has been 
robust to accidental or implied reboots since all time I'm using it (even 
with btrfs as the filesystem on bcache).

So I'd probably remove MD from your plans on using bcache.

BTW: My system uses vanilla gentoo kernel, 4.1.4 currently.

-- 
Replies to list only preferred.
