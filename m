From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: replacing cache device "live"
Date: Fri, 10 Feb 2017 11:32:29 -0800 (PST)
Message-ID: <alpine.LRH.2.11.1702101128180.5783@mail.ewheeler.net>
References: <20170210121045.Horde.-fJa4QkH3OMcVtzM7lqMtr-@www3.nde.ag>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:49624 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932201AbdBJTca (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 10 Feb 2017 14:32:30 -0500
In-Reply-To: <20170210121045.Horde.-fJa4QkH3OMcVtzM7lqMtr-@www3.nde.ag>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Cc: linux-bcache@vger.kernel.org

On Fri, 10 Feb 2017, Jens-U. Mozdzen wrote:

> Hi *,
> 
> I'd like to change the cache device setup of my servers, with a minimum of
> downtime (if at all).
> 
> https://evilpiepirate.org/git/linux-bcache.git/tree/Documentation/bcache.txt?h=bcache-dev
> describes the steps required to replace the caching device:
> 
> - detach the caching device (echo 1 > /sys/block/bcacheX/bcache/detach)
> 
> - unregister the cache set (echo 1 > /sys/fs/bcache/<uuid>/stop)
> 
> I believe that issuing that second step will break access to /dev/bcacheX, so
> cannot be done without interrupting the service (description for cset "stop"
> in bcache.txt: "Write to this file to shut down the cache set - waits until
> all attached backing devices have been shut down.").
> 
> What I'm actually looking for is to change the sectors per block value of the
> caching device, without having to shut down operations on the according bcache
> device (cache_mode=none at that time). Is there any way to do so?

Yes, detaching the cache device should be safe.  It will writeback the 
data (if writeback) and then detach.  Sometimes writeback takes a while.

Then you should be able to `make-bcache -C -w 4096 /dev/cachedev` with any 
other opts you like and attach it to the cache dev.  Here are my notes 
for hot-remove-replace of cachedevs.  My cache device is /dev/ssd/bcache_cache:

# To remove cache:
~] bcache-super-show /dev/ssd/bcache_cache
[...]
cset.uuid		3db83b23-1af7-43a6-965d-c277b402b16a

~] echo 3db83b23-1af7-43a6-965d-c277b402b16a > /sys/block/bcache0/bcache/detach
~] watch cat /sys/block/bcache0/bcache/dirty_data
  # wait until 0
~] echo 1 > /sys/fs/bcache/3db83b23-1af7-43a6-965d-c277b402b16a/unregister

# To add cache without recreating backing volume
~] make-bcache -w 4096 -C /dev/ssd/bcache_cache --writeback
[...]
Set UUID:		492d94e3-8298-4a5b-9ee1-c12cbda2c780

~] bcache-super-show /dev/ssd/bcache_cache
[...]
cset.uuid		492d94e3-8298-4a5b-9ee1-c12cbda2c780

~] echo /dev/ssd/bcache_cache > /sys/fs/bcache/register
~] echo 492d94e3-8298-4a5b-9ee1-c12cbda2c780 > /sys/block/bcache0/bcache/attach

--
Eric Wheeler


> 
> Regards,
> Jens
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
