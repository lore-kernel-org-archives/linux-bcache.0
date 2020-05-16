From: Coly Li <colyli@suse.de>
Subject: Re: [RFC PATCH v2 3/4] block: remove queue_is_mq restriction from
 blk_revalidate_disk_zones()
Date: Sat, 16 May 2020 21:13:50 +0800
Message-ID: <d3fe49f1-d37b-689e-ae0e-078b1254d7e7@suse.de>
References: <20200516035434.82809-1-colyli@suse.de>
 <20200516035434.82809-4-colyli@suse.de> <20200516124020.GC13448@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35870 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726202AbgEPNN6 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 16 May 2020 09:13:58 -0400
In-Reply-To: <20200516124020.GC13448@lst.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, damien.lemoal@wdc.com, hare@suse.com, axboe@kernel.dk, linux-bcache@vger.kernel.org, kbusch@kernel.org

On 2020/5/16 20:40, Christoph Hellwig wrote:
> On Sat, May 16, 2020 at 11:54:33AM +0800, Coly Li wrote:
>> The bcache driver is bio based and NOT request based multiqueued driver,
>> if a zoned SMR hard drive is used as backing device of a bcache device,
>> calling blk_revalidate_disk_zones() for the bcache device will fail due
>> to the following check in blk_revalidate_disk_zones(),
>> 478       if (WARN_ON_ONCE(!queue_is_mq(q)))
>> 479             return -EIO;
>>
>> Now bcache is able to export the zoned information from the underlying
>> zoned SMR drives and format zonefs on top of a bcache device, the
>> resitriction that a zoned device should be multiqueued is unnecessary
>> for now.
>>
>> Although in commit ae58954d8734c ("block: don't handle bio based drivers
>> in blk_revalidate_disk_zones") it is said that bio based drivers should
>> not call blk_revalidate_disk_zones() and just manually update their own
>> q->nr_zones, but this is inaccurate. The bio based drivers also need to
>> set their zone size and initialize bitmaps for cnv and seq zones, it is
>> necessary to call blk_revalidate_disk_zones() for bio based drivers.
> 
> Why would you need these bitmaps for bcache?  There is no reason to
> serialize requests for stacking drivers, and you can already derive
> if a zone is sequential or not from whatever internal information
> you use.
> 
> So without a user that actually makes sense: NAK.
> 

It is OK for me to set the zone_nr and zone size without calling
blk_revalidate_disk_zones().

Coly Li
