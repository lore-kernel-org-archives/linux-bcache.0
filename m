From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: cache_mode none
Date: Thu, 4 Oct 2012 12:53:59 -0700
Message-ID: <20121004195359.GC29494@google.com>
References: <20121004102406.GC17229@narnia.kingsly.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121004102406.GC17229-Z3X8UqLNtc1Swagx7F3lBaxOck334EZe@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Thu, Oct 04, 2012 at 03:54:06PM +0530, Kingsly John wrote:
> Hi!
> 
> I've been trying out bcache over the last couple of weeks and couldn't find
> this explained anywhere.
> 
> On my setup here while writing with cache_mode set to none, there's a
> near constant 30-40kb/sec write happening to the flash device all through.
> But in the other modes the amount of data written is significantly
> higher.(While copying the same set of files into a freshly formatted bcache
> device)
> 
> Does setting cache_mode to none just disable the cache for reading or does it
> disable it for both reading and writing?
> 
> If it's only disabled for reads, then with cache_mode set to none would
> bcache still recover from an unclean shutdown?

In cache_mode none, nothing new will be added to the cache (neither from
writes nor cache misses), but the cache is still kept consistent -
that's the reason for the writing that still happens to the flash
devices, it's invalidating the cache whenever you do a write.

It will still read from the cache, because there might still be dirty
data in the cache.
