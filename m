From: Pavel Goran <via-bcache@pvgoran.name>
Subject: Re[2]: best way to get the bdev of a bcache block device
Date: Tue, 23 Jan 2018 07:32:19 +0300
Message-ID: <1983233152.20180123073219@pvgoran.name>
References: <3f40cbd2-46cd-d3d5-f43d-3e305da8ca6b@profihost.ag> <120a1d62-87bf-c9c5-81aa-254e619c7398@lyle.org>
Reply-To: Pavel Goran <via-bcache@pvgoran.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from vostok.pvgoran.name ([71.19.149.48]:52373 "EHLO
        vostok.pvgoran.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751147AbeAWEh2 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 22 Jan 2018 23:37:28 -0500
In-Reply-To: <120a1d62-87bf-c9c5-81aa-254e619c7398@lyle.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>

Hello Michael,

Tuesday, January 23, 2018, 1:20:28 AM, you wrote:

> On 01/22/2018 01:59 PM, Stefan Priebe - Profihost AG wrote:
>> Hello,
>> 
>> what's the best way to get the correct bcache backing device (bdev) form
>> a known dev (f.e. /dev/bcache2)?
>> 
>> I haven't found an easy reliable way through /sys/block.
>> 
>> Thanks!
>> 
>> Greets,
>> Stefan

> /sys/block/bcache0/slaves

This lists both the backing device and the cache device(s), without an
(apparent) way of identifying which one is backing.

> /sys/block/bcache0/bcache/cache/bdev0

/sys/block/bcache0/bcache/cache links to the cache set (/sys/fs/bcache/[UUID])
which can serve several bcache devices, so bdev0 would link to the first
backing device registered in the set, not the backing device that corresponds
to the bcache device we started with.

However, it's actually possible to go further: iterate all bdevX devices and
identify the correct one by looking at the "dev" symlink:

/sys/block/bcache0/bcache/cache/bdev0/dev
/sys/block/bcache0/bcache/cache/bdev1/dev
etc.

The device whose "dev" symlink points to bcache0 should be the backing device
for bcache0.

Pavel Goran
  
