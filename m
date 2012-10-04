From: Kingsly John <member+bcache-4+VQVQEymQXR7s880joybQ@public.gmane.org>
Subject: cache_mode none
Date: Thu, 4 Oct 2012 15:54:06 +0530
Message-ID: <20121004102406.GC17229@narnia.kingsly.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi!

I've been trying out bcache over the last couple of weeks and couldn't find
this explained anywhere.

On my setup here while writing with cache_mode set to none, there's a
near constant 30-40kb/sec write happening to the flash device all through.
But in the other modes the amount of data written is significantly
higher.(While copying the same set of files into a freshly formatted bcache
device)

Does setting cache_mode to none just disable the cache for reading or does it
disable it for both reading and writing?

If it's only disabled for reads, then with cache_mode set to none would
bcache still recover from an unclean shutdown?

Kingsly


-- 
