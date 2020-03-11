From: Coly Li <colyli@suse.de>
Subject: Re: [QUESTION] Bcache in writeback mode is bypassed
Date: Wed, 11 Mar 2020 19:15:30 +0800
Message-ID: <edb39850-b488-5a54-709e-fc889b932bd1@suse.de>
References: <abe94294-4365-6448-4c46-831c40d4d41d@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37712 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbgCKLPg (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 11 Mar 2020 07:15:36 -0400
In-Reply-To: <abe94294-4365-6448-4c46-831c40d4d41d@canonical.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Benjamin Allot <benjamin.allot@canonical.com>
Cc: linux-bcache@vger.kernel.org

On 2020/3/11 6:20 下午, Benjamin Allot wrote:
> Hello and sorry for the noise if this list is fully intended for contribution or patch purpose only.
> 
> We use bcache quite a lot on our infrastructure, and quite happily so far.
> We recently noticed a strange behavior in the way bcache reports amount of dirty data and the related
> available cache percentage used.
> 
> I opened a related "bug" [0] but I will do a quick TL;DR here
> 
> * bcache is in writeback mode, running, with one cache device, one backing device, writeback_percent set to 40
> 
> * bcache congested_{read,write}_threshold_us are set to 0
> 
> * writeback_rate_debug shows 148Gb of dirty data, priority_stats shows 70% of dirty data in the cache,
>   the cache device is 1.6 TB (and the cache size related to that, given the nbbucket and bucket_size),
>   so one of the metric is lying. Because we're at 70%, I believe we bypass the writeback
>   completely because we reach CUTOFF_WRITEBACK_SYNC [1].
> 
> * As a result, on an I/O intensive throughput server, we have high I/O latency (=~ 1 sec) for both the cache device
>   and the backing device (although I don't explain why we have this latency on the cache device as well. The graphs
>   of both devices are pretty much aligned).
> 
> * when the GC is triggered (manually or automatically), the writeback is restored for a short period of
>   time (10-15 minutes) and the I/O latency drops. Until we reach the 70% of dirty data mark again
> 
> * we seems to have this discrepancy of metric everywhere but because the default writeback_percent is at 10%, we
>   never really reach the 70% threshold as displayed in priority_stats
> 
> Again sorry if this was the wrong forum.
> 
> Regards,
> 
> [0]: https://bugzilla.kernel.org/show_bug.cgi?id=206767
> [1]: https://github.com/torvalds/linux/blob/v4.15/drivers/md/bcache/writeback.h line 69
> 

Hi Benjamin,

I see the kernel is 4.15 stable without bcache backport, am I right ?
There are quite a lot of things fixed in later kernel releases. And I
suggest to use Linux kernel after v5.3 (and v5.5 is better), which I
feel most of obvious issues are fixed.

Could you please to try Linux v5.5 and see whether things get better ?

Thanks.
-- 

Coly Li
