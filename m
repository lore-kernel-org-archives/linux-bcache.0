From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [GIT PULL] Bcache fixes for 3.10
Date: Wed, 15 May 2013 01:12:41 -0700
Message-ID: <20130515081241.GA16030@moria.home.lan>
References: <20130515075302.GA26662@moria.home.lan>
 <20130515080645.GC3276@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130515080645.GC3276-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Wed, May 15, 2013 at 10:06:45AM +0200, Jens Axboe wrote:
> On Wed, May 15 2013, Kent Overstreet wrote:
> > Jens - couple more bcache patches. Bug fixes and a doc update.
> > 
> > The following changes since commit f50efd2fdbd9b35b11f5778ed85beb764184bda9:
> > 
> >   Merge branch 'bcache-for-upstream' of http://evilpiepirate.org/git/linux-bcache into for-3.10/drivers (2013-05-01 09:23:05 +0200)
> > 
> > are available in the git repository at:
> > 
> > 
> >   http://evilpiepirate.org/git/linux-bcache.git bcache-for-upstream
> > 
> > for you to fetch changes up to f59fce847fc8483508b5028c24e2b1e00523dd88:
> > 
> >   bcache: Fix error handling in init code (2013-05-15 00:48:14 -0700)
> 
> No workie:
> 
> axboe@nelson:/src/linux-block $ git pull
> http://evilpiepirate.org/git/linux-bcache.git bcache-for-upstream
> error: Unable to find b09beb2b52c74a69b45da259e5684e3bf3b1ca08 under
> http://evilpiepirate.org/git/linux-bcache.git
> Cannot obtain needed blob b09beb2b52c74a69b45da259e5684e3bf3b1ca08
> while processing commit 867e1162068eb5632c829d453fd65d6089564f55.
> error: Fetch failed.

Argh.

> In general, http:// git just sucks.

Yeah, but cloning over git:// seems to use a fair amount more memory
than dumb http, so that's the one I publish :/ But I do have git daemon
running, try this:

git://evilpiepirate.org/~kent/linux-bcache.git bcache-for-upstream

> If you can't host git:// on your own
> box, please consider moving to a kernel.org or similar hosting.

I'd love to not have to deal with this stuff anymore, do you know who
gives those out?
