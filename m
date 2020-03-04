From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
Date: Wed, 4 Mar 2020 11:42:39 -0700
Message-ID: <239a316b-3c43-019a-bef0-409110284789@kernel.dk>
References: <20200302093450.48016-1-colyli@suse.de>
 <20200302093450.48016-2-colyli@suse.de>
 <20200302122748.GH4380@dhcp22.suse.cz> <20200302134919.GB9769@redhat.com>
 <20200303080544.GW4380@dhcp22.suse.cz> <20200303121918.GA27520@redhat.com>
 <20200303160307.GI4380@dhcp22.suse.cz> <20200304113613.GA13170@redhat.com>
 <20200304115330.GB13170@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200304115330.GB13170@redhat.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>, Michal Hocko <mhocko@kernel.org>
Cc: Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, hare@suse.de, mkoutny@suse.com
List-Id: linux-bcache@vger.kernel.org

On 3/4/20 4:53 AM, Oleg Nesterov wrote:
> On 03/04, Oleg Nesterov wrote:
>>
>> arch/arm/common/bL_switcher.c:bL_switcher_thread(). Why does it do
>> flush_signals() ? signal_pending() must not be possible. It seems that
>> people think that wait_event_interruptible() or even schedule() in
>> TASK_INTERRUPTIBLE state can lead to a pending signal but this is not
>> true. Of course, I could miss allow_signal() in bL_switch_to() paths...
> 
> Jens, could you explain flush_signals() in io_sq_thread() ?

I actually don't think that one is needed - the only one that io_uring
needs, and which is valid, is flushing signals for the io-wq worker as
we use that for cancelation.

In any case, both are kthreads.

-- 
Jens Axboe
