From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC PATCH v2 1/4] block: change REQ_OP_ZONE_RESET from 6 to 13
Date: Mon, 18 May 2020 08:53:30 +0200
Message-ID: <19eea726-590c-bf55-2dbf-35b71c9d1600@suse.de>
References: <20200516035434.82809-1-colyli@suse.de>
 <20200516035434.82809-2-colyli@suse.de> <20200516123801.GB13448@lst.de>
 <fc0fd3c9-ea46-7c62-2a57-abd64e79cd08@suse.de>
 <20200516125027.GA13730@lst.de>
 <f57da1e7-1563-db1e-8730-8daca219cbe7@suse.de>
 <20200516153649.GB16693@lst.de>
 <c50be737-da25-1e48-3e26-aa15df175110@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <c50be737-da25-1e48-3e26-aa15df175110@suse.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, damien.lemoal@wdc.com, hare@suse.com, axboe@kernel.dk, linux-bcache@vger.kernel.org, kbusch@kernel.org, Jens Axboe <axboe@fb.com>, Johannes Thumshirn <johannes.thumshirn@wdc.com>, Shaun Tancheff <shaun.tancheff@seagate.com>
List-Id: linux-bcache@vger.kernel.org

On 5/17/20 7:30 AM, Coly Li wrote:
> On 2020/5/16 23:36, Christoph Hellwig wrote:
>> On Sat, May 16, 2020 at 09:05:39PM +0800, Coly Li wrote:
>>> On 2020/5/16 20:50, Christoph Hellwig wrote:
>>>> On Sat, May 16, 2020 at 08:44:45PM +0800, Coly Li wrote:
>>>>> Yes you are right, just like REQ_OP_DISCARD which does not transfer any
>>>>> data but changes the data on device. If the request changes the stored
>>>>> data, it does transfer data.
>>>>
>>>> REQ_OP_DISCARD is a special case, because most implementation end up
>>>> transferring data, it just gets attached in the low-level driver.
>>>>
>>>
>>> Yes, REQ_OP_ZONE_RESET and REQ_OP_ZONE_RESET_ALL are quite similar to
>>> REQ_OP_DISCARD. Data read from the LBA range of reset zone is not
>>> suggested and the content is undefined.
>>>
>>> For bcache, similar to REQ_OP_DISCARD, REQ_OP_ZONE_RESET and
>>> REQ_OP_ZONE_RESET_ALL are handled in same way: If the backing device
>>> supports discard/zone_reset, and the operation successes, then cached
>>> data on SSD covered by the LBA range should be invalid, otherwise users
>>> will read outdated and garbage data.
>>>
>>> We should treat REQ_OP_ZONE_RESET and REQ_OP_ZONE_RESET_ALL being in
>>> WRITE direction.
>>
>> No, the difference is that the underlying SCSI/ATA/NVMe command tend to
>> usually actually transfer data.  Take a look at the special_vec field
>> in struct request and the RQF_SPECIAL_PAYLOAD flag.
>>
> 
> Then bio_data_dir() will be problematic, as it is defined,
>   52 /*
>   53  * Return the data direction, READ or WRITE.
>   54  */
>   55 #define bio_data_dir(bio) \
>   56         (op_is_write(bio_op(bio)) ? WRITE : READ)
> 
> For the REQ_OP_ZONE_RESET bio, bio_data_dir() will report it as READ.
> 
> Since the author is you, how to fix this ?
> 

Well, but I do think that Coly is right in that bio_data_dir() is very 
unconvincing, or at least improperly documented.

I can't quite follow Christoph's argument in that bio_data_dir() 
reflects whether data is _actually_ transferred (if so, why would 
REQ_OP_ZONE_CLOSE() be marked as WRITE?)
However, in most cases bio_data_dir() will only come into effect if 
there are attached bvecs.

So the _correct_ usage for bio_data_dir() would be to check if there is 
data attached to the bio (eg by using bio_has_data()), and only call 
bio_data_dir() if that returns true. For false you'd need to add a 
switch evaluating the individual commands.

And, btw, bio_has_data() needs updating, too; all the zone commands are 
missing from there, too.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
