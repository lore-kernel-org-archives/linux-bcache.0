From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: [GIT PULL] bcache changes for 3.13
Date: Mon, 4 Nov 2013 12:16:11 -0800
Message-ID: <20131104201611.GB27733@kmo>
References: <20131104200747.GD27129@kmo>
 <5277FFA1.6060001@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5277FFA1.6060001-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Mon, Nov 04, 2013 at 01:12:17PM -0700, Jens Axboe wrote:
> On 11/04/2013 01:07 PM, Kent Overstreet wrote:
> > Hey Jens, sorry for being late with this - anyways, it's roughly the same set of
> > patches you had queued up before plus a few minor fixes, but it's been rebased
> > onto your for-3.13/core branch.
> 
> Merge window is a little later this time, and since it was already in
> for the previous release, we can make it happen.
> 
> But can you please base it on for-3.13/drivers however? That's where I'd
> like to pull in the driver bits, and if I pull this one, then things get
> even more tangled since for-3.13/core is holding the blk-mq changes too.

I'd like to do the merge with immutable biovecs myself though - there's some
tricky bits in there. How will that work?
