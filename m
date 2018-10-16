From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: add separate workqueue for journal_write to avoid
 deadlock
Date: Tue, 16 Oct 2018 14:27:38 +0800
Message-ID: <e7dd4db1-85c6-5acd-4737-cc03b904973e@suse.de>
References: <1538055919-5757-1-git-send-email-fangguoju@gmail.com>
 <bda92f58-d321-d4db-c73f-0ceecbfd9c38@suse.de>
 <9b1abe65-c6f5-77b4-290e-e6af21723cfc@ehuk.net>
 <ef36fbef-9f2e-0208-aa00-bd9ba656de31@suse.de>
 <17ea92fa-a07b-2391-aba3-377382c63d9b@ehuk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <17ea92fa-a07b-2391-aba3-377382c63d9b@ehuk.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Eddie Chapman <eddie@ehuk.net>, guoju <fangguoju@gmail.com>
Cc: kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, s.priebe@profihost.ag
List-Id: linux-bcache@vger.kernel.org

On 2018/10/4 下午10:07, Eddie Chapman wrote:
> On 28/09/18 03:32, Coly Li wrote:
>>
>> On 9/27/18 11:53 PM, Eddie Chapman wrote:
>>> On 27/09/18 16:23, Coly Li wrote:
>>>>
>>>> On 9/27/18 9:45 PM, guoju wrote:
>>>>> After write SSD completed, bcache schedule journal_write work to
>>>>> system_wq, that is a public workqueue in system, without
>>>>> WQ_MEM_RECLAIM>>>> flag. system_wq is also a bound wq, and there
>>>>> may be no idle kworker on
>>>>> current processor. Creating a new kworker may unfortunately need to
>>>>> reclaim memory first, by shrinking cache and slab used by vfs, which
>>>>> depends on bcache device. That's a deadlock.
>>>>>
>>>>> This patch create a new workqueue for journal_write with
>>>>> WQ_MEM_RECLAIM
>>>>> flag. It's rescuer thread will work to avoid the deadlock.
>>>>>
>>>>> Signed-off-by: guoju <fangguoju@gmail.com>
>>>>
>>>> Nice catch, this fix is quite important. I will try to submit to
>>>> Jens ASAP.
>>>>
>>>> Thanks.
>>>>
>>>> Coly Li
>>>
>>> Once this goes into 4.19, would this be a candidate for backporting
>>> to any stable kernels, or does it only fix something introduced in
>>> this cycle?
>>>
>> This bug exists in upstream for quite long time, it should be applied
>> to all stable kernels which it can be applied. And it is Cced to
>> stable@vger.kernel.org already.
>>
>> Coly Li
> 
> Thanks Coly! :-)
> 
> Just to let you know, I applied this (and couple of other cherry picks)
> to a couple of 4.14 boxes last night, so far so good, running without
> issues. However, this one needed this recent commit upstream as a
> pre-requisite:
> 
> 16c1fdf4cfd6c0091e59b93ec2cb7e99973f8244
> bcache: do not assign in if condition in bcache_init()
> 
> in order to be able to apply it.
> 
> This is because the context of the second hunk for
> drivers/md/bcache/super.c (in this journal_write workqueue patch)
> contains code added by that commit
> 16c1fdf4cfd6c0091e59b93ec2cb7e99973f8244.
> 
> So I guess either 16c1fdf4cfd6c0091e59b93ec2cb7e99973f8244 also needs
> tagging for stable, or perhaps a backport of this journal_write
> workqueue will have to be created for earlier kernels, with different
> context for that hunk?
> 
> Eddie

Hi Eddie,

Yes I missed the patch dependency, thanks for the hint:-)
Guoju Fang or I will take care of the back port to stable tree.

Coly Li
