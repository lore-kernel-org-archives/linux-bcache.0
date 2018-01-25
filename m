From: Pavel Goran <via-bcache@pvgoran.name>
Subject: Re[2]: [PATCH v3 00/13] bcache: device failure handling improvement
Date: Thu, 25 Jan 2018 06:35:16 +0300
Message-ID: <1664591662.20180125063516@pvgoran.name>
References: <20180114144236.28213-1-colyli@suse.de> <87po5ykiaw.fsf@esperi.org.uk>
Reply-To: Pavel Goran <via-bcache@pvgoran.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from vostok.pvgoran.name ([71.19.149.48]:37649 "EHLO
        vostok.pvgoran.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932998AbeAYDfU (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 24 Jan 2018 22:35:20 -0500
In-Reply-To: <87po5ykiaw.fsf@esperi.org.uk>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

Hello Nix,

Thursday, January 25, 2018, 1:23:19 AM, you wrote:

> On 14 Jan 2018, Coly Li said:

>> Hi maintainers and folks,
>>
>> This patch set tries to improve bcache device failure handling, includes
>> cache device and backing device failures.
>>
>> The basic idea to handle failed cache device is,
>> - Unregister cache set
>> - Detach all backing devices which are attached to this cache set
>> - Stop all the detached bcache devices
>> - Stop all flash only volume on the cache set
>> The above process is named 'cache set retire' by me. The result of cache
>> set retire is, cache set and bcache devices are all removed, following
>> I/O requests will get failed immediately to notift upper layer or user
>> space coce that the cache device is failed or disconnected.

> This feels wrong to me. If a cache device is writethrough, the cache is
> a pure optimization: having such a device fail should not lead to I/O
> failures of any sort, but should only flip the cache device to 'none' so
> that writes to the backing store simply don't get cached any more.

> Anything else leads to a reliability reduction, since in the end cache
> devices *will* fail.

It's one of those choices: "if something can't work as intended, should it be
allowed to work at all?" I believe different use cases will have different
answers to this question. So ideally this should be configurable by some kind
of option stored in superblock, much like the "Errors behavior" option of ext*
filesystems.

Of course, this only applies to "writethrough" and "writearound" modes with
zero dirty data; "writeback" bcache devices (or devices switched from
writeback and still having some dirty data) should probably be disabled if the
cache device fails.

Pavel Goran
  
