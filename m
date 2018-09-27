From: Eddie Chapman <eddie@ehuk.net>
Subject: Re: [PATCH] bcache: add separate workqueue for journal_write to avoid
 deadlock
Date: Thu, 27 Sep 2018 16:53:06 +0100
Message-ID: <9b1abe65-c6f5-77b4-290e-e6af21723cfc@ehuk.net>
References: <1538055919-5757-1-git-send-email-fangguoju@gmail.com>
 <bda92f58-d321-d4db-c73f-0ceecbfd9c38@suse.de>
Reply-To: Eddie Chapman <eddie@ehuk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <bda92f58-d321-d4db-c73f-0ceecbfd9c38@suse.de>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, guoju <fangguoju@gmail.com>
Cc: kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 27/09/18 16:23, Coly Li wrote:
> 
> On 9/27/18 9:45 PM, guoju wrote:
>> After write SSD completed, bcache schedule journal_write work to
>> system_wq, that is a public workqueue in system, without WQ_MEM_RECLAIM
>> flag. system_wq is also a bound wq, and there may be no idle kworker on
>> current processor. Creating a new kworker may unfortunately need to
>> reclaim memory first, by shrinking cache and slab used by vfs, which
>> depends on bcache device. That's a deadlock.
>>
>> This patch create a new workqueue for journal_write with WQ_MEM_RECLAIM
>> flag. It's rescuer thread will work to avoid the deadlock.
>>
>> Signed-off-by: guoju <fangguoju@gmail.com>
> 
> Nice catch, this fix is quite important. I will try to submit to Jens ASAP.
> 
> Thanks.
> 
> Coly Li

Once this goes into 4.19, would this be a candidate for backporting to 
any stable kernels, or does it only fix something introduced in this cycle?

thanks,
Eddie
