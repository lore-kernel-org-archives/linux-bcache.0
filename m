From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH v2 06/12] bcache: set error_limit correctly
Date: Wed, 17 Jan 2018 23:11:46 +0800
Message-ID: <71a93b12-fa5f-dcdf-951b-fa9c4c65486c@suse.de>
References: <1516169355-3057-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48131 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750908AbeAQPMB (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 17 Jan 2018 10:12:01 -0500
In-Reply-To: <1516169355-3057-1-git-send-email-tang.junhui@zte.com.cn>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: mlyle@lyle.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

On 17/01/2018 2:09 PM, tang.junhui@zte.com.cn wrote:
> From: Tang Junhui <tang.junhui@zte.com.cn>
> 
> Hello Coly:
> 
> Then in bch_count_io_errors(), why did us still keep these code:
>> 92             unsigned errors = atomic_add_return(1 << IO_ERROR_SHIFT,
>> 93                                                 &ca->io_errors);
>> 94             errors >>= IO_ERROR_SHIFT;
> 
> why not just modify the code as bellow:
>> 92             unsigned errors = atomic_add_return(1,
>> 93                                                 &ca->io_errors);
> 
> 

Hi Junhui,

It is because of ca->set->error_decay. When error_decay is set, bcache
tries to do an exponential decay for error count. That is, error numbers
is decaying against the quantity of io count, this is to avoid long time
accumulated errors exceeds error_limit and trigger bch_cache_set_error().

The I/O error counter, uses most significant 12 bits to record real
errors number. And too many I/Os may decay the errors number too fast,
so left shit it by 20 bits to make sure there are still enough errors
number after a while (e.g. the halflife).

The we don't use the left shifting, when error_deay is set, and too many
I/Os happen, after a small piece of time, number of I/O errors will be
decayed too fast to reach error_limit. Therefore IMHO the left shifting
is necessary.

BTW, I doubt whether current exponential error decay in
bch_count_io_errors() works properly. Because I don't catch the
connection between IO counter (ca->io_count) and error counter
(ca->io_errors). By default ca->set->error_decay is 0, so I doubt how
many people use/test this piece of code. (Maybe I am wrong)


Coly Li

[code snipped]
