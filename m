From: Coly Li <colyli@suse.de>
Subject: Re: [RFC PATCH v4 2/3] bcache: handle zone management bios for bcache
 device
Date: Tue, 2 Jun 2020 00:06:11 +0800
Message-ID: <825e0e6e-b783-c899-bc25-38a8f2e06385@suse.de>
References: <20200522121837.109651-1-colyli@suse.de>
 <20200522121837.109651-3-colyli@suse.de>
 <CY4PR04MB37511266F1D87572D3C648CFE7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43774 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726073AbgFAQGU (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 1 Jun 2020 12:06:20 -0400
In-Reply-To: <CY4PR04MB37511266F1D87572D3C648CFE7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>

On 2020/5/25 09:24, Damien Le Moal wrote:
> On 2020/05/22 21:18, Coly Li wrote:
>> Fortunately the zoned device management interface is designed to use
>> bio operations, the bcache code just needs to do a little change to
>> handle the zone management bios.
>>
>> Bcache driver needs to handle 5 zone management bios for now, all of
>> them are handled by cached_dev_nodata() since their bi_size values
>> are 0.
>> - REQ_OP_ZONE_OPEN, REQ_OP_ZONE_CLOSE, REQ_OP_ZONE_FINISH:
>>     The LBA conversion is already done in cached_dev_make_request(),
>>   just simply send such zone management bios to backing device is
>>   enough.
>> - REQ_OP_ZONE_RESET, REQ_OP_ZONE_RESET_ALL:
>>     If thre is cached data (clean or dirty) on cache device covered
>>   by the LBA range of resetting zone(s), such cached data must be
> 
> The first part of the sentence is a little unclear... Did you mean:
> 
> If the cache device holds data of the target zones, cache invalidation is needed
> before forwarding...

It will be fixed in next version.

> 
>>   invalidate from the cache device before forwarding the zone reset
>>   bios to the backing device. Otherwise data inconsistency or further
>>   corruption may happen from the view of bcache device.
>>     The difference of REQ_OP_ZONE_RESET_ALL and REQ_OP_ZONE_RESET is
>>   when the zone management bio is to reset all zones, send all zones
>>   number reported by the bcache device (s->d->disk->queue->nr_zones)
>>   into bch_data_invalidate_zones() as parameter 'size_t nr_zones'. If
>>   only reset a single zone, just set 1 as 'size_t nr_zones'.
>>
>> By supporting zone managememnt bios with this patch, now a bcache device
> 
> s/managememnt/management
> 

It will be fixed in next version.

>> can be formatted by zonefs, and the zones can be reset by truncate -s 0
>> on the zone files under seq/ directory. Supporting REQ_OP_ZONE_RESET_ALL
>> makes the whole disk zones reset much faster. In my testing on a 14TB
>> zoned SMR hard drive, 1 by 1 resetting 51632 seq zones by sending
>> REQ_OP_ZONE_RESET bios takes 4m34s, by sending a single
>> REQ_OP_ZONE_RESET_ALL bio takes 12s, which is 22x times faster.
>>
>> REQ_OP_ZONE_RESET_ALL is supported by bcache only when the backing device
>> supports it. So the bcache queue flag is set QUEUE_FLAG_ZONE_RESETALL on
>> only when queue of backing device has such flag, which can be checked by
>> calling blk_queue_zone_resetall() on backing device's request queue.

The above part about REQ_OP_ZONE_RESET_ALL will be removed.


>>
>> Signed-off-by: Coly Li <colyli@suse.de>
>> Cc: Damien Le Moal <damien.lemoal@wdc.com>
>> Cc: Hannes Reinecke <hare@suse.com>
>> Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>> ---
>> Changelog:
>> v2: an improved version without any generic block layer change.
>> v1: initial version depends on other generic block layer changes.
>>
>>  drivers/md/bcache/request.c | 99 ++++++++++++++++++++++++++++++++++++-
>>  drivers/md/bcache/super.c   |  2 +
>>  2 files changed, 100 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
>> index 34f63da2338d..700b8ab5dec9 100644
>> --- a/drivers/md/bcache/request.c
>> +++ b/drivers/md/bcache/request.c
>> @@ -1052,18 +1052,115 @@ static void cached_dev_write(struct cached_dev *dc, struct search *s)
>>  	continue_at(cl, cached_dev_write_complete, NULL);
>>  }
>>  
>> +/*
>> + * Invalidate the LBA range on cache device which is covered by the
>> + * the resetting zones.
>> + */
>> +static int bch_data_invalidate_zones(struct closure *cl,
>> +				      size_t zone_sector,
>> +				      size_t nr_zones)
> 
> No need for the line break after the second argument.

Believe me, I tried hard to make them into 2 lines. But the second line
is a bit longer, I try to persuade me to accept it but still quite
uncomfortable for the unaligned tails. I choose to keep current aligned
format ....

[snipped]

>> +
>>  static void cached_dev_nodata(struct closure *cl)
>>  {
>>  	struct search *s = container_of(cl, struct search, cl);
>>  	struct bio *bio = &s->bio.bio;
>> +	int nr_zones = 1;
>>  
>>  	if (s->iop.flush_journal)
>>  		bch_journal_meta(s->iop.c, cl);
>>  
>> -	/* If it's a flush, we send the flush to the backing device too */
>> +	if (bio_op(bio) == REQ_OP_ZONE_RESET_ALL ||
>> +	    bio_op(bio) == REQ_OP_ZONE_RESET) {
>> +		int err = 0;
>> +		/*
>> +		 * If this is REQ_OP_ZONE_RESET_ALL bio, cached data
>> +		 * covered by all zones should be invalidate from the
> 
> s/invalidate/invalidated

It will be fixed in next version.

> 
>> +		 * cache device.
>> +		 */
>> +		if (bio_op(bio) == REQ_OP_ZONE_RESET_ALL)
>> +			nr_zones = s->d->disk->queue->nr_zones;
> 
> Not: sending a REQ_OP_ZONE_RESET BIO to a conventional zone will be failed by
> the disk... This is not allowed by the ZBC/ZAC specs. So invalidation the cache
> for conventional zones is not really necessary. But as an initial support, I
> think this is fine. This can be optimized later.
>
Copied, will think of how to optimized later. So far in my testing,
resetting conventional zones may receive error and timeout from
underlying drivers and bcache code just forwards such error to upper
layer. What I see is the reset command hangs for a quite long time and
failed. I will find a way to make the zone reset command on conventional
zone fail immediately.


>> +
>> +		err = bch_data_invalidate_zones(
>> +			cl, bio->bi_iter.bi_sector, nr_zones);
>> +
>> +		if (err < 0) {
>> +			s->iop.status = errno_to_blk_status(err);
>> +			/* debug, should be removed before post patch */
>> +			bio->bi_status = BLK_STS_TIMEOUT;
> 
> You did not remove it :)

Remove it in next version LOL

> 
>> +			/* set by bio_cnt_set() in do_bio_hook() */
>> +			bio_put(bio);
>> +			/*
>> +			 * Invalidate cached data fails, don't send
>> +			 * the zone reset bio to backing device and
>> +			 * return failure. Otherwise potential data
>> +			 * corruption on bcache device may happen.
>> +			 */
>> +			goto continue_bio_complete;
>> +		}
>> +
>> +	}
>> +
>> +	/*
>> +	 * For flush or zone management bios, of cause
>> +	 * they should be sent to backing device too.
>> +	 */
>>  	bio->bi_end_io = backing_request_endio;
>>  	closure_bio_submit(s->iop.c, bio, cl);
> 
> You cannot submit a REQ_OP_ZONE_RESET_ALL to the backing dev here, at least not
> unconditionally. The problem is that if the backing dev doe not have any
> conventional zones at its LBA 0, REQ_OP_ZONE_RESET_ALL will really reset all
> zones, including the first zone of the device that contains bcache super block.
> So you will loose/destroy the bcache setup. You probably did not notice this
> because your test drive has conventional zones at LBA 0 and reset all does not
> have any effect on conventional zones...
> 
> The easy way to deal with this is to not set the QUEUE_FLAG_ZONE_RESETALL flag
> for the bcache device queue. If it is not set, the block layer will
> automatically issue only single zone REQ_OP_ZONE_RESET BIOs. That is slower,
> yes, but that cannot be avoided when the backend disk does not have any
> conventional zones. The QUEUE_FLAG_ZONE_RESETALL flag can be kept if the backend
> disk first zone containing the bcache super block is a conventional zone.
> 

You are totally right. Finally I realize why zonefs does not use
REQ_OP_ZONE_RESET_ALL and reset each non-conventional and non-offline
and non-read-only zones one-by-one. Yes, I remove the support of
REQ_OP_ZONE_RESET_ALL in next version.


>> +continue_bio_complete:
>>  	continue_at(cl, cached_dev_bio_complete, NULL);
>>  }
>>  
>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>> index d5da7ad5157d..70c31950ec1b 100644
>> --- a/drivers/md/bcache/super.c
>> +++ b/drivers/md/bcache/super.c
>> @@ -1390,6 +1390,8 @@ static int bch_cached_dev_zone_init(struct cached_dev *dc)
>>  		 */
>>  		d_q->nr_zones = b_q->nr_zones -
>>  			(dc->sb.data_offset / d_q->limits.chunk_sectors);
>> +		if (blk_queue_zone_resetall(b_q))
>> +			blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, d_q);
> 
> See above comment.
> 

Removed in next version.

>>  	}
>>  
>>  	return 0;
>>

Thank you for the detailed review comments.

Coly Li
