From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: Re: bcache and LVM
Date: Mon, 08 Feb 2016 14:44:19 +0100
Message-ID: <20160208144419.Horde.Ci1_2KcBCEnOa-WxsDN90oU@www3.nde.ag>
References: <87k2mgo2rz.fsf@vostro.rath.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.183]:35546 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbcBHNuq (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 8 Feb 2016 08:50:46 -0500
In-Reply-To: <87k2mgo2rz.fsf@vostro.rath.org>
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Nikolaus Rath <Nikolaus@rath.org>
Cc: linux-bcache@vger.kernel.org

Hi Nikolaus,

Zitat von Nikolaus Rath <Nikolaus@rath.org>:
> Hello,
>
> The internet claims that using bcache with LVM is not a good idea
> (eg. on https://wiki.archlinux.org/index.php/Bcache )- but I wasn't able
> to find any substantial information other than this general
> recommendation.

looking at that article, it only references possibly ill-handled  
"discard" operations, when running bcache on top of LVM.

The article itself does positively mention sub-dividing bcache devices  
using LVM.

> Is this still (or has ever been) correct? If so, what issues can arise?
> And does this happen only when using bcache on top of an LVM LV, or also
> when using a bcache device as an LVM PV?

We're running bcache between MD-RAID (RAID6 for the HDD backing store  
and RAID1 for caching SSDs) and LVM2 (using bcache0 as the only PV for  
the volume group) without any noticeable problem, for moderate to  
significant load (SAN/NAS servers with NFS, Samba, and virtual  
machines' storage via SCST/FC and SCST/iSCSI).

Regards,
Jens
