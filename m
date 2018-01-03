From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: fix unmatched generic_end_io_acct() &
 generic_start_io_acct()
Date: Wed, 3 Jan 2018 15:21:21 +0800
Message-ID: <545409e2-4917-4a4f-c6a9-ba3c391f7360@suse.de>
References: <20180103043937.28235-1-kxuanobj@gmail.com>
 <58e10ebe-0a40-c866-94d7-50cd7a6872ea@suse.de>
 <567f7731-915b-d654-4838-41c7872e651a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55534 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751202AbeACHVf (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 3 Jan 2018 02:21:35 -0500
In-Reply-To: <567f7731-915b-d654-4838-41c7872e651a@gmail.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Zhaoxuan <kxuanobj@gmail.com>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Cc: tang.junhui@zte.com.cn, Michael Lyle <mlyle@lyle.org>

On 03/01/2018 3:05 PM, Zhaoxuan wrote:
> 
> On 03/01/2018 13:45 PM, Coly Li wrote:
>> On 03/01/2018 12:39 PM, Zhai Zhaoxuan wrote:
>>> The function cached_dev_make_request() and flash_dev_make_request() call
>>> generic_start_io_acct() with (struct bcache_device)->disk when they
>>> start a
>>> closure. Then the function bio_complete() calls generic_end_io_acct()
>>> with
>>> (struct search)->orig_bio->bi_disk when the closure has done.
>>> Since the `bi_disk` is not the bcache device, the
>>> generic_end_io_acct() is
>>> called with a wrong device queue.
>>>
>>> It causes the "inflight" (in struct hd_struct) counter keep increasing
>>> without decreasing.
>>>
>>> This patch fix the problem by calling generic_end_io_acct() with
>>> (struct bcache_device)->disk.
>>>
>>> Signed-off-by: Zhai Zhaoxuan <kxuanobj@gmail.com>
>> Hi Zhaoxuan,
>>
>> Nice catch, it makes sense. Thanks.
>>
>> Reviewed-by: Coly Li <colyli@suse.de>
>>
>> One more question, do you experience any problem when inflight counter
>> increases only ? I just wondering.
> 
> Hi Coly,
> 
> Thanks for your review.
> 
> There is a problem in `iostat -x`. `iostat` shows the bcache device keep
> 100.00%
> busy (100.00 in the "%util" column), even if the bcache is idle.
> 
> [root@base ~]# iostat -x -d 1
> Linux 4.15.0-rc6-ARCH (base)    01/03/18        _x86_64_        (2 CPU)
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
> avgrq-sz avgqu-sz   await r_await w_await  svctm %util
> vda               7.85     1.07   69.98   13.20  1818.60   158.20
> 47.54     0.04    1.08    0.67    3.28   0.30 2.47
> vdb               0.00     0.00    2.61    0.00    75.80     0.00
> 58.09     0.00    0.75    0.75    0.00   0.00 0.00
> bcache0           0.00     0.00    1.98    0.00    52.00     0.00
> 52.64    77.73    1.06    1.06    0.00 485.93 96.00
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
> avgrq-sz avgqu-sz   await r_await w_await  svctm %util
> vda               0.00     0.00    0.00    0.00     0.00 0.00    
> 0.00     0.00    0.00    0.00    0.00   0.00 0.00
> vdb               0.00     0.00    0.00    0.00     0.00 0.00    
> 0.00     0.00    0.00    0.00    0.00   0.00 0.00
> bcache0           0.00     0.00    0.00    0.00     0.00 0.00    
> 0.00    81.00    0.00    0.00    0.00   0.00 100.00
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
> avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> vda               0.00     9.00    0.00    2.00     0.00    44.00
> 44.00     0.00   10.00    0.00   10.00   0.00   0.00
> vdb               0.00     0.00    0.00    0.00     0.00 0.00    
> 0.00     0.00    0.00    0.00    0.00   0.00   0.00
> bcache0           0.00     0.00    0.00    0.00     0.00 0.00    
> 0.00    81.00    0.00    0.00    0.00   0.00 100.00
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
> avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> vda               0.00     0.00    0.00    0.00     0.00 0.00    
> 0.00     0.00    0.00    0.00    0.00   0.00   0.00
> vdb               0.00     0.00    0.00    0.00     0.00 0.00    
> 0.00     0.00    0.00    0.00    0.00   0.00   0.00
> bcache0           0.00     0.00    0.00    0.00     0.00 0.00    
> 0.00    81.00    0.00    0.00    0.00   0.00 100.00
> 
> ^C
> [root@base ~]# bcache-super-show /dev/vdb
> sb.magic                ok
> sb.first_sector         8 [match]
> sb.csum                 54824DA53D2DC101 [match]
> sb.version              1 [backing device]
> 
> dev.label               (empty)
> dev.uuid                c5e43e66-4b28-48d7-bd46-73fb6e1efdbb
> dev.sectors_per_block   1
> dev.sectors_per_bucket  1024
> dev.data.first_sector   16
> dev.data.cache_mode     0 [writethrough]
> dev.data.cache_state    1 [clean]
> 
> cset.uuid               a79f8422-ed64-4b92-8688-692f48cd6d97
> [root@base ~]# bcache-super-show /dev/vda2
> sb.magic                ok
> sb.first_sector         8 [match]
> sb.csum                 EF7AB1A8928862E6 [match]
> sb.version              3 [cache device]
> 
> dev.label               (empty)
> dev.uuid                5762b745-77f8-4831-81ce-9ee7866b8d84
> dev.sectors_per_block   1
> dev.sectors_per_bucket  1024
> dev.cache.first_sector  1024
> dev.cache.cache_sectors 2096128
> dev.cache.total_sectors 2097152
> dev.cache.ordered       yes
> dev.cache.discard       no
> dev.cache.pos           0
> dev.cache.replacement   0 [lru]
> 
> cset.uuid               a79f8422-ed64-4b92-8688-692f48cd6d97
> 

Hi Zhaoxuan,

Cool, this is an already reported issue but I still have no idea how to
fix it yet... Thank you for the fix and the above detailed information!

Coly Li
