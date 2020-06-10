From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: check and adjust logical block size for backing
 devices
Date: Wed, 10 Jun 2020 19:39:31 +0800
Message-ID: <90a6dd02-5e3b-97ca-9131-842b59135cc5@suse.de>
References: <20200603160310.499252-1-mfo@canonical.com>
 <c4442cda-941c-c697-f7d5-b9121c780f45@suse.de>
 <CAO9xwp2hPbuNzsV2pBF9dDtDD=Qa+RLToCt5GUBKRqdoGYJ0Vw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55862 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728510AbgFJLjh (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 10 Jun 2020 07:39:37 -0400
In-Reply-To: <CAO9xwp2hPbuNzsV2pBF9dDtDD=Qa+RLToCt5GUBKRqdoGYJ0Vw@mail.gmail.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Mauricio Faria de Oliveira <mfo@canonical.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org

On 2020/6/4 22:14, Mauricio Faria de Oliveira wrote:
> Hi Coly,
> 
> Thanks for reviewing.
> 
> On Wed, Jun 3, 2020 at 9:41 PM Coly Li <colyli@suse.de> wrote:
>>
>> On 2020/6/4 00:03, Mauricio Faria de Oliveira wrote:
>>> It's possible for a block driver to set logical block size to
>>> a value greater than page size incorrectly; e.g. bcache takes
>>> the value from the superblock, set by the user w/ make-bcache.
>>>
>>> This causes a BUG/NULL pointer dereference in the path:
>>>
>>>   __blkdev_get()
>>>   -> set_init_blocksize() // set i_blkbits based on ...
>>>      -> bdev_logical_block_size()
>>>         -> queue_logical_block_size() // ... this value
>>>   -> bdev_disk_changed()
>>>      ...
>>>      -> blkdev_readpage()
>>>         -> block_read_full_page()
>>>            -> create_page_buffers() // size = 1 << i_blkbits
>>>               -> create_empty_buffers() // give size/take pointer
>>>                  -> alloc_page_buffers() // return NULL
>>>                  .. BUG!
>>>
>>> Because alloc_page_buffers() is called with size > PAGE_SIZE,
>>> thus it initializes head = NULL, skips the loop, return head;
>>> then create_empty_buffers() gets (and uses) the NULL pointer.
>>>
>>> This has been around longer than commit ad6bf88a6c19 ("block:
>>> fix an integer overflow in logical block size"); however, it
>>> increased the range of values that can trigger the issue.
>>>
>>> Previously only 8k/16k/32k (on x86/4k page size) would do it,
>>> as greater values overflow unsigned short to zero, and queue_
>>> logical_block_size() would then use the default of 512.
>>>
>>> Now the range with unsigned int is much larger, and users w/
>>> the 512k value, which happened to be zero'ed previously and
>>> work fine, started to hit this issue -- as the zero is gone,
>>> and queue_logical_block_size() does return 512k (>PAGE_SIZE.)
>>>
>>> Fix this by checking the bcache device's logical block size,
>>> and if it's greater than page size, fallback to the backing/
>>> cached device's logical page size.
>>>
>>> This doesn't affect cache devices as those are still checked
>>> for block/page size in read_super(); only the backing/cached
>>> devices are not.
>>>
>>> Apparently it's a regression from commit 2903381fce71 ("bcache:
>>> Take data offset from the bdev superblock."), moving the check
>>> into BCACHE_SB_VERSION_CDEV only. Now that we have superblocks
>>> of backing devices out there with this larger value, we cannot
>>> refuse to load them (i.e., have a similar check in _BDEV.)
>>>
>>> Ideally perhaps bcache should use all values from the backing
>>> device (physical/logical/io_min block size)? But for now just
>>> fix the problematic case.
>>>
>>> Test-case:
>>>
>>>     # IMG=/root/disk.img
>>>     # dd if=/dev/zero of=$IMG bs=1 count=0 seek=1G
>>>     # DEV=$(losetup --find --show $IMG)
>>>     # make-bcache --bdev $DEV --block 8k
>>>       < see dmesg >
>>>
>>> Before:
>>>
>>>     # uname -r
>>>     5.7.0-rc7
>>>
>>>     [   55.944046] BUG: kernel NULL pointer dereference, address: 0000000000000000
>>>     ...
>>>     [   55.949742] CPU: 3 PID: 610 Comm: bcache-register Not tainted 5.7.0-rc7 #4
>>>     ...
>>>     [   55.952281] RIP: 0010:create_empty_buffers+0x1a/0x100
>>>     ...
>>>     [   55.966434] Call Trace:
>>>     [   55.967021]  create_page_buffers+0x48/0x50
>>>     [   55.967834]  block_read_full_page+0x49/0x380
>>>     [   55.972181]  do_read_cache_page+0x494/0x610
>>>     [   55.974780]  read_part_sector+0x2d/0xaa
>>>     [   55.975558]  read_lba+0x10e/0x1e0
>>>     [   55.977904]  efi_partition+0x120/0x5a6
>>>     [   55.980227]  blk_add_partitions+0x161/0x390
>>>     [   55.982177]  bdev_disk_changed+0x61/0xd0
>>>     [   55.982961]  __blkdev_get+0x350/0x490
>>>     [   55.983715]  __device_add_disk+0x318/0x480
>>>     [   55.984539]  bch_cached_dev_run+0xc5/0x270
>>>     [   55.986010]  register_bcache.cold+0x122/0x179
>>>     [   55.987628]  kernfs_fop_write+0xbc/0x1a0
>>>     [   55.988416]  vfs_write+0xb1/0x1a0
>>>     [   55.989134]  ksys_write+0x5a/0xd0
>>>     [   55.989825]  do_syscall_64+0x43/0x140
>>>     [   55.990563]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>>     [   55.991519] RIP: 0033:0x7f7d60ba3154
>>>     ...
>>>
>>> After:
>>>
>>>     # uname -r
>>>     5.7.0.bcachelbspgsz
>>>
>>>     [   31.672460] bcache: bcache_device_init() bcache0: sb/logical block size (8192) greater than page size (4096) falling back to device logical block size (512)
>>>     [   31.675133] bcache: register_bdev() registered backing device loop0
>>>
>>>     # grep ^ /sys/block/bcache0/queue/*_block_size
>>>     /sys/block/bcache0/queue/logical_block_size:512
>>>     /sys/block/bcache0/queue/physical_block_size:8192
>>>
>>> Reported-by: Ryan Finnie <ryan@finnie.org>
>>> Reported-by: Sebastian Marsching <sebastian@marsching.com>
>>> Signed-off-by: Mauricio Faria de Oliveira <mfo@canonical.com>
>>> ---
>>>  drivers/md/bcache/super.c | 22 +++++++++++++++++++---
>>>  1 file changed, 19 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>>> index d98354fa28e3..d0af298d39ba 100644
>>> --- a/drivers/md/bcache/super.c
>>> +++ b/drivers/md/bcache/super.c
>>> @@ -816,7 +816,8 @@ static void bcache_device_free(struct bcache_device *d)
>>>  }
>>>
>>>  static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
>>> -                           sector_t sectors, make_request_fn make_request_fn)
>>> +                           sector_t sectors, make_request_fn make_request_fn,
>>> +                           struct block_device *cached_bdev)
>>>  {
>>>       struct request_queue *q;
>>>       const size_t max_stripes = min_t(size_t, INT_MAX,
>>> @@ -882,6 +883,21 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
>>>       q->limits.io_min                = block_size;
>>>       q->limits.logical_block_size    = block_size;
>>>       q->limits.physical_block_size   = block_size;
>>> +
>>> +     if (q->limits.logical_block_size > PAGE_SIZE && cached_bdev) {
>>> +             /*
>>> +              * This should only happen with BCACHE_SB_VERSION_BDEV.
>>> +              * Block/page size is checked for BCACHE_SB_VERSION_CDEV.
>>> +              */
>>> +             pr_info("%s: sb/logical block size (%u) greater than page size "
>>> +                     "(%lu) falling back to device logical block size (%u)",
>>> +                     d->disk->disk_name, q->limits.logical_block_size,
>>> +                     PAGE_SIZE, bdev_logical_block_size(cached_bdev));
>>> +
>>> +             /* This also adjusts physical block size/min io size if needed */
>>> +             blk_queue_logical_block_size(q, bdev_logical_block_size(cached_bdev));
>>> +     }
>>> +
>>>       blk_queue_flag_set(QUEUE_FLAG_NONROT, d->disk->queue);
>>>       blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, d->disk->queue);
>>>       blk_queue_flag_set(QUEUE_FLAG_DISCARD, d->disk->queue);
>>> @@ -1339,7 +1355,7 @@ static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
>>>
>>>       ret = bcache_device_init(&dc->disk, block_size,
>>>                        dc->bdev->bd_part->nr_sects - dc->sb.data_offset,
>>> -                      cached_dev_make_request);
>>> +                      cached_dev_make_request, dc->bdev);
>>>       if (ret)
>>>               return ret;
>>>
>>> @@ -1452,7 +1468,7 @@ static int flash_dev_run(struct cache_set *c, struct uuid_entry *u)
>>>       kobject_init(&d->kobj, &bch_flash_dev_ktype);
>>>
>>>       if (bcache_device_init(d, block_bytes(c), u->sectors,
>>> -                     flash_dev_make_request))
>>> +                     flash_dev_make_request, NULL))
>>>               goto err;
>>>
>>>       bcache_device_attach(d, c, u - c->uuids);
>>>
>>
>> Hi Mauricio,
>>
>> Thank you for this good catch. I am OK with the analysis, but I prefer
>> to check the block_size when reading backing device super block. Such
>> check can be added after this code piece in read_super(),
>>
>>  117         err = "Superblock block size smaller than device block size";
>>  118         if (sb->block_size << 9 < bdev_logical_block_size(bdev))
>>  119                 goto err;
>>
>> My opinion is, if there is a illegal value in on-disk super block, we
>> should fail the registration and report it immediately, it is better
>> then keep it and implicitly fix the value in memory.
>>
> 
> So, I considered that option, but I guess we cannot do that now,
> when such superblocks are already out there -- this would break
> existing, working bcache superblocks, making them unusable.
> Sorry, I mentioned that in a rather hidden part of commit msg.
> 
> (Unless the kernel provides an option to fix-up the superblock
> on disk, but that means 'interaction' with the user, who might
> not even exist -- this bcache device being on VMs on servers;
> and we'd still break their bcache workflow somehow/for a bit,
> which was working just fine.)
> 
> Another point there is that, the block_size value in superblock
> is not illegal for all parameters it's used for -- i.e., it's wrong for
> logical block size, but not for physical block size nor min io size
> (both of which can indeed be greater than page size, iiuic.)
> 
> This originates from the fact that bcache uses one single value
> to set all 3 parameters, as make-bcache provides only one switch
> for block size.
> 
> That is the reason why I mentioned we _maybe_should_try to?_
> set these 3 parameters from the underlying block device; as
> the reason these users are using a 512k block size is to align
> with their underlying RAID6 setup, which has a 512k stripe size.
> 
> So if we took values from the underlying backing device, it'd do that;
> with the additional value of no longer depend on the block size
> from the superblock _for the backing devices_, which is something
> mentioned in the superblock struct:
> 
>                 /*
>                  * block_size from the cache device section is still used by
>                  * backing devices, so don't add anything here until we fix
>                  * things to not need it for backing devices anymore
>                  */
> 
> However, I don't know enough about bcache/block layer to understand if
> it would be OK/better to use the values from the backing or cache device,
> as data goes into cache first most of the time, and if it is sent to backing
> device from there according to the block size parameters of the backing device.
> (i.e., the IO path and honoring of the block sizes between
> cache/backing devices.)
> 
> And particularly because all that seems complicated, is why I chose
> (er, had :-) to try just a simple fix first, to get these users out of the
> kernel errors they hit, and allow them to use their bcache devices,
> while we can get that straightened out. :-)
> 
> 
>> BTW, would you like to patch the bcache-tools as well against,
>> https://git.kernel.org/pub/scm/linux/kernel/git/colyli/bcache-tools.git/
>>
>> Then we can also prevent people create incorrect block size in creating
>> time.
> 
> Yes, once there's settling on what is the right approach is (given the value
> is OK for the non-logical block size parameters), I can most certainly send
> something for userspace too.
> 
>>
>> After all, great catch, thank you :-)
>>
> 
> Glad to help!  Thank you for the prompt review!
> Mauricio

I see, it makes sense. There might be better method to improve, but now
I'd like to have it. I will submit this to Jens with other for rc-1/rc2
patches.

Thanks.

Coly Li
