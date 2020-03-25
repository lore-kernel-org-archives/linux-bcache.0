From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/1] bcache: remove dupplicated declaration from btree.h
Date: Tue, 24 Mar 2020 20:42:57 -0600
Message-ID: <f165ad0c-c78c-d738-269b-8a6433b0bbac@kernel.dk>
References: <20200325013057.114340-1-colyli@suse.de>
 <20200325013057.114340-2-colyli@suse.de>
 <6577c33f-5e57-f34a-8bbc-a4c17e124e11@kernel.dk>
 <364bfce6-7bbc-6bfa-fcc1-3dbb97c1acec@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35967 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727299AbgCYCnB (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 24 Mar 2020 22:43:01 -0400
Received: by mail-pl1-f194.google.com with SMTP id g2so227679plo.3
        for <linux-bcache@vger.kernel.org>; Tue, 24 Mar 2020 19:43:00 -0700 (PDT)
In-Reply-To: <364bfce6-7bbc-6bfa-fcc1-3dbb97c1acec@suse.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, kbuild test robot <lkp@intel.com>

On 3/24/20 8:32 PM, Coly Li wrote:
> On 2020/3/25 9:57 上午, Jens Axboe wrote:
>> On 3/24/20 7:30 PM, Coly Li wrote:
>>> Commit ab544165dc2d ("bcache: move macro btree() and btree_root()
>>> into btree.h") makes two duplicated declaration into btree.h,
>>> 	typedef int (btree_map_keys_fn)();
>>> 	int bch_btree_map_keys();
>>>
>>> The kbuild test robot <lkp@intel.com> detects and reports this
>>> problem and this patch fixes it by removing the duplicated ones.
>>>
>>> Fixes: ab544165dc2d ("bcache: move macro btree() and btree_root() into btree.h")
>>
>> Applied, but I fixed up the commit sha, not sure where yours is from?
>>
> 
> I should use the sha from your tree, not mine. I just realize with your
> SOB the sha number should change. Sorry for the inconvenience, and I
> will notice such condition next time.
> 
> BTW, you still find such issue by your own eyes, without any extra tool?

Manual inspection, to try and avoid cases where the sha is either too
short, or just plain wrong.

-- 
Jens Axboe
