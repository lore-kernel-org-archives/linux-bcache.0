From: Coly Li <i@coly.li>
Subject: Re: Comm: bcache_allocato BUG: unable to handle kernel NULL pointer
 dereference at 00000000000006bc
Date: Sun, 15 Oct 2017 18:27:23 +0800
Message-ID: <132af933-178f-2e46-d2ee-4d48a83e3c71@coly.li>
References: <CAGmahrSoEjp5Qh4P9OLk-x7W73F3FNbwc7x2wpChHq_Y_SSj=g@mail.gmail.com>
 <c1470bb5-413c-2cc9-0560-b90a3b577c99@coly.li>
 <CAGmahrQ=UhHOpwcRXgWqgyb6aWFt3FGn0vip630JSCq8cMH0CA@mail.gmail.com>
 <f0bd886e-b083-a07a-89c2-a8ade257aeef@coly.li>
 <2c3a76c1-3374-ac8d-5023-fd8809d399d2@lyle.org>
 <f4f81939-723a-b130-7d72-b9e4f194d604@coly.li>
 <9cfdd5d4-0956-2c51-e30e-e76fb2276ec7@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:48382 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750722AbdJOK12 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 15 Oct 2017 06:27:28 -0400
In-Reply-To: <9cfdd5d4-0956-2c51-e30e-e76fb2276ec7@lyle.org>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: Sverd Johnsen <sverd.johnsen@googlemail.com>, linux-bcache@vger.kernel.org

On 2017/10/15 上午6:34, Michael Lyle wrote:
> On 10/14/2017 03:02 PM, Coly Li wrote:
> [snip]
> 
> Hey Coly,--
> 
> My bad: I misread the trace and your commit log.  This makes more sense.
> 
> Does this re-ordering also prevent the other alloc_thread issue from
> being triggered?
> 

So far my answer is not yet. Because I don't have exact idea that
creating sysfs late may prevent such NULL dereference issue. This is a
draft patch for try, there might be some other reason I didn't cache yet.

For wake up allocator thread, if the thread pointer is not initialized,
ignore it and wake up for next time is safe. But this NULL dereference
happens in bucket allocation code patch, simply ignore it or return an
error may cause bcache fails to start.


> I feel like we should maybe be holding a big lock that excludes sysfs
> actions during these critical times-- maybe make the register_lock
> bigger-- so that it is not as critical to handle these dependencies.  It
> will be a little less responsive/concurrent during registration but this
> is just a boot-time or shutdown issue, so...

Copied, I keep in mind for this suggestion, need to look close for the
code dependence. I will update status late.

Thanks.

Coly Li

>> Hi Mike,
>>
>> I check the code, creating sysfs obj has no obvious logic change in the
>> code. And I ran a test for this change, just echo 1 into stop files and
>> re-register cache/cached devices by bash script.
>>
>> The dmesg output displays,
>> [ 5646.739946] bcache: bch_journal_replay() journal replay done, 3406
>> keys in 8 entries, seq 15762
>> [ 5646.740120] bcache: register_cache() registered cache device nvme1n1p1
>> [ 5647.074204] bcache: register_bdev() registered backing device md0
>> [ 5647.145510] bcache: bch_cached_dev_attach() Caching md0 as bcache0 on
>> set 76abb9d9-aea3-4e1a-9b4a-46a217963834
>> [ 5664.285232] bcache: bcache_device_free() bcache0 stopped
>> [ 5664.322575] bcache: cache_set_free() Cache set
>> 76abb9d9-aea3-4e1a-9b4a-46a217963834 unregistered
>> [ 5674.928248] bcache: bch_journal_replay() journal replay done, 4063
>> keys in 11 entries, seq 15859
>> [ 5674.928413] bcache: register_cache() registered cache device nvme1n1p1
>> [ 5675.257664] bcache: register_bdev() registered backing device md0
>> [ 5675.347494] bcache: bch_cached_dev_attach() Caching md0 as bcache0 on
>> set 76abb9d9-aea3-4e1a-9b4a-46a217963834
>> [ 5692.665452] bcache: bcache_device_free() bcache0 stopped
>>
>> I ran the test for a while, it seems nothing broken. Then I post out
>> this draft version.
>>
>>> Isn't this reported issue is the thing that you fixed earlier in
>>> "bcache: check ca->alloc_thread initialized before wake up it" ?
>>>
>>
>> They are different NULL dereference locations, my previous fix is a NULL
>> dereference when waking up allocator thread, this one is a NULL
>> dereference on data bucket spinlock.
>>
>> This NULL spinlock is a little bit complex, I don't find a proper way to
>> handle caller's logic where data bucket spinlock is referenced, so I
>> change the function calling order to make sure it has been initialized
>> before any further reference.
>>
>>> It seems like we have a lot of issues with bringing up devices and
>>> tearing them down/detaching.
>>
>> Yes, if you look at Liang Chen's patch "bcache: explicitly destroy mutex
>> while exiting", you may find he moves sysfs_create_files(bcache_kobj,
>> files)) after bch_request_init() for the similar reason.
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Coly Li
