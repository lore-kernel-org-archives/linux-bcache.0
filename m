From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 0/2] bcache patches for Linux v5.7-rc5
Date: Tue, 5 May 2020 10:43:24 +0800
Message-ID: <92a2e38a-5b08-fc3a-48f9-25c75384e4f6@suse.de>
References: <20200504153529.2242-1-colyli@suse.de>
 <ade380f2-e124-9e64-572a-3299bebcd658@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43166 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726516AbgEECna (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 4 May 2020 22:43:30 -0400
In-Reply-To: <ade380f2-e124-9e64-572a-3299bebcd658@kernel.dk>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

On 2020/5/4 23:52, Jens Axboe wrote:
> On 5/4/20 9:35 AM, Coly Li wrote:
>> Hi Jens,
>>
>> These two patches are in my testing directory for weeks and it is
>> about time to submit them for Linux v5.7-rc5.
>>
>> The first one from Colin helps to remove unncessary local variables.
>> And Joe contributes second patch to improve the kernel message format
>> by remove extra '\n' from existing pr_format() and adds the '\n' to
>> the location of printing kernel messages. 
>>
>> Please them for v5.7.
> 
> Why not 5.8? Doesn't look critical, nor something that was introduced
> in this series. More like cleanups, hence should go into 5.8 instead.
> 

Sure, of cause. They will go with 5.8 series.

Thanks.

Coly Li
