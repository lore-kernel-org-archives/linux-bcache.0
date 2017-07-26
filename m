From: Coly Li <colyli@suse.de>
Subject: Re: handling cache device disconnection more properly ( was Re:
 [PATCH] bcache: only recovery I/O error for writethrough mode)
Date: Thu, 27 Jul 2017 01:08:45 +0800
Message-ID: <228ce580-aa61-bd23-149f-f4a88a22ba43@suse.de>
References: <20170710111828.97918-1-colyli@suse.de>
 <OFCB2AA6A0.E15FCC3D-ON4825815B.0001EEF5-4825815B.00033093@zte.com.cn>
 <eb85fc2b-91d9-0344-829c-972803572ac1@suse.de>
 <OFAAA836F5.65C1F846-ON4825815B.00093270-4825815B.0009741B@zte.com.cn>
 <45926957-5990-6520-7bd7-6de8c2bae7b8@suse.de>
 <OF7159B9D9.1C66A3AE-ON4825815B.000AD084-4825815B.000B252E@zte.com.cn>
 <be0287d1-9af2-659c-0d40-5fb774e3b178@suse.de>
 <alpine.LRH.2.11.1707130012390.9683@mail.ewheeler.net>
 <8d781ce2-db3c-9d8c-4309-a56ca242f2be@suse.de>
 <alpine.LRH.2.11.1707241852080.9683@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.11.1707241852080.9683@mail.ewheeler.net>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: tang.junhui@zte.com.cn, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 07/25/2017 03:19 AM, Eric Wheeler wrote:
> On Thu, 13 Jul 2017, Coly Li wrote:
> 
>> What we are discussing is more then the original patch, now the topic
>> changes to how handling cache device disconnection more properly. So I
>> change email thread subject.
>>
>> On 2017/7/13 上午8:53, Eric Wheeler wrote:
>>> On Wed, 12 Jul 2017, Coly Li wrote:
>>>
>>>> On 2017/7/12 上午10:01, tang.junhui@zte.com.cn wrote:
>>>>>> I meant "it is very necessary for data base applications which always
>>>>>> use *writeback* mode and not switch to other mode during all their
>>>>>> online time."  ^_^
>>>>>
>>>>> I know, it is necessary, but not enough. who can promise they will not
>>>>> switch during online time? This patch is logical imperfectly.
>>>>
>>>> Yes, I agree with you. Since Eric mentions dirty data map, an improved
>>>> fix shows up in my head,
>>>>
>>>> When cache device disconnected from system,
>>>> 0) If in non mode, do nothing.
>>>
>>> Does non mode guarantee that nothing is dirty?  I'm not convinced of that.
>>> I think you can set non mode with dirty blocks. (Correct me if I'm wrong
>>> here.)
>>>
>>
>> I think you are correct. Your question notices me, that it is still
>> possible that user switches cache mode more then once as they want,
>> maybe some sequence like this,
>>   writeback -> writethrough -> none -> writeback -> none ....
>> So we should always check whether dirty map exists or clean, no matter
>> what current cache mode is.
>>
>> Nice hint :-)
>>
>>
>>>> 1) If in writeback/writethough/writearound mode, and dirty map is clean,
>>>>     - switch to non mode
>>>>     - continue to handle I/O without cache device
>>>
>>> Sure, that makes sense.
>>>
>>>> 2) If in writeback mode, and dirty map is not clean,
>>>
>>> You would want to do a dirty map lookup for each IO.  How about this:
>>>
>>> 2) If in _any_ mode, and dirty map is dirty for *that specific block*:
>>>
>>>    If WRITE request completely overlaps the dirty segment then clear
>>> 	the dirty flag and pass through to the backing dev.
>>>    otherwise:
>>>      - return -EIO immediately for WRITE request
>>>      - return -EIO immediately for READ request (*)
>>>
>>> If the WRITE request completely overlaps the dirty segment as indicated
>>> from the in-memory metadata, then clear its dirty flag and write to the
>>> backing device.  Whatever was dirty isn't important anymore as it was
>>> overwritten.
>>
>> What I worried here is, the lost dirty data blocks is probably to have
>> inter-dependency, e.g. file system metadata (maybe database transaction
>> records).
>>
>> If the cache device disconnected and a single overlapped dirty block is
>> permitted to go into backing device. It may cause a more worse metadata
>> corruption and data lose on backing device.
> 
> I think we might be using the term "overlapped" in two different ways: I
> think you mean overlap as a request which only partially overwrites the
> data which is dirty.  My meaning for overlap was that it completely
> overlaps the dirty data, that is, the whole block specified by the WRITE
> request is already dirty at the time of submission and exactly matches
> what the dirty map indicates such that clearing the dirty map for the
> request does not clear the dirty map for any dirty data that is not
> overwritten by the request.
> 
> I agree that WRITE requests which do not fully overwrite the dirty block
> must -EIO.

I understand what you meant on "overlap", my reply was not detailed 
enough, let me explain my idea again.

I mentioned, "the lost dirty data blocks is probably to have
inter-dependency, e.g. file system metadata". That is, even a failed 
request exactly overlaps with a dirty key range, permitting it goes into 
disk platter may not be correct. Because if the dirty data is file 
system metadata (indeed bcache tends to keep metadata in cache), and 
cache device disconnects from system. In this case, file system on 
cached device may be corrupted already, permit one or more dirty blocks 
hitting disk platter does not help, maybe make things worse.

Imaging cached device is formatted as Ext4 file system, and it is 
attached to cache set. During an offline fsck running on the bcache 
device, and cache device disconnected. In this case, almost all modified 
metadata blocks are on disconnected cache device. At this moment, dirty 
data (on cache device) on top of cached device is a consistent file 
system; only cached device may contain a consistent or recoverable file 
system. But if fsck continue to write meta blocks and bcache permits 
them hitting disk platter (because of exact key range overlap), then the 
file system on cached device will be in a undefined inter medium status. 
Which may mislead further fsck operations and make a worse file system 
corruption.

So when a cache device disconnects from system, unless we have following 
dirty data exactly overlaps all dirty key ranges, otherwise we should 
not permit it (them) hitting disk platter. It is possible that a write 
request just exactly overlaps existing dirty key ranges, e.g. only one 
dirty key and it exactly matches LBA range of the write request.

> 
> We can only write to the backing device if the WRITE request being made is
> to an offset+length that is completely dirty, in which case the related
> cache block in-memory dirty flag can be cleared.  It must completely match
> the dirty block size so the write complete replaces the dirty area.
> 
> Does this seem correct?  If not, please suggest an example to illustrate.
> 

I provide a fsck example in above lines. Indeed when there is dependency 
within on-disk data structure, e.g. a tree structure, on disk heartbeat 
map, permitting an exactly overlapped write request to overwrite cached 
disk is very probably problematic.


>>>
>>> Unless there is a good reason to diverge, we would want this recovery
>>> logic would be the same for failed IOs from an existing cachedev (eg, with
>>> badblocks), and for cachedevs that are altogether missing.
>>>
>>
>> For clean data lost, this is totally correct. For dirty data lost, it
>> might not be always correct. At least for writeback mode, this recovery
>> logic is buggy. Return a corrupted/stale data in silence is disaster,
>> this logic should be fixed.
> 
> I think we are saying the same thing.  Always return valid data or -EIO.
> I'm just suggesting that the -EIO path from the cache device should be the
> same logic whether it is because the driver returned -EIO or because the
> cache device is missing.
> 

Yes, they are same code path. Bcache does not handle cache device 
failure now, I/O failure or cache device failure are all non-zero 
bi_status in bi_end_io call back. Yes, we think in same way here.


>>>
>>>> 3) If not in writeback mode, and dirty map is not clean. It means the
>>>> cache mode is switched from writeback mode with dirty data lost, then
>>>>     - returns -EIO immediately for WRITE request
>>>>     - returns -EIO immediately for READ request (*)
>>>
>>> For #2,3, do a dirty map lookup for every IO: if the block is clean, pass
>>> it to the backing device.  Only -EIO if the request cannot be recovered
>>> (block is dirty) and invoke pr_crit_once() to notify the user.  We want
>>> all IO requests to succeed to the extent possible.
>>
>> For SSD, especially industry level NVMe SSD, there are quite a lot
>> redundant capacity inside. If an internal storage unit failed, SSD
>> controller will recovery the broken unit by map its LBA to another
>> internal storage unit. Which means if we encounter consistent bad block
>> on NVMe SSD, this is an important warning, because this device has no
>> internal space to remap and will die very soon.
> 
> Interesting, true!
> 
> What does bcache do currently if the cache device still exists (is not
> missing) but is getting -EIO's from the driver?
>   

Currently they are same code path, bcache code only receives non-zero 
error from bi_status, we cannot know it is from a failed cache device, 
or just an I/O error returned from device.


>> 5 years ago, I know some PCIe SSDs had 30%~50% capacity more internally
>> for better write performance (more space to avoid synchronized garbage
>> collection). If a bad block returned from such SSD, the situation is
>> similar to a hard disk reports 25%~30% sectors are bad. Definitely
>> people should replace the SSD as soon as possible.
> 
> Indeed!
> 
>>> I think #3 is the same case as #2.  The logic is the same whether its is
>>> now or ever was in writeback mode, regardless of the current mode.
>>>
>>>> (*) NOTE:
>>>> A sysfs entry "recovery_io_error" can be add here, which is disabled as
>>>> default. If it is enabled, if a READ request does not hit dirty map,
>>>> bcache will provide it from backing device.
>>>
>>> Resilience first!  This should default on.
>>
>> For any storage system, data health is always first priority. Providing
>> corrupted data is unacceptable.
>>
>> If bcache cannot recovery a correct data, returning a stale data by
>> recovery is insane from view of users, we should not make it happen.
> 
> Agreed.
>   
>> But if people use bcache to accelerate applications on laptop with cheap
>> SSD, they care about performance much more then data consistency. And
>> this kind of use case should represent most of bcache development in the
>> world. Hmm, I cannot find a way to refute you... you are right, this
>> should default on.
>>
>> How about this,
>> we make this configure default on, and explain in code and document why
>> it exists and in which condition it should be disabled. Then people may
>> disable it when they seriously cares about data consistency.
>>
>> Do you think it is reasonable ?
> 
> Definitely!
> 
>> [cut pagecache bits]
> 
> (Nevermind what I said about the pagecache, it only confuses things.
> Lets stick to the block layer :) )
> 
>>> Since the dirty map is still in memory, that information is
>>> useful for recovery.  After a reboot the dirty map is lost---and with it
>>> the data about what is consistent and what is not.
>>>
>>> For example, if LVM snapshots sit atop of the bcache volume, then you
>>> could `dd` them off.  If you hit an error, you know that copy is at least
>>> partially inconsistent and can try an older snapshot until one is found
>>> which is old enough to be 100% consistent.  Without the dirty map, you
>>> would only be guessing at which volume is actually consistent.
>>>
>>> Let users set recovery_io_error=0 for those who really want to fail early.
>>
>> Yes, your suggestion is great, let's set recovery_io_error=1 as default.
>>
>>  From the above discussion, if:
>> - recovery_io_error=1 is set as default.
>> - dirty map should still be check in "non" mode (this is any mode that
>> you suggested), and handled properly.
>> do you think there is any thing more to fix on my proposal ?
> 
> I think you proposal is great, thank you for all of the work on this!

Thanks for your review on this proposal. Now I start to compose another 
patch for you all to review.

-- 
Coly Li
