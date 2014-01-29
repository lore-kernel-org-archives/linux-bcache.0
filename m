From: Gabriel de Perthuis <g2p.code@gmail.com>
Subject: Re: Moving a backing device between 2 cachesets
Date: Wed, 29 Jan 2014 10:42:13 +0000 (UTC)
Message-ID: <lcalu5$iek$1@ger.gmane.org>
References: <338c5bf03af2422ab712a3552c981390@navex1.navixia.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55367 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbaA2Kmi (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 29 Jan 2014 05:42:38 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1W8SbM-00033F-5l
	for linux-bcache@vger.kernel.org; Wed, 29 Jan 2014 11:42:36 +0100
Received: from pro75-5-88-162-203-35.fbx.proxad.net ([88.162.203.35])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Wed, 29 Jan 2014 11:42:36 +0100
Received: from g2p.code by pro75-5-88-162-203-35.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Wed, 29 Jan 2014 11:42:36 +0100
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

On Tue, 28 Jan 2014 21:59:02 +0000, Patrick Zwahlen wrote:

> Hi,
> 
> We're working on a 2-nodes pacemaker cluster that provides iSCSI LUNs via
> SCST. The LUNs are either software RAID arrays located in a shared JBOD, or
> DRBD ressources (active/passive).
> 
> We are adding bcache to the game with local SSDs (ie not shared, but
> dedicated to each cluster node).
> 
> We are using write-through.
> 
> I need to evaluate the risk when moving a backing device (md) from cacheset1
> (on node #1) to cacheset2 (on node #2) and then back to cacheset #1.
> 
> Scenario
> - md attached to cacheset1 and working (on node 1)
> - md detached from cacheset1
> - md stopped on node 1
> - md started on node 2
> - md attached to cacheset2 on node 2
> 
> At this point, cacheset1 is attached to nothing, but still has valid blocks
> "linked" to the backing md device

From bcache.h:

When you register a newly formatted backing device it'll come up
in passthrough mode, and then you can attach and detach a backing device from
a cache set at runtime - while it's mounted and in use. Detaching implicitly
invalidates any cached data for that backing device.

After flushing, detaching does two things:
- the backing device gets flagged as detached
- the backing device is removed from the cache set's metadata
(stored as uuid_entry in a special bucket; the entry is flagged
with a bogus uuid but not reused).  The offset in that uuids
array constitutes an id, local to the cache set, that is not
reused after detaching.

The second step invalidates the backing device's id in the cache set,
and indirectly invalidates all buckets that referenced it (through
bkey->inode in the bucket key).

> - md detached from cacheset2
> - md stopped on node 2
> - md started on node 1
> - md RE-attached to cacheset1 on node 1
> 
> At this point, I need to make sure that bcache will not serve "old" blocks
> that were linked to the backing device.
> 
> My understanding is that as we have attached the backing device to a new
> cacheset (#2) in-between, this will be "recorded" in the bcache headers and
> all the blocks that used to be valid in the first place won't be served.
> 
> Can you please validate if this is safe or if we need to take special care
> about invalidating the original cacheset ?

> Thanks a lot, - Patrick -
