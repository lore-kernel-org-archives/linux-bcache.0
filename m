From: "Dr. Greg Wettstein" <greg@wind.enjellic.com>
Subject: RE: How important is bcache cache device in write-thru mode? (was Re: Tiered bcache)
Date: Tue, 28 Jan 2014 08:20:00 -0600
Message-ID: <201401281420.s0SEK0sb008045@wind.enjellic.com>
References: <paz@navixia.com>
Reply-To: greg@enjellic.com
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from wind.enjellic.com ([76.10.64.91]:42009 "EHLO wind.enjellic.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754635AbaA1Osc (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 28 Jan 2014 09:48:32 -0500
In-Reply-To: Patrick Zwahlen <paz@navixia.com>
       "RE: How important is bcache cache device in write-thru mode? (was Re: Tiered bcache)" (Jan 21,  6:44pm)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Patrick Zwahlen <paz@navixia.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Cc: scst-devel@lists.sourceforge.net

On Jan 21,  6:44pm, Patrick Zwahlen wrote:
} Subject: RE: How important is bcache cache device in write-thru mode? (was

Hi, hope the week is going well for everyone.

> > -----Original Message-----
> > From: linux-bcache-owner@vger.kernel.org [mailto:linux-bcache-
> > owner@vger.kernel.org] On Behalf Of matthew patton
> > Sent: mardi 21 janvier 2014 18:35
> > To: linux-bcache@vger.kernel.org
> > Cc: Patrick Zwahlen
> > Subject: How important is bcache cache device in write-thru mode? (was
> > Re: Tiered bcache)
> > 
> > >>  wait, the cache DEVICE for bcache is a Btier device composed of an
> > SSD
> > >>  and RAM? So in effect you want btier to move the really hot blocks
> > >>  within the bcache cache device into RAM? So effectively bcache
> > metadata
> > >>  and any really hot blocks will live in RAM and the rest of the
> > > 'read'
> > >>  cache will sit on the SSD.
> > >
> > > Exactly! Apologies if that wasn't clear in the first place but that
> > > describes 100% what we're currently testing.

> > you REALLY want to check with Kent as to what happens when the bcache
> > caching device (and any meta-data it stores there) routinely get blown
> > away or run a high risk of experiencing sudden destruction. I'm afraid
> > this is not a test case that has undergone enough scrutiny.

> Thanks Matthew for raising this in this list.
>
> I should add that we have two SAN servers sharing the
> JBOD. Clustering is managed by pacemaker. During normal operations,
> we can migrate a whole RAID from one node to the other and we do a
> proper cache detach on node #1 (that would even write dirty data if
> were doing write-back) and re-attach the RAID to the existing cache
> on the node #2. Beauty here is we can "share" a cache set between
> multiple backend devices.
>
> We made the assumption that as bcache is designed for potentially
> failing SSDs, moving to a potentially failing SSD+RAM shouldn't make
> a difference.
>
> I'm definitely not expert enough to assess the risk any further and
> I rely on you guys.

Interestingly enough we have been working on infrastructure to support
this type of model for some time.  Our primary focus is on
accelerating SCST based storage targets and software defined storage
(SDS) devices.

At one point in time we had entertained discussions with the SCST
developers to pay for an implementation of RAM based block device
cacheing in SCST itself, for a variety of reasons that didn't move
forward.  We recognized early on that Kent's work with bcache was
going to make that strategy irrelevant.

SCST using FILEIO is blindingly fast but I don't know of any serious
storage architects that are going to trust 50-60 gigabytes of a
database or filesystem to the Linux pagecache and associated vagaries
of VM writeback behavior.  So the architectural question becomes how
to take advantage of the fact that it is now tractable to provision
commodity based storage targets with a quarter terrabyte of RAM and
how to take advantage of this in a manner which protects data and
provides deterministic performance characteristics.

So Izzy (our golden retriever) and I spent a lot of time down at our
lake place over the holidays cross-country skiing and working on a
hugepage backed block device driver.  We are in the process of putting
the beta through various beatings and addressing some issues with the
device model implementation.  We are hoping to have something to
release in the next week or so before we leave for Colorado and some
downhill skiing.

The goal for this driver is a block based interface to RAM for use as
a cache set for bcache.  Since it sits directly on the physical
hugepage allocator and associated page magazine the block devices can
be dynamically configured, unlike the current RAM based block device,
which also has the disadvantage of being implemented on top of page
cache.  None of this should be construed as a gripe against the Linux
VM but obviously one does not want memory pressure to start driving a
high speed cache store out onto disk.

This model is obviously dependent on solid behavior of bcache in
write-through mode.  We are testing aggressively against 3.10.x and
haven't tipped it over it but we will turn up the pressure on that and
see if it gives.  I'm pretty confident there is enough community and
commercial interest in all this to get the bugs beaten out pretty
thoroughly, provided people report them back.... :-)

We will copy both the bcache and SCST lists when we have something up
on the FTP site as it would seem to be of interest to both
communities.

> - Patrick -

Have a good week.

Greg

}-- End of excerpt from Patrick Zwahlen

As always,
Greg Wettstein, Ph.D.       Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Heaven goes by favor.  If it went by merit, you would stay out and your
 dog would go in."
                                -- Mark Twain
