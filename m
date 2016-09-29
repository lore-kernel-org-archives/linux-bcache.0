From: Wido den Hollander <wido@42on.com>
Subject: Re: Partitions on bcache devices
Date: Thu, 29 Sep 2016 17:38:38 +0200 (CEST)
Message-ID: <225072061.5367.1475163518820@ox.pcextreme.nl>
References: <951934014.5256.1475070307225@ox.pcextreme.nl>
 <20160928191142.2e545aa5@harpe.intellique.com>
 <1406388200.5277.1475090090844@ox.pcextreme.nl>
 <20160929160903.10b63b45@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from smtp02.mail.pcextreme.nl ([109.72.87.139]:58948 "EHLO
        smtp02.mail.pcextreme.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753791AbcI2Pip (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 29 Sep 2016 11:38:45 -0400
In-Reply-To: <20160929160903.10b63b45@harpe.intellique.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Emmanuel Florac <eflorac@intellique.com>
Cc: linux-bcache@vger.kernel.org


> Op 29 september 2016 om 16:09 schreef Emmanuel Florac <eflorac@intellique.com>:
> 
> 
> Le Wed, 28 Sep 2016 21:14:50 +0200 (CEST)
> Wido den Hollander <wido@42on.com> écrivait:
> 
> > In both cases Ceph wants to create partitions on all disks it uses.
> > By adding bcache in between the performance can be boosted really
> > well. Fast NVM-e SSDs with some large SATA drives vastly improve
> > performance.
> > 
> > Yes, you could use LVM in between, but that just adds more layers and
> > is rather complex to accomplish with the current tooling. If bcache
> > would support partitions it would all be a lot easier.
> > 
> > And next to Ceph there might be other tools which can benefit from
> > partitions on bcache, who knows?
> 
> Two points: first I'm pretty sure LVM is the preferred method nowadays
> to create volumes on disks that are not boot drives. In fact, all
> enterprises distros propose to set up even the boot drive with LVM
> instead of partitionning and have been doing so for 10 years. 
> So I'm pretty sure having in ceph the option to use LVM instead of
> partitionning would be a darn good thing :)
> 

Thanks for the information :) Currently not really a option with Ceph.

> Second: are you absolutely sure you can't partition a bcache device?
> Does parted refuse to open and partition it? In which case, you may
> only be missing some appropriate udev rules.
> 

Yes, I'm sure. You can create the partitions, but they will not show up as devices which you can use due to a limitation in the bcache kernel driver.

Patches [0] are out there to make this work, but they are not in bcache yet.

Hence my thread if this support can be added.

Wido

[0]: https://yaple.net/2016/03/31/bcache-partitions-and-dkms/

> -- 
> ------------------------------------------------------------------------
> Emmanuel Florac     |   Direction technique
>                     |   Intellique
>                     |	<eflorac@intellique.com>
>                     |   +33 1 78 94 84 02
> ------------------------------------------------------------------------
