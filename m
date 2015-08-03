From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: Re: crash: kernel bug in bch_generic_make_request
Date: Mon, 03 Aug 2015 12:02:16 +0200
Message-ID: <20150803120216.Horde.dsLHmHwhI-N9PUU-svUfoIM@www3.nde.ag>
References: <20150727123616.Horde.QmkKAZrQpCm25D6aq4ZAhJY@www3.nde.ag>
 <20150730181106.Horde.cvOmAMdHdKaT2ONZfVrte0G@www3.nde.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.182]:52094 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbbHCKCZ (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 3 Aug 2015 06:02:25 -0400
Received: from hh2-mail.hh.nde.ag (gw-hh2.hh.nde.ag [85.183.17.20])
	by post.strato.de (RZmta 37.8 AUTH)
	with ESMTPA id z064d4r73A2MNCG
	for <linux-bcache@vger.kernel.org>;
	Mon, 3 Aug 2015 12:02:22 +0200 (CEST)
Received: from www3.nde.ag (hh2-www.hh.nde.ag [192.168.102.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by hh2-mail.hh.nde.ag (Postfix) with ESMTPS id 141401C05C
	for <linux-bcache@vger.kernel.org>; Mon,  3 Aug 2015 12:02:17 +0200 (CEST)
In-Reply-To: <20150730181106.Horde.cvOmAMdHdKaT2ONZfVrte0G@www3.nde.ag>
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

When it rains, it pours.

Zitat von "Jens-U. Mozdzen" <jmozdzen@nde.ag>:
> Zitat von "Jens-U. Mozdzen" <jmozdzen@nde.ag>:
>> Hi everybody,
>>
>> we experience reproducible server crashes (reboots) when creating  
>> new file systems on bcache'd devices.
>
> update: If I set cache_mode to "writethrough", I can successfully  
> create the file system.

over the weekend, I received multiple successive reports about disks  
failing in the RAID, on both servers. This is a rather new hardware  
setup, no disk is older than 6 months, so I didn't actually believe in  
failing disks to be the reason.

In syslog I noticed reports from the upper layers (SCST, which is  
using files on the ext4->DRBD->LVM->bcache->MD-RAID chain) indicating  
stalling disk access; DRBD reporting stalling updates from the remote  
server), both indicating some kind of locking condition inside the  
kernel. The RAID failures were right after these incidents.

With identical workload, but having turned caching back to  
"writeback", no more "RAID failures" were reported.

We received end-user reports that system access sometimes hangs for a  
few seconds, which now makes me believe that the actual cause lies  
somewhere within the software stack on our servers, most probably  
within the bcache layer (as no such problems were reported before  
introducing bcache to our setup).

Is there anyone out there that is running bcache on MD-RAIDs (both for  
data and cache device) with significant I/O volume, successfully? I'd  
like to compare setups then :)

Regards,
Jens
