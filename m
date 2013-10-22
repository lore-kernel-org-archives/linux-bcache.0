From: Dirk Geschke <dirk-WMiem5eIfR0n5izryJqWLw@public.gmane.org>
Subject: Re: bcache not working on large files?
Date: Tue, 22 Oct 2013 20:03:16 +0200
Message-ID: <20131022180316.GA24473@euve30603.vserver.de>
References: <20131022070830.GA20286@euve30603.vserver.de>
 <5266B774.6040202@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5266B774.6040202-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Cc: Dirk Geschke <dirk-WMiem5eIfR0n5izryJqWLw@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi Rolf,

> >I was just playing a little bit with bcache and it works fine. But
> >if I try random IOPS writes (writeback) on a file larger than the
> >cache, it seems not to work? At least I get a performance as without
> >bcache.
> >
> >Did I miss something? Is caching disabled in such cases?
> >
> >Has anyone a hint for me, what is going wrong?
> Bcache has some specific handling of sequential I/O:
> 
> http://evilpiepirate.org/git/linux-bcache.git/tree/Documentation/bcache.txt
> 
> Could this explain what you're seeing?

no, I was explicitly testing random I/O writes of 4k blocks, 
no sequential writing. With a file of 1000 GB it does work, but
if I use a 10000 GB file, it seems to fail. I would expect, that
the size should not really matter here, at least until the cache
is filled up.

The only thing I can imagine is a problem with the RAID controller.
Both RAIDs (HDDs and SSDs) are on the same controller. Maybe the
controller slows down the SSD cache if it writes to the HDDs?

Hmm, maybe I should do two test prarallel, benchmarking random
writes of 4k blocks to a 1000 GB file on the SSD RAID and random
writes on the HDD RAID. Maybe with random I/O on a 10000 GB file 
would take too long and slow down the SSD RAID?

I will see if I can test it. So maybe it is not an issue of BCache
at all...

Best regards

Dirk
-- 
+----------------------------------------------------------------------+
| Dr. Dirk Geschke       / Plankensteinweg 61    / 85435 Erding        |
| Telefon: 08122-559448  / Mobil: 0176-96906350 / Fax: 08122-9818106   |
| dirk-tpR6ahGJfjwEZ6m2XrtfILNAH6kLmebB@public.gmane.org / dirk-WMiem5eIfR0n5izryJqWLw@public.gmane.org  / kontakt-WMiem5eIfR0n5izryJqWLw@public.gmane.org |
+----------------------------------------------------------------------+
