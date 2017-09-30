From: Coly Li <i@coly.li>
Subject: Re: [PATCH 4/5] bcache: writeback: collapse contiguous IO better
Date: Sat, 30 Sep 2017 10:25:29 +0800
Message-ID: <477dc501-bbb3-f864-c637-1f19f787448a@coly.li>
References: <1506497553-12552-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1506497553-12552-1-git-send-email-tang.junhui@zte.com.cn>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: tang.junhui@zte.com.cn, mlyle@lyle.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2017/9/27 下午3:32, tang.junhui@zte.com.cn wrote:
> From: Tang Junhui <tang.junhui@zte.com.cn>
> 
> Hello Mike:
> 
> For the second question, I thinks this modification is somewhat complex, 
> cannot we do something simple to resolve it? I remember there were some
> patches trying to avoid too small writeback rate, Coly, is there any 
> progress now?
> 
Junhui,

That patch works well, but before I solve the latency of calculating
dirty stripe numbers, I won't push it upstream so far.

This patch does not conflict with my max-writeback-rate-when-idle, this
patch tries to fetch more dirty keys from cache device which are
continuous on cached device, and assume they can be continuously written
back to cached device.

For the above purpose, if writeback_rate is high, dc->last_read just
works well. But when dc->writeback_rate is low, e.g. 8, event
KEY_START(&w->key) == dc->last_read, the continuous key will only be
submit in next delay cycle. I feel Micheal wants to make larger
writeback I/O and delay more, then backing cached device may be woke up
less chance.

This policy only works better then current dc->last_read when
writeback_rate is low, that's say, when front write I/O is low or no
front write. I hesitate whether it is worthy to modify general writeback
logic for it.


> -------
> Tang Junhui
>                        
>> Ah-- re #1 -- I was investigating earlier why not as much was combined
>> as I thought should be when idle.  This is surely a factor.  Thanks
>> for the catch-- KEY_OFFSET is correct.  I will fix and retest.
>>
>> (Under heavy load, the correct thing still happens, but not under
>> light or intermediate load0.
>>
>> About #2-- I wanted to attain a bounded amount of "combining" of
>> operations.  If we have 5 4k extents in a row to dispatch, it seems
>> really wasteful to issue them as 5 IOs 60ms apart, which the existing
>> code would be willing to do-- I'd rather do a 20k write IO (basically
>> the same cost as a 4k write IO) and then sleep 300ms.  It is dependent
>> on the elevator/IO scheduler merging the requests.  At the same time,
>> I'd rather not combine a really large request.
>>
>> It would be really neat to blk_plug the backing device during the
>> write issuance, but that requires further work.
>>
>> Thanks
>>
>> Mike
>>
>> On Tue, Sep 26, 2017 at 11:51 PM,  <tang.junhui@zte.com.cn> wrote:
>>> From: Tang Junhui <tang.junhui@zte.com.cn>
>>>
>>> Hello Lyle:
>>>
>>> Two questions:
>>> 1) In keys_contiguous(), you judge I/O contiguous in cache device, but not
>>> in backing device. I think you should judge it by backing device (remove
>>> PTR_CACHE() and use KEY_OFFSET() instead of PTR_OFFSET()?).
>>>
>>> 2) I did not see you combine samll contiguous I/Os to big I/O, so I think
>>> it is useful when writeback rate was low by avoiding single I/O write, but
>>> have no sense in high writeback rate, since previously it is also write
>>> I/Os asynchronously.
>>>
>>> -----------
>>> Tang Junhui
>>>
>>>> Previously, there was some logic that attempted to immediately issue
>>>> writeback of backing-contiguous blocks when the writeback rate was
>>>> fast.
>>>>
>>>> The previous logic did not have any limits on the aggregate size it
>>>> would issue, nor the number of keys it would combine at once.  It
>>>> would also discard the chance to do a contiguous write when the
>>>> writeback rate was low-- e.g. at "background" writeback of target
>>>> rate = 8, it would not combine two adjacent 4k writes and would
>>>> instead seek the disk twice.
>>>>
>>>> This patch imposes limits and explicitly understands the size of
>>>> contiguous I/O during issue.  It also will combine contiguous I/O
>>>> in all circumstances, not just when writeback is requested to be
>>>> relatively fast.
>>>>
>>>> It is a win on its own, but also lays the groundwork for skip writes to
>>>> short keys to make the I/O more sequential/contiguous.
>>>>
>>>> Signed-off-by: Michael Lyle <mlyle@lyle.org>
[snip code]

-- 
Coly Li
