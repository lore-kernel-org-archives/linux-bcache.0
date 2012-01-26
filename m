From: David Rhodes Clymer <david-LEGOU7lN1jbY0TyS/+Ba5Q@public.gmane.org>
Subject: Stats
Date: Thu, 26 Jan 2012 13:31:34 -0500
Message-ID: <CAB7K1hGfTHjskUbmgWG6GBBZCyfDFvTzZwpHjEAmsUgnt3FnMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Although the doc (Documentation/bcache.txt) seems to indicate that
"bypassed" should contain cumulative IO for the stat period, I've
noticed that it does not consistently increase. In fact, it increases
and decreases quite a bit over a short period of time.

root@zapazoid:~# date
Thu Jan 26 13:23:34 EST 2012
root@zapazoid:~# cat /sys/block/bcache0/bcache/stats_day/bypassed
5.4M
root@zapazoid:~# cat /sys/block/bcache0/bcache/stats_day/bypassed
9.1M
root@zapazoid:~# cat /sys/block/bcache0/bcache/stats_day/bypassed
1008k
root@zapazoid:~# cat /sys/block/bcache0/bcache/stats_day/bypassed
2.4M
root@zapazoid:~# cat /sys/block/bcache0/bcache/stats_day/bypassed
5.1M
root@zapazoid:~# date
Thu Jan 26 13:24:44 EST 2012


This is while doing an rsync into a cached filesystem, which I would
imagine would entail a significant amount of sequential writes.

Am I just misunderstanding what this is supposed to be telling me?

-davidc
