From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: Re: Partitions on bcache devices
Date: Thu, 29 Sep 2016 17:40:56 +0200
Message-ID: <20160929174056.Horde.Tkp24xa2MRhriRvK8KE1QU8@www3.nde.ag>
References: <951934014.5256.1475070307225@ox.pcextreme.nl>
 <20160928191142.2e545aa5@harpe.intellique.com>
 <1406388200.5277.1475090090844@ox.pcextreme.nl>
 <20160929160903.10b63b45@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.182]:28696 "EHLO
        mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754998AbcI2Pln (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 29 Sep 2016 11:41:43 -0400
In-Reply-To: <20160929160903.10b63b45@harpe.intellique.com>
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Wido den Hollander <wido@42on.com>, linux-bcache@vger.kernel.org

Hi Emmanuel,

Zitat von Emmanuel Florac <eflorac@intellique.com>:
> [...]
> Two points: first I'm pretty sure LVM is the preferred method nowadays
> to create volumes on disks that are not boot drives. In fact, all
> enterprises distros propose to set up even the boot drive with LVM
> instead of partitionning and have been doing so for 10 years.
> So I'm pretty sure having in ceph the option to use LVM instead of
> partitionning would be a darn good thing :)

I disagree. As a matter of fact, it'd be a bad idea IMO: Unlike with  
what you have given as good examples for LVM usage, the disk layout on  
OSDs is fixed. So you're throwing in a (rather fast, but unnecessary)  
code path intended to provide flexibility, where you need none. This  
causes delays and provides potential problems that can be avoided.  
Another counter-example: You wouldn't put LVM on a disk that's  
intended as a (100%) MD-RAID volume, and add an LV as RAID member...  
you'll add a partition table for a reason, but no extra layer between  
the partition and the RAID stuff.

> Second: are you absolutely sure you can't partition a bcache device?

While I haven't tried in a while, that's the way it was when I tested  
last. No partitioning of the bcache device. If you want multiple  
bcached partitions on a backing store, partition first and then create  
multiple bcached devices. This could be done with the BlueStore  
installer as well, but somebody will have to provide the code to  
optionally bcache the partitions.

Regards,
J
