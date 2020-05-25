From: Coly Li <colyli@suse.de>
Subject: Re: [RFC PATCH v4 0/3] bcache: support zoned device as bcache backing
 device
Date: Mon, 25 May 2020 16:14:15 +0800
Message-ID: <f9b8d7a4-2cdb-9c65-81a7-a1fbabb47159@suse.de>
References: <20200522121837.109651-1-colyli@suse.de>
 <CY4PR04MB3751BEA457F5B95A4D6EFB01E7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54498 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730769AbgEYIOV (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 25 May 2020 04:14:21 -0400
In-Reply-To: <CY4PR04MB3751BEA457F5B95A4D6EFB01E7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>

On 2020/5/25 13:25, Damien Le Moal wrote:
> On 2020/05/22 21:19, Coly Li wrote:
>> Hi folks,
>>
>> This is series, now bcache can support zoned device (e.g. host managed
>> SMR hard drive) as the backing deice. Currently writeback mode is not
>> support yet, which is on the to-do list (requires on-disk super block
>> format change).
>>
>> The first patch makes bcache to export the zoned information to upper
>> layer code, for example formatting zonefs on top of the bcache device.
>> By default, zone 0 of the zoned device is fully reserved for bcache
>> super block, therefore the reported zones number is 1 less than the
>> exact zones number of the physical SMR hard drive.
>>
>> The second patch handles zone management command for bcache. Indeed
>> these zone management commands are wrappered as zone management bios.
>> For REQ_OP_ZONE_RESET and REQ_OP_ZONE_RESET_ALL zone management bios,
>> before forwarding the bio to backing device, all cached data covered
>> by the resetting zone(s) must be invalidated to keep data consistency.
>> For rested zone management bios just minus the bi_sector by data_offset
>> and simply forward to the zoned backing device.
>>
>> The third patch is to make sure after bcache device starts, the cache
>> mode cannot be changed to writeback via sysfs interface. Bcache-tools
>> is modified to notice users and convert to writeback mode to the default
>> writethrough mode when making a bcache device.
>>
>> There is one thing not addressed by this series, that is re-write the
>> bcache super block after REQ_OP_ZONE_RESET_ALL command. There will be
>> quite soon that all seq zones device may appear, but it is OK to make
>> bcache support such all seq-zones device a bit later.
>>
>> Now a bcache device created with a zoned SMR drive can pass these test
>> cases,
>> - read /sys/block/bcache0/queue/zoned, content is 'host-managed'
>> - read /sys/block/bcache0/queue/nr_zones, content is number of zones
>>   excluding zone 0 of the backing device (reserved for bcache super
>>   block).
>> - read /sys/block/bcache0/queue/chunk_sectors, content is zone size
>>   in sectors.
>> - run 'blkzone report /dev/bcache0', all zones information displayed.
>> - run 'blkzone reset -o <zone LBA> -c <zones number> /dev/bcache0',
>>   conventional zones will reject the command, seqential zones covered
>>   by the command range will reset its write pointer to start LBA of
>>   their zones. If <zone LBA> is 0 and <zones number> covers all zones,
>>   REQ_OP_ZONE_RESET_ALL command will be received and handled by bcache
>>   device properly.
>> - zonefs can be created on top of the bcache device, with/without cache
>>   device attached. All sequential direct write and random read work well
>>   and zone reset by 'truncate -s 0 <zone file>' works too.
>> - Writeback cache mode does not support yet.
>>
>> Now all prevous code review comments are addressed by this RFC version.
>> Please don't hesitate to offer your opinion on this version.
>>
>> Thanks in advance for your help.
> 
> Coly,
> 
> One more thing: your patch series lacks support for REQ_OP_ZONE_APPEND. It would
> be great to add that. As is, since you do not set the max_zone_append_sectors
> queue limit for the bcache device, that command will not be issued by the block
> layer. But zonefs (and btrfs) will use zone append in (support for zonefs is
> queued already in 5.8, btrfs will come later).

Hi Damien,

Thank you for the suggestion, I will work on it now and post in next
version.

> 
> If bcache writethrough policy results in a data write to be issued to both the
> backend device and the cache device, then some special code will be needed:
> these 2 BIOs will need to be serialized since the actual write location of a
> zone append command is known only on completion of the command. That is, the
> zone append BIO needs to be issued to the backend device first, then to the
> cache SSD device as a regular write once the zone append completes and its write
> location is known.
> 

Copied. It should be OK for bcache. For writethrough mode the data will
be inserted into SSD only after bio to the backing storage accomplished.

Thank you for all your comments, I start to work on your comments on the
series and reply your comments (maybe with more questions) latter.

Coly Li
