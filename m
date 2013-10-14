From: "Paul B. Henson" <henson-HInyCGIudOg@public.gmane.org>
Subject: good bcache use case?
Date: Mon, 14 Oct 2013 15:49:55 -0700
Message-ID: <1005c01cec92f$b61b2040$225160c0$@acm.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-us
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

I'm building a server to do some kvm virtualization. Right now, I've got 4
2TB Western Digital RE4 hard disks, and 2 256G Samsung 840 Pro SSD's.

My initial intent was to build a RAID10 from the 2 TB hard disks, and a
RAID1 from the SSD's, have two separate lvm volume groups, and manually
partition file systems between them based on the need for performance.

I was wondering if it would make a good use case for bcache to instead use
the 256G RAID1 as a cache for backing the 4TB RAID10? Ideally that would
enhance the performance of all I/O, rather than just whatever filesystems
were manually placed on the SSD's in my original plan.

From my research so far, it seems that bcache in the 3.10 kernel is
considered stable enough for production, and there shouldn't be any issues
using software RAID for the backing and cache devices? Even with writeback
enabled?

Any gotchas or pointers for this potential deployment?

Thanks much.
