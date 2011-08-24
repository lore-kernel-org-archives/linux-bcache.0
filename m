From: Justin Rush <jarush-Ub+6UvMsOfg@public.gmane.org>
Subject: patch for 2.6.36.4
Date: Wed, 24 Aug 2011 06:58:06 -0500
Message-ID: <DF79D67463342E47A18897C1112AEF644ABB784D94@ESCC1.epicsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

I am running 2.6.36.4 and I had to apply a few patches to get current hardware working as well as the lio backports so I prefer to stay on this kernel.  Is there a 2.6.34.4 patch available?  If not, can I make one?

Looking at this helpful human's post, it looks fairly straightforward:
http://comments.gmane.org/gmane.linux.kernel.bcache.devel/24

I checked out both trees, then switched to my branch:
git checkout -b 2.6.36.4

Then created the patch:
git diff linux-2.6 linux-bcache >patch

However, this resulted in a 236MB patch file, which is several orders of magnitude bigger than any other patch I have ever used.  Assuming this is even the right way to do it, do I just install it by moving it into my running kernel's source and doing a patch -p0 patch ?

Slightly un-related question:
I want to use this as a cache for two sw raid6 arrays.  The raid devices have a bunch of logical volumes carved out of them and those LVs are presented to LIO and served out as iSCSI LUNs.  Will bcache serve as a write cache for these devices?  My read performance is great, but my random write performance, or write performance in general, really sucks hard.

Justin Rush
