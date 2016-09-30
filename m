From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: Re: Partitions on bcache devices
Date: Fri, 30 Sep 2016 10:30:45 +0200
Message-ID: <20160930103045.Horde.OTV589oERGwRhKzf9FmPFKB@www3.nde.ag>
References: <951934014.5256.1475070307225@ox.pcextreme.nl>
 <20160928191142.2e545aa5@harpe.intellique.com>
 <1406388200.5277.1475090090844@ox.pcextreme.nl>
 <20160929160903.10b63b45@harpe.intellique.com>
 <20160929174056.Horde.Tkp24xa2MRhriRvK8KE1QU8@www3.nde.ag>
 <20160929183122.3641f307@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.181]:24260 "EHLO
        mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751161AbcI3Iau (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 30 Sep 2016 04:30:50 -0400
In-Reply-To: <20160929183122.3641f307@harpe.intellique.com>
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Emmanuel Florac <eflorac@intellique.com>
Cc: linux-bcache@vger.kernel.org

Zitat von Emmanuel Florac <eflorac@intellique.com>:
> Le Thu, 29 Sep 2016 17:40:56 +0200
> "Jens-U. Mozdzen" <jmozdzen@nde.ag> écrivait:
>
>> Another counter-example: You wouldn't put LVM on a disk that's
>> intended as a (100%) MD-RAID volume, and add an LV as RAID member...
>> you'll add a partition table for a reason, but no extra layer
>> between the partition and the RAID stuff.
>>
>
> I agree, but usually you wouldn't partition an MD-RAID either, would
> you? OSDs are still holding (so far) ordinary filesystems locally
> mounted on the nodes (except for BlueStore AFAIK).

in both cases, it's a matter of your point of view.

I treat bcache as a means to introduce "hybrid disks" (or rather  
hybrid block devices), where I can take standard HDDs and extend them  
by adding SSD caching at the OS layer - instead of buying special RAID  
controllers or hybrid disks. This adds a layer of flexibility (in  
terms of "buying choice") for me.

>
> Anyway bcache would mostly make sense for the journal, much less for
> the data section, so wouldn't it better to use bcache (or flash) for
> journal/metadata only?

SSDs provide a lot of space nowadays, why not speed up all accesses?  
This will lead to faster persistence and probably faster read access  
as well (depending on your workload).
