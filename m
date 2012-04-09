From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: New bcache code up
Date: Sun, 8 Apr 2012 22:12:20 -0400
Message-ID: <20120409021220.GA4713@dhcp-172-18-216-138.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

I just pushed new code to the bcache-3.2-dev branch. I expect this
version to be more or less stable and production ready, but it does need
new testing.

There's two changes that should improve performance:

 * Reworked the code for inserting cache misses into the cache.
Previously, in order to work around a particularly obscure race we had
to fail a lot of inserts from cache misses that should've been fine (if
there was any key at a particular offset, even a stale key or a key that
just invalidated that region of the cache, inserts from cache misses
would fail until the btree node was rewritten).

This'll improve the cache hit ratio, how much depending on how badly the
given workload was affected.

 * Reworked the journalling code to handle cache flushes instead of
treating all writes as sync.

This improves write latency and reduces the amount of journal io.

Fixed some bugs too, including a memory leak. Please let me know if you
find any more, and if anyone's running benchmarks I'd love to know how
it's doing.
