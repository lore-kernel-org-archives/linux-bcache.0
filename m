From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: option for recovery from staled data
Date: Sun, 17 Sep 2017 23:11:18 +0200
Message-ID: <e30b6ae7-d39d-0224-d392-e6e64ebdd35c@suse.de>
References: <20170909175621.9705-1-colyli@suse.de>
 <87r2v5mzhu.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51452 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751551AbdIQVL0 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 17 Sep 2017 17:11:26 -0400
In-Reply-To: <87r2v5mzhu.fsf@esperi.org.uk>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Kai Krakow <hurikhan77@gmail.com>, Eric Wheeler <bcache@lists.ewheeler.net>, Junhui Tang <tang.junhui@zte.com.cn>, stable@vger.kernel.org

On 2017/9/17 上午11:43, Nix wrote:
> On 9 Sep 2017, Coly Li spake thusly:
> 
>> When bcache does read I/Os, for example in writeback or writethrough mode,
>> if a read request on cache device is failed, bcache will try to recovery
>> the request by reading from cached device. If the data on cached device is
>> not synced with cache device, then requester will get a staled data.
>>
>> For critical storage system like database, recovery from staled data may
>> result an application level data corruption, which is unacceptible. But
>> for some other situation like multi-media stream cache, continuous service
>> may be more important and it is acceptible to fetch a staled chunk of data.
>>
>> This patch tries to solve the above conflict by adding a sysfs option
>> 	/sys/block/bcache<idx>/bcache/recovery_from_staled_data
>> which is defaultly cleared (to 0) as disabled. Now people can make choices
>> for different situations.
> 
> 'Staled' is not a word, though perhaps it should be. You probably want
> to call it recovery_from_stale_data. But given the description below...
> 

Hi Nix,

Thanks for pointing out this. Sure, I will replace all typos with
'stale'. Good suggestion :-)

>> With this patch, for a failed read request in writeback or writethrough
>> mode, recovery a recoverable read request only happens in one of the
>> following conditions,
>>  - dc->has_dirty is zero. It means all data on cache device is synced to
>>    cached device, the recoveried data is up-to-date. 
>>  - dc->has_dirty is non-zero, and dc->recovery_from_staled_data is set
>>    to 1. It means there is dirty data not synced to cached device yet, but
>>    option recovery_from_staled_data is set, receiving staled data is
>>    explicitly acceptible for requester.
> 
> ... this name is also unclear. It sounded to me like it was an option
> that recovers *from* stale data (as if the stale data was a problem to
> recover from), not an option that uses stale data to *allow* recovery.
> 
> Perhaps, instead, something like stale_data_permitted or
> allow_stale_data_on_failure would be better?
> 

I didn't notice such a confusion without your suggestion, thank you!
allow_stale_data_on_failure is good for me.

I will send out another patch, fix 'stale' and rename sysfs entry to
allow_stale_data_on_failure.
