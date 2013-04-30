From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: block activity stats
Date: Tue, 30 Apr 2013 13:31:34 -0700
Message-ID: <20130430203134.GI9931@google.com>
References: <CAC7rs0t4uKx37i7pxMoMQgVeUT6spDeridfdC+R6mqLbf1dwug@mail.gmail.com>
 <1367293610.13617.YahooMailClassic@web181503.mail.ne1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1367293610.13617.YahooMailClassic-XYahOdtEMNn35Xbc4wGBzZOW+3bF1jUfVpNB7YpNyf8@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matthew patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Mon, Apr 29, 2013 at 08:46:50PM -0700, matthew patton wrote:
> Is block activity tracked exclusively by Bcache code or is Bcache
> piggy-backing on already existing statistics tracking that is
> implemented in LVM or the VM or (scsi?) block layers? If the first, I
> was wondering how hard it would be to move it into the lower levels
> and turned on/off with sysfs.

What sort of activity? Do you mean which blocks are cached and which
aren't?

That sort of thing is tracked entirely within bcache.

Maybe you could tell me more specifically what you're trying to do?

> Is there a whitepaper that goes into the mechanics of the tracking,
> the granularity (eg. block region size), (de)promotion trigger logic,
> etc? Or is this a question best answered by "go read the code"?

There might be a more concise description of this stuff in the wiki, but
probably the best documentation is going to be in the code - I wrote a
lot of high level documentation and stuck it at the top of various
files:

http://atlas.evilpiepirate.org/git/linux-bcache.git/tree/drivers/md/bcache/bcache.h?h=bcache-dev

http://atlas.evilpiepirate.org/git/linux-bcache.git/tree/drivers/md/bcache/alloc.c?h=bcache-dev

http://atlas.evilpiepirate.org/git/linux-bcache.git/tree/drivers/md/bcache/btree.h?h=bcache-dev

Let me know what's missing!
