From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: Re: layering question.
Date: Wed, 05 Aug 2015 09:04:46 +0200
Message-ID: <20150805090446.Horde.VMReCuJzW3PwyI8Gh_BZ_yJ@www3.nde.ag>
References: <55C0E63F.2030007@fsck.co.uk>
 <k0n89c-dgn.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.181]:42973 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbbHEHEx (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 5 Aug 2015 03:04:53 -0400
In-Reply-To: <k0n89c-dgn.ln1@hurikhan77.spdns.de>
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kai Krakow <hurikhan77@gmail.com>
Cc: linux-bcache@vger.kernel.org

Hi Kai,

Zitat von Kai Krakow <hurikhan77@gmail.com>:
> A. James Lewis <james@fsck.co.uk> schrieb:
>
>> I've heard rumours that layering bcache with other block device drivers
>> might not be recommended... I wonder what the truth really is... perhaps
>> someone can advise.
>
> I think this is not just rumours. Multiple people reported problems when
> layering caching or backing devices on top of MD devices. This may be an
> implementation problem in MD which is gone in later kernel versions [...]

being rather new to bcache, I did only browse the last few months of  
mailing list history - are you saying that these problems were fixed  
(or simply vanished) some point after 3.18.8? Because if so, I'd of  
course try to upgrade our servers to a more recent kernel :)

Regards,
Jens
