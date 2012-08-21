From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Issues dropping vm fs caches with kernel 3.5.2 + bcache master
Date: Mon, 20 Aug 2012 17:15:14 -0700
Message-ID: <20120821001514.GB21953@google.com>
References: <CAAnFQG9JCMpZ7VSnuNxSGxXa4KrDWjdP4e3UJZj=W2Jbi30dZg@mail.gmail.com>
 <20120820202921.GA21953@google.com>
 <CAAnFQG-aK4aR8J05oe=MygbzjkoW4furOSyEjrhw6Zp0vznhEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAnFQG-aK4aR8J05oe=MygbzjkoW4furOSyEjrhw6Zp0vznhEw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Javier Marcet <jmarcet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Linux BCache Mailing List <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On Mon, Aug 20, 2012 at 11:06:30PM +0200, Javier Marcet wrote:
> >> I've recently set up a software RAID5 + bcache.
> >>
> >> I'm using kernel 3.5.2 merged with bcache master branch. I'm quite
> >> happy with the performance but
> >> there is an important issue. I can't drop caches. Writing any number
> >> to /proc/sys/vm/drop_caches
> >> makes the system hung.
> >>
> >> Furthermore, so far I've been unable to curb bcache's memory
> >> consumption using the available
> >> sysctl knobs.
> >>
> >> Is this problem known?
> >
> > No I didn't know about that - thanks, I'll look into it.

Just tried it - I can reproduce it, but it's gone in 3.6. Looks like a
3.5 bug, not a bcache bug.

I'm gonna reset the master branch to my current dev branch soon as I've
tested it a bit more, but I'd suggest the bcache-3.2 branch - that's the
best tested code.
