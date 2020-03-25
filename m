From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 1/1] bcache: remove dupplicated declaration from btree.h
Date: Wed, 25 Mar 2020 10:32:43 +0800
Message-ID: <364bfce6-7bbc-6bfa-fcc1-3dbb97c1acec@suse.de>
References: <20200325013057.114340-1-colyli@suse.de>
 <20200325013057.114340-2-colyli@suse.de>
 <6577c33f-5e57-f34a-8bbc-a4c17e124e11@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58362 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727262AbgCYCcu (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 24 Mar 2020 22:32:50 -0400
In-Reply-To: <6577c33f-5e57-f34a-8bbc-a4c17e124e11@kernel.dk>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, kbuild test robot <lkp@intel.com>

On 2020/3/25 9:57 上午, Jens Axboe wrote:
> On 3/24/20 7:30 PM, Coly Li wrote:
>> Commit ab544165dc2d ("bcache: move macro btree() and btree_root()
>> into btree.h") makes two duplicated declaration into btree.h,
>> 	typedef int (btree_map_keys_fn)();
>> 	int bch_btree_map_keys();
>>
>> The kbuild test robot <lkp@intel.com> detects and reports this
>> problem and this patch fixes it by removing the duplicated ones.
>>
>> Fixes: ab544165dc2d ("bcache: move macro btree() and btree_root() into btree.h")
> 
> Applied, but I fixed up the commit sha, not sure where yours is from?
> 

I should use the sha from your tree, not mine. I just realize with your
SOB the sha number should change. Sorry for the inconvenience, and I
will notice such condition next time.

BTW, you still find such issue by your own eyes, without any extra tool?

Thanks.
-- 

Coly Li
