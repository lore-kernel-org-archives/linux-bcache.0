From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: Re: layering question.
Date: Fri, 07 Aug 2015 18:24:13 +0200
Message-ID: <20150807182413.Horde.gYQ0jmSi6dPcSZ7amGH5GRV@www3.nde.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.182]:43579 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932341AbbHGQY2 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 7 Aug 2015 12:24:28 -0400
Received: from hh2-mail.hh.nde.ag (gw-hh2.hh.nde.ag [85.183.17.20])
	by post.strato.de (RZmta 37.8 AUTH)
	with ESMTPA id w04f1dr77GOQfWk
	for <linux-bcache@vger.kernel.org>;
	Fri, 7 Aug 2015 18:24:26 +0200 (CEST)
Received: from www3.nde.ag (hh2-www.hh.nde.ag [192.168.102.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by hh2-mail.hh.nde.ag (Postfix) with ESMTPS id DC2051C05C
	for <linux-bcache@vger.kernel.org>; Fri,  7 Aug 2015 18:24:13 +0200 (CEST)
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi James,

Zitat von "A. James Lewis" <james@fsck.co.uk>:
> OK, but in that case bcache is not between your MD RAID and it's  
> disks, so if your disks are dropping out of the MD array, that has  
> to be either an independent problem, or a very complex bug.

My guess is that it's a rather simple timeout / locking problem, which  
leads to an expiring timer in the MD code. And bcache has a well-known  
history for locking problems, according to the mailing list.

Regards,
Jens

> James
>
>
> On 07/08/15 16:36, Jens-U. Mozdzen wrote:
>> Hi James,
>>
>> Zitat von "A. James Lewis" <james@fsck.co.uk>:
>>> That's interesting, are you putting your MD on top of multiple  
>>> bcache devices... rather than bcache on top of an MD device... I  
>>> wonder what the rationale behind this is?
>>
>> Hi James, no such thing here...
>>
>> bcache is running on top of two MD-RAIDs - RAID6 with 7 spinning  
>> drives and RAID1 with two SSDs.
>>
>> The stack is, from bottom to top:
>>
>> - MD-RAID6 data, MD-RAID1 cache
>> - bcache (/dev/bcache0, used as an LVM PV)
>> - LVM
>> - many LVs
>> - DRBD on top of most of the LVs
>> - Ext4 on each of the DRBD devices
>> - SCST / NFS / SMB sharing these file systems
>>
>> In the referenced incidents, SCST reports that (many) writes failed  
>> due to time-out, and MD reports a single disk faulty. No other  
>> traces in syslog, especially no stalled processes, locking problems  
>> or kernel bugs.
>>
>> The i/o pattern is highly parallel reads and writes, mostly via SCST.
>>
>> Regards,
>> Jens
