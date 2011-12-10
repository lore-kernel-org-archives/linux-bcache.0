From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Quick bcache benchmark
Date: Fri, 9 Dec 2011 22:33:23 -0800
Message-ID: <20111210063307.GA16262@moria>
References: <20111206082233.GA19390@moria>
 <CAEp_DRCHQo1JyPZk6dKYZjJvxtaR7yxpEDtGE+uYK9n2dNb2Pw@mail.gmail.com>
 <20111206115617.GA32759@moria>
 <CAEp_DRDEQLSkJ3arx81qM1M4iSJ5Wy0dwZhsrYD=94682qw8JQ@mail.gmail.com>
 <CALFpzo4s5ee23CMqNJbNUBW_wYBwc3gq0P8zzfAp8QSM+r_JLA@mail.gmail.com>
 <CALFpzo6ugO-5KHvrszp0bAYHY9eT8ADebbBqwgM3Y9FRS7PnGw@mail.gmail.com>
 <CAC7rs0vvJbN6iOvvKJ3Xgm5BAzBxBYL+e6_F_ZzfREEbnC9-CA@mail.gmail.com>
 <CALFpzo6kXrC+8kkqrtRuMcsqnRL-oPc+B3A-Vq3wkWhRLBbAJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALFpzo6kXrC+8kkqrtRuMcsqnRL-oPc+B3A-Vq3wkWhRLBbAJw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marcus Sorensen <shadowsor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Fri, Dec 09, 2011 at 10:09:55AM -0700, Marcus Sorensen wrote:
> Here's some more info. I'm running kernel 3.1.4. When I do random
> writes, the 'bypassed' number increases in stats. Now I'm random
> writing direct to /dev/bcache0 and get the same result.

Weird. From what you're describing it sounds like throttling is screwed
up (and it was recently), but I can't reproduce it now.

Can you try echoing 0 to congested_threshold_us in the cache set dir,
and seeing if that fixes it?

> There also seems to be some work needed with clean-up, since I'm
> unfamiliar with how bcache works I attempted to make-bcache twice,
> thinking I'd start over. That worked, but because my cache device was
> already registered I was unable to re-register my newly formatted
> cache dev, got "kobject_add_internal failed for bcache with -EEXIST,
> don't try to register things with the same name in the same
> directory." I was still able to use my cache device via the old uuid,
> but this will probably cause problems on reboot. Perhaps an unregister
> file in /sys/fs/bcache would help, I also tried rmmod'ing bcache to
> see if I could clear /sys/fs/bcache, but no luck. make-bcache should
> perhaps check for an existing superblock, ask for confirmation, and
> give some sort instruction on how to unregister, or do it for you if
> you reformat.

Yeah, I think for some reason bcache isn't opening the devices
exclusively on 3.1. I'll have a look...
