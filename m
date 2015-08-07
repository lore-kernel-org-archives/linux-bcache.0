From: "A. James Lewis" <james@fsck.co.uk>
Subject: Re: layering question.
Date: Fri, 07 Aug 2015 17:16:18 +0100
Message-ID: <55C4D9D2.9050401@fsck.co.uk>
References: <55C0E63F.2030007@fsck.co.uk>	<k0n89c-dgn.ln1@hurikhan77.spdns.de>	<20150805090446.Horde.VMReCuJzW3PwyI8Gh_BZ_yJ@www3.nde.ag>	<poha9c-rh4.ln1@hurikhan77.spdns.de> <55C2B034.2090404@fsck.co.uk>	<u76d9c-m19.ln1@hurikhan77.spdns.de>	<20150807144344.Horde.5xyJhwIOzk_C5q__CpHL4IV@www3.nde.ag>	<55C4C2E9.7020501@fsck.co.uk> <20150807173602.Horde.dWINpeEAKs7BuPiCgWmUMrJ@www3.nde.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from dozer.fsck.co.uk ([77.246.163.77]:58837 "EHLO dozer.fsck.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932216AbbHGQQV (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Fri, 7 Aug 2015 12:16:21 -0400
Received: from dozer.fsck.co.uk (localhost.localdomain [127.0.0.1])
	by dozer.fsck.co.uk (Postfix) with ESMTP id 6F06369004C
	for <linux-bcache@vger.kernel.org>; Fri,  7 Aug 2015 17:34:44 +0100 (BST)
Received: from [192.168.0.20] (80-46-130-192.static.dsl.as9105.com [80.46.130.192])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by dozer.fsck.co.uk (Postfix) with ESMTPSA id 22F8B69003F
	for <linux-bcache@vger.kernel.org>; Fri,  7 Aug 2015 17:34:44 +0100 (BST)
In-Reply-To: <20150807173602.Horde.dWINpeEAKs7BuPiCgWmUMrJ@www3.nde.ag>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org


OK, but in that case bcache is not between your MD RAID and it's disks, 
so if your disks are dropping out of the MD array, that has to be either 
an independent problem, or a very complex bug.

James


On 07/08/15 16:36, Jens-U. Mozdzen wrote:
> Hi James,
>
> Zitat von "A. James Lewis" <james@fsck.co.uk>:
>> That's interesting, are you putting your MD on top of multiple bcache
>> devices... rather than bcache on top of an MD device... I wonder what
>> the rationale behind this is?
>
> Hi James, no such thing here...
>
> bcache is running on top of two MD-RAIDs - RAID6 with 7 spinning
> drives and RAID1 with two SSDs.
>
> The stack is, from bottom to top:
>
> - MD-RAID6 data, MD-RAID1 cache
> - bcache (/dev/bcache0, used as an LVM PV)
> - LVM
> - many LVs
> - DRBD on top of most of the LVs
> - Ext4 on each of the DRBD devices
> - SCST / NFS / SMB sharing these file systems
>
> In the referenced incidents, SCST reports that (many) writes failed
> due to time-out, and MD reports a single disk faulty. No other traces
> in syslog, especially no stalled processes, locking problems or kernel
> bugs.
>
> The i/o pattern is highly parallel reads and writes, mostly via SCST.
>
> Regards,
> Jens
>
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
