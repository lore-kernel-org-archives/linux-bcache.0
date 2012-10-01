From: Brad Walker <bwalker-WlSugiYO8JFBDgjK7y7TUQ@public.gmane.org>
Subject: Re: problem w/ read caching..
Date: Mon, 1 Oct 2012 19:18:40 +0000 (UTC)
Message-ID: <loom.20121001T211315-779@post.gmane.org>
References: <CAPKZHbV3n7O+VRVNS-C2oDVSpO_VdirMDUOuwwWKaA5ZOUEG_g@mail.gmail.com> <CAH+dOxLKJKRLU2+0hD0LVmTC68SnFpFrTE63+QegaGPs5BOSMg@mail.gmail.com> <loom.20120928T010314-562@post.gmane.org> <20120928185949.GA7062@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Kent Overstreet <koverstreet@...> writes:

> 
> By disk you do mean spinning disk? Or just to the bcache device?
>
> I'm wondering if your storage array just is that fast (which would
> explain the 7 ms) or something weird is going on.
> 
> Cache hit ratio or iostat would tell you.

The cache_hit_ratio is 99%. And yet, iostat still shows i/o running to the
raid array.

> > Yes, if I run the same test over a 1GB region, runs really fast. 
> > Pretty close to the max IOPS rate of the SSD.
> > 
> > So I'm thinking there is a problem here or I have a bcache config issue.
> 
> Sounds like some sort of bcache problem. hrm.
> 
> Most likely cause is something is keeping the cache from warming up, and
> some IO is still going to disk. That used to be an issue with the old
> synchronization for updating the cache on cache miss, but it shouldn't
> be anymore...
> 
> Check number of cache misses after a run... if it's going up when all
> the data should be in the cache, that's one bug. If there's no cache
> misses and you're still seeing 7 ms latency... well, that would be
> weird. queueing delays, maybe..

After running my tests when the cache is fully warmed, the cache_hit_ratio
goes to 99%.

Yet, cache misses are stable and not changing. Cache hits are increasing and
still iostat is showing 32K blocks being read from disk.

Any ideas on how to debug this?

Thanks for the help.

-brad w.
