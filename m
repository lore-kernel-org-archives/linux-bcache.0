From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: First observations with bcache
Date: Wed, 21 Sep 2011 23:13:39 -0700
Message-ID: <20110922061339.GA14669@moria>
References: <1109101110320.2733@stax.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1109101110320.2733-4jfXtw+jRJ582hYKe6nXyg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Hills <mark-UrrBsZIrrsb10XsdtD+oqA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Ok, I should have all the issues you found fixed. They're only compile
tested but they should be correct - tomorrow I'll pull them into the dev
branch and test them.

But I got that and the most recent stable code pushed to the public
repository. I got rid of the 2.6.34 branch, the bcache branch is now
based off 3.1.

You got it up and running? How's it working?

On Sat, Sep 10, 2011 at 02:44:56PM +0100, Mark Hills wrote:
> I took some time to try out bcache, on an x86 Dell PC with OCZ Agility 3 
> SSD.
> 
> The good news is that once I had applied various workarounds, thing seems 
> to work as expected, both with 2.6.34 and with an updated 3.1 branch.
> 
> I had to make a few modifications to get going, and then more to enable 
> the various debug options.
> 
> The most awkward problems seem to be the result of 32-bit architecture, 
> and I think are highlighted by building as a module.
> 
> I'll follow-up this email with the patches (based on bcache-3.1 branch), 
> though I don't consider them to be long-term solutions; they show the 
> changes I made.
> 
> I some cases I've proposed a better solution, but thought I'd raise them 
> here for discussion first.
> 
> -- 
> Mark
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
