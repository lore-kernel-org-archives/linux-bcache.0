From: Coly Li <i@coly.li>
Subject: Re: [PATCH] bcache: smooth writeback rate control
Date: Thu, 21 Sep 2017 21:20:49 +0200
Message-ID: <57de6158-01ac-f41f-f08a-610c079c00a9@coly.li>
References: <20170920071517.30505-1-mlyle@lyle.org>
 <8a4425d9-2b86-e7d0-f332-3a7ad6b3f706@coly.li>
 <CAJ+L6qcZVE0hkiN0xe00fFt4ndmha+uOi9x4UpO-7DRD=vh_mQ@mail.gmail.com>
 <CAJ+L6qdoZKtnrVZSjC_HC00sHs=vCLa-TrJ6qEqjjaxn8BUjXg@mail.gmail.com>
 <73bf31e7-894a-9f7c-df16-3a757553058c@suse.de>
 <CAJ+L6qfBDwbQ=3JmZ1GmjbRnAW-ZNVYUc+nBx1ssLcV9ieSN9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:36560 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751666AbdIUTU5 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 21 Sep 2017 15:20:57 -0400
In-Reply-To: <CAJ+L6qfBDwbQ=3JmZ1GmjbRnAW-ZNVYUc+nBx1ssLcV9ieSN9w@mail.gmail.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>

On 2017/9/20 下午11:50, Michael Lyle wrote:
> On Wed, Sep 20, 2017 at 2:07 PM, Coly Li <colyli@suse.de> wrote:
>> I get your point here. Current code sets minimum writeback rate to 1
>> sector, and indeed it writes 4K. But parameter "done" sent to
>> bch_next_delay() is 1 sector, indeed the correct value should be 8 sectors.
> 
> Not quite.  The value sent to bch_next_delay is 8 sectors.  So then
> the code wants to sleep 8 seconds, but it is only willing to sleep at
> most one second.  In other words, when rate is low, the controller
> becomes ineffective and does one write of any size no matter what.
> This keeps the controller effective at low target rates-- if it does a
> minimally-sized write, it will sleep one second like before-- if it
> writes more, it will sleep longer.
> 

Hi Mike,

Got it. Now I understand why you set dc->writeback_rate_minimum	to 8,
it's reasonable and thoughtful. I agree with you. Thanks for your patent
explaining.

>> [snip]
>> I see. This is a situation I missed in my environment. On my desktop
>> machine they are all SSD. My testing server is too noisy and overwhelm
>> groan of my hard disks. Thanks for your information :-)
>>
>> I have one more question for this line "When writing back faster, they
>> are quieter.  This will at least do it 2.5x less often."
>>
>> Current bcache code indeed writes back 4K per-second at minimum
>> writeback rate if I understand correctly. Your patch makes the minimum
>> writeback rate to 4K every 2.5 seconds, it makes writing back slower not
>> faster. Do I miss something here ?
> 
> It is still doing the bad thing, but only 40% of the bad thing and
> hopefully will wear out the disk slower.  I want to make further
> changes to do it even less (and let disks spin down).
> 
> The value of 2.5 seconds is chosen because it is half the speed that
> we recalculate the target rate, by default.  If the rate increases, we
> won't be sleeping too long before we start writing faster.  (i.e. our
> typical reaction time is now 5 + 2.5/2 = 6.25 seconds, instead of 5 +
> 1/2 = 5.5 seconds)
> 

OK I see. So the interval for idle time writeback will be longer, but
not too long. Interesting, you want it longer, I want it shorter :-)
Don't worry I will solve the conflict from my side.


>>> In a subsequent patch, there's additional things I'd like to do-- like
>>> be willing to do no write after a wakeup if we are very far ahead.
>>> That is, to allow the effective value to be much larger than 2.5
>>> seconds.  This would potentially allow spindown on laptops, etc.  But
>>> this change is still worthwhile on its own.
>>>
>>
>> OK, looking forward to the subsequent patch :-)
> 
> This one is a first step just because it's very simple and
> self-contained.  The next step on this path is a bit more difficult,
> because it requires rewriting bch_next_delay to store the reciprocal
> of what it currently does and bounding both the amount it can be
> ahead, and the sleep interval.
> 

Then please make this patch as simple/understandable as possible. Bcache
is not deserved for a very complicated delay calculation policy. If you
remember the discussions years ago for memory readahead and writeback,
you may find always simple things win.

>>> Another thing that would be helpful would be to issue more than 1
>>> write at a time, so that queue depth doesn't always equal 1.  Queue
>>> depth=4 has about 40-50% more throughput--- that is, it completes the
>>> 4 IOPs in about 2.5x the time of one-- when writes are clustered to
>>> the same region of the disk/short-stroked.  However this has a
>>> potential cost in latency, so it needs to be carefully traded off.
>>>
>>
>> It makes sense. But "dc->writeback_rate_minimum = 8" is one 4KB I/O,
>> then your patch is to make minimum I/O slower x2.5 times, does not
>> change I/O size. So this patch just makes writeback I/O less frequently,
>> not increase number of I/Os for each writeback ?
> 
> If writeback is doing minimum-sized I/Os with a minimum target rate,
> they will happen at the same rate as before.  If what it finds from
> the dirty keybuf is a bigger-than-minimum sized I/O, it will sleep
> longer.  e.g. if it finds a contiguous 8k block, it will now sleep 2
> seconds (and will achieve the target 4k/second as a result).  if it
> finds a contiguous >=10k block, it will sleep the maximum 2.5 seconds.
> This keeps the controller doing something meaningful even when stuff
> being written is larger than the target amount written in one second.
> 
> Note that it has an effect even when the rate is above the minimum.
> If we're trying to write 1MB/second, and we find a 1.5MB continguous
> block to write, we'll wait 1.5 seconds.

It is clear to me. It's a good discussion, make things more clear and
understandable for me and other people.

Could you please add some important information from our discussion to
your patch commit log ? I do appreciate for this, then more people will
get to know how and why you design a P.I controller in this way, this is
valuable.

Now I know the patch is good, and have no comment for it. Thank you for
your informative response.

-- 
Coly Li
