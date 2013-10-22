From: Dirk Geschke <dirk-WMiem5eIfR0n5izryJqWLw@public.gmane.org>
Subject: bcache not working on large files?
Date: Tue, 22 Oct 2013 09:08:30 +0200
Message-ID: <20131022070830.GA20286@euve30603.vserver.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi all,

I was just playing a little bit with bcache and it works fine. But
if I try random IOPS writes (writeback) on a file larger than the
cache, it seems not to work? At least I get a performance as without
bcache.

I used a RAID-6 of 8 SSDs (each 238 GiB) as a cache and a RAID-6 of
10 HDDs (2794 Gib). For my test I did random writes of 4k blocks.
With 8 threads writing on one 1000 GB file, I get IOPS in the range
of 20000, but with a file of 10000 GB I end up with about 400 IOPS.
That is the same as without cache. 

Did I miss something? Is caching disabled in such cases?

I would expect, that even in this case (writeback and random writes)
it should work as well. Even after a few minutes I get these results,
so it is not a problem of a full cache.

Has anyone a hint for me, what is going wrong?

Best regards

Dirk

-- 
+----------------------------------------------------------------------+
| Dr. Dirk Geschke       / Plankensteinweg 61    / 85435 Erding        |
| Telefon: 08122-559448  / Mobil: 0176-96906350 / Fax: 08122-9818106   |
| dirk-tpR6ahGJfjwEZ6m2XrtfILNAH6kLmebB@public.gmane.org / dirk-WMiem5eIfR0n5izryJqWLw@public.gmane.org  / kontakt-WMiem5eIfR0n5izryJqWLw@public.gmane.org |
+----------------------------------------------------------------------+
