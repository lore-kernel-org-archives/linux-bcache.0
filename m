From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: every boot gives: bcache/alloc.c:78 WARNING
Date: Wed, 3 Aug 2016 18:43:42 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1608031842120.10662@mail.ewheeler.net>
References: <20160803231919.GA13477@merlins.org> <alpine.LRH.2.11.1608031707300.10662@mail.ewheeler.net> <20160804003351.GI31234@merlins.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:50873 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752526AbcHDBul (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 3 Aug 2016 21:50:41 -0400
In-Reply-To: <20160804003351.GI31234@merlins.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: linux-bcache@vger.kernel.org


On Wed, 3 Aug 2016, Marc MERLIN wrote:

> On Wed, Aug 03, 2016 at 05:26:30PM -0700, Eric Wheeler wrote:
> > On Wed, 3 Aug 2016, Marc MERLIN wrote:
> > 
> > > This happens on all kernels up to 4.7.
> > > Sorry, it happens earlier than ethernet coming up or my storage, so I can't
> > > use netconsole or other text dumps:
> > > https://goo.gl/photos/ubsi6maZXsjkevYY7
> > > 
> > > Looks like the warning happens on the registration of one of my bcache, but
> > > I can't tell which one or why.
> > > 
> > > Does the trace give any hints?
> > > (please ignore the load modules errors below, different issue)
> > 
> > Does it cause a problem, or just warn?
>  
> No problem, but since it's a warning, I'm reporting it.
> 
> > It looks like something needs garbage collected but perhaps isn't.  
> > 
> > You could write to sysfs/.../trigger_gc:
> >  
> > https://evilpiepirate.org/git/linux-bcache.git/tree/Documentation/bcache.txt
> > 	trigger_gc
> > 	  Writing to this file forces garbage collection to run.
> 
> BTW both this and the just released 4.7.0 are still missing the
> documentation updates I contributed months ago. Any idea what's going on
> there?
> 
> > If that doesn't work, I wonder what increasing BUCKET_GC_GEN_MAX would do, 
> > though I don't know if that is safe.  Its set to 96U, so its not on on a 
> > bit boundary which sounds like it could be slightly safer---but I wouldn't 
> > try it unless this is a test machine.
> 
> That's on the backing device, correct?
> I have 3 of them, and I can only write to them way way later in the boot
> process.
> Should I do that one by one and see if I get output now?


When you say do "that" do you mean `trigger_gc` ?

I think trigger_gc a cache thing, but the whole bcacheN dev might need to 
be online before it can be triggered (not sure).  Backing devices really 
have metadata, just superblock.

--
Eric Wheeler


> 
> Thanks,
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
