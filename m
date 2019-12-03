From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: add REQ_FUA to avoid data lost in writeback mode
Date: Tue, 3 Dec 2019 22:21:57 +0800
Message-ID: <1a728329-1b12-0ebf-21a4-058ef6f65ead@suse.de>
References: <20191202102409.3980-1-wings.wyang@gmail.com>
 <785fe04f-f841-3083-66db-53fab7bc0577@suse.de>
 <alpine.LRH.2.11.1912021932570.11561@mx.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.11.1912021932570.11561@mx.ewheeler.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: kungf <wings.wyang@gmail.com>, kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2019/12/3 3:34 上午, Eric Wheeler wrote:
> On Mon, 2 Dec 2019, Coly Li wrote:
>> On 2019/12/2 6:24 下午, kungf wrote:
>>> data may lost when in the follow scene of writeback mode:
>>> 1. client write data1 to bcache
>>> 2. client fdatasync
>>> 3. bcache flush cache set and backing device
>>> if now data1 was not writed back to backing, it was only guaranteed safe in cache.
>>> 4.then cache writeback data1 to backing with only REQ_OP_WRITE
>>> So data1 was not guaranteed in non-volatile storage,  it may lost if  power interruption 
>>>
>>
>> Hi,
>>
>> Do you encounter such problem in real work load ? With bcache journal, I
>> don't see the possibility of data lost with your description.
>>
>> Correct me if I am wrong.
>>
>> Coly Li
> 
> If this does become necessary, then we should have a sysfs or superblock 
> flag to disable FUA for those with RAID BBUs.

Hi Eric,

I doubt it is necessary to add FUA tag for all writeback bios, it is
unnecessary. If power failure happens after dirty data written to
backing device and the bkey turns into clean, a following read request
will go to cache device because the LBA can be indexed no matter it is
dirty or clean. Unless the bkey is invalidated from the B+tree, read
will always go to cache device firstly in writeback mode. If a power
failure happens before the cached bkey turns from dirty to clean, just
an extra writeback bio flushed from cache device to backing device with
identical data. Comparing the FUA tag for all writeback bios (it will be
really slow), the extra writeback IOs after a power failure is more
acceptable to me.

Coly Li

> 
>>> Signed-off-by: kungf <wings.wyang@gmail.com>
>>> ---
>>>  drivers/md/bcache/writeback.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
>>> index 4a40f9eadeaf..e5cecb60569e 100644
>>> --- a/drivers/md/bcache/writeback.c
>>> +++ b/drivers/md/bcache/writeback.c
>>> @@ -357,7 +357,7 @@ static void write_dirty(struct closure *cl)
>>>  	 */
>>>  	if (KEY_DIRTY(&w->key)) {
>>>  		dirty_init(w);
>>> -		bio_set_op_attrs(&io->bio, REQ_OP_WRITE, 0);
>>> +		bio_set_op_attrs(&io->bio, REQ_OP_WRITE | REQ_FUA, 0);
>>>  		io->bio.bi_iter.bi_sector = KEY_START(&w->key);
>>>  		bio_set_dev(&io->bio, io->dc->bdev);
>>>  		io->bio.bi_end_io	= dirty_endio;
>>>
>>
