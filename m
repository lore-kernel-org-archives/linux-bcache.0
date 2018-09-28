From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: add separate workqueue for journal_write to avoid
 deadlock
Date: Fri, 28 Sep 2018 10:31:28 +0800
Message-ID: <b4d23257-1912-30c8-85f4-5a7b0d69115c@suse.de>
References: <1538055919-5757-1-git-send-email-fangguoju@gmail.com>
 <bda92f58-d321-d4db-c73f-0ceecbfd9c38@suse.de>
 <9b1abe65-c6f5-77b4-290e-e6af21723cfc@ehuk.net>
 <2C0DE6F7-624B-49B6-9788-BA0A8E7DA25C@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2C0DE6F7-624B-49B6-9788-BA0A8E7DA25C@profihost.ag>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Eddie Chapman <eddie@ehuk.net>, guoju <fangguoju@gmail.com>, kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

Hi Stefan,

This bug was triggered by following condition:

1, few system memory available to allocate

2, journal delayed its operations to system_wq, which needs to allocate 
memory to execute.

3, Due to lack of memory, kernel starts to reclaim system memory, and 
trigger writeback to file system on top of bcache device

4, the memory writeback I/O hitting bcache device via upper layer file 
system, requiring more bcache journal operations

5, a loop-blocking issue happens in bcache journal

If your system is under heavy memory pressure, this deadlock may also 
happens in your environment. Anyway, this is a patch I suggest to apply 
because it fix a real deadlock which is probably happens when system 
memory is exhausted.


Thanks.


Coly Li

On 9/28/18 1:16 AM, Stefan Priebe - Profihost AG wrote:
> Hi Coly,
>
> is this the deadlock I reported some weeks ago?
>
> Greets,
> Stefan
>
> Excuse my typo sent from my mobile phone.
>
> Am 27.09.2018 um 17:53 schrieb Eddie Chapman <eddie@ehuk.net 
> <mailto:eddie@ehuk.net>>:
>
>> On 27/09/18 16:23, Coly Li wrote:
>>> On 9/27/18 9:45 PM, guoju wrote:
>>>> After write SSD completed, bcache schedule journal_write work to
>>>> system_wq, that is a public workqueue in system, without WQ_MEM_RECLAIM
>>>> flag. system_wq is also a bound wq, and there may be no idle kworker on
>>>> current processor. Creating a new kworker may unfortunately need to
>>>> reclaim memory first, by shrinking cache and slab used by vfs, which
>>>> depends on bcache device. That's a deadlock.
>>>>
>>>> This patch create a new workqueue for journal_write with WQ_MEM_RECLAIM
>>>> flag. It's rescuer thread will work to avoid the deadlock.
>>>>
>>>> Signed-off-by: guoju <fangguoju@gmail.com <mailto:fangguoju@gmail.com>>
>>> Nice catch, this fix is quite important. I will try to submit to 
>>> Jens ASAP.
>>> Thanks.
>>> Coly Li
>>
>> Once this goes into 4.19, would this be a candidate for backporting 
>> to any stable kernels, or does it only fix something introduced in 
>> this cycle?
>>
>> thanks,
>> Eddie
