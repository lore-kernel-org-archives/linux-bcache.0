From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: Few questions on bcache internals
Date: Thu, 25 Feb 2016 04:20:59 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1602250409120.3635@mail.ewheeler.net>
References: <CAPSEm=aMgfe5Eaa64sepiyepFd1va+jMQCuGCT1EcS=6GY8bHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([71.19.153.34]:38779 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756602AbcBYEVJ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 24 Feb 2016 23:21:09 -0500
In-Reply-To: <CAPSEm=aMgfe5Eaa64sepiyepFd1va+jMQCuGCT1EcS=6GY8bHA@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Pradeep Fernando <pradeepfn@gmail.com>
Cc: linux-bcache@vger.kernel.org


On Wed, 24 Feb 2016, Pradeep Fernando wrote:

> Hi All,
> 
> I'm trying to get familiar with the bcache internals. 

do you mean bcache or bcachefs?

> I went through this detailed write-up [1] and looked in to the code 
> found in stable Linux kernel release (not the latest bcache code) as 
> well.
> 
> I have few questions on the topic.
> 
> Here is my abstract model on how bcache work.
> 
> - format the caching device and the backing device with its own bucket
> based file system (bcacheFS)

bcachefs is new and still in development.  Eventually its caching code 
will supply bcache with a cache superblock version 2 and better 
performance. bcache is available from mainline since 3.10 iirc.

> - exposes a virtual block device to the applications (/dev/bcache0)

yes

> - the data is organized as buckets, indexed by b+tree structures and
> auxilary search structures.

That sounds reasonable, though I've not been digging in the metadata 
structure.

> - when a request comes in, search the b+tree based on <inode:offset>

Maybe in bcachefs, but not in bcache at the block layer (current in-kernel 
version).

> and try finding the data on caching device, else send the request to 
> backing device.
> 
> 
> 1. Why bcache refers to inodes ? The block driver layer does not have
> an idea about the file system layed on top of it. (ext4). Is this
> inode refers to device file? As per my
> understanding the block layer gets bio_structure, it does not have a
> notion of inodes...

You're probably looking at bcachefs, not bcache.

If you're interested in looking at bcache, it would be great if you can 
check out the most recent list issues and see if there is one you can work 
on: the "Re: BUG: drivers/md/bcache/writeback.c:237" thread, for example.

Also there are some places that could use a mempool.

> 2. How the cache eviction work. ? for an example in processor caches
> we evict the cache lines
> within a set in a set associative cache using LRU/etc. How does
> eviction happens in bcache/policy?

configurable: lru/fifo

> 3. Can i use any file system in backing device other than bcacheFS. ?
> My abstract model on bcache says NO.

bcache, yes.  bcachefs, no (without loopback)

-Eric

> I'm new to Linux driver programming. so I might be missing few trivial
> details and hence the confusion..
> appreciate if someone can shed some light on the above questions...
> 
> [1] bcache.evilpiepirate.org/BcacheGuide
> 
> thanks
> Pradeep
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
