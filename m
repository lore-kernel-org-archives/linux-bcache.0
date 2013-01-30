From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Loosing transactions
Date: Wed, 30 Jan 2013 12:18:17 -0800
Message-ID: <20130130201817.GA12631@moria.home.lan>
References: <51004490.704@pierre-beck.de>
 <20130124233559.GO26407@google.com>
 <51068F01.9060000@pierre-beck.de>
 <20130129190133.GL26407@google.com>
 <20130129190942.GM26407@google.com>
 <51082E02.7000908@pierre-beck.de>
 <20130130190220.GS26407@google.com>
 <51097D0A.6040204@pierre-beck.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51097D0A.6040204-MZZvbRqs/9F0RdzJJlgK+g@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pierre Beck <debian-bugs-MZZvbRqs/9F0RdzJJlgK+g@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Wed, Jan 30, 2013 at 09:05:31PM +0100, Pierre Beck wrote:
> Am 30.01.2013 20:02, schrieb Kent Overstreet:
> >That delay is a parameter - /sys/fs/bcache/<cache set>/journal_delay_ms.
> >Can you set it to 0 and see what happens? It might reduce the number of
> >missing transactions, eliminate the missing transactions... or have no
> >effect at all.
> >
> 
> Test passed. Double-checked. No transactions lost.

None at all, ever?

That's actually kind of annoying, because we can't definitively
distinguish between "fixes bug completely" and "makes bug a lot harder
to actually detect". Bah :p

Can you run blktrace on the bcache device and the SSD for a second or
two while your msql test is running? Maybe if I stare at the trace I'll
get lucky and see something wrong.

> I really want to see bcache in mainline kernel soon. It's such a
> great addition for storage arrays. Let's polish it up. When you have
> a fix, I'll test a full storage stack on it. Ext4 alone is boring
> :-)

Working on it :D
