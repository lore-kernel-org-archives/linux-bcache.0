From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
Date: Mon, 2 Mar 2020 10:19:48 -0700
Message-ID: <dfcd5b4d-592d-fe2a-5c25-ac22729b479e@kernel.dk>
References: <20200302093450.48016-1-colyli@suse.de>
 <20200302093450.48016-2-colyli@suse.de>
 <20200302122748.GH4380@dhcp22.suse.cz> <20200302134919.GB9769@redhat.com>
 <48c6480a-3b26-fb7f-034d-923f9b8875f1@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <48c6480a-3b26-fb7f-034d-923f9b8875f1@suse.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, Oleg Nesterov <oleg@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, hare@suse.de, mkoutny@suse.com
List-Id: linux-bcache@vger.kernel.org

On 3/2/20 10:16 AM, Coly Li wrote:
> On 2020/3/2 9:49 下午, Oleg Nesterov wrote:
>> On 03/02, Michal Hocko wrote:
>>>
>>> I cannot really comment on the bcache part because I am not familiar
>>> with the code.
>>
>> same here...
>>
>>>> This patch calls flush_signals() in bcache_device_init() if there is
>>>> pending signal for current process. It avoids bcache registration
>>>> failure in system boot up time due to bcache udev rule timeout.
>>>
>>> this sounds like a wrong way to address the issue. Killing the udev
>>> worker is a userspace policy and the kernel shouldn't simply ignore it.
>>
>> Agreed. If nothing else, if a userspace process has pending SIKILL then
>> flush_signals() is very wrong.
>>
>>> Btw. Oleg, I have noticed quite a lot of flush_signals usage in the
>>> drivers land and I have really hard time to understand their purpose.
>>
>> Heh. I bet most if not all users of flush_signals() are simply wrong.
>>
>>> What is the actual valid usage of this function?
>>
>> I thinks it should die... It was used by kthreads, but today
>> signal_pending() == T is only possible if kthread does allow_signal(),
>> and in this case it should probably use kernel_dequeue_signal().
>>
>>
>> Say, io_sq_thread(). Why does it do
>>
>> 		if (signal_pending(current))
>> 			flush_signals(current);
>>
>> afaics this kthread doesn't use allow_signal/allow_kernel_signal, this
>> means that signal_pending() must be impossible even if this kthread sleeps
>> in TASK_INTERRUPTIBLE state. Add Jens.
> 
> Hi Oleg,
> 
> Can I use disallow_signal() before the registration begins and use
> allow_signal() after the registration done. Is this a proper way to
> ignore the signal sent by udevd for timeout ?
> 
> For me the above method seems to solve my problem too.

Really seems to me like you're going about this all wrong. The issue is
that systemd is killing the startup, because it's taking too long. Don't
try and work around that, ensure the timeout is appropriate.

What if someone else tried to kill the startup? It'd be pretty
frustrating that it was impossible, just because signals were blocked or
flushed. The assumption that systemd is the ONLY task that would want to
kill it is flawed.

-- 
Jens Axboe
