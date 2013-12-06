From: Matthias Ferdinand <bcache@mfedv.net>
Subject: Re: md-raid5 with bcache member devices => kernel panic
Date: Fri, 6 Dec 2013 01:00:45 +0100
Message-ID: <20131206000045.GG1848@teapot>
References: <20131205212913.GE1848@teapot>
 <20131205225234.GA4054@kmo>
 <20131205230813.GF1848@teapot>
 <20131205231547.GB4054@kmo>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from sw.mfedv.net ([212.82.36.162]:41254 "EHLO sw.mfedv.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923Ab3LFAAw (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 5 Dec 2013 19:00:52 -0500
Content-Disposition: inline
In-Reply-To: <20131205231547.GB4054@kmo>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>
Cc: nks@daterainc.com, linux-bcache@vger.kernel.org

On Thu, Dec 05, 2013 at 03:15:47PM -0800, Kent Overstreet wrote:
> On Fri, Dec 06, 2013 at 12:08:13AM +0100, Matthias Ferdinand wrote:
> > I only get panics when I use md-raid on top of bcaches:
> > 
> >               LVM
> >                |
> >            md-raid5
> >          /     |     \
> >   bcache0  bcache1  bcache2
> >    |           |       |
> >   sdb6       sdc6     sdd6
> > 
> > (probably an unusual setup; just playing around...)
> 
> Yeah, that is unusual. Very odd though, that setup I would definitely expect to
> work.
> 
> You mentioned it's faster with bcache higher in the stack - do you have any
> issues with your preferred setup?

for simpler administration, I would prefer to have LVM on top. Where
exactly bcache sits below that is not really important (except for
performance gains, which is the whole point of it all :-)

My preferred lookup would be like this:

         LVM
          |
       bcache0
          |
       md-raid5
      /   |    \
  sdb6   sdc6   sdd6

but it is slightly slower compared to having bcache{0,1,2} devices on
top of LVs for the virtual disks.

I only had the idea to RAID bcaches because the default chunk size of
512k equals the erase block size of the SSD (I assume it is 512k, could
not find hard evidence for it). And since small writes on RAID5 create
tremendous overhead, I hoped to benefit from bcache having already
cached some full chunks.

> If the bug isn't actually affecting real/preferred use cases then I'll be a lot
> less concerned about it - I'm reworking how all this crap works in mainline,
> maybe by 3.14 generic_make_request() will be accepting arbitrary size bios and
> the code that's probably buggy here will be gone.
It is not yet in production use, I am still playing with the setup.

Regards
Matthias
