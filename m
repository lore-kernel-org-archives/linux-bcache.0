From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [PATCH v1] bcache: partition support: add 16 minors per bcacheN
 device
Date: Sun, 23 Oct 2016 18:22:48 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1610231821070.24191@mail.ewheeler.net>
References: <951934014.5256.1475070307225@ox.pcextreme.nl> <20160928191142.2e545aa5@harpe.intellique.com> <1406388200.5277.1475090090844@ox.pcextreme.nl> <20160929160903.10b63b45@harpe.intellique.com> <20160929174056.Horde.Tkp24xa2MRhriRvK8KE1QU8@www3.nde.ag>
 <20160929183122.3641f307@harpe.intellique.com> <293451899.5382.1475167934533@ox.pcextreme.nl> <20160929191127.779f94d0@harpe.intellique.com> <1673593557.6129.1476447335568@ox.pcextreme.nl> <alpine.LRH.2.11.1610231807320.24191@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1641074820-455960155-1477272169=:24191"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:43421 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756890AbcJXBWu (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 23 Oct 2016 21:22:50 -0400
In-Reply-To: <alpine.LRH.2.11.1610231807320.24191@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@gmail.com>, Emmanuel Florac <eflorac@intellique.com>, "Jens-U. Mozdzen" <jmozdzen@nde.ag>, Wido den Hollander <wido@42on.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1641074820-455960155-1477272169=:24191
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


[ Fixed subject: 
  Really I meant 16 minors per device, not per-major; major hasn't changed.]

On Sun, 23 Oct 2016, Eric Wheeler wrote:

> On Fri, 14 Oct 2016, Wido den Hollander wrote:
> > > Op 29 september 2016 om 19:11 schreef Emmanuel Florac <eflorac@intellique.com>:
> > > Le Thu, 29 Sep 2016 18:52:14 +0200 (CEST)
> > > Wido den Hollander <wido@42on.com> écrivait:
> > > > > I agree, but usually you wouldn't partition an MD-RAID either, would
> > > > > you? OSDs are still holding (so far) ordinary filesystems locally
> > > > > mounted on the nodes (except for BlueStore AFAIK).
> > > > I have partitioned MD-RAID before, works just fine.
> > > 
> > > Yes, sure. It just doesn't feel right, my  grey-bearded Unix instinct
> > > tingles :)
> > > 
> > > > The question still remains, can bcache be patched that it allocates
> > > > the right minor in the kernel so that it allows for partitions.
> > > 
> > > Even looks easy... As Sam Yaple made a patch.
> > > 
> > > > I'm not a kernel nor bcache developer, just looking for somebody who
> > > > would be willing to do this. Happy to assist, support and test!
> > > 
> > > Well if I have some time I may give it a try next week :)
> > > 
> > 
> > I was wondering if you were able to take a look at this?
> 
> Hi Wido,
> 
> See below and please test.  It works for me, but I've not done any more 
> than create a partition and verify that it was detected.  Use-case 
> opinions aside, some may or may not wish to use partitions atop of bcache. 
> (If you do, just make sure they are aligned correctly!).
> 
> I'll add your tested-by and request a pull for v4.9 unless someone has 
> good reason to implement this differently.
> 
> Kent, is there any reason to change this implementation?
> 
> --
> Eric Wheeler
> 
> 
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 849ad44..6e53afd 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -58,6 +58,7 @@
>  struct workqueue_struct *bcache_wq;
>  
>  #define BTREE_MAX_PAGES		(256 * 1024 / PAGE_SIZE)
> +#define BCACHE_MINORS		16 /* partition support */
>  
>  /* Superblock */
>  
> @@ -783,8 +784,10 @@ static int bcache_device_init(struct bcache_device *d, unsigned block_size,
>  	if (minor < 0)
>  		return minor;
>  
> +	minor *= BCACHE_MINORS;
> +
>  	if (!(d->bio_split = bioset_create(4, offsetof(struct bbio, bio))) ||
> -	    !(d->disk = alloc_disk(1))) {
> +	    !(d->disk = alloc_disk(BCACHE_MINORS))) {
>  		ida_simple_remove(&bcache_minor, minor);
>  		return -ENOMEM;
>  	}
--1641074820-455960155-1477272169=:24191--
