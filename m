From: matthew patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Re: bcache not working on large files?
Date: Tue, 22 Oct 2013 14:11:24 -0700 (PDT)
Message-ID: <1382476284.36900.YahooMailNeo@web181506.mail.ne1.yahoo.com>
References: <20131022070830.GA20286@euve30603.vserver.de> <5266B774.6040202@rolffokkens.nl> <20131022180316.GA24473@euve30603.vserver.de>
Reply-To: matthew patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131022180316.GA24473-TGNR7510c4H9eX/OD4jYIkzuTB+3w3uf@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dirk Geschke <dirk-WMiem5eIfR0n5izryJqWLw@public.gmane.org>, Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

>>  http://evilpiepirate.org/git/linux-bcache.git/tree/Documentation/bc=
ache.txt

>=20
> no, I was explicitly testing random I/O writes of 4k blocks,=20
> no sequential writing. With a file of 1000 GB it does work, but
> if I use a 10000 GB file, it seems to fail. I would expect, that
> the size should not really matter here, at least until the cache
> is filled up.


When the SSD gets too slow it will get by-passed by bcache. The tunable=
 is in the document. Though if memory serves it's a latency of 20ms for=
 writes which is probably way too short since SSDs can easily take 1-5 =
seconds when they have to resort to heavy lifting.



What you should do is turn off RAID controller READ caching entirely. A=
nd turn OFF writeBACK-caching for the SSD-based LUN(s) at said controll=
er that are being used as bcache caching devices.

It would be helpful is you elaborated as to the HBA and SSD drives you =
are using. BTW doing RAID across the SSDs being used for cache is rathe=
r pointless IMO. You're shortening their life, adding unnecessary write=
 IOPs. It's a cache. It's supposed to fail. Bcache will(?) properly han=
dle a busted SSD.

Cache is only useful for absorbing sudden spikes in IOPs or for highly =
localized and frequently re-used blocks. It's not intended to magically=
 improve the underlying storage by 10-100x under a load that can't be s=
ustained by said layer. Big $$$ SANs have lots of cache but at some poi=
nt you will reach the saturation point and everything slows to HDD spee=
d.

I also wouldn't futz with the EXT4 settings you had posted previously w=
hile doing =A0benchmark runs because I expect it gets in the way and ma=
kes performance worse than if the block stream was less chunky. Only on=
ce you have defined a realistic sustained workload and know how often a=
nd how fast journaled-to-SSD writes (bcache write-back) can reasonably =
be de-staged would I revisit those tuning parameters and see if there i=
s any merit to them.

Personally I put NVRAM boards in my servers to be filesystem journals a=
nd MD mirror maps. They're incredibly cheap.
