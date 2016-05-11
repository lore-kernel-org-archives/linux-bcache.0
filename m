From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: scrub backing device
Date: Wed, 11 May 2016 12:13:22 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1605111212540.22680@mx.ewheeler.net>
References: <CACHiF8Bm9i=m-nCVv2MnSFVDcgmnOzSytzYo0gzjkfp0u8Y52A@mail.gmail.com> <alpine.LRH.2.11.1605101814280.22680@mx.ewheeler.net> <CACHiF8AdwiO3FKV9=sNrFMom8pb1DiUzXAdvb4ze+k+U0N_-1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [66.155.3.69] ([66.155.3.69]:33915 "EHLO mx.ewheeler.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932072AbcEKTNN (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 11 May 2016 15:13:13 -0400
In-Reply-To: <CACHiF8AdwiO3FKV9=sNrFMom8pb1DiUzXAdvb4ze+k+U0N_-1g@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: ching lu <lsching17@gmail.com>
Cc: linux-bcache@vger.kernel.org

On Wed, 11 May 2016, ching lu wrote:

> The read cache prevent the program to scrub the backing device directly.
> 
> if a few bits flipped in the backing device, the cache may still
> return healthy data for a while.
> 
> Must i remove cache device before scrubbing?

What do you mean by scrub?

--
Eric Wheeler

> 
> 
> On Wed, May 11, 2016 at 9:15 AM, Eric Wheeler <bcache@lists.ewheeler.net> wrote:
> > On Fri, 29 Apr 2016, ching lu wrote:
> >
> >> Hello,
> >>
> >> i want to develop a script to perform data scrubbing periodically.
> >
> > I think you want to set dirty_percent to 0 and cache_mode=writethrough.
> > Then wait a long time for dirty_percent to actually reach 0.
> >
> > --
> > Eric Wheeler
> >
> >
> >>
> >> For my use case, i think it is meaningless to scrub cached data.
> >>
> >> If i change the cache mode to "none", will it turn off the read cache too?
> >>
> >> Furthermore, will this invalidate cached data? (i do not want to "warm
> >> up" the cache again after the scrubbing)
> >>
> >> Thanks in advance,
> >> c
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
