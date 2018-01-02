From: tang.junhui@zte.com.cn
Subject: Re: Re: Re: [for-416 PATCH 3/3] bcache: allow quick writeback when backingidle
Date: Tue, 2 Jan 2018 22:34:58 +0800
Message-ID: <1514903698-19103-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from out1.zte.com.cn ([202.103.147.172]:51210 "EHLO mxct.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750748AbeACCsT (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 2 Jan 2018 21:48:19 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: mlyle@lyle.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn

From: Tang Junhui <tang.junhui@zte.com.cn>


>On 01/02/2018 12:53 AM, tang.junhui@zte.com.cn wrote:
>> If no front-end I/O coming, would this cause write-back IOs one by one
>> (one write-back IO issued must after the completion of the previous IO)?
>> though with zero delay time, is the write-back performance still good?
>
>Yes-- this speeds up writeback during idle from 4k/sec to about 10MB/sec
>on my slow 5400RPM disk.  (It writes back at about 20MB/sec with deep
>queues in the same scenario).  So in this case it's about 2500x faster
>than current idle writeback, but half as fast as writeback with full
>device utilization.
>
>With only one I/O outstanding at a time, if front-end I/O starts latency
>for the first request is still good.
>

OK, LGTM.

Reviewed-by: Tang Junhui <tang.junhui@zte.com.cn>

Thanks,
Tang Junhui
