From: Ming Lin <mlin@kernel.org>
Subject: Re: [bcachefs] Mounting the same device multiple times now works
Date: Wed, 12 Aug 2015 00:36:02 -0700
Message-ID: <1439364962.5775.4.camel@hasee>
References: <20150811083453.GA29708@kmo-pixel>
	 <1439315982.19144.7.camel@ssi> <20150812013853.GA2192@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52959 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933463AbbHLHgG (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 12 Aug 2015 03:36:06 -0400
In-Reply-To: <20150812013853.GA2192@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

On Tue, 2015-08-11 at 17:38 -0800, Kent Overstreet wrote:
> On Tue, Aug 11, 2015 at 10:59:42AM -0700, Ming Lin wrote:
> > On Tue, 2015-08-11 at 00:34 -0800, Kent Overstreet wrote:
> > > Like in other filesystems, you can now do
> > > 
> > > mount /dev/sda1 /foo
> > > mount /dev/sda1 /bar
> > > 
> > > What this really means is that if the udev hook has registered the bcache device
> > > via the old style sysfs interface for caching, you'll still be able to mount the
> > > device like normal.
> > 
> > Thanks!
> > 
> > BTW, could you share the bcachefs long term development plans and short
> > term high priority tasks?
> 
> Right now, my main priority is stabilizing it and making it usable - fixing all
> the things that people are going to trip over when they try it out. I want to
> get it somewhat more polished before I announce on linux-fsdevel.
> 
> The big thing I'm working on at the moment is debugging atomic renames, I had to
> back that code out at the last minute.
> 
> > I'd like to pick something to work on. Probably the debugfs tool you
> > mentioned or other things?
> 
> One thing that would actually be really helpful is more benchmarking vs.
> ext4/xfs - identifying areas where there's still more performance work to do.
> 
> The debugfs tool is definitely important but that's a longer term thing. If
> you're feeling productive like that feel free to keep going with it.
> 
> Really though right now the main thing we need is more testing and debugging.

I have run xfstests. Here is the results for generic tests.
http://minggr.net/pub/bcachefs/xfstests.log

One thing is fallocate not supported yet. Is it known?

root@bee:~# mount |grep bcache
/dev/sda on /mnt/test type bcache (rw,relatime)

root@bee:~# fallocate -l 4096 /mnt/test/hello.c
fallocate: /mnt/test/hello.c: fallocate failed: Operation not supported
