From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [bcachefs] Mounting the same device multiple times now works
Date: Tue, 11 Aug 2015 17:38:53 -0800
Message-ID: <20150812013853.GA2192@kmo-pixel>
References: <20150811083453.GA29708@kmo-pixel>
 <1439315982.19144.7.camel@ssi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35939 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933245AbbHLBi7 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 11 Aug 2015 21:38:59 -0400
Received: by pacrr5 with SMTP id rr5so2669082pac.3
        for <linux-bcache@vger.kernel.org>; Tue, 11 Aug 2015 18:38:58 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1439315982.19144.7.camel@ssi>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: linux-bcache@vger.kernel.org

On Tue, Aug 11, 2015 at 10:59:42AM -0700, Ming Lin wrote:
> On Tue, 2015-08-11 at 00:34 -0800, Kent Overstreet wrote:
> > Like in other filesystems, you can now do
> > 
> > mount /dev/sda1 /foo
> > mount /dev/sda1 /bar
> > 
> > What this really means is that if the udev hook has registered the bcache device
> > via the old style sysfs interface for caching, you'll still be able to mount the
> > device like normal.
> 
> Thanks!
> 
> BTW, could you share the bcachefs long term development plans and short
> term high priority tasks?

Right now, my main priority is stabilizing it and making it usable - fixing all
the things that people are going to trip over when they try it out. I want to
get it somewhat more polished before I announce on linux-fsdevel.

The big thing I'm working on at the moment is debugging atomic renames, I had to
back that code out at the last minute.

> I'd like to pick something to work on. Probably the debugfs tool you
> mentioned or other things?

One thing that would actually be really helpful is more benchmarking vs.
ext4/xfs - identifying areas where there's still more performance work to do.

The debugfs tool is definitely important but that's a longer term thing. If
you're feeling productive like that feel free to keep going with it.

Really though right now the main thing we need is more testing and debugging.
