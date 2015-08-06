From: "A. James Lewis" <james@fsck.co.uk>
Subject: Re: layering question.
Date: Thu, 06 Aug 2015 01:54:12 +0100
Message-ID: <55C2B034.2090404@fsck.co.uk>
References: <55C0E63F.2030007@fsck.co.uk>	<k0n89c-dgn.ln1@hurikhan77.spdns.de>	<20150805090446.Horde.VMReCuJzW3PwyI8Gh_BZ_yJ@www3.nde.ag> <poha9c-rh4.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from dozer.fsck.co.uk ([77.246.163.77]:52023 "EHLO dozer.fsck.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072AbbHFAyP (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 5 Aug 2015 20:54:15 -0400
Received: from dozer.fsck.co.uk (localhost.localdomain [127.0.0.1])
	by dozer.fsck.co.uk (Postfix) with ESMTP id 01D1269004C
	for <linux-bcache@vger.kernel.org>; Thu,  6 Aug 2015 02:09:20 +0100 (BST)
Received: from [192.168.0.20] (80-46-130-192.static.dsl.as9105.com [80.46.130.192])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by dozer.fsck.co.uk (Postfix) with ESMTPSA id CD71169003F
	for <linux-bcache@vger.kernel.org>; Thu,  6 Aug 2015 02:09:19 +0100 (BST)
In-Reply-To: <poha9c-rh4.ln1@hurikhan77.spdns.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

The problem is tho... with a very large backing store, I'm not really 
happy with a single point of failure in the cache... is there another 
way to mirror the cache device?

Does anyone make an M.2 raid controller... being PCIe, I don't know it 
that could even be possible.

James

On 06/08/15 00:10, Kai Krakow wrote:
> Jens-U. Mozdzen <jmozdzen@nde.ag> schrieb:
>
>> Zitat von Kai Krakow <hurikhan77@gmail.com>:
>>> A. James Lewis <james@fsck.co.uk> schrieb:
>>>
>>>> I've heard rumours that layering bcache with other block device drivers
>>>> might not be recommended... I wonder what the truth really is... perhaps
>>>> someone can advise.
>>> I think this is not just rumours. Multiple people reported problems when
>>> layering caching or backing devices on top of MD devices. This may be an
>>> implementation problem in MD which is gone in later kernel versions [...]
>> being rather new to bcache, I did only browse the last few months of
>> mailing list history - are you saying that these problems were fixed
>> (or simply vanished) some point after 3.18.8? Because if so, I'd of
>> course try to upgrade our servers to a more recent kernel :)
> Latest posts imply it is still a problem. It fits with earlier reports:
> Caching on native device, backing on md device... Bcache breaks within the
> caching device (although this is not on md). There seem to still be bugs
> with bcache and md to properly interact.
>
> It was suspected that bcache uses a faulty discard implementation. Some
> reports miss details about this setting. However, my setups are working fine
> with discards fully enabled on SSD - but without using MD. And it has been
> robust to accidental or implied reboots since all time I'm using it (even
> with btrfs as the filesystem on bcache).
>
> So I'd probably remove MD from your plans on using bcache.
>
> BTW: My system uses vanilla gentoo kernel, 4.1.4 currently.
>
