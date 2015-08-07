From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: Re: layering question.
Date: Fri, 07 Aug 2015 17:36:02 +0200
Message-ID: <20150807173602.Horde.dWINpeEAKs7BuPiCgWmUMrJ@www3.nde.ag>
References: <55C0E63F.2030007@fsck.co.uk>
 <k0n89c-dgn.ln1@hurikhan77.spdns.de>
 <20150805090446.Horde.VMReCuJzW3PwyI8Gh_BZ_yJ@www3.nde.ag>
 <poha9c-rh4.ln1@hurikhan77.spdns.de> <55C2B034.2090404@fsck.co.uk>
 <u76d9c-m19.ln1@hurikhan77.spdns.de>
 <20150807144344.Horde.5xyJhwIOzk_C5q__CpHL4IV@www3.nde.ag>
 <55C4C2E9.7020501@fsck.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.180]:10343 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072AbbHGPgS (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 7 Aug 2015 11:36:18 -0400
In-Reply-To: <55C4C2E9.7020501@fsck.co.uk>
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "A. James Lewis" <james@fsck.co.uk>
Cc: linux-bcache@vger.kernel.org

Hi James,

Zitat von "A. James Lewis" <james@fsck.co.uk>:
> That's interesting, are you putting your MD on top of multiple  
> bcache devices... rather than bcache on top of an MD device... I  
> wonder what the rationale behind this is?

Hi James, no such thing here...

bcache is running on top of two MD-RAIDs - RAID6 with 7 spinning  
drives and RAID1 with two SSDs.

The stack is, from bottom to top:

- MD-RAID6 data, MD-RAID1 cache
- bcache (/dev/bcache0, used as an LVM PV)
- LVM
- many LVs
- DRBD on top of most of the LVs
- Ext4 on each of the DRBD devices
- SCST / NFS / SMB sharing these file systems

In the referenced incidents, SCST reports that (many) writes failed  
due to time-out, and MD reports a single disk faulty. No other traces  
in syslog, especially no stalled processes, locking problems or kernel  
bugs.

The i/o pattern is highly parallel reads and writes, mostly via SCST.

Regards,
Jens
