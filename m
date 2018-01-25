From: tang.junhui@zte.com.cn
Subject: Re: [PATCH] bcache: lock in btree_flush_write() to avoid races
Date: Thu, 25 Jan 2018 10:30:45 +0800
Message-ID: <1516847445-10005-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mxhk.zte.com.cn ([63.217.80.70]:52342 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752683AbeAYC3S (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 24 Jan 2018 21:29:18 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: kent.overstreet@gmail.com
Cc: nix@esperi.org.uk, colyli@suse.de, mlyle@lyle.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn

From: Tang Junhui <tang.junhui@zte.com.cn>

Hello Kent

>The only purpose of rcu_read_lock() would be to ensure the object
>isn't freed out from under you. That's not an issue here.
> 
I do not think so. In for_each_cached_btree(), we traverse all
btrees by hlist_for_each_entry_rcu(), and the hlist_for_each_entry_rcu()
should be protect by rcu lock, as the API describle bellow:
 * This list-traversal primitive may safely run concurrently with
 * the _rcu list-mutation primitives such as hlist_add_head_rcu()
 * as long as the traversal is guarded by rcu_read_lock().
 */
#define hlist_for_each_entry_rcu(pos, head, member)			\
	for (pos = hlist_entry_safe (rcu_dereference_raw(hlist_first_rcu(head)),\

>Racing with other writers isn't a correctness issue here, and if it
>was - just throwing write_lock around where you have it wouldn't be
>sufficient, you'd need something much more complicated.
> 
since we only read by hlist_for_each_entry_rcu(), so I think we does not 
need any more write locker.

>On Wed, Jan 24, 2018 at 8:50 PM,  <tang.junhui@zte.com.cn> wrote:
>> From: Tang Junhui <tang.junhui@zte.com.cn>
>>
>> Hello Kent && Nix
>>
>>>
>>>neither of those locks are needed - rcu_read_lock() isn't needed because we never
>>>free struct btree (except at shutdown), and we're not derefing journal there
>>
>> __bch_btree_node_write() is called in many places, in __bch_btree_node_write(),
>> before node writing over, it has changed the write buff index to another, but the
>> journal of changed write buff maybe still NULL if no journal writing occurred. But
>> luckily we only use the NULL as ZERO to calculate the fifo_idx, the result is a very
>> big value, so it does no harm. And since we cannot take mutex under rcu_read_lock,
>> we can ignore it.
>>
>> As to the rcu lock, though the btree is not freed, but we often delete it from one
>> list (such as one bucket_hash) and move it to another list (such as btree_cache_freed),
>> shouldn't it be protected by rcu locker?
>>
>>
>>>On Wed, Jan 24, 2018 at 5:30 AM, Nikolay Borisov <nborisov@suse.com> wrote:
>>>
>>>
>>>On 24.01.2018 08:54, tang.junhui@zte.com.cn wrote:
>>>> From: Tang Junhui <tang.junhui@zte.com.cn>
>>>>
>>>> In btree_flush_write(), two places need to take a locker to
>>>> avoid races:
>>>>
>>>> Firstly, we need take rcu read locker to protect the bucket_hash
>>>> traverse, since hlist_for_each_entry_rcu() must be called under
>>>> the protection of rcu read locker.
>>>>
>>>> Secondly, we need take b->write_lock locker to protect journal
>>>> of the btree node, otherwise, the btree node may have been
>>>> written, and the journal have been assign to NULL.
>>>>
>>>> Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
>>>> ---
>>>>  drivers/md/bcache/journal.c | 7 ++++++-
>>>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
>>>> index 02a98dd.505f9f3 100644
>>>> --- a/drivers/md/bcache/journal.c
>>>> +++ b/drivers/md/bcache/journal.c
>>>> @@ -375,7 +375,9 @@ static void btree_flush_write(struct cache_set *c)
>>>>  retry:
>>>>       best = NULL;
>>>>
>>>> -     for_each_cached_btree(b, c, i)
>>>> +     rcu_read_lock();
>>>> +     for_each_cached_btree(b, c, i) {
>>>> +             mutex_lock(&b->write_lock);
>>>
>>
>>>You can't sleep in rcu read critical section, yet here you take mutex
>>>which can sleep under rcu_read_lock.
>> To Nix: Yes, you are write. Good catch.
>>
>>>
>>>>               if (btree_current_write(b)->journal) {
>>>>                       if (!best)
>>>>                               best = b;
>>>> @@ -385,6 +387,9 @@ static void btree_flush_write(struct cache_set *c)
>>>>                               best = b;
>>>>                       }
>>>>               }
>>>> +             mutex_unlock(&b->write_lock);
>>>> +     }
>>>> +     rcu_read_unlock();
>>>>
>>>>       b = best;
>>>>       if (b) {
>>
>> Thanks,
>> Tang Junhui
>>

Thanks,
Tang Junhui
