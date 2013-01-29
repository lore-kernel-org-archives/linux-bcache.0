From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Loosing transactions
Date: Tue, 29 Jan 2013 11:09:42 -0800
Message-ID: <20130129190942.GM26407@google.com>
References: <51004490.704@pierre-beck.de>
 <20130124233559.GO26407@google.com>
 <51068F01.9060000@pierre-beck.de>
 <20130129190133.GL26407@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130129190133.GL26407-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pierre Beck <debian-bugs-MZZvbRqs/9F0RdzJJlgK+g@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Tue, Jan 29, 2013 at 11:01:33AM -0800, Kent Overstreet wrote:
> On Mon, Jan 28, 2013 at 03:45:23PM +0100, Pierre Beck wrote:
> > 
> > >We probably want to start by simplifying/narrowing it down a bit - we
> > >can eliminate the possibility of the disk having anything to do with it
> > >and just use the SSD by forcing everything to writeback mode:
> > >
> > >For that you'll want to disable both sequential bypass (echo 0 >
> > >/sys/block/bcache/bcacheN/sequential_cutoff) and the congested
> > >thresholds -
> > >echo 0 > /sys/fs/bcache/<cache set>/congested_read_threshold_us,
> > >echo 0 > /sys/fs/bcache/<cache set>/congested_write_threshold_us
> > >
> > >After that (assuming you're also in writeback mode) all writes will be
> > >writeback writes until the device is more than half full of dirty data.
> > >
> > >Can you check if transactions are still getting lost in that setup? If
> > >so (I kind of expect they will be) we may have to do a bit of
> > >blktracing, but that'll really narrow down the possibilities.
> > >
> > 
> > Yes, the most recent transactions are still lost.
> 
> Think I figured out what's going on. Just had a chat with another kernel
> dev and figured out the flaw in my logic :P

I lied, that idea turned out to be wrong.

Though - data=journal isn't that commonly used, an ext4 bug is an
outside possibility (if it was assuming the pre 2.6.38 semantics of
barriers that could cause this). Could you test with data=ordered and
tell me what happens?
