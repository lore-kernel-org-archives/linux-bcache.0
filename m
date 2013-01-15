From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: Bcache v. whatever
Date: Tue, 15 Jan 2013 14:50:24 -0800
Message-ID: <20130115225024.GE32544@kroah.com>
References: <20130114223202.GV26407@google.com>
 <20130115014931.GA19373@kroah.com>
 <20130115211837.GB26407@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130115211837.GB26407@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, akpm@linux-foundation.org, tj@kernel.org, axboe@kernel.dk, James.Bottomley@hansenpartnership.com, snitzer@redhat.com
List-Id: linux-bcache@vger.kernel.org

On Tue, Jan 15, 2013 at 01:18:37PM -0800, Kent Overstreet wrote:
> On Mon, Jan 14, 2013 at 05:49:31PM -0800, Greg KH wrote:
> > On Mon, Jan 14, 2013 at 02:32:02PM -0800, Kent Overstreet wrote:
> > > Bcache: a block layer SSD cache
> > > 
> > > Does writethrough and writeback, handles unclean shutdown, and has
> > > various other nifty features. See the wiki and the documentation for
> > > more:
> > > 
> > > http://bcache.evilpiepirate.org
> > > 
> > > Over the Christmas break I finally got the tree into a self contained
> > > state that ought to be suitable for merging; this tree is fairly close
> > > to the previous stable tree that people have been running on production
> > > servers for awhile (and that I've been running on this workstation), 
> > > 
> > > So, I think this is ready for mainline and I'd like to get it in. I
> > > should've tried to push it ages ago, but I was hoping to get in various
> > > block layer cleanups first; I finally deided to work around them in the
> > > meantime since I haven't had time to finish the block layer stuff.
> > > 
> > > Not everything has been addressed since I last posted for review
> > > feedback - notably the closure code was controversial and for now I've
> > > just moved that into drivers/block/bcache (though I've been refactoring
> > > stuff to make it less asynchronous lately; most of that work is in the
> > > testing/dev branches). The bigger issue IMO is the userspace interface -
> > > I'd like to finish the md integration so it doesn't need userspace stuff
> > > for probing/bootup. So, I'd be fine with it going into staging if that's
> > > the consensus, but it's stable tested code.
> > 
> > If it goes into staging, I need a reason why it can't be merged into the
> > "real" part of the kernel, and what will be done to get it there.
> 
> I don't personally see why it can't, but maybe other people will chime
> in. There's certainly still stuff to do (something this size is never
> finished) but I'm not abandoning the code.

Ok, then it should be accepted, care to make it up into a format that
can be applied to someone's tree?  We can't do anything in the current
git-tree format it is in today.

thanks,

greg k-h
