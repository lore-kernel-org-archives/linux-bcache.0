From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [GIT] Bcache version 12
Date: Tue, 20 Sep 2011 19:55:45 -0700
Message-ID: <20110921025545.GB5521@moria>
References: <20110910064531.GA32536@moria>
 <CAOJsxLFPODubVEB3Tjg54C7jDKM8H-RCM_u5kvO1D0kKyjUYXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOJsxLFPODubVEB3Tjg54C7jDKM8H-RCM_u5kvO1D0kKyjUYXQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Mon, Sep 19, 2011 at 10:28:03AM +0300, Pekka Enberg wrote:
> Hi Kent,
> 
> On Sat, Sep 10, 2011 at 9:45 AM, Kent Overstreet
> <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > bcache, n.: a cache for arbitrary block devices that uses an SSD
> >
> > It's probably past time I started poking people to see about getting
> > this stuff in. It's synced up with mainline, the documentation is for
> > once relatively up to date, and it looks just about production ready.
> >
> > Suggestions are more than welcome on how to make it easier to review -
> > it's entirely too much code, I know (near 10k lines now). I'll be
> > emailing the patches that touch other parts of the kernel separately.
> >
> > Short overview:
> > Bcache does both writethrough and writeback caching. It presents itself
> > as a new block device, a bit like say md. You can cache an arbitrary
> > number of block devices with a single cache device, and attach and
> > detach things at runtime - it's quite flexible.
> 
> The changelog is pretty useless for people like myself who have never
> heard of bcache before because it lacks any explanation why bcache is
> useful (i.e. a real-world use case).
> 
>                         Pekka

Well, I think you'll want the documentation for that -
Documentation/bcache.txt is somewhat up to date and should answer that
decently.

Short version: bcache is for making IO faster.
