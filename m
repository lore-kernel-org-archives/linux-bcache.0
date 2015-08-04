From: "A. James Lewis" <james@fsck.co.uk>
Subject: Re: layering question.
Date: Tue, 04 Aug 2015 18:16:02 +0100
Message-ID: <55C0F352.8080602@fsck.co.uk>
References: <20150804190107.Horde.CuYUHXjE-ddVDzpxOLcbbPH@www3.nde.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from dozer.fsck.co.uk ([77.246.163.77]:45693 "EHLO dozer.fsck.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093AbbHDRQF (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 4 Aug 2015 13:16:05 -0400
Received: from dozer.fsck.co.uk (localhost.localdomain [127.0.0.1])
	by dozer.fsck.co.uk (Postfix) with ESMTP id 171B961001E
	for <linux-bcache@vger.kernel.org>; Tue,  4 Aug 2015 18:29:08 +0100 (BST)
Received: from [192.168.0.20] (80-46-130-192.static.dsl.as9105.com [80.46.130.192])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by dozer.fsck.co.uk (Postfix) with ESMTPSA id DE94B610001
	for <linux-bcache@vger.kernel.org>; Tue,  4 Aug 2015 18:29:07 +0100 (BST)
In-Reply-To: <20150804190107.Horde.CuYUHXjE-ddVDzpxOLcbbPH@www3.nde.ag>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org


Thanks for the details... to clarify, you are using raid1 for SSD cache 
devices, and then creating a RAID6 MD device to act as backing store?

What kernel are you using? You are having some stability issues, but in 
principle it works?...  what is performance like?

James


On 04/08/15 18:01, Jens-U. Mozdzen wrote:
> Hi James,
>
> Zitat von "A. James Lewis" <james@fsck.co.uk>:
>> Hi all...
>>
>> I've heard rumours that layering bcache with other block device 
>> drivers might not be recommended... I wonder what the truth really 
>> is... perhaps someone can advise.
>
> to me it's more than rumors. We're facing severe difficulties (server 
> reboots, disks marked faulty by MDRAID, hangs) in our layered setup:
>
> - physical disks MD-RAID6 (data) plus two SSDs MD-RAID1 (cache)
> - bcache
> - LVM
> - DRBD for many of the logical volumes (always primary, no fail-overs)
> - ext4 fs
> - NFS / Samba / SCST (fileio)
>
>> I was planning to use 2 SSD's... combined with 4 large spinning 
>> drives to create a large filesystem with BTRFS...  my questions are 
>> as follows.
>>
>> 1. Is there a way to use 2 SSD's directly, or would it be OK to use 
>> MD to stripe them?... then used the MD array as the cache device?
>
> MD-RAID1 is what our current configuration looks like. We've also 
> combined the spinning disks into a RAID6.
>
>> 2. I would be using BTRFS, so would it be better to create 4 separate 
>> bcache devices each attached to the single cache device, and then use 
>> BTRFS to raid 4 bcache devices... obviously this would be more 
>> flexible, or would I need to make an MD raid of the 4 devices, and 
>> then use that to create a single bcache device and build a BTRFS 
>> filesystem on top of that.
>
> I have no btrfs experience, so I cannot answer that one. I went for a 
> single data and cache device (via RAID) so I won't have to partition 
> my SSDs - that would not have been scalable (we're planning to add 
> plenty of physical disks over time, and to use many LVs/file systems).
>
>> Also, there's talk about a pending on-disk cache format change some 
>> time around 3.19, but no details... is this over with, or still pending?
>
> Someone else might want to help with that one as well?
>
> Regards,
> Jens
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
