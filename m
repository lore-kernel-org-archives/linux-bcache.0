From: Coly Li <colyli@suse.de>
Subject: Re: Bcache status and queue
Date: Wed, 31 Jan 2018 17:34:57 +0800
Message-ID: <32dadac0-ab64-4043-4bce-de7647878f5f@suse.de>
References: <1517388034-32331-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57621 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752611AbeAaJfJ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 31 Jan 2018 04:35:09 -0500
In-Reply-To: <1517388034-32331-1-git-send-email-tang.junhui@zte.com.cn>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn, mlyle@lyle.org
Cc: linux-bcache@vger.kernel.org

On 31/01/2018 4:40 PM, tang.junhui@zte.com.cn wrote:
> From: Tang Junhui <tang.junhui@zte.com.cn>
> 
> 
> Hello Mike,
> 
> 
>> I hope these patches can be reviwed and inclued in
>> 4.16, since they are bugs to me.
>> [PATCH] bcache: fix error return value in memory shrink
>> [PATCH] bcache: fix error count in memory shrink
>> [PATCH 2/2] bcache: fix high CPU occupancy during journal
>> [PATCH 1/2] bcache: add journal statistic
>> [PATCH] [PATCH v2] bcache: fix for allocator and register thread race
>> [PATCH v4 09/13] bcache: fix inaccurate io state for detached bcache devices
>>
>> I hope bellow patch can be reviewd, since I need it very much:
>> [PATCH] bcache: finish incremental GC
>>
>> And Coly's patches is also important, but thanks to Hannes,
>> most of them have been already well reviewed.
> 
> Sorry, since 4.16 will release soon, I have no urgent patch.
> I hope above patch can be reviwed and inclued in the 4.17.

Me too. I am targeting bcache device failure handling patch set to Linux
v4.17. I will post v5 patch within this week.

Thanks you all.

Coly Li
