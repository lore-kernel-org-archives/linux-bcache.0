From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH v2] bcache: explicitly destroy mutex while exiting
Date: Mon, 30 Oct 2017 11:02:27 -0700
Message-ID: <a8c68129-9b7f-66c0-d7ee-ea56b236a933@lyle.org>
References: <20171010090049.6596-1-liangchen.linux@gmail.com>
 <01f432e8-950a-fc9f-150d-0b51fa9e7559@coly.li>
 <c06f2a04-3654-0bb9-f07d-ee6d2b27868d@lyle.org>
 <CAKhg4tKcO-DEjnhS6tasSrXd9TwuLaOxgYdPEo9FbgLpBH8ZBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:50376 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751167AbdJ3SCa (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 30 Oct 2017 14:02:30 -0400
Received: by mail-pg0-f41.google.com with SMTP id y5so12294645pgq.7
        for <linux-bcache@vger.kernel.org>; Mon, 30 Oct 2017 11:02:29 -0700 (PDT)
In-Reply-To: <CAKhg4tKcO-DEjnhS6tasSrXd9TwuLaOxgYdPEo9FbgLpBH8ZBA@mail.gmail.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Liang C <liangchen.linux@gmail.com>
Cc: Coly Li <i@coly.li>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Liang--

On 10/30/2017 05:33 AM, Liang C wrote:
> Hi Michael,
> Would you please to include this patch in your tree for the next
> release? It seems passed the review. Thank you.
> 
> Thanks,
> Liang

Thanks for the reminder.

It's in my bcache-for-next tree at https://github.com/mlyle/linux/ along
with a few other small changes.  I am testing today and plan on sending
them up to Jens soon if I have good luck overall (and after reading
overall diff).

Though: it is getting late for non-critical changes in 4.15 so I need to
have perfect test sequences with no unexplained anomalies to send these
to Jens for 4.15.

Mike

> 
> On Tue, Oct 10, 2017 at 11:44 PM, Michael Lyle <mlyle@lyle.org> wrote:
>> On 10/10/2017 05:25 AM, Coly Li wrote:
>>> On 2017/10/10 下午5:00, Liang Chen wrote:
>>>> mutex_destroy does nothing most of time, but it's better to call
>>>> it to make the code future proof and it also has some meaning
>>>> for like mutex debug.
>>>>
>>>> As Coly pointed out in a previous review, bcache_exit() may not be
>>>> able to handle all the references properly if userspace registers
>>>> cache and backing devices right before bch_debug_init runs and
>>>> bch_debug_init failes later. So not exposing userspace interface
>>>> until everything is ready to avoid that issue.
>>>>
>>>> Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
>>>
>>> Hi Liang,
>>>
>>> No more comment from me, it looks good. Thanks.
>>>
>>> Reviewed-by: Coly Li <colyli@suse.de>
>>
>> Looks good to me too.
>>
>> Reviewed-by: Michael Lyle <mlyle@lyle.org>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
