From: Javier Marcet <jmarcet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Issues dropping vm fs caches with kernel 3.5.2 + bcache master
Date: Mon, 20 Aug 2012 09:03:08 +0200
Message-ID: <CAAnFQG9JCMpZ7VSnuNxSGxXa4KrDWjdP4e3UJZj=W2Jbi30dZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux BCache Mailing List <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hi,

I've recently set up a software RAID5 + bcache.

I'm using kernel 3.5.2 merged with bcache master branch. I'm quite
happy with the performance but
there is an important issue. I can't drop caches. Writing any number
to /proc/sys/vm/drop_caches
makes the system hungs.

Furthermore, so far I've been unable to curb bcache's memory
consumption using the available
sysctl knobs.

Is this problem known?


-- 
Javier Marcet <jmarcet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
