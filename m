From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
Date: Mon, 2 Mar 2020 08:01:57 -0700
Message-ID: <429df503-00b7-a433-5f6f-08b3f232a1bf@kernel.dk>
References: <20200302093450.48016-1-colyli@suse.de>
 <20200302093450.48016-2-colyli@suse.de>
 <20200302122748.GH4380@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200302122748.GH4380@dhcp22.suse.cz>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>, Coly Li <colyli@suse.de>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, hare@suse.de, mkoutny@suse.com, Oleg Nesterov <oleg@redhat.com>
List-Id: linux-bcache@vger.kernel.org

On 3/2/20 5:27 AM, Michal Hocko wrote:
> [Cc Oleg]
> 
> On Mon 02-03-20 17:34:49, Coly Li wrote:
>> When cache device and cached device are registered simuteneously and
>> register_cache() firstly acquires bch_register_lock. register_bdev()
>> has to wait before register_cache() finished, it might be a very long
>> time.
>>
>> If the registration is from udev rules in system boot up time, and
>> registration is not completed before udev timeout (default 180s), the
>> registration process will be killed by udevd. Then the following calls
>> to kthread_run() or kthread_create() will fail due to the pending
>> signal (they are implemented this way at this moment).
>>
>> For boot time, this is not good, because it means a cache device with
>> huge cached data will always fail in boot time, just because it
>> spends too much time to check its internal meta data (btree and dirty
>> sectors).
>>
>> The failure for cache device registration is solved by previous
>> patches, but failure due to timeout also exists in cached device
>> registration. As the above text explains, cached device registration
>> may also be timeout if it is blocked by a timeout cache device
>> registration process. Then in the following code path,
>>     bioset_init() <= bcache_device_init() <= cached_dev_init() <=
>>     register_bdev() <= register_bcache()
>> bioset_init() will fail because internally kthread_create() will fail
>> for pending signal in the following code path,
>>     bioset_init() => alloc_workqueue() => init_rescuer() =>
>>     kthread_create()
>>
>> Maybe fix kthread_create() and kthread_run() is better method, but at
>> this moment a fast workaroudn is to flush pending signals before
>> calling bioset_init() in bcache_device_init().
> 
> I cannot really comment on the bcache part because I am not familiar
> with the code. It is quite surprising to see an initialization taking
> that long though.
> 
> Anyway
> 
>> This patch calls flush_signals() in bcache_device_init() if there is
>> pending signal for current process. It avoids bcache registration
>> failure in system boot up time due to bcache udev rule timeout.
> 
> this sounds like a wrong way to address the issue. Killing the udev
> worker is a userspace policy and the kernel shouldn't simply ignore it.
> Is there any problem to simply increase the timeout on the system which
> uses a large bcache?

On top of that, what if signals were sent for other reasons than just
terminate it? Flushing a fatal signal from "some task" seems bad enough
on its own, but we could be losing others as well.

Coly, this seems like a very bad idea. And the same goes for the
existing flush_signals() in bcache. It's just not the right way to deal
with it, and it could be causing other issues.

-- 
Jens Axboe
