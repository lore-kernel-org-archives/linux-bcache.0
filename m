From: Coly Li <i@coly.li>
Subject: Re: [PATCH 15/19] bcache: fix issue of writeback rate at minimum 1
 key per second
Date: Sat, 28 Oct 2017 16:58:49 +0800
Message-ID: <973911b2-db49-ab6e-a7f6-183c72a7226f@coly.li>
References: <20170629134510.GA32385@infradead.org>
 <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
 <1498855388-16990-15-git-send-email-bcache@lists.ewheeler.net>
 <a0e50d65-6e9d-23d0-d73c-8fb2b3dfcc51@coly.li>
 <alpine.LRH.2.11.1710271906110.24585@mail.ewheeler.net>
 <alpine.LRH.2.11.1710271908450.24585@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:35034 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751189AbdJ1I7D (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 28 Oct 2017 04:59:03 -0400
In-Reply-To: <alpine.LRH.2.11.1710271908450.24585@mail.ewheeler.net>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Tang Junhui <tang.junhui@zte.com.cn>, Michael Lyle <mlyle@lyle.org>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, hch@infradead.org, axboe@kernel.dk

On 2017/10/28 上午3:09, Eric Wheeler wrote:
> 
> [+cc Michael Lyle]
> 
> On Fri, 27 Oct 2017, Eric Wheeler wrote:
> 
>> On Sun, 16 Jul 2017, Coly Li wrote:
>>
>>> On 2017/7/1 上午4:43, bcache@lists.ewheeler.net wrote:
>>>> From: Tang Junhui <tang.junhui@zte.com.cn>
>>>>
>>>> When there is not enough dirty data in writeback cache,
>>>> writeback rate is at minimum 1 key per second
>>>> util all dirty data to be cleaned, it is inefficiency,
>>>> and also causes waste of energy;
>>>
>>> Hi Junhui and Eric,
>>>
>>> What: /sys/block/<disk>/bcache/writeback_percent
>>> Description:
>>>       For backing devices: If nonzero, writeback from cache to
>>>       backing device only takes place when more than this percentage
>>>       of the cache is used, allowing more write coalescing to take
>>>       place and reducing total number of writes sent to the backing
>>>       device. Integer between 0 and 40.
>>>
>>> I see above text from Documentation/ABI/testing/sysfs-block-bcache (I
>>> know this document is quite old), it seems if "not enough" means dirty
>>> data percentage is less then writback_percent, bcache should not
>>> performance writeback I/O. But in __update_writeback_rate(),
>>> writeback_rate.rate is clamped in [1, NSEC_PER_MSEC]. It seems in PD
>>> controller code of __update_writeback_rate(), writeback_percent is only
>>> used to calculate dirty target number, its another functionality as
>>> writeback threshold is not handled here.
>>>
>>>>
>>>> in this patch, When there is not enough dirty data,
>>>> let the writeback rate to be 0, and writeback re-schedule
>>>> in bch_writeback_thread() periodically with schedule_timeout(),
>>>> the behaviors are as follows :
>>>>
>>>> 1) If no dirty data have been read into dc->writeback_keys,
>>>> goto step 2), otherwise keep writing these dirty data to
>>>> back-end device at 1 key per second, until all these dirty data
>>>> write over, then goto step 2).
>>>>
>>>> 2) Loop in bch_writeback_thread() to check if there is enough
>>>> dirty data for writeback. if there is not enough diry data for
>>>> writing, then sleep 10 seconds, otherwise, write dirty data to
>>>> back-end device.
>>>
>>> Bcache uses a Proportion-Differentiation Controller to control writeback
>>> rate. When dirty data is far from target, writeback rate is higher; when
>>> dirty data is close to target, writeback rate is slower. The advantage
>>> of PD controller here is, when regular I/O and writeback I/O happens in
>>> same time,
>>> - When there are a lot of dirty data, writeback I/O can have more chance
>>> to write them back to cached device, which in turns has positive impact
>>> to regular I/O.
>>> - When dirty data is decreased and close to target dirty number, less
>>> writeback I/O can help regular I/O has better throughput and latency.
>>>
>>> The root cause of 1 key per second is, the PD controller is designed for
>>> better I/O performance, not less energy consumption. When the existing
>>> dirty data gets closed to target dirty number, the PD controller chooses
>>> to use longer writeback time to make a better regular I/O performance.
>>> If it is designed for less energy consumption, it should keep the
>>> writeback rate in a high level and finish writing back all dirty data as
>>> soon as possible.
>>>
>>> This patch may introduce an unexpected behavior of dirty data writeback
>>> throughput, when regular write I/O and writeback I/O happen in same
>>> time. In this case, dirty data number may shake up and down around
>>> target dirty number, it is possible that change (the variable in
>>> __update_writeback_rate()) is a minus value, and the result of
>>> dc->writeback_rate.rate + change happens to be 0. This patch changes the
>>> clamp range of writeback_rate.rate to [0, NSEC_PER_MSEC], so
>>> writeback_rate.rate can be possible to be 0. And in bch_next_delay() if
>>> d->rate is zero, the write back I/O will be delayed to now +
>>> NSEC_PER_SEC. When there is no regular I/O it works well, but when there
>>> is regular I/O, this longer delay may cause more dirty data piled in
>>> cache device, and PD controller cannot generage a stable writeback rate.
>>> This is not an expected behavior for the writeback rate PD controller.
>>>
>>> Another method to fix might be,
>>> 1) define a sysfs to define writeback_rate with max/dynamic option.
>>> 2) dynamic writeback_rate as default
>>> 3) when max is set, in __update_writeback_rate() assign NSEC_PER_MSEC to
>>> writeback_rate.rate
>>> 4) in bch_writeback_thread(), if no writeback I/O on fly, and dirty data
>>> does not reach dc->writeback_percent, schedule out.
>>> 5) if writeback is necessary then do it in max rate and finish it as
>>> soon as possible, to save laptop energy.
>>>
>>> The above method might be helpful to energy save as well (perform dirty
>>> dat write back in batch), and does not change default PD controller
>>> behavior.
>>>
>>> Just for your reference. Or if you are too busy to look at it, I can try
>>> to compose a patch for review.
>>
>> Hi Coli,
>>
>> Did this go anywere?  I think the 1-key/sec fix is a good idea and your 
>> suggestion will help out mobile users.
>>

Hi Eric,

Michael is working on writeback improvement currently. He proposes some
patches to improve writeback efficiency from a little bit different
view, and after some quite deep discussion I feel some of his ideas are
promising. e.g. writeback more keys if backing device is idle.

Currently it seems a better writeback performance results more lock
contention in between with front end I/O. This is why Junhui posts a
realy time buckets in use counting patch. This is a start to reduce lock
contention in bcache tree writebac/gc/key insert.

I just feel this is a serieal continuous effort to improve writeback
efficiency. the 1-key/sec fix might be one of them, let's
improve-and-test :-)

Thanks.

Coly Li


-- 
Coly Li
