From: Javier Marcet <jmarcet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Raid5 slower with bcache
Date: Wed, 27 Mar 2013 11:03:52 +0100
Message-ID: <CAAnFQG9Uafe2PLgA33Uve95W06hb_EHMOqC5FQg9mUbuH-hznw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux BCache Mailing List <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hi,

I've been using bcache since last summer, caching a 4x3TB raid5.

Last week one of my disks died so after replacing it, I also got a new
SSD and began to do some tests. There is something which, while not
proving anything, worries me anyway. Better than describing it, just
see this (caches were flushed before each hdparm):

 # hdparm -tT /dev/md0

/dev/md0:
 Timing cached reads:   23860 MB in  2.00 seconds = 11941.98 MB/sec
 Timing buffered disk reads: 996 MB in  3.00 seconds = 331.85 MB/sec

# hdparm -tT /dev/bcache0

/dev/bcache0:
 Timing cached reads:   22944 MB in  2.00 seconds = 11482.63 MB/sec
 Timing buffered disk reads: 488 MB in  3.00 seconds = 162.49 MB/sec

This is without any caching devices attached, that is, in pass-through
mode. My md raid5 is bottlenecked by the 3Gbps of the SATA controller
but with bcache, even in pass-through mode, seems to have a degrading
effect.

With a caching device attached, I know random I/O improves, but it
seems I'm degrading sequential access considerably. See now with a
fresh 128GB Crucial M4 SSD attached:

# hdparm -tT /dev/sdb

/dev/sdb:
 Timing cached reads:   23964 MB in  2.00 seconds = 11994.69 MB/sec
 Timing buffered disk reads: 1594 MB in  3.00 seconds = 530.72 MB/sec

 # hdparm -tT /dev/bcache0

/dev/bcache0:
 Timing cached reads:   23830 MB in  2.00 seconds = 11927.29 MB/sec
 Timing buffered disk reads: 626 MB in  3.00 seconds = 208.64 MB/sec

# hdparm -tT /dev/bcache0

/dev/bcache0:
 Timing cached reads:   24156 MB in  2.00 seconds = 12089.18 MB/sec
 Timing buffered disk reads: 542 MB in  3.05 seconds = 177.53 MB/sec

I would like to try more suited testing tools directly over the RAID,
without any bcache but it looks like I'd need to recreate the whole
array, sigh.

I would appreciate any more info about these numbers.


-- 
Javier Marcet <jmarcet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
