From: Dirk Geschke <dirk-WMiem5eIfR0n5izryJqWLw@public.gmane.org>
Subject: Re: bcache not working on large files?
Date: Wed, 23 Oct 2013 16:47:16 +0200
Message-ID: <20131023144715.GA3373@euve30603.vserver.de>
References: <20131022070830.GA20286@euve30603.vserver.de>
 <5266B774.6040202@rolffokkens.nl>
 <20131022180316.GA24473@euve30603.vserver.de>
 <1382476284.36900.YahooMailNeo@web181506.mail.ne1.yahoo.com>
 <20131022214553.GC26186@euve30603.vserver.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131022214553.GC26186-TGNR7510c4H9eX/OD4jYIkzuTB+3w3uf@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hi all,

> So with 8 threads doing random I/O of 4k blocks in a 1000 GB file
> results in IOPS in the range of about 20,000. The same setup with
> a file of 10,000 GB results in an IOPS of about 400. That is about
> the same rate the HDDs have without bcache. This is something I did
> not expect. It looks like bcache stopped to work at all...

I have to correct it: I rebuild the SSD-RAID and used now an RAID 0
instead of RAID 6 for caching. So now I get about 10.000 IOPS with
writing 4k blocks . I think this is 

   a) ok 

and 

   b) it is not a bcache problem

I suspect it is a problem of the raid controller, but I have no clue 
which one...

Probably it is a better decision to use a separate raid controller
for SSD (b)cache...

Best regards

Dirk

-- 
+----------------------------------------------------------------------+
| Dr. Dirk Geschke       / Plankensteinweg 61    / 85435 Erding        |
| Telefon: 08122-559448  / Mobil: 0176-96906350 / Fax: 08122-9818106   |
| dirk-tpR6ahGJfjwEZ6m2XrtfILNAH6kLmebB@public.gmane.org / dirk-WMiem5eIfR0n5izryJqWLw@public.gmane.org  / kontakt-WMiem5eIfR0n5izryJqWLw@public.gmane.org |
+----------------------------------------------------------------------+
