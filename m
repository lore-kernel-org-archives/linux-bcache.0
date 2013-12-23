From: Matthias Ferdinand <bcache@mfedv.net>
Subject: meaning of /sys/fs/bcache/<cset-uuid>/congested ?
Date: Mon, 23 Dec 2013 01:07:14 +0100
Message-ID: <20131223000714.GV16285@teapot>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from sw.mfedv.net ([212.82.36.162]:42233 "EHLO sw.mfedv.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755438Ab3LWAHT (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Sun, 22 Dec 2013 19:07:19 -0500
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi,

while watching bcache sysfs values, I noticed that sometimes the
    /sys/fs/bcache/<cset-uuid>/congested
shows non-zero, indicating that my SSD cannot cope with all the
writes.

I tried to understand what this value means (not mentioned in
Documentation/bcache.txt).

Using kernel 3.13-rc3.

In sysfs.c:
    510         sysfs_hprint(congested,
    511                      ((uint64_t) bch_get_congested(c)) << 9);

In request.c:
    464 /* Congested? */
    465 
    466 unsigned bch_get_congested(struct cache_set *c)
    467 {
    468         int i;
    469         long rand;
    470 
    471         if (!c->congested_read_threshold_us &&
    472             !c->congested_write_threshold_us)
    473                 return 0;
    474 
    475         i = (local_clock_us() - c->congested_last_us) / 1024;
    476         if (i < 0)
    477                 return 0;
    478 
    479         i += atomic_read(&c->congested);
    480         if (i >= 0)
    481                 return 0;
    482 
    483         i += CONGESTED_MAX;
    484 
    485         if (i > 0)
    486                 i = fract_exp_two(i, 6);
    487 
    488         rand = get_random_int();
    489         i -= bitmap_weight(&rand, BITS_PER_LONG);
    490 
    491         return i > 0 ? i : 1;
    492 }

Apparently c->congested_last_us is a value in microseconds, i and
c->congested are values in (approx.) milliseconds.

But after line 485 I am completely lost :-)

Line 485 is something like 
    i = int (2 ** (i/64.0));

And then in line 489 a random number <= 64 (or <= 32 on 32 bit) is
subtracted. 

What does it mean? What unit is "congested" in?

Regards
Matthias
