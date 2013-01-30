From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Loosing transactions
Date: Wed, 30 Jan 2013 11:02:20 -0800
Message-ID: <20130130190220.GS26407@google.com>
References: <51004490.704@pierre-beck.de>
 <20130124233559.GO26407@google.com>
 <51068F01.9060000@pierre-beck.de>
 <20130129190133.GL26407@google.com>
 <20130129190942.GM26407@google.com>
 <51082E02.7000908@pierre-beck.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51082E02.7000908-MZZvbRqs/9F0RdzJJlgK+g@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pierre Beck <debian-bugs-MZZvbRqs/9F0RdzJJlgK+g@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Tue, Jan 29, 2013 at 09:16:02PM +0100, Pierre Beck wrote:
> Am 29.01.2013 20:09, schrieb Kent Overstreet:
> >I lied, that idea turned out to be wrong.
> >
> >Though - data=journal isn't that commonly used, an ext4 bug is an
> >outside possibility (if it was assuming the pre 2.6.38 semantics of
> >barriers that could cause this). Could you test with data=ordered and
> >tell me what happens?
> >
> 
> Sorry I didn't state that clearly. The ext4 data=journal test was
> for comparison only. All bcache tests were done with defaults, which
> is data=ordered.
> 
> # mkfs.ext4 -K -b 4096
> # mount -o noatime

Ok, good - so it's pretty definitively a bcache bug then.

> Disabling all hardware caches with hdparm AND putting bcache in
> writethrough mode made it pass the test, btw., with severe
> performance loss of course. What's really alarming is that bcache in
> writeback with hw caches deactivated still loses transactions. This
> points to the journal logic. Maybe the last element of the journal
> is simply not iterated?

I was thinking more the cache flush logic, but you may be right -
there's not much logic involved in handling cache flushes, there's
somewhat more to screw up in the journalling code itself.

I'll start reading through the journalling code. Can you try another
setting and tell me what happens?

For normal (non flush) data writes, bcache adds the keys to the next
journal write that's going to go down but it doesn't do the journal
write right away - it delays by up to 100 ms by default, unless either
the journal write fills up or it sees a flush (only flushes actually
wait on journal writes).

That delay is a parameter - /sys/fs/bcache/<cache set>/journal_delay_ms.
Can you set it to 0 and see what happens? It might reduce the number of
missing transactions, eliminate the missing transactions... or have no
effect at all.

And thanks for all the testing you've been doing! It's greatly
appreciated.
