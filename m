From: Wido den Hollander <wido@42on.com>
Subject: Re: Partitions on bcache devices
Date: Wed, 28 Sep 2016 21:14:50 +0200 (CEST)
Message-ID: <1406388200.5277.1475090090844@ox.pcextreme.nl>
References: <951934014.5256.1475070307225@ox.pcextreme.nl>
 <20160928191142.2e545aa5@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from smtp02.mail.pcextreme.nl ([109.72.87.139]:38776 "EHLO
        smtp02.mail.pcextreme.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752032AbcI1TO6 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 28 Sep 2016 15:14:58 -0400
In-Reply-To: <20160928191142.2e545aa5@harpe.intellique.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Emmanuel Florac <eflorac@intellique.com>
Cc: linux-bcache@vger.kernel.org


> Op 28 september 2016 om 19:11 schreef Emmanuel Florac <eflorac@intellique.com>:
> 
> 
> Le Wed, 28 Sep 2016 15:45:07 +0200 (CEST)
> Wido den Hollander <wido@42on.com> écrivait:
> 
> > Hi,
> > 
> > Currently it is not possible to create partitions on bcache devices,
> > eg, if you have bcache0 you can't create bcache0p1, bcache0p2, etc.
> > 
> > There are patches [0] out there which 'enable' this, but they aren't
> > suited to be send upstream.
> > 
> > For the Ceph [1] project it would be very beneficial if bcache would
> > support the creation of partitions on the devices.
> 
> What's the use case exactly? You can create LVM lvs on bcache devices
> if you need to split them. And I don't really understand why it would
> be beneficial to Ceph, which is about agreggating many devices.
> 

Underneath a Ceph OSD you currently have the FileStore. This uses two partitions on a disk. One for a Journal and the rest for XFS to store it's data.

$ ceph-disk prepare /dev/sda

That would create a GPT layout:

- sda1: 5GB Journal
- sda2: X TB XFS data

Now, with the upcoming BlueStore for Ceph you would have this layout:

- sda1: XFS/EXT4 OSD metadata
- sda2: RocksDB
- sda3: RocksDB WAL
- sda4: BlueStore Blob/Data

In both cases Ceph wants to create partitions on all disks it uses. By adding bcache in between the performance can be boosted really well. Fast NVM-e SSDs with some large SATA drives vastly improve performance.

Yes, you could use LVM in between, but that just adds more layers and is rather complex to accomplish with the current tooling. If bcache would support partitions it would all be a lot easier.

And next to Ceph there might be other tools which can benefit from partitions on bcache, who knows?

Wido

> -- 
> ------------------------------------------------------------------------
> Emmanuel Florac     |   Direction technique
>                     |   Intellique
>                     |	<eflorac@intellique.com>
>                     |   +33 1 78 94 84 02
> ------------------------------------------------------------------------
