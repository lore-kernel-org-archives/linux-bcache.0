From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Bcache v. whatever
Date: Tue, 15 Jan 2013 13:18:37 -0800
Message-ID: <20130115211837.GB26407@google.com>
References: <20130114223202.GV26407@google.com>
 <20130115014931.GA19373@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130115014931.GA19373-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Mon, Jan 14, 2013 at 05:49:31PM -0800, Greg KH wrote:
> On Mon, Jan 14, 2013 at 02:32:02PM -0800, Kent Overstreet wrote:
> > Bcache: a block layer SSD cache
> > 
> > Does writethrough and writeback, handles unclean shutdown, and has
> > various other nifty features. See the wiki and the documentation for
> > more:
> > 
> > http://bcache.evilpiepirate.org
> > 
> > Over the Christmas break I finally got the tree into a self contained
> > state that ought to be suitable for merging; this tree is fairly close
> > to the previous stable tree that people have been running on production
> > servers for awhile (and that I've been running on this workstation), 
> > 
> > So, I think this is ready for mainline and I'd like to get it in. I
> > should've tried to push it ages ago, but I was hoping to get in various
> > block layer cleanups first; I finally deided to work around them in the
> > meantime since I haven't had time to finish the block layer stuff.
> > 
> > Not everything has been addressed since I last posted for review
> > feedback - notably the closure code was controversial and for now I've
> > just moved that into drivers/block/bcache (though I've been refactoring
> > stuff to make it less asynchronous lately; most of that work is in the
> > testing/dev branches). The bigger issue IMO is the userspace interface -
> > I'd like to finish the md integration so it doesn't need userspace stuff
> > for probing/bootup. So, I'd be fine with it going into staging if that's
> > the consensus, but it's stable tested code.
> 
> If it goes into staging, I need a reason why it can't be merged into the
> "real" part of the kernel, and what will be done to get it there.

I don't personally see why it can't, but maybe other people will chime
in. There's certainly still stuff to do (something this size is never
finished) but I'm not abandoning the code.

> Oh, and you will need to get acks from the people who's symbols you are
> wanting to export, usually staging patches are self-contained.

Yeah, good point. I'll mail out those patches now.
