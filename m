From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: RAID5/6 stripe awareness
Date: Wed, 15 May 2013 02:48:46 -0700
Message-ID: <20130515094846.GG16164@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

There's now raid5/6 stripe awareness in the bcache branch. I'm running
it on this machine right now.

If your backing device is a raid5 or 6 and you're using normal md raid,
in writeback mode it'll try really hard to buffer up and write out full
stripes:
 * writes to dirty stripes are forced to writeback - even if normally
   the write would've bypassed the cache because of sequential IO
   bypass/congested throttling
 * background writeback preferentially flushes full stripes, if there
   are any

There isn't currently a way to flip on the optimizations for other types
of raid where the settings can't be autodetected (could add an interface
for that if anyone wants).

I haven't benchmarked it yet, should theoretically be a big boost to
write performance - if anyone else benchmarks it I'd love to see.
