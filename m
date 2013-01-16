From: Alasdair G Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Bcache v. whatever
Date: Wed, 16 Jan 2013 01:29:15 +0000
Message-ID: <20130116012914.GA27245@agk-dp.fab.redhat.com>
References: <20130114223202.GV26407@google.com> <1358241656.2383.2.camel@dabdike.int.hansenpartnership.com> <20130115205912.GA26407@google.com> <1358291738.10591.23.camel@dabdike.int.hansenpartnership.com> <20130115233347.GD26407@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130115233347.GD26407-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Tue, Jan 15, 2013 at 03:33:47PM -0800, Kent Overstreet wrote:
> I haven't been active on dm-devel, besides the occasional cross
> posting... not sure what activity you're referring to on the dm list,
 
A caching framework based on dm has been proposed by Joe Thornber (the
original author of dm).

Mike Snitzer is trying to adapt the performance tests for this dm-based
framework to include the latest bcache code that you just posted to
start to give us an idea of the circumstances in which each of them work
well (or badly).

1, Caching is a complicated feature: It's easy to get no benefit or even
a negative benefit from a cache if you use an inappropriate policy or
don't tune it to your I/O patterns.

2. We now have several independent/overlapping implementations of this
type of caching.  Comparing and contrasting them should help us to tease
out the critical design elements and optimisations and decide which of
them together or separately (or some hybrid) would enable the kernel to
support the widest range of situations users require with the minimum
of code and complexity.

3. We all want to move quickly now, perhaps even with something in the
next merge window if we can or otherwise the one after that.

Alasdair
