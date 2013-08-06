From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: bcache hang on suspend? sometimes?
Date: Tue, 6 Aug 2013 16:12:42 -0700
Message-ID: <20130806231241.GB8519@kmo-pixel>
References: <20130806053403.GB7998@blackbox.djwong.org>
 <20130806205650.GA5878@blackbox.djwong.org>
 <20130806210224.GA8519@kmo-pixel>
 <20130806230851.GA10118@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130806230851.GA10118-yuuUpGxbzT9UbpRmUfBrXUB+6BGkLq7r@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Tue, Aug 06, 2013 at 04:08:52PM -0700, Darrick J. Wong wrote:
> On Tue, Aug 06, 2013 at 02:02:24PM -0700, Kent Overstreet wrote:
> > On Tue, Aug 06, 2013 at 01:56:50PM -0700, Darrick J. Wong wrote:
> > > Ok, I've narrowed it down a little bit --
> > > 
> > > It's not caused by any of the fixes that went into 3.10.[1-5].  It doesn't seem
> > > to be specific to any particular storage bus, controller, disk, or even cache
> > > set -- the same bcache'd usb stick will crash my laptop and not crash my test
> > > box.  The 4k/512b sector thing was a red herring; you can ignore that.
> > 
> > Ok, that makes more sense...
> > 
> > > The test box is a boring old Core2 box; the laptop is an Ivy Bridge.  I'll try
> > > to enable more verbose PM debugging to see if I can determine what exactly's
> > > going on at sleep time.  (Again, shooting in the dark...)
> > 
> > I just looked at the code and it appears there was a freezer fix that
> > didn't make it into 3.10 and should have. Can you try the
> > bcache-for-3.11 branch and see if that fixes it? If so, I'll get that
> > patch sent out for stable.
> 
> The suspend problem seems to be gone with the for-3.11 branch. 

Good!

> The branch
> seems to be based off 3.10-rc7... is that correct?

Yeah, that's just where it was when I sent Jens the pull request.

> Also, is there any way to figure out how much of a cache device is actively
> holding cached data?

<cache set dir>/cache0/priority_stats
