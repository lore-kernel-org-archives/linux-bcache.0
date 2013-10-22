From: matthew patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Re: bcache not working on large files?
Date: Tue, 22 Oct 2013 15:27:09 -0700 (PDT)
Message-ID: <1382480829.46079.YahooMailNeo@web181504.mail.ne1.yahoo.com>
References: <20131022070830.GA20286@euve30603.vserver.de> <5266B774.6040202@rolffokkens.nl> <20131022180316.GA24473@euve30603.vserver.de> <1382476284.36900.YahooMailNeo@web181506.mail.ne1.yahoo.com> <20131022214553.GC26186@euve30603.vserver.de>
Reply-To: matthew patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131022214553.GC26186-TGNR7510c4H9eX/OD4jYIkzuTB+3w3uf@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dirk Geschke <dirk-WMiem5eIfR0n5izryJqWLw@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org



>> cache. It's supposed to fail. Bcache will(?) properly handle a busted SSD.

> 
> The doumentation says no and recommends a RAID. That's the reason 
> why it is used in WriteThrough mode per default.

'busted' in this case means errors on write. If the device disappears and is no longer readable, then sure any un-committed blocks are gone and your filesystem/file is broken.

On write failure (how many?) I would sure hope the code-path marks the malfunctioning SSD as disabled and just sends the writes to the HDD. Whether it then gets more aggressive about de-staging previously staged writes I don't know (probably not) but just as long as the SSD is readable the dirty blocks can be written out.

If you're not running kernel 3.11.5 (or 3.11.4 with *all* the bcache fixes) you're wasting your time.
