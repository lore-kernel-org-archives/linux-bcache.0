From: Mark Hills <mark-UrrBsZIrrsb10XsdtD+oqA@public.gmane.org>
Subject: Re: First observations with bcache
Date: Fri, 23 Sep 2011 00:14:07 +0100 (BST)
Message-ID: <1109221154170.28261@jrf.vwaro.pbz>
References: <1109101110320.2733@stax.localdomain> <20110922061339.GA14669@moria>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110922061339.GA14669@moria>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Wed, 21 Sep 2011, Kent Overstreet wrote:

> Ok, I should have all the issues you found fixed. They're only compile
> tested but they should be correct - tomorrow I'll pull them into the dev
> branch and test them.

You mean commit a1f7b3d? I checked this out quickly now, but on install 
got:

  DEPMOD  3.1.0-rc7-bcache+
  WARNING: Loop detected: /lib/modules/3.1.0-rc7-bcache+/kernel/block/bcache.ko needs bcache_util.ko which needs bcache.ko again!
  WARNING: Module /lib/modules/3.1.0-rc7-bcache+/kernel/block/bcache.ko ignored, due to loop
  WARNING: Module /lib/modules/3.1.0-rc7-bcache+/kernel/block/bcache_util.ko ignored, due to loop

Perhaps I will look in more detail tomorrow.

Did you make any steps in removing -std=gnu99? I think this is a must; I 
could not see this trend elsewhere in the existing kernel code.

> But I got that and the most recent stable code pushed to the public 
> repository. I got rid of the 2.6.34 branch, the bcache branch is now 
> based off 3.1.
> 
> You got it up and running? How's it working?

Hi, yes I did get it running before. The effect of the caching in tests 
was as I'd hoped; it felt like it was working well.

Something I found particularly interesting is the pass-through for 
sequential operations. With an SSD an order of magnitude faster than HDD, 
it seems like an interesting part of the project could be in the 
heuristics for this.

But I haven't been using it as I'd hoped, because of re-formatting the 
source device. IMO this is an unnecessary barrier to adoption. Flashcache, 
dm-cache etc. show a simple design that doesn't require this.

Whilst the aims of auto-configuration, thin provisioning, tiering etc. are 
admirable, it feels rather ambitious.

I mentioned on IRC the other week: I'd like to see bcache focus on the 
cache. From a user perspective, it already has a major contribution in 
this area, and could slot in neatly to provide this -- such as within 
device-mapper.

It would also have a clear position in the existing structure, which would 
ease the review process and leave the focus on the code quality and docs.

Thanks

-- 
Mark
