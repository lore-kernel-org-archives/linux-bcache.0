From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: bcache strange behaviour in write back mode
Date: Wed, 24 Apr 2013 08:56:26 +0200
Message-ID: <5177821A.3010004@profitbricks.com>
References: <51758C42.4040708@profitbricks.com> <CAC7rs0u=epPv0c_swBSifi_fDRC0k9WpZ+34OmFdgxjR3-8WcA@mail.gmail.com> <51759D17.5040204@profitbricks.com> <20130422215138.GA9931@google.com> <517676E7.4030805@profitbricks.com> <CAH+dOxL9Ajsp7fruw-9nC63rJLzOqBYreeE1URxF945-pv6vug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH+dOxL9Ajsp7fruw-9nC63rJLzOqBYreeE1URxF945-pv6vug-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 04/23/2013 08:40 PM, Kent Overstreet wrote:
> Well _that_ interesting, the implication is that garbage collection is
> getting stuck somehow and unable to finish.
> 
> I'll probably have another debug patch for you later today.

Hi Kent,

Any possible patch, please don't hesitate to send to me , I can help to
test and hope we can fix that finally.

Regards,
Jack
> 
> On Tue, Apr 23, 2013 at 4:56 AM, Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org> wrote:
>> Hi Kent,
>>
>> After some test, we saw log in dmesg like below:
>>
>>
>>
>> [ 1505.282400] bcache: bch_allocator_thread() bcache: invalidating
>> buckets: free_inc 0/127
>> [ 1505.285843] bcache: bch_allocator_thread() bcache: not writing prios:
>> free_inc 0/127
>> [ 1508.005957] bcache: bch_allocator_thread() bcache: invalidating
>> buckets: free_inc 0/127
>> [ 1508.009357] bcache: bch_allocator_thread() bcache: not writing prios:
>> free_inc 0/127
>> [ 1512.493609] bcache: bch_allocator_thread() bcache: invalidating
>> buckets: free_inc 0/127
>> [ 1512.497070] bcache: bch_allocator_thread() bcache: not writing prios:
>> free_inc 0/127
>>
>> Does this show some clue to you?
>>
>> Regards,
>> Jack
>>
>> On 04/22/2013 11:51 PM, Kent Overstreet wrote:
>>> On Mon, Apr 22, 2013 at 10:27:03PM +0200, Jack Wang wrote:
>>>> Thanks for reply, Kent, two of my colleagues saw this behaviour, so I
>>>> think we can reproduce this.
>>>> If you could give me more detailed guide to narrow it down, I can try it
>>>> on my side.
>>>
>>> So, my current hypothesis is that the problem is the allocator spinning,
>>> and the IO is from it continually rewriting prios/gens.
>>>
>>> But I'm still not sure what's causing the allocator to spin, that's what
>>> the last patch was supposed to fix.
>>>
>>> Can you see if you can reproduce it with this patch, and then tell me
>>> what shows up in the dmesg log? I expect you'll get a _lot_ of output -
>>> flip timestamps on in your kernel config, if they're not already on.
>>> Thanks!
>>>
>>> commit 60a09d37d301f88dd0f0f413408821a067966d1a
>>> Author: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>> Date:   Mon Apr 22 14:49:33 2013 -0700
>>>
>>>     bcache: Allocator debug patch
>>>
>>> diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
>>> index 2879487..37c22c6 100644
>>> --- a/drivers/md/bcache/alloc.c
>>> +++ b/drivers/md/bcache/alloc.c
>>> @@ -393,12 +393,15 @@ void bch_allocator_thread(struct closure *cl)
>>>                               allocator_wait(ca, !list_empty(&ca->discards));
>>>                               do_discard(ca, bucket);
>>>                       } else {
>>> -                             fifo_push(&ca->free, bucket);
>>> +                             BUG_ON(!fifo_push(&ca->free, bucket));
>>>                               closure_wake_up(&ca->set->bucket_wait);
>>>                       }
>>>               }
>>>
>>>               allocator_wait(ca, ca->set->gc_mark_valid);
>>> +
>>> +             printk(KERN_DEBUG "bcache: invalidating buckets: free_inc %zu/%zu\n",
>>> +                    fifo_used(&ca->free_inc), ca->free_inc.size);
>>>               invalidate_buckets(ca);
>>>
>>>               allocator_wait(ca, !atomic_read(&ca->set->prio_blocked) ||
>>> @@ -407,8 +410,12 @@ void bch_allocator_thread(struct closure *cl)
>>>               if (CACHE_SYNC(&ca->set->sb) &&
>>>                   (!fifo_empty(&ca->free_inc) ||
>>>                    ca->need_save_prio > 64)) {
>>> +                     printk(KERN_DEBUG "bcache: writing prios: free_inc %zu/%zu\n",
>>> +                            fifo_used(&ca->free_inc), ca->free_inc.size);
>>>                       bch_prio_write(ca);
>>> -             }
>>> +             } else
>>> +                     printk(KERN_DEBUG "bcache: not writing prios: free_inc %zu/%zu\n",
>>> +                            fifo_used(&ca->free_inc), ca->free_inc.size);
>>>       }
>>>  }
>>>
>>
