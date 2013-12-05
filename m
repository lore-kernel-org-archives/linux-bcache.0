From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: md-raid5 with bcache member devices => kernel panic
Date: Thu, 5 Dec 2013 15:15:47 -0800
Message-ID: <20131205231547.GB4054@kmo>
References: <20131205212913.GE1848@teapot>
 <20131205225234.GA4054@kmo>
 <20131205230813.GF1848@teapot>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:54551 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267Ab3LEXPv (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 5 Dec 2013 18:15:51 -0500
Received: by mail-pb0-f49.google.com with SMTP id jt11so26815023pbb.22
        for <linux-bcache@vger.kernel.org>; Thu, 05 Dec 2013 15:15:50 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20131205230813.GF1848@teapot>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Matthias Ferdinand <bcache@mfedv.net>
Cc: nks@daterainc.com, linux-bcache@vger.kernel.org

On Fri, Dec 06, 2013 at 12:08:13AM +0100, Matthias Ferdinand wrote:
> On Thu, Dec 05, 2013 at 02:52:34PM -0800, Kent Overstreet wrote:
> > On Thu, Dec 05, 2013 at 10:29:13PM +0100, Matthias Ferdinand wrote:
> > Erk. I thought I was done with these bugs. Nick, do you think you could try and
> > track this down?
> > 
> > Looking at this:
> > http://dl.mfedv.net/md5raid_on_bcache_panic/mdraid5_on_bcache_panic_3.12.2.txt
> > 
> > that's a null pointer deref; if Matthias could get the exact line number it
> I have no idea how to do that - can you help me out on that?
> 
> > Matthias - I'm running bcache on top of a raid6 at home and I've never seen
> I only get panics when I use md-raid on top of bcaches:
> 
>               LVM
>                |
>            md-raid5
>          /     |     \
>   bcache0  bcache1  bcache2
>    |           |       |
>   sdb6       sdc6     sdd6
> 
> (probably an unusual setup; just playing around...)

Yeah, that is unusual. Very odd though, that setup I would definitely expect to
work.

You mentioned it's faster with bcache higher in the stack - do you have any
issues with your preferred setup?

If the bug isn't actually affecting real/preferred use cases then I'll be a lot
less concerned about it - I'm reworking how all this crap works in mainline,
maybe by 3.14 generic_make_request() will be accepting arbitrary size bios and
the code that's probably buggy here will be gone.
