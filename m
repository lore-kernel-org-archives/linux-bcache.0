From: Pradeep Fernando <pradeepfn@gmail.com>
Subject: Few questions on bcache internals
Date: Wed, 24 Feb 2016 20:38:15 -0500
Message-ID: <CAPSEm=aMgfe5Eaa64sepiyepFd1va+jMQCuGCT1EcS=6GY8bHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.161.182]:34514 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbcBYBif (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 24 Feb 2016 20:38:35 -0500
Received: by mail-yw0-f182.google.com with SMTP id h129so31356461ywb.1
        for <linux-bcache@vger.kernel.org>; Wed, 24 Feb 2016 17:38:35 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi All,

I'm trying to get familiar with the bcache internals. I went through
this detailed write-up [1] and
looked in to the code found in stable Linux kernel release (not the
latest bcache code) as well.

I have few questions on the topic.

Here is my abstract model on how bcache work.

- format the caching device and the backing device with its own bucket
based file system (bcacheFS)
- exposes a virtual block device to the applications (/dev/bcache0)
- the data is organized as buckets, indexed by b+tree structures and
auxilary search structures.
- when a request comes in, search the b+tree based on <inode:offset>
and try finding the data
on caching device, else send the request to backing device.


1. Why bcache refers to inodes ? The block driver layer does not have
an idea about the file system layed on top of it. (ext4). Is this
inode refers to device file? As per my
understanding the block layer gets bio_structure, it does not have a
notion of inodes...

2. How the cache eviction work. ? for an example in processor caches
we evict the cache lines
within a set in a set associative cache using LRU/etc. How does
eviction happens in bcache/policy?

3. Can i use any file system in backing device other than bcacheFS. ?
My abstract model on bcache says NO.

I'm new to Linux driver programming. so I might be missing few trivial
details and hence the confusion..
appreciate if someone can shed some light on the above questions...

[1] bcache.evilpiepirate.org/BcacheGuide

thanks
Pradeep
