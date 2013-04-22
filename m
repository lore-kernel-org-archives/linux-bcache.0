From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: bcache strange behaviour in write back mode
Date: Mon, 22 Apr 2013 21:15:14 +0200
Message-ID: <51758C42.4040708@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi all,

We've seen strange behaviour in bcache mode in current bcache-testing
branch with Possible allocator fix:

Once I start writing data with "dd if=/dev/zero of=/dev/bcache0 bs=4k
count=10000 oflag=sync", all SSDs in the Pool go close to 100% util and
I see about 3600 writes/second in iostat for each disk in the pool, BUT
no data written in means of throughput.

Then after some seconds (the flush interval of bcache) I see the flush
of the writeback and also data written to the pool SSDs which looks
pretty much like reordering and merging happened for that data.

bcache-3.2 does not have such problem.
only bcache(master) and bcache-testing have such problem.

What's the possible reason?

Regards,
Jack
