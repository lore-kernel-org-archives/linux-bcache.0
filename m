From: Eddie Chapman <eddie@ehuk.net>
Subject: Re: [PATCH] bcache: add separate workqueue for journal_write to avoid
 deadlock
Date: Thu, 4 Oct 2018 15:07:54 +0100
Message-ID: <17ea92fa-a07b-2391-aba3-377382c63d9b@ehuk.net>
References: <1538055919-5757-1-git-send-email-fangguoju@gmail.com>
 <bda92f58-d321-d4db-c73f-0ceecbfd9c38@suse.de>
 <9b1abe65-c6f5-77b4-290e-e6af21723cfc@ehuk.net>
 <ef36fbef-9f2e-0208-aa00-bd9ba656de31@suse.de>
Reply-To: Eddie Chapman <eddie@ehuk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ef36fbef-9f2e-0208-aa00-bd9ba656de31@suse.de>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: guoju <fangguoju@gmail.com>, kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, s.priebe@profihost.ag
List-Id: linux-bcache@vger.kernel.org

On 28/09/18 03:32, Coly Li wrote:
> 
> On 9/27/18 11:53 PM, Eddie Chapman wrote:
>> On 27/09/18 16:23, Coly Li wrote:
>>>
>>> On 9/27/18 9:45 PM, guoju wrote:
>>>> After write SSD completed, bcache schedule journal_write work to
>>>> system_wq, that is a public workqueue in system, without WQ_MEM_RECLAIM>>>> flag. system_wq is also a bound wq, and there may be no idle kworker on
>>>> current processor. Creating a new kworker may unfortunately need to
>>>> reclaim memory first, by shrinking cache and slab used by vfs, which
>>>> depends on bcache device. That's a deadlock.
>>>>
>>>> This patch create a new workqueue for journal_write with WQ_MEM_RECLAIM
>>>> flag. It's rescuer thread will work to avoid the deadlock.
>>>>
>>>> Signed-off-by: guoju <fangguoju@gmail.com>
>>>
>>> Nice catch, this fix is quite important. I will try to submit to Jens 
>>> ASAP.
>>>
>>> Thanks.
>>>
>>> Coly Li
>>
>> Once this goes into 4.19, would this be a candidate for backporting to 
>> any stable kernels, or does it only fix something introduced in this 
>> cycle?
>>
> This bug exists in upstream for quite long time, it should be applied to 
> all stable kernels which it can be applied. And it is Cced to 
> stable@vger.kernel.org already.
> 
> Coly Li

Thanks Coly! :-)

Just to let you know, I applied this (and couple of other cherry picks) 
to a couple of 4.14 boxes last night, so far so good, running without 
issues. However, this one needed this recent commit upstream as a 
pre-requisite:

16c1fdf4cfd6c0091e59b93ec2cb7e99973f8244
bcache: do not assign in if condition in bcache_init()

in order to be able to apply it.

This is because the context of the second hunk for 
drivers/md/bcache/super.c (in this journal_write workqueue patch) 
contains code added by that commit 16c1fdf4cfd6c0091e59b93ec2cb7e99973f8244.

So I guess either 16c1fdf4cfd6c0091e59b93ec2cb7e99973f8244 also needs 
tagging for stable, or perhaps a backport of this journal_write 
workqueue will have to be created for earlier kernels, with different 
context for that hunk?

Eddie
