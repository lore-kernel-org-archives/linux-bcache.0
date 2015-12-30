From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: [PULL] Re: bcache stability patches
Date: Tue, 29 Dec 2015 19:00:30 -0800 (PST)
Message-ID: <alpine.LRH.2.11.1512291807510.30746@mail.ewheeler.net>
References: <CAO2mnow-HG_0pnDVFGfU0e+hPXfT=zMTrdemwiv=pxgJ+m4o2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [71.19.153.34] ([71.19.153.34]:57533 "EHLO mail.ewheeler.net"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754113AbbL3DBN (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 29 Dec 2015 22:01:13 -0500
In-Reply-To: <CAO2mnow-HG_0pnDVFGfU0e+hPXfT=zMTrdemwiv=pxgJ+m4o2w@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: axboe@kernel.dk, Kent Overstreet <kent.overstreet@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Denis Bychkov <manover@gmail.com>, g2p.code@gmail.com, Jiri Kosina <jkosina@suse.com>, Joshua Schmid <jschmid@suse.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.orgmanover@gmail.com, stefan.bader@canonical.com, Takashi Iwai <tiwai@suse.de>, Vojtech Pavlik <vojtech@suse.com>, Zheng Liu <gnehzuil.liu@gmail.com>, Zheng Liu <wenqing.lz@taobao.com>

Hi Jens and Kent,

This affects many users, so please take a look when you have a moment:

There is a growing bcache user community with a well-tested patchset that 
is necessary for production bcache use.  The diffstat is small and we all 
want someone to pull it in and get it into mainline.  This would serve 
many people if this can get pulled in upstream.

More below:

On Tue, 22 Dec 2015, Denis Bychkov wrote:
> There is a set of bcache stability patches elevating bcache stability to 
> production level. As far as I know, there is no single reported and peer 
> confirmed bug that is not solved by this set. Unfortunately, for some 
> reason, Kent does not have enough time and/or energy to review them and 
> send them upstream. Let's come up with a solution that would allow to 
> review all these patches (some of them written by Ken himself, some of 
> them produced by the community), review them and hand them to the 
> maintainer who is willing to apply them upstream. Without that, bcache 
> is just another half-assed unstable and buggy cache layer. These patches 
> will allow people to start use bcache in production systems. Please find 
> the patch set attached. (The patches apply cleanly to 4.3 and 4.4 kernel 
> series).

Hi Dennis,

I'm maintaining a branch here that is ready to merge.  We have been 
testing this for about a year in production and works great.  All Cc's and 
authors are correct and it (should) have every stability patch below, 
possibly others too.  Please tell me if there are any patches missing:

git pull https://github.com/ewheelerinc/linux.git bcache-patches-for-3.17
(Yes, github for hosting only, I don't edit with their web interfaces.) 

Note that this branch still merges cleanly through v4.4-rc7 and as far 
back as 3.17-rc1 (maybe earlier).  Each patch provides Cc: stable@vger.kernel.org.

It is ready to merge!  We just need Jens or Kent or someone to pull it in.  
Here is the diffstat and shortlog against v4.4-rc7:

 drivers/md/bcache/btree.c     |  5 ++++-
 drivers/md/bcache/super.c     | 16 ++++++++++++----
 drivers/md/bcache/writeback.c | 37 ++++++++++++++++++++++++++++++-------
 drivers/md/bcache/writeback.h |  3 ++-
 4 files changed, 48 insertions(+), 13 deletions(-)

Al Viro (1):
      bcache: fix a leak in bch_cached_dev_run()

Gabriel de Perthuis (1):
      bcache: allows use of register in udev to avoid "device_busy" error.

Kent Overstreet (2):
      bcache: Add a cond_resched() call to gc
      bcache: Change refill_dirty() to always scan entire disk if 
necessary

Stefan Bader (1):
      bcache: prevent crash on changing writeback_running

Zheng Liu (3):
      bcache: fix a livelock when we cause a huge number of cache misses
      bcache: clear BCACHE_DEV_UNLINK_DONE flag when attaching a backing device
      bcache: unregister reboot notifier if bcache fails to unregister device

See also these threads:
  https://lkml.org/lkml/2015/12/5/38
  https://www.mail-archive.com/linux-bcache@vger.kernel.org/msg03159.html

Quickly view commits here, too:
  https://github.com/ewheelerinc/linux/commits/bcache-patches-for-3.17


Cheers,

-Eric


-- 
Eric Wheeler, President           eWheeler, Inc. dba Global Linux Security
888-LINUX26 (888-546-8926)        Fax: 503-716-3878           PO Box 25107
www.GlobalLinuxSecurity.pro       Linux since 1996!     Portland, OR 97298
