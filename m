From: Wido den Hollander <wido@42on.com>
Subject: Re: Partitions on bcache devices
Date: Thu, 29 Sep 2016 18:52:14 +0200 (CEST)
Message-ID: <293451899.5382.1475167934533@ox.pcextreme.nl>
References: <951934014.5256.1475070307225@ox.pcextreme.nl>
 <20160928191142.2e545aa5@harpe.intellique.com>
 <1406388200.5277.1475090090844@ox.pcextreme.nl>
 <20160929160903.10b63b45@harpe.intellique.com>
 <20160929174056.Horde.Tkp24xa2MRhriRvK8KE1QU8@www3.nde.ag>
 <20160929183122.3641f307@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from smtp01.mail.pcextreme.nl ([109.72.87.137]:54756 "EHLO
        smtp01.mail.pcextreme.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751287AbcI2QwV (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 29 Sep 2016 12:52:21 -0400
In-Reply-To: <20160929183122.3641f307@harpe.intellique.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Jens-U. Mozdzen" <jmozdzen@nde.ag>, Emmanuel Florac <eflorac@intellique.com>
Cc: linux-bcache@vger.kernel.org


> Op 29 september 2016 om 18:31 schreef Emmanuel Florac <eflorac@intellique.com>:
> 
> 
> Le Thu, 29 Sep 2016 17:40:56 +0200
> "Jens-U. Mozdzen" <jmozdzen@nde.ag> écrivait:
> 
> > Another counter-example: You wouldn't put LVM on a disk that's  
> > intended as a (100%) MD-RAID volume, and add an LV as RAID member...  
> > you'll add a partition table for a reason, but no extra layer
> > between the partition and the RAID stuff.
> > 
> 
> I agree, but usually you wouldn't partition an MD-RAID either, would
> you? OSDs are still holding (so far) ordinary filesystems locally
> mounted on the nodes (except for BlueStore AFAIK).
> 

I have partitioned MD-RAID before, works just fine.

FileStore currently has a local XFS filesystem indeed, with BlueStore the OSD will consume a RAW device.

> Anyway bcache would mostly make sense for the journal, much less for
> the data section, so wouldn't it better to use bcache (or flash) for
> journal/metadata only?
>

The Journal will be gone with BlueStore and that will become the RocksDB WAL. Using bcache for the data partition (the large one) will still benefit since frequently accessed blocks can be cached and thus lower the read latency.

The question still remains, can bcache be patched that it allocates the right minor in the kernel so that it allows for partitions.

I'm not a kernel nor bcache developer, just looking for somebody who would be willing to do this. Happy to assist, support and test!

Wido
 
> -- 
> ------------------------------------------------------------------------
> Emmanuel Florac     |   Direction technique
>                     |   Intellique
>                     |	<eflorac@intellique.com>
>                     |   +33 1 78 94 84 02
> ------------------------------------------------------------------------
