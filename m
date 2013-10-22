From: Dirk Geschke <dirk-WMiem5eIfR0n5izryJqWLw@public.gmane.org>
Subject: Re: bcache not working on large files?
Date: Tue, 22 Oct 2013 23:45:53 +0200
Message-ID: <20131022214553.GC26186@euve30603.vserver.de>
References: <20131022070830.GA20286@euve30603.vserver.de>
 <5266B774.6040202@rolffokkens.nl>
 <20131022180316.GA24473@euve30603.vserver.de>
 <1382476284.36900.YahooMailNeo@web181506.mail.ne1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1382476284.36900.YahooMailNeo-XYahOdtEMNlRBbKmAC7my5OW+3bF1jUfVpNB7YpNyf8@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matthew patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Cc: Dirk Geschke <dirk-WMiem5eIfR0n5izryJqWLw@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hi Matthew,

> > no, I was explicitly testing random I/O writes of 4k blocks,=20
> > no sequential writing. With a file of 1000 GB it does work, but
> > if I use a 10000 GB file, it seems to fail. I would expect, that
> > the size should not really matter here, at least until the cache
> > is filled up.
>=20
>=20
> When the SSD gets too slow it will get by-passed by bcache. The tunab=
le is in the document. Though if memory serves it's a latency of 20ms f=
or writes which is probably way too short since SSDs can easily take 1-=
5 seconds when they have to resort to heavy lifting.

ah, that could be an explanation for this effect. But I do not find
an apropriate parameter in the documentation. Do you have a hint?

> What you should do is turn off RAID controller READ caching entirely.=
 And turn OFF writeBACK-caching for the SSD-based LUN(s) at said contro=
ller that are being used as bcache caching devices.

hmm, yes read cache for SSDs is a kind of overhead. You mean, this may
have an impact, too? Actually I am not sure about the settings, it is
likely the default...

However, it worked with smaller files like 1000 GB. There is no change
at all in random I/O but the size of the file I am using.

> It would be helpful is you elaborated as to the HBA and SSD drives yo=
u are using. BTW doing RAID across the SSDs being used for cache is rat=
her pointless IMO. You're shortening their life, adding unnecessary wri=
te IOPs. It's a cache. It's supposed to fail. Bcache will(?) properly h=
andle a busted SSD.

The doumentation says no and recommends a RAID. That's the reason=20
why it is used in WriteThrough mode per default. Probably a RAID 5/6
is not a good idea for a Caching SSD-RAID, especially when the HDDs
form a RAID 5/6 on the same controller, too.

Probably a RAID 10 would be better...

> Cache is only useful for absorbing sudden spikes in IOPs or for highl=
y localized and frequently re-used blocks. It's not intended to magical=
ly improve the underlying storage by 10-100x under a load that can't be=
 sustained by said layer. Big $$$ SANs have lots of cache but at some p=
oint you will reach the saturation point and everything slows to HDD sp=
eed.

Yes, I was just testing random I/O. And I had expected, that bcache
will work with large files, too.

So with 8 threads doing random I/O of 4k blocks in a 1000 GB file
results in IOPS in the range of about 20,000. The same setup with
a file of 10,000 GB results in an IOPS of about 400. That is about
the same rate the HDDs have without bcache. This is something I did
not expect. It looks like bcache stopped to work at all...

Maybe your first comment explains this, so that the SSDs get too
lazy. Maybe this is due to the raid controller working with the
HDDs.=20

> I also wouldn't futz with the EXT4 settings you had posted previously=
 while doing =A0benchmark runs because I expect it gets in the way and =
makes performance worse than if the block stream was less chunky. Only =
once you have defined a realistic sustained workload and know how often=
 and how fast journaled-to-SSD writes (bcache write-back) can reasonabl=
y be de-staged would I revisit those tuning parameters and see if there=
 is any merit to them.

Oh, that must be another thread, I am using XFS... ;-)

> Personally I put NVRAM boards in my servers to be filesystem journals=
 and MD mirror maps. They're incredibly cheap.

I am just curious, where the limits are and in which ranges on can=20
use bcache. But I did not expect this result, therefore I asked for
a hint. I would have expected, it would work as before. The random
writes would entirely fit in the SSD cache even if the HDDs would
sleep all the time...

And yes, I am not convinced that a RAID 5/6 for SSD caches is really a
good idea. Hmm, maybe I can use a RAID 10 instead...

Best regards

Dirk

--=20
+----------------------------------------------------------------------=
+
| Dr. Dirk Geschke       / Plankensteinweg 61    / 85435 Erding        =
|
| Telefon: 08122-559448  / Mobil: 0176-96906350 / Fax: 08122-9818106   =
|
| dirk-tpR6ahGJfjwEZ6m2XrtfILNAH6kLmebB@public.gmane.org / dirk-WMiem5eIfR0n5izryJqWLw@public.gmane.org  / kontakt-WMiem5eIfR0n5izryJqWLw@public.gmane.org =
|
+----------------------------------------------------------------------=
+
