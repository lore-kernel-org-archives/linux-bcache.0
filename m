From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: problem w/ read caching..
Date: Mon, 1 Oct 2012 13:37:06 -0700
Message-ID: <20121001203706.GB26488@google.com>
References: <CAPKZHbV3n7O+VRVNS-C2oDVSpO_VdirMDUOuwwWKaA5ZOUEG_g@mail.gmail.com>
 <CAH+dOxLKJKRLU2+0hD0LVmTC68SnFpFrTE63+QegaGPs5BOSMg@mail.gmail.com>
 <loom.20120928T010314-562@post.gmane.org>
 <20120928185949.GA7062@google.com>
 <loom.20121001T211315-779@post.gmane.org>
 <20121001193806.GA26488@google.com>
 <loom.20121001T220412-225@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <loom.20121001T220412-225-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Brad Walker <bwalker-WlSugiYO8JFBDgjK7y7TUQ@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Mon, Oct 01, 2012 at 08:05:14PM +0000, Brad Walker wrote:
> Kent Overstreet <koverstreet@...> writes:
> 
> > 
> > What about cache_bypass_hits, cache_bypass_misses?
> > 
> 
> cache_bypass_hits = 0
> cache_bypass_misses = 0

I should've just asked you for all the stats - what about
cache_miss_collision?

Also, internal/cache_read_races?

Perhaps stuff is getting evicted from the cache for some reason... How
big is the SSD?

Is cache_replacement_policy lru? (the default - cache_replacement_policy
is in cache0/)

What's cache0/priority_stats say?
