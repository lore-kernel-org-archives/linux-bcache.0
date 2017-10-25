From: Coly Li <i@coly.li>
Subject: Re: [PATCH] update bucket_in_use in real time
Date: Wed, 25 Oct 2017 08:29:35 +0800
Message-ID: <a85ea673-70cb-ddab-f05e-ca9e37fb2cdc@coly.li>
References: <1508835429-6977-1-git-send-email-tang.junhui@zte.com.cn>
 <661da640-5093-a621-d18c-b81bc30d108c@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:50178 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751887AbdJYA3k (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 24 Oct 2017 20:29:40 -0400
In-Reply-To: <661da640-5093-a621-d18c-b81bc30d108c@lyle.org>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>, tang.junhui@zte.com.cn, colyli@suse.de
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

On 2017/10/25 上午2:50, Michael Lyle wrote:
> Hi---
> 
> On 10/24/2017 01:57 AM, tang.junhui@zte.com.cn wrote:
>> From: Tang Junhui <tang.junhui@zte.com.cn>
>>
>> bucket_in_use is updated in gc thread which triggered by invalidating or
>> writing sectors_to_gc dirty data, It's a long interval. Therefore, when we
>> use it to compare with the threshold, it is often not timely, which leads
>> to inaccurate judgment and often results in bucket depletion.
>>
>> We have send a patch before, by the means of updating bucket_in_use
>> periodically In gc thread, which Coly thought that would lead high
>> latency, In this patch, we add avail_nbuckets to record the count of
>> available buckets, and we calculate bucket_in_use when alloc or free
>> bucket in real time.
>>
>> Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
>> ---
>>  drivers/md/bcache/alloc.c  | 10 ++++++++++
>>  drivers/md/bcache/bcache.h |  1 +
>>  drivers/md/bcache/btree.c  | 17 ++++++++++-------
>>  drivers/md/bcache/btree.h  |  1 +
>>  4 files changed, 22 insertions(+), 7 deletions(-)
>>  mode change 100644 => 100755 drivers/md/bcache/alloc.c
>>  mode change 100644 => 100755 drivers/md/bcache/bcache.h
>>  mode change 100644 => 100755 drivers/md/bcache/btree.c
>>  mode change 100644 => 100755 drivers/md/bcache/btree.h
>>
>> diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
>> old mode 100644
>> new mode 100755
>> index ca4abe1..89a5e35
>> --- a/drivers/md/bcache/alloc.c
>> +++ b/drivers/md/bcache/alloc.c
>> @@ -439,6 +439,11 @@ long bch_bucket_alloc(struct cache *ca, unsigned reserve, bool wait)
>>  		b->prio = INITIAL_PRIO;
>>  	}
>>  
>> +	if(ca->set->avail_nbuckets > 0) {
>> +		ca->set->avail_nbuckets--;
>> +		bch_update_bucket_in_use(ca->set);
>> +	}
>> +
> 
> I am not sure this needs an atomic.  All accesses to this variable are
> done with the bucket_lock held, so that seems correct.  Is this right?
> 

Hi Mike and Junhui,

Aha! mutex bucket_lock is held in bch_bucket_alloc_set(), which is 2
layers up in the caller :-) In sequence, __bch_bucket_free() has
bucket_lock held too. They are safe.

Since there is mutex protected avai_nbuckets, this patch is good to me.
Nothing needs to be changed. Thanks for Mike's double check.

Reviewed-by: Coly Li <colyli@suse.de>

Thanks.

-- 
Coly Li
