From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH] bcache: recover data from backing device when read
 request hit clean
Date: Tue, 21 Nov 2017 21:13:52 -0800
Message-ID: <8cb4231f-9b0d-3cb3-d733-b868f37daa6d@lyle.org>
References: <CAPGwLLNwG+kLT9_QaCL5PBLS0a6K-x-iog+ON2pArUQWr1rWTg@mail.gmail.com>
 <1c715cc2-b656-36a8-4017-55052937df82@lyle.org>
 <CAPGwLLNyjjxKOXA3RCFGSi4p-ZWZ5T9ADWP6EAqrfL3oUvMbFQ@mail.gmail.com>
 <CAJ+L6qen=5AVFr_q_r_F6jU8BTQ=t+7p94ucFW9HXEDD6AGEKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:40432 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751079AbdKVFNz (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 22 Nov 2017 00:13:55 -0500
Received: by mail-pg0-f66.google.com with SMTP id u3so12017111pgn.7
        for <linux-bcache@vger.kernel.org>; Tue, 21 Nov 2017 21:13:55 -0800 (PST)
In-Reply-To: <CAJ+L6qen=5AVFr_q_r_F6jU8BTQ=t+7p94ucFW9HXEDD6AGEKg@mail.gmail.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Rui Hua <huarui.dev@gmail.com>
Cc: Coly Li <i@coly.li>, Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache <linux-bcache@vger.kernel.org>, linux-block@vger.kernel.org

Reviewed-by: Michael Lyle <mlyle@lyle.org>

Please note though, that your patches have all tabs expanded to spaces,
which makes them difficult to apply.  I have fixed things these times
but please try to submit them in correct form in the future.

Thanks,

Mike

On 11/17/2017 04:57 PM, Michael Lyle wrote:
> Rui Hua--
> 
> Thanks for the clarification.  You're correct, it doesn't get called,
> and it goes to read_complete.  However, read_error should probably get
> called.  How would you suggest handling this-- should we initially set
> read_dirty_data true and clear it if it is all clean?  (and change the
> condition to properly go into the error path).  As it is, the patch
> makes things no worse but the error path is very unsafe.
> 
> Mike
> 
> On Thu, Nov 16, 2017 at 8:25 PM, Rui Hua <huarui.dev@gmail.com> wrote:
>> Hi, Michael--
>>
>> Thanks for the quickly reply.
>>
>> If the metadata on the cache device was NOT correctly read,
>> cached_dev_read_error() will not be called, so the recovery check will
>> not be executed. so this patch is safe.
>> s->iop.error was not set when faild to read metadata on the cache
>> device, so the  cached_dev_bio_complete() will be called instead of
>> cached_dev_read_error()
>>
>> 2017-11-17 12:02 GMT+08:00 Michael Lyle <mlyle@lyle.org>:
>>> Hi, Rui Hua--
>>>
>>> On 11/16/2017 07:51 PM, Rui Hua wrote:
>>>> In this patch, we use s->read_dirty_data to judge whether the read
>>>> request hit dirty data in cache device, it is safe to reread data from
>>>> the backing device when the read request hit clean data. This can not
>>>> only handle cache read race, but also recover data when failed read
>>>> request from cache device.
>>>
>>> I haven't read over all of this yet, to understand the read race.  But
>>> this change can't be safe-- read_dirty_data only is set to true if the
>>> metadata on the cache device is correctly read.  If that fails, the flag
>>> may not be set and we could read stale data on the backing device.
>>>
>>> Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
