From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PULL] Re: bcache stability patches
Date: Wed, 30 Dec 2015 10:59:39 -0700
Message-ID: <56841B8B.6070306@kernel.dk>
References: <CAO2mnow-HG_0pnDVFGfU0e+hPXfT=zMTrdemwiv=pxgJ+m4o2w@mail.gmail.com>
 <alpine.LRH.2.11.1512291807510.30746@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:33743 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbbL3R7m (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 30 Dec 2015 12:59:42 -0500
Received: by mail-oi0-f45.google.com with SMTP id y66so205622996oig.0
        for <linux-bcache@vger.kernel.org>; Wed, 30 Dec 2015 09:59:42 -0800 (PST)
In-Reply-To: <alpine.LRH.2.11.1512291807510.30746@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>, Kent Overstreet <kent.overstreet@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Denis Bychkov <manover@gmail.com>, g2p.code@gmail.com, Jiri Kosina <jkosina@suse.com>, Joshua Schmid <jschmid@suse.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, stefan.bader@canonical.com, Takashi Iwai <tiwai@suse.de>, Vojtech Pavlik <vojtech@suse.com>, Zheng Liu <gnehzuil.liu@gmail.com>, Zheng Liu <wenqing.lz@taobao.com>

On 12/29/2015 08:00 PM, Eric Wheeler wrote:
> Hi Jens and Kent,
>
> This affects many users, so please take a look when you have a moment:
>
> There is a growing bcache user community with a well-tested patchset that
> is necessary for production bcache use.  The diffstat is small and we all
> want someone to pull it in and get it into mainline.  This would serve
> many people if this can get pulled in upstream.
>
> More below:
>
> On Tue, 22 Dec 2015, Denis Bychkov wrote:
>> There is a set of bcache stability patches elevating bcache stability to
>> production level. As far as I know, there is no single reported and peer
>> confirmed bug that is not solved by this set. Unfortunately, for some
>> reason, Kent does not have enough time and/or energy to review them and
>> send them upstream. Let's come up with a solution that would allow to
>> review all these patches (some of them written by Ken himself, some of
>> them produced by the community), review them and hand them to the
>> maintainer who is willing to apply them upstream. Without that, bcache
>> is just another half-assed unstable and buggy cache layer. These patches
>> will allow people to start use bcache in production systems. Please find
>> the patch set attached. (The patches apply cleanly to 4.3 and 4.4 kernel
>> series).
>
> Hi Dennis,
>
> I'm maintaining a branch here that is ready to merge.  We have been
> testing this for about a year in production and works great.  All Cc's and
> authors are correct and it (should) have every stability patch below,
> possibly others too.  Please tell me if there are any patches missing:
>
> git pull https://github.com/ewheelerinc/linux.git bcache-patches-for-3.17
> (Yes, github for hosting only, I don't edit with their web interfaces.)
>
> Note that this branch still merges cleanly through v4.4-rc7 and as far
> back as 3.17-rc1 (maybe earlier).  Each patch provides Cc: stable@vger.kernel.org.
>
> It is ready to merge!  We just need Jens or Kent or someone to pull it in.
> Here is the diffstat and shortlog against v4.4-rc7:
>
>   drivers/md/bcache/btree.c     |  5 ++++-
>   drivers/md/bcache/super.c     | 16 ++++++++++++----
>   drivers/md/bcache/writeback.c | 37 ++++++++++++++++++++++++++++++-------
>   drivers/md/bcache/writeback.h |  3 ++-
>   4 files changed, 48 insertions(+), 13 deletions(-)
>
> Al Viro (1):
>        bcache: fix a leak in bch_cached_dev_run()
>
> Gabriel de Perthuis (1):
>        bcache: allows use of register in udev to avoid "device_busy" error.
>
> Kent Overstreet (2):
>        bcache: Add a cond_resched() call to gc
>        bcache: Change refill_dirty() to always scan entire disk if
> necessary
>
> Stefan Bader (1):
>        bcache: prevent crash on changing writeback_running
>
> Zheng Liu (3):
>        bcache: fix a livelock when we cause a huge number of cache misses
>        bcache: clear BCACHE_DEV_UNLINK_DONE flag when attaching a backing device
>        bcache: unregister reboot notifier if bcache fails to unregister device

Looking over these, most are really simple one-liners, and nothing 
sticks out as being overly complicated. Kent, do you have any plans to 
maintain the in-kernel bcache?

If I don't hear otherwise, I'll pull these in for 4.5.

-- 
Jens Axboe
