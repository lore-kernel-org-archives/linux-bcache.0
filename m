From: Alexandru Ionica <alexandru.ionica-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: code stability (production readiness) and kernel versions
Date: Fri, 6 Apr 2012 15:21:24 +0200
Message-ID: <CAPwaGKZi1MTU03X+eam4Nm7K_RoTaQQVqzbLFLsN3xWvpMn-1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hello,

I have been doing several benchmarks (Phoronix test suite, disk suite) and
I'm really impressed with the performance when doing writeback caching. For
the benchmarks I did a git checkout and compiled the 3.1.0+ kernel. As the
wiki is outdated I am wondering if the patches have also been applied on a
kernel version which is used by server oriented distributions, meaning
kernel version 2.6.32 for example or if there is a way to apply the patches
(if they exist separately) to kernel version 2.6.32 .
I am interested in this specific version of the kernel as other constrains
impose it.

Also ... do you think that your code is production ready when using bcache
to do writeback caching ? Of course I will keep testing but I'd like to
know if you think the code by now is production ready.
Basically I plan to run a setup like: bcache device assembled from software
raid10 or raid0 (4 disk) + ssd ; on top of this a volume group ; on top of
logical devices drbd setup . We are running this for a long while without
bcache so the setup is stable and the new part here would be bcache.

P.S. during the benchmarks bcache outperformed in every way flashcache (I
tried two different sequential size settings with flash cache, both
underperformed)

Regards,

Alexandru Ionica
