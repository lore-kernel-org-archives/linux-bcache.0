From: Coly Li <colyli@suse.de>
Subject: Re: [for-416 PATCH 3/3] bcache: allow quick writeback when backing
 idle
Date: Thu, 4 Jan 2018 00:54:28 +0800
Message-ID: <42e6fd64-1ab3-3b4d-4dfe-70a76152d9d2@suse.de>
References: <1514883236-11844-1-git-send-email-tang.junhui@zte.com.cn>
 <0fdcfaaf-af7a-adb8-075d-b321b9df4ef7@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <0fdcfaaf-af7a-adb8-075d-b321b9df4ef7@lyle.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>, tang.junhui@zte.com.cn
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 03/01/2018 12:23 AM, Michael Lyle wrote:
> On 01/02/2018 12:53 AM, tang.junhui@zte.com.cn wrote:
>> If no front-end I/O coming, would this cause write-back IOs one by one
>> (one write-back IO issued must after the completion of the previous IO)?
>> though with zero delay time, is the write-back performance still good?
> 

Hi Mike,

> Yes-- this speeds up writeback during idle from 4k/sec to about 10MB/sec
> on my slow 5400RPM disk.  (It writes back at about 20MB/sec with deep
> queues in the same scenario).  So in this case it's about 2500x faster
> than current idle writeback, but half as fast as writeback with full
> device utilization.
> 

Nice performance data!


> With only one I/O outstanding at a time, if front-end I/O starts latency
> for the first request is still good.

It is good idea, I like it.

Acked-by: Coly Li <colyli@suse.de>

Thanks for the effort :-)

Coly Li
