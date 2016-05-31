From: Marc MERLIN <marc@merlins.org>
Subject: Re: [PULL v4.6-rc1] bcache: documentation updates
Date: Tue, 31 May 2016 16:02:16 -0700
Message-ID: <20160531230216.GE23248@merlins.org>
References: <20160312050003.GN26973@merlins.org> <alpine.LRH.2.11.1603120706310.30893@mail.ewheeler.net> <alpine.LRH.2.11.1603290106450.13440@mail.ewheeler.net> <CAKhhfD7C+CAnUEXfUX=g3bT=TX3QkyLvQnh0eWNJxcK4MeYnHA@mail.gmail.com> <alpine.LRH.2.11.1604130636080.26685@mail.ewheeler.net> <20160530144309.GC21737@merlins.org> <20160531165508.215100e6@lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:55509 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756553AbcEaXCS (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 31 May 2016 19:02:18 -0400
Content-Disposition: inline
In-Reply-To: <20160531165508.215100e6@lwn.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jonathan Corbet <corbet@lwn.net>
Cc: Eric Wheeler <bcache@lists.ewheeler.net>, linux-bcache@vger.kernel.org, linux-doc@vger.kernel.org, kent.overstreet@gmail.com

On Tue, May 31, 2016 at 04:55:08PM -0600, Jonathan Corbet wrote:
> On Mon, 30 May 2016 07:43:09 -0700
> Marc MERLIN <marc@merlins.org> wrote:
> 
> > > There is a bcache documentation update available:
> > >   
> > > > > git pull https://bitbucket.org/ewheelerinc/linux v4.6-rc1-bcache-documentation  
> > > 
> > > Is this the right list to submit such documentation?  
> > 
> > Howdy,
> > 
> > I just pulled 4.6 and noticed the doc updates from Eric and me don't
> > seem to have made it.
> > 
> > Jon, would you know who can help getting those in? I wrote them before
> > 4.5 came out :)
> 
> I don't think I ever saw this, was it sent to me?
 
No I think Eric Emailed linux-doc@vger.kernel.org, instead of you directly.

> How about we post the docs as patches and go from there?

His posted tree contains them. Here are the 2 patches:
https://bitbucket.org/ewheelerinc/linux/commits/606d51faf12382a2a8ab049a5a931533be720386?at=v4.6-rc1-bcache-documentation
https://bitbucket.org/ewheelerinc/linux/commits/69d2dc24a24415901983a045e1f9c7ab1ebb71c4?at=v4.6-rc1-bcache-documentation
(both should be applied)

Thanks for looking at this.
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
