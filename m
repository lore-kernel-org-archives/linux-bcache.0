From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 14/17] bcache: back to cache all readahead I/Os
Date: Thu, 23 Jan 2020 11:31:47 -0700
Message-ID: <31f7f6b4-98ea-3cf6-44cc-a9ba67484eb0@kernel.dk>
References: <20200123170142.98974-1-colyli@suse.de>
 <20200123170142.98974-15-colyli@suse.de>
 <CAJ+L6qckUd+Kw8_jKov0dNnSiGxxvXSgc=2dPai+1ANaEdfWPQ@mail.gmail.com>
 <efdfdd2b-b22e-42d1-c642-6c398db6864c@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46918 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727194AbgAWSbu (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 23 Jan 2020 13:31:50 -0500
Received: by mail-pf1-f195.google.com with SMTP id n9so1907342pff.13
        for <linux-bcache@vger.kernel.org>; Thu, 23 Jan 2020 10:31:50 -0800 (PST)
In-Reply-To: <efdfdd2b-b22e-42d1-c642-6c398db6864c@suse.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>, Michael Lyle <mlyle@lyle.org>
Cc: linux-bcache <linux-bcache@vger.kernel.org>, linux-block@vger.kernel.org, stable <stable@vger.kernel.org>

On 1/23/20 10:27 AM, Coly Li wrote:
> On 2020/1/24 1:19 上午, Michael Lyle wrote:
>> Hi Coly and Jens--
>>
>> One concern I have with this is that it's going to wear out
>> limited-lifetime SSDs a -lot- faster.  Was any thought given to making
>> this a tunable instead of just changing the behavior?  Even if we have
>> an anecdote or two that it seems to have increased performance for
>> some workloads, I don't expect it will have increased performance in
>> general and it may even be costly for some workloads (it all comes
>> down to what is more useful in the cache-- somewhat-recently readahead
>> data, or the data that it is displacing).
> 
> Hi Mike,
> 
> Copied. This is good suggestion, I will do it after I back from Lunar
> New Year vacation, and submit it with other tested patches in following
> v5.6-rc versions.

Do you want me to just drop this patch for now from the series?

-- 
Jens Axboe
