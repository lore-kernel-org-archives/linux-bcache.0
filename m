From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: problem w/ read caching..
Date: Fri, 28 Sep 2012 11:59:49 -0700
Message-ID: <20120928185949.GA7062@google.com>
References: <CAPKZHbV3n7O+VRVNS-C2oDVSpO_VdirMDUOuwwWKaA5ZOUEG_g@mail.gmail.com>
 <CAH+dOxLKJKRLU2+0hD0LVmTC68SnFpFrTE63+QegaGPs5BOSMg@mail.gmail.com>
 <loom.20120928T010314-562@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <loom.20120928T010314-562-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Brad Walker <bwalker-WlSugiYO8JFBDgjK7y7TUQ@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Thu, Sep 27, 2012 at 11:28:20PM +0000, Brad Walker wrote:
> Kent Overstreet <koverstreet@...> writes:
> 
> > 
> > Sounds like a good portion of your IO is bypassing the cache. That
> > will happen if some of it's sequential, or if the SSD latency goes
> > over a threshold - sequential_cutoff, congested_read_threshold_us and
> > congest_write_threshold_us (if I'm remembering the names correctly)
> > are the settings that control all that. 0 disables all of them.
> > 
> 
> So I set the sequential_cutoff and congested_read_threshold_us to both be 0.
> Since I was only doing reads, I figured there was no need to mess with the write
> option.
> 
> But, I'm still seeing a problem. 
> 
> My hardware is:
> 1 - Dell PowerEdge R710 w/ 24 x Xeon processors, 96GB of ram
> 2 - Micron P320H SSD
> 3 - LSI storage device connected by a SAS interface
> 
> What I see is that when I do random reads over a 10GB region, the cache warms up
> but hits a read response plateau at about 7ms. I still see a LOT (i.e. 32000
> IOPS) of I/O to the disk. 

By disk you do mean spinning disk? Or just to the bcache device?

I'm wondering if your storage array just is that fast (which would
explain the 7 ms) or something weird is going on.

Cache hit ratio or iostat would tell you.

> Yes, if I run the same test over a 1GB region, runs really fast. Pretty close to
> the max IOPS rate of the SSD.
> 
> So I'm thinking there is a problem here or I have a bcache config issue.

Sounds like some sort of bcache problem. hrm.

Most likely cause is something is keeping the cache from warming up, and
some IO is still going to disk. That used to be an issue with the old
synchronization for updating the cache on cache miss, but it shouldn't
be anymore...

Check number of cache misses after a run... if it's going up when all
the data should be in the cache, that's one bug. If there's no cache
misses and you're still seeing 7 ms latency... well, that would be
weird. queueing delays, maybe..
