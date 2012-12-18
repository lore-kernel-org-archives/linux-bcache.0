From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Project Status
Date: Tue, 18 Dec 2012 11:05:00 -0800
Message-ID: <20121218190500.GA24548@google.com>
References: <50CE31A3.1040706@networklabs.co.nz>
 <kalcpa$v3p$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <kalcpa$v3p$1@ger.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Aaron W.  Hsu" <arcfide-5nC73gNclPNzbRFIqnYvSA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Sun, Dec 16, 2012 at 04:00:13PM -0500, Aaron W.  Hsu wrote:
> Andrew Thrift wrote:
> 
> > I have noticed a slowdown in GIT commits, no updates to the bcache
> > website since July and no mailing list activity since mid November.
> > 
> > Is this project being actively developed ?
> > 
> > A while back, there were talks of bcache becoming part of the mainline
> > Kernel.  Is this still happening ?
> 
> I would also like to bump this. I have wanted to play with and incorporate 
> bcache into my installations for a while, but things seemed to be in a 
> constant state of flux, and I was hoping that bcache would end up in the 
> mainline Linux kernel by now, but I haven't found any word as to what is 
> happening on that front.
> 
> I would love to know what the state of things is. It's hard for me to know 
> what kernels bcache can be used for, how to use it, and the status of 
> integration into the mainline kernel.

Sorry for the slow response. Things have slowed down lately as I've been
getting pulled off to help with other projects, and I've been slacking
on getting it upstream but I'm still working on it.

On the up side, the stable branch isn't in flux and is being actively
deployed, and it's been receiving only bug fixes.

I've been chasing bugs in the dev branch for the past couple days though
:p

My original plan was to try to get bcache into staging as soon as I got
all the block layer improvements in that the dev branch depends on, but
as I've been slacking on that I think I may try to see if I can get the
stable branch forward ported and self contained enough that it can go
into staging. I should have time for that pretty soon, I think.
