From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: SSD failure modes
Date: Thu, 24 Jan 2013 14:52:05 -0800
Message-ID: <20130124225205.GL26407@google.com>
References: <6035A0D088A63A46850C3988ED045A4B35638C4A@BITCOM1.int.sbss.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6035A0D088A63A46850C3988ED045A4B35638C4A-mzsoxcrO4/2UD0RQwgcqbDSf8X3wrgjD@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Harper <james.harper-NMzNsA1hOHcW+bLBXbPJGg@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On Wed, Jan 23, 2013 at 02:56:40AM +0000, James Harper wrote:
> What is the expected behaviour of bcache when an SSD wears out? Do SSD's internally do a verify after write to ensure that the data has made it to the 'media' correctly and report a failure if that's the case? Does (or can) bcache do a verify itself?

I've never heard of SSDs doing that, AFAIK they rely more on strong ECC.
Bcache does not itself do that kind of verify, though I think it'd be
pretty easy to implement (and you'd only need it for dirty data and
metadata).

> And what about an SSD that fails hard (eg linux detects an unplug)? A system crash is acceptable in such a case if the cache was in write-back mode, but what are the chances of rebooting successfully with the outstanding cached writes now lost?

I just wrote some documentation about error handling - tell me if that
helps:
http://atlas.evilpiepirate.org/git/linux-bcache.git/tree/Documentation/bcache.txt?h=bcache-dev

Not quite sure I get the scenario you're describing though - you unplug
the SSD, then reboot?

The reboot itself is not a problem, nor is unplugging the SSD -
unplugging the SSD from bcache's perspective looks like a crash when
things come up again (at some point writes just stopped, but whatever's
on the SSD will still be consistent).

However, if you unplug the SSD in writeback mode, run for a bit, and
then reboot - after the SSD is unplugged all the writeback writes are
going to error. We could retry those writes as writes that bypass the
cache (in case it was just a random IO error), although we don't do that
yet - but metadata writes fail in writeback mode we may want to just
panic the kernel.

Hrm.
