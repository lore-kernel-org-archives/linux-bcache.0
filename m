From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 3/5] bcache: fix refcount underflow in
 bcache_device_free()
Date: Wed, 27 May 2020 10:40:50 +0800
Message-ID: <3588b887-ec5b-1306-1857-43f614472af9@suse.de>
References: <20200526155928.32036-1-colyli@suse.de>
 <20200526155928.32036-4-colyli@suse.de>
 <34b826ff-0093-4427-f542-88c17abad934@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <34b826ff-0093-4427-f542-88c17abad934@kernel.dk>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2020/5/27 01:23, Jens Axboe wrote:
> On 5/26/20 9:59 AM, Coly Li wrote:
>> The problematic code piece in bcache_device_free() is,
>>
>>  785 static void bcache_device_free(struct bcache_device *d)
>>  786 {
>>  787     struct gendisk *disk = d->disk;
>>  [snipped]
>>  799     if (disk) {
>>  800             if (disk->flags & GENHD_FL_UP)
>>  801                     del_gendisk(disk);
>>  802
>>  803             if (disk->queue)
>>  804                     blk_cleanup_queue(disk->queue);
>>  805
>>  806             ida_simple_remove(&bcache_device_idx,
>>  807                               first_minor_to_idx(disk->first_minor));
>>  808             put_disk(disk);
>>  809         }
>>  [snipped]
>>  816 }
>>
>> At line 808, put_disk(disk) may encounter kobject refcount of 'disk'
>> being underflow.
>>
>> Here is how to reproduce the issue,
>> - Attche the backing device to a cache device and do random write to
>>   make the cache being dirty.
>> - Stop the bcache device while the cache device has dirty data of the
>>   backing device.
>> - Only register the backing device back, NOT register cache device.
>> - The bcache device node /dev/bcache0 won't show up, because backing
>>   device waits for the cache device shows up for the missing dirty
>>   data.
>> - Now echo 1 into /sys/fs/bcache/pendings_cleanup, to stop the pending
>>   backing device.
>> - After the pending backing device stopped, use 'dmesg' to check kernel
>>   message, a use-after-free warning from KASA reported the refcount of
>>   kobject linked to the 'disk' is underflow.
>>
>> The dropping refcount at line 808 in the above code piece is added by
>> add_disk(d->disk) in bch_cached_dev_run(). But in the above condition
>> the cache device is not registered, bch_cached_dev_run() has no chance
>> to be called and the refcount is not added. The put_disk() for a non-
>> added refcount of gendisk kobject triggers a underflow warning.
>>
>> This patch checks whether GENHD_FL_UP is set in disk->flags, if it is
>> not set then the bcache device was not added, don't call put_disk()
>> and the the underflow issue can be avoided.
>>
>> Signed-off-by: Coly Li <colyli@suse.de>
>> ---
>>  drivers/md/bcache/super.c | 9 +++++++--
>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>> index 467149f3bcc5..c68d42730ca0 100644
>> --- a/drivers/md/bcache/super.c
>> +++ b/drivers/md/bcache/super.c
>> @@ -797,15 +797,20 @@ static void bcache_device_free(struct bcache_device *d)
>>  		bcache_device_detach(d);
>>  
>>  	if (disk) {
>> -		if (disk->flags & GENHD_FL_UP)
>> +		bool disk_added = false;
>> +
>> +		if (disk->flags & GENHD_FL_UP) {
>> +			disk_added = true;
>>  			del_gendisk(disk);
>> +		}
> 
> This would be cleaner as:
> 
> 	bool disk_added = (disk->flags & GENHD_FL_UP) != 0;
> 
> 	if (disk_added)
> 		del_gendisk(disk);
> 
> and so on.
> 

Sure, I improve it now in v2 series.

Thanks.

Coly Li
