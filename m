From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: How to create bcachefs?
Date: Thu, 25 Aug 2016 18:48:22 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1608251846530.10662@mail.ewheeler.net>
References: <e6d5ceae4a7dd53daf2667e25b76539b@mejor.pl>        <20160824065212.fzs2nk3rg7z7iudb@kmo-pixel>        <f92c1177-565d-47a1-b3ad-1876774003d4@mejor.pl>        <1472083387.31787.0@mail.cooperteam.net>        <2f1e41df-3f3e-0115-e21b-2f1fb2148934@mejor.pl>
        <1472123394.15072.7@mail.cooperteam.net>        <13f3920b-638f-bf04-40ec-7cece2c34b78@mejor.pl> <1472173610.31787.2@mail.cooperteam.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1641074820-780232114-1472176102=:10662"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:52387 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756872AbcHZBtr (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 25 Aug 2016 21:49:47 -0400
In-Reply-To: <1472173610.31787.2@mail.cooperteam.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Christopher James Halse Rogers <chris@cooperteam.net>
Cc: =?ISO-8859-2?Q?Marcin_Miros=B3aw?= <marcin@mejor.pl>, linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1641074820-780232114-1472176102=:10662
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 26 Aug 2016, Christopher James Halse Rogers wrote:

> 
> 
> On Thu, Aug 25, 2016 at 10:11 PM, Marcin Mirosław <marcin@mejor.pl> wrote:
> > W dniu 25.08.2016 o 13:09, Christopher James Halse Rogers pisze:
> > > 
> > > 
> > > On Thu, Aug 25, 2016 at 7:21 PM, Marcin MirosÅ‚aw <marcin@mejor.pl> wrote:
> > > >  W dniu 25.08.2016 o 02:03, Christopher James Halse Rogers pisze:
> > > > 
> > > >  Hi!
> > > > 
> > > > >   On Thu, Aug 25, 2016 at 7:21 AM, marcin@mejor.pl wrote:
> > > >  [...]
> > > > > >   Does it means that cache is unavailable and only tiering will be
> > > > > > in
> > > > > >   bcachefs?
> > > > > >   And... How to mount tiered FS? When I pass one device in mount 
> > > > > > I'm
> > > > > >   getting:
> > > > > >    bcache: bch_open_as_blockdevs() register_cache_set err
> > > > > > insufficient
> > > > > >   devices
> > > > > 
> > > > >   Tiering gets you all the advantages of caching, plus you can (with
> > > > > some
> > > > >   effort) have the combined filesystem size be the sum of the SSD +
> > > > > HDD
> > > > >   capacities, rather than the capacity be determined solely by the
> > > > >   capacity of the slow tier (this is not currently the case for
> > > > >  bcachefs).
> > > > 
> > > >  I think that cacheing has at least such advantages over tiering:
> > > >  - allow fast read and write to files compressed with slow alghoritm
> > > >  (gzip)
> > > 
> > > I think this is getting into ā€œwhat should we call this thingā€?
> > > arguments. A naive cache is just going to promote the gzipped data to
> > > the fast storage. On the other end, there's nothing much preventing a
> > > sophisticated tiering system from compressing/decompressing as a part of
> > >  tier demotion/promotion.
> > 
> > When (de|re)compressing would be part of demotion or promotion then I
> > agree, cache device doesn't have advantages.
> 
> You also don't get (de|re)compression for free in a caching strategy depending
> on where you put your cache. For example, a traditional bcache cache backing a
> compressed filesystem will only ever see compressed data.

Nor crypto.  Best to compress->encrypt->store.


--
Eric Wheeler


> 
> > 
> > > >  - can be optimized for using SSD drives
> > > 
> > > It's not clear to me how? Tiering and caching are doing the same sort of
> > >  things.
> > I don't know how bcachefs handle SSD drives. SSD are faster in
> > sequential write, I'm not sure if it could be achieved using tier
> > device. Using cache device on disk format can be different than using in
> > bcachefs and can turn random writes into sequential writes.
> 
> I believe you mean *HDDs* are faster in sequential write? This is exactly what
> tiering gets you - all writes go to the fast, SSD storage¹, and then data are
> migrated off to the slower HDD in big, sequential chunks.
> 
> ¹: Indeed, IIRC this is the only dataloss bug I've found in bcachefs - I wrote
> too much data too fast, the migration from tier 0 to tier 1 couldn't keep up,
> and tier 0 filled up to the point where it could no longer write necessary
> journal entries, resulting in the filesystem being unmountable.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
--1641074820-780232114-1472176102=:10662--
