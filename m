From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Bcache v. whatever
Date: Fri, 26 Apr 2013 13:54:54 -0700
Message-ID: <20130426205454.GG9931@google.com>
References: <20130114223202.GV26407@google.com>
 <20130425161704.3f0fc3b6af55cf75acbc9d9e@linux-foundation.org>
 <20130426194642.GC9931@google.com>
 <20130426132438.4e48e0688fc3c3c298e71d7e@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130426132438.4e48e0688fc3c3c298e71d7e-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Fri, Apr 26, 2013 at 01:24:38PM -0700, Andrew Morton wrote:
> > As far as I can tell the only real improvement would be to add a %p
> > format string to vsnprintf, but adding a global extension would obviously be
> > inappropriate for this. It'd be really nice to have a mechanism for
> > adding file/module private format strings to vsnprintf, but I haven't
> > cared enough yet to implement it myself.
> > 
> > Of course if you know a better solution I'm all ears.
> > 
> > Uhm, as for the actual bug - that is a fairly ancient gcc, I wasn't
> > aware we were supporting compilers that old but I'm sure you wouldn't be
> > bugging me about it if we weren't...
> 
> Why are those things macros anyway?  urgh, it's because we want to jam
> a string into the caller's stack frame without declaring any of it.

Well, it also _used_ to be the case that if DEBUG and
CONFIG_DYNAMIC_DEBUG weren't defined then pr_debug() was defined as an
empty macro, so btree_to_text() wouldn't be called.

But, I just checked and it's been converted to an empty inline
function, and some of this debug code is called from fast paths where
the overhead really does matter :/ argh

> Really I do think it would be better to do away with the C party tricks
> and have callers do
> 
> 	char btree_buf[BTREE_BUF_SIZE];
> 
> 	btree_to_text(btree_buf, b);
> 	pr_debug("%s\n", btree_buf);
> 
> Nice, simple, explicit, direct and stupid.  It might generate
> unused-var warnings if DEBUG is undefined but from my reading of
> pr_debug() things will be OK.
> 
> Then we can poke around at btree_to_text() until gcc-3.4.5 is happy
> with it.

Well, since pr_debug() isn't an empty macro anymore there goes my main
reason for keeping these macros around.

seems like pr_debug() could still have the no_printk() call inside an
if (0) though...

argh. If there was some way to tell gcc "this function only modifies
this argument so you don't have to call it if the output is never used"
then I'd just convert it to the explicit bufs now. But I really can't
have btree_to_text()/bkey_to_text() getting called in non debug
kernels...

I'm going to mull it over a bit for now, and try and decide what's least
ugly.
