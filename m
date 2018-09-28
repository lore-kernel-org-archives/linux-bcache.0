From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: add separate workqueue for journal_write to avoid
 deadlock
Date: Fri, 28 Sep 2018 10:32:53 +0800
Message-ID: <ef36fbef-9f2e-0208-aa00-bd9ba656de31@suse.de>
References: <1538055919-5757-1-git-send-email-fangguoju@gmail.com>
 <bda92f58-d321-d4db-c73f-0ceecbfd9c38@suse.de>
 <9b1abe65-c6f5-77b4-290e-e6af21723cfc@ehuk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9b1abe65-c6f5-77b4-290e-e6af21723cfc@ehuk.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Eddie Chapman <eddie@ehuk.net>
Cc: guoju <fangguoju@gmail.com>, kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org


On 9/27/18 11:53 PM, Eddie Chapman wrote:
> On 27/09/18 16:23, Coly Li wrote:
>>
>> On 9/27/18 9:45 PM, guoju wrote:
>>> After write SSD completed, bcache schedule journal_write work to
>>> system_wq, that is a public workqueue in system, without WQ_MEM_RECLAIM
>>> flag. system_wq is also a bound wq, and there may be no idle kworker on
>>> current processor. Creating a new kworker may unfortunately need to
>>> reclaim memory first, by shrinking cache and slab used by vfs, which
>>> depends on bcache device. That's a deadlock.
>>>
>>> This patch create a new workqueue for journal_write with WQ_MEM_RECLAIM
>>> flag. It's rescuer thread will work to avoid the deadlock.
>>>
>>> Signed-off-by: guoju <fangguoju@gmail.com>
>>
>> Nice catch, this fix is quite important. I will try to submit to Jens 
>> ASAP.
>>
>> Thanks.
>>
>> Coly Li
>
> Once this goes into 4.19, would this be a candidate for backporting to 
> any stable kernels, or does it only fix something introduced in this 
> cycle?
>
This bug exists in upstream for quite long time, it should be applied to 
all stable kernels which it can be applied. And it is Cced to 
stable@vger.kernel.org already.

Coly Li
