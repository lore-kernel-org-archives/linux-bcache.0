From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
Date: Mon, 2 Mar 2020 13:33:19 -0700
Message-ID: <64c2a8e9-1dc9-f81d-1c11-d9c4e7e0fd2b@kernel.dk>
References: <20200302093450.48016-1-colyli@suse.de>
 <20200302093450.48016-2-colyli@suse.de>
 <20200302122748.GH4380@dhcp22.suse.cz> <20200302134919.GB9769@redhat.com>
 <48c6480a-3b26-fb7f-034d-923f9b8875f1@suse.de>
 <dfcd5b4d-592d-fe2a-5c25-ac22729b479e@kernel.dk>
 <2e4898f0-0c2b-9320-b925-456a85ebdea0@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-io1-f66.google.com ([209.85.166.66]:35528 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbgCBUdV (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 2 Mar 2020 15:33:21 -0500
Received: by mail-io1-f66.google.com with SMTP id h8so957918iob.2
        for <linux-bcache@vger.kernel.org>; Mon, 02 Mar 2020 12:33:21 -0800 (PST)
In-Reply-To: <2e4898f0-0c2b-9320-b925-456a85ebdea0@suse.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: Oleg Nesterov <oleg@redhat.com>, Michal Hocko <mhocko@kernel.org>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, hare@suse.de, mkoutny@suse.com

On 3/2/20 10:32 AM, Coly Li wrote:
> On 2020/3/3 1:19 上午, Jens Axboe wrote:
>> On 3/2/20 10:16 AM, Coly Li wrote:
>>> On 2020/3/2 9:49 下午, Oleg Nesterov wrote:
>>>> On 03/02, Michal Hocko wrote:
>>>>>
>>>>> I cannot really comment on the bcache part because I am not familiar
>>>>> with the code.
>>>>
>>>> same here...
>>>>
>>>>>> This patch calls flush_signals() in bcache_device_init() if there is
>>>>>> pending signal for current process. It avoids bcache registration
>>>>>> failure in system boot up time due to bcache udev rule timeout.
>>>>>
>>>>> this sounds like a wrong way to address the issue. Killing the udev
>>>>> worker is a userspace policy and the kernel shouldn't simply ignore it.
>>>>
>>>> Agreed. If nothing else, if a userspace process has pending SIKILL then
>>>> flush_signals() is very wrong.
>>>>
>>>>> Btw. Oleg, I have noticed quite a lot of flush_signals usage in the
>>>>> drivers land and I have really hard time to understand their purpose.
>>>>
>>>> Heh. I bet most if not all users of flush_signals() are simply wrong.
>>>>
>>>>> What is the actual valid usage of this function?
>>>>
>>>> I thinks it should die... It was used by kthreads, but today
>>>> signal_pending() == T is only possible if kthread does allow_signal(),
>>>> and in this case it should probably use kernel_dequeue_signal().
>>>>
>>>>
>>>> Say, io_sq_thread(). Why does it do
>>>>
>>>> 		if (signal_pending(current))
>>>> 			flush_signals(current);
>>>>
>>>> afaics this kthread doesn't use allow_signal/allow_kernel_signal, this
>>>> means that signal_pending() must be impossible even if this kthread sleeps
>>>> in TASK_INTERRUPTIBLE state. Add Jens.
>>>
>>> Hi Oleg,
>>>
>>> Can I use disallow_signal() before the registration begins and use
>>> allow_signal() after the registration done. Is this a proper way to
>>> ignore the signal sent by udevd for timeout ?
>>>
>>> For me the above method seems to solve my problem too.
>>
>> Really seems to me like you're going about this all wrong. The issue is
>> that systemd is killing the startup, because it's taking too long. Don't
>> try and work around that, ensure the timeout is appropriate.
>>
> 
> Copied. Then let me try how to make event_timeout works on my udevd. If
> it works without other side effect, I will revert existing
> flush_signals() patches.

Thanks, this one, right?

commit 0b96da639a4874311e9b5156405f69ef9fc3bef8
Author: Coly Li <colyli@suse.de>
Date:   Thu Feb 13 22:12:05 2020 +0800

    bcache: ignore pending signals when creating gc and allocator thread

because that definitely needs to be reverted.

-- 
Jens Axboe
