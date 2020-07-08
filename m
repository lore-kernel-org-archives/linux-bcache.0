From: kent.overstreet@gmail.com
Subject: Re: how does the caching works in bcachefs
Date: Wed, 8 Jul 2020 18:37:29 -0400
Message-ID: <20200708220220.GA109921@zaphod.evilpiepirate.org>
References: <2308642.L3yuttUQlX@t460-skr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbgGHWhh (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 8 Jul 2020 18:37:37 -0400
Content-Disposition: inline
In-Reply-To: <2308642.L3yuttUQlX@t460-skr>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Stefan K <shadow_7@gmx.net>
Cc: linux-bcache@vger.kernel.org, linux-bcachefs@vger.kernel.org

On Wed, Jul 08, 2020 at 11:46:00PM +0200, Stefan K wrote:
> Hello,
> 
> short question: how does the caching works with bcachefs? Is it like  "first
> in first out" or is it more complex like the ARC system in zfs?

LRU, same as bcache.

> The same with the write-cache,  will be everything written to the SSD/NVMe
> (Cache) and then to the HDD? When will will the filesystem say "its written to
> disk"? And what happens with the data on the write cache if we have a
> powerfail?

Disks that are used as caches are treated no differently from other disks by the
filesystem. If you want bcachefs to not rely on a specific disk, you can set its
durability to 0, and then it'll basically only be used as a writethrough cache.

> 
> And can I say have this file/folder always in the cache, while it works "normal" ?

Yes.

So caching is configured differently, specifically so that it can be configured
on a per file/directory basis. Instead of having a notion of "cache device",
there are options for
 - foregroud target: which device or group of devices are used for foreground
   writes
 - background target: if enabled, the rebalance thread will in the background
   move data to this target in the background, leaving a cached copy on the
   foreground target
 - promote target: if enabled, when data is read and it doesn't exist in this
   target, a cached copy will be added there

So these options can be set to get you writeback mode, by setting foreground
target and promote target to your SSD and background target to your HDD.

And you can pin specific files/folders to a device, by setting foreground target
to that device and setting background target and promote target to nothing.
