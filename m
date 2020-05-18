From: Coly Li <colyli@suse.de>
Subject: Re: [RFC PATCH v2 4/4] block: set bi_size to REQ_OP_ZONE_RESET bio
Date: Mon, 18 May 2020 10:32:17 +0800
Message-ID: <4248690d-1be2-3da4-3dec-9d9f3216526e@suse.de>
References: <20200516035434.82809-1-colyli@suse.de>
 <20200516035434.82809-5-colyli@suse.de>
 <BY5PR04MB6900FDE1CD0D754084FCCA38E7B80@BY5PR04MB6900.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55212 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726639AbgERCc1 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 17 May 2020 22:32:27 -0400
In-Reply-To: <BY5PR04MB6900FDE1CD0D754084FCCA38E7B80@BY5PR04MB6900.namprd04.prod.outlook.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "hch@lst.de" <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "kbusch@kernel.org" <kbusch@kernel.org>, Ajay Joshi <Ajay.Joshi@wdc.com>, Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>

On 2020/5/18 08:59, Damien Le Moal wrote:
> On 2020/05/16 12:55, Coly Li wrote:
>> Now for zoned device, zone management ioctl commands are converted into
>> zone management bios and handled by blkdev_zone_mgmt(). There are 4 zone
>> management bios are handled, their op code is,
>> - REQ_OP_ZONE_RESET
>>   Reset the zone's writer pointer and empty all previously stored data.
>> - REQ_OP_ZONE_OPEN
>>   Open the zones in the specified sector range, no influence on data.
>> - REQ_OP_ZONE_CLOSE
>>   Close the zones in the specified sector range, no influence on data.
>> - REQ_OP_ZONE_FINISH
>>   Mark the zone as full, no influence on data.
>> All the zone management bios has 0 byte size, a.k.a their bi_size is 0.
>>
>> Exept for REQ_OP_ZONE_RESET request, zero length bio works fine for
>> other zone management bio, before the zoned device e.g. host managed SMR
>> hard drive can be created as a bcache device.
>>
>> When a bcache device (virtual block device to forward bios like md raid
>> drivers) can be created on top of the zoned device, and a fast SSD is
>> attached as a cache device, bcache driver may cache the frequent random
>> READ requests on fast SSD to accelerate hot data READ performance.
>>
>> When bcache driver receives a zone management bio for REQ_OP_ZONE_RESET
>> op, while forwarding the request to underlying zoned device e.g. host
>> managed SMR hard drive, it should also invalidate all cached data from
>> SSD for the resetting zone. Otherwise bcache will continue provide the
>> outdated cached data to READ request and cause potential data storage
>> inconsistency and corruption.
>>
>> In order to invalidate outdated data from SSD for the reset zone, bcache
>> needs to know not only the start LBA but also the range length of the
>> resetting zone. Otherwise, bcache won't be able to accurately invalidate
>> the outdated cached data.
>>
>> Is it possible to simply set the bi_size inside bcache driver? The
>> answer is NO. Although every REQ_OP_ZONE_RESET bio has exact length as
>> zone size or q->limits.chunk_sectors, it is possible that some other
>> layer stacking block driver (in the future) exists between bcache driver
>> and blkdev_zone_mgmt() where the zone management bio is made.
> 
> But bcache "knows" what underlying devices it is using, right ? So getting the
> SMR drive zone size using blk_queue_zone_sectors(), bdev_zone_sectors() or by
> directly accessing q->limits->chunk_sectors should not be a problem at all, no ?
> 
>>
>> The best location to set bi_size is where the zone management bio is
>> composed in blkdev_zone_mgmt(), then no matter how this bio is split
>> before bcache driver receives it, bcache driver can always correctly
>> invalidate the resetting range.
>>
>> This patch sets the bi_size of REQ_OP_ZONE_RESET bio for each resetting
>> zone. Here REQ_OP_ZONE_RESET_ALL is special whose bi_size should be set
>> as capacity of whole drive size, then bcache can invalidate all cached
>> data from SSD for the zoned backing device.
> 
> NACK. The problem here is that struct bio_vec bv_len field and struct bvec_iter
> bi_size field are both "unsigned int". So they can describe at most 4G x 512B =
> 2TB ranges. For REQ_OP_ZONE_RESET_ALL, that is simply way too small (we already
> are at 20TB capacity for SMR). One cannot issue a BIO with a length that is the
> entire disk capacity.
> 
> I really think that bcache should handle the zone management ops as a special
> case. I understand the goal of trying to minimize that by integrating them as
> much as possible into the regular bcache IO path, but that really seems
> dangerous to me. Since these operations will need remapping in bcache anyway
> (for handling the first hidden zone containing the super block), all special
> processing can be done under a single "if" which should not impact too much
> performance of regular read/write commands in the hot path.
> 
> Device mapper has such code: see __split_and_process_bio() and its use of
> op_is_zone_mgmt() function to handle zone management requests slightly
> differently than other BIOs. That remove the need for relying on op_is_write()
> direction (patch 1 and 2 in this series) for reset zones too, which in the end
> will I think make your bcache code a lot more solid.
> 

Copied. I understand and agree with you and Christoph now. Let me
reconstruct the bcache code and maybe the depended change of generic
block layer code can be avoided.

Damien and Christoph, thank you all for the comments.

Coly Li
