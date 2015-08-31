From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: Bcache stuck at writeback of a key, consuming 100% CPU, not
 possible to detach
Date: Mon, 31 Aug 2015 07:04:29 -0800
Message-ID: <20150831150429.GA27538@kmo-pixel>
References: <20150830085442.GA31722@suse.com>
 <20150831163937.00ca3f7a@harpe.intellique.com>
 <20150831144949.GA3276@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35483 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020AbbHaPEe (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 31 Aug 2015 11:04:34 -0400
Received: by pacdd16 with SMTP id dd16so142017759pac.2
        for <linux-bcache@vger.kernel.org>; Mon, 31 Aug 2015 08:04:34 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150831144949.GA3276@suse.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Vojtech Pavlik <vojtech@suse.cz>
Cc: Emmanuel Florac <eflorac@intellique.com>, kmo@daterainc.com, linux-bcache@vger.kernel.org

On Mon, Aug 31, 2015 at 04:49:49PM +0200, Vojtech Pavlik wrote:
> On Mon, Aug 31, 2015 at 04:39:37PM +0200, Emmanuel Florac wrote:
> 
> > > Then I noticed that during those situations where the system was
> > > slow, and processes stuck in D, bcache_writeback CPU usage was
> > > soaring all the way to saturating a core,
> > 
> > In my experience, bcache_writeback stays in Wait state, therefore
> > always saturate a core: any machine I'm running bcache on has a
> > constant load of 1.00 even when completely idle.
> 
> In this situation, I see it in an "R" state.
> 
> > > showing this backtrace,
> > > spending time in refill_keybuf_fn():
> >  <snip>
> > > Changing the configuration to writeback_percent=40 helped. For some
> > > time at least.
> > > 
> > > When the issue returned, without any further changes to the system, I
> > > started investigating deeper. Since writeback_percent was large, also
> > > the amount of dirty data was large.
> > 
> > In my case, when dirty data reaches the upper limit (i.e. when the
> > amount of dirty data equals the writeback_percent * backing device
> > size ), and it occurs regularly, the system just freezes...
> 
> That may be a similar symptom.

I suspect there's two different bugs here.

 - I'm starting to suspect there's a bug in the dirty data accounting, and it's
   getting out of sync - i.e. reading 2.8 GB or whatever when it's actually 0.
   that would explain it spinning when there actually isn't any work for it to
   do.

 - with a large enough amount of data, the 30 second writeback_delay may be
   insufficient; if it takes longer than that just to scan the entire keyspace
   it'll never get a chance to sleep. try bumping writeback_delay up and see if
   that helps.

   the ratelimiting on scanning for dirty data needs to be changed to something
   more sophisticated, the existing fixed delay is problematic.
