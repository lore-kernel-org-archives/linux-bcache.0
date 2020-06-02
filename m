From: Coly Li <colyli@suse.de>
Subject: Re: [RFC PATCH v4 1/3] bcache: export bcache zone information for
 zoned backing device
Date: Tue, 2 Jun 2020 20:50:45 +0800
Message-ID: <c6492f79-423e-b37c-261c-80e4b26081ab@suse.de>
References: <20200522121837.109651-1-colyli@suse.de>
 <20200522121837.109651-2-colyli@suse.de>
 <CY4PR04MB37519681E8730119C1C74A75E7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
 <1c124ebe-3f1c-6715-0c1b-245ae18ec012@suse.de>
 <9ad1e32ddd1d93ad4120723d23446160a0877752.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53080 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbgFBMuz (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 2 Jun 2020 08:50:55 -0400
In-Reply-To: <9ad1e32ddd1d93ad4120723d23446160a0877752.camel@wdc.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Cc: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hare@suse.com" <hare@suse.com>

On 2020/6/2 16:48, Damien Le Moal wrote:
> On Mon, 2020-06-01 at 20:34 +0800, Coly Li wrote:
>> [...]
>>>> +
>>>> +	/* convert back to LBA of the bcache device*/
>>>> +	zone->start -= data_offset;
>>>> +	zone->wp -= data_offset;
>>>
>>> This has to be done depending on the zone type and zone condition: zone->wp is
>>> "invalid" for conventional zones, and sequential zones that are full, read-only
>>> or offline. So you need something like this:
>>>
>>> 	/* Remap LBA to the bcache device */
>>> 	zone->start -= data_offset;
>>> 	switch(zone->cond) {
>>> 	case BLK_ZONE_COND_NOT_WP:
>>> 	case BLK_ZONE_COND_READONLY:
>>> 	case BLK_ZONE_COND_FULL:
>>> 	case BLK_ZONE_COND_OFFLINE:
>>> 		break;
>>> 	case BLK_ZONE_COND_EMPTY:
>>> 		zone->wp = zone->start;
>>> 		break;
>>> 	default:
>>> 		zone->wp -= data_offset;
>>> 		break;
>>> 	}
>>>
>>> 	return args->orig_cb(zone, idx, args->orig_data);
>>>
>>
>> Hmm, do we have a unified spec to handle the wp on different zone
>> condition ?
> 
> This comes from SCSI ZBC and ATA ZAC specifications, version r05 of the
> documents for both (ratified specifications). These 2 specifications
> define identical semantic and states for SMR zones. Upcoming NVMe ZNS
> has similar and compatible zone management too.
> 
>> In zonefs I see zone->wp sets to zone->start for,
>> - BLK_ZONE_COND_OFFLINE
>> - BLK_ZONE_COND_READONLY
> 
> This is because zonefs uses a zone write pointer position for the file
> size: file size = zone->wp - zone->start;
> For the read-only and offline zone conditions, since the wp given by
> the drive is defined as "invalid", so unknown, zonefs changes the wp to
> zone start to make the file size 0 and prevent any read IO issuing.
> 
>>
>> In sd_zbc.c, I see wp sets to end of the zone for
>> - BLK_ZONE_COND_FULL
> 
> This is only to be nice to host software users, so that the wp position
> relative to the zone start is exactly the zone size, indicating that
> the entire zone was written. This allows to have equivalence between
> the tests
> 
> zone->cond == BLK_ZONE_COND_FULL
> 
> and
> 
> zone->wp == zone->start + zone->len
> 
> to make coding easier. But the fact remain that the value given for the
> wp of a full zone by the disk is undefined. Generally, drives return
> 0xfffff...ffff.
> 

Copied. Thanks for the above information.


>> And in dm.c I see zone->wp is set to zone->start for,
>> - BLK_ZONE_COND_EMPTY
> 
> That is because like bcache, dm may remap zones to indicate sector
> values that make sense for the target device. The values given by the
> physical underlying disk cannot be used as is. The code snippet above I
> sent does the same for the same reason.
> 
>> It seems except for BLK_ZONE_COND_NOT_WP, for other conditions the
>> writer pointer should be taken cared by device driver already.
> 
> The physical drive device driver gives you what the disk indicated,
> modulo the change for full zone. Bcache *is* a device driver too,
> driver of the target device. The report zones method for that device
> needs to take care of the zone remapping if needed. That is not for the
> underlying physical device driver lower in the stack to do this as that
> layer does not know how the drive is being used.
> 


Copied, thanks for the information :-)

>> So I write such switch-case in the following way by the inspair of your
>> comments,
>>
>>         /* Zone 0 should not be reported */
>>         if(WARN_ON_ONCE(zone->start < data_offset))
>>                 return -EIO;
> 
> That depends on the start sector specified when blkdev_report_zones()
> is called. Beware to have the start sector being >= zone size. That is,
> that report start sector needs remapping too.
> 

Because zones before data_offset should not visible by upper layer code,
such zones should not be sent to cached_dev_report_zones_cb(). This is a
double check that caller of cached_dev_report_zones_cb() does things in
correct way.


>>         /* convert back to LBA of the bcache device*/
>>         zone->start -= data_offset;
>>         if (zone->cond != BLK_ZONE_COND_NOT_WP)
>>                 zone->wp -= data_offset;
> 
> Since you have the BLK_ZONE_COND_NOT_WP condition in the switch-case,
> this is not needed. 
> 
>>
>>         switch (zone->cond) {
>>         case BLK_ZONE_COND_NOT_WP:
>>                 /* No write pointer available */
>>                 break;
>>         case BLK_ZONE_COND_EMPTY:
> 
> zone->wp = zone->start;
> 

Correct me if I am wrong. I assume when the zone is in empty condition,
LBA of zone->wp should be exactly equal to zone->start before bcache
does the conversion. Therefore 'zone->wp - data_offset' should still be
equal to 'zone->start - data_offset'. Therefore explicitly handle it in
'case BLK_ZONE_COND_EMPTY:' should be equal to handle it in 'default:' part.

Just want to double check I understand the wp correctly, thanks.


> needs to ba added here so that your wp is remapped.
> 
>>         case BLK_ZONE_COND_READONLY:
>>         case BLK_ZONE_COND_OFFLINE:
>>                 /*
>>                  * If underlying device driver does not properly
>>                  * set writer pointer, warn and fix it.
>>                  */
>>                 if (WARN_ON_ONCE(zone->wp != zone->start))
>>                         zone->wp = zone->start;
> 
> This is not needed. The wp value is undefined for these conditions.
> touching it, looking at it or even thinking of it does not make sense
> :) So leave the wp as is for these 2 cases.

Copied.

> 
>>                 break;
>>         case BLK_ZONE_COND_FULL:
>>                 /*
>>                  * If underlying device driver does not properly
>>                  * set writer pointer, warn and fix it.
>>                  */
>>                 if (WARN_ON_ONCE(zone->wp != zone->start + zone->len))
>>                         zone->wp = zone->start + zone->len;
> 
> Simply unconditionally set the wp to zone->start + zone->len. No WARN
> ON needed at all. I actually forgot this case in the code snippet I
> sent.

Copied.


> 
>>                 break;
>>         default:
>>                 break;
>>         }
>>
>>         return args->orig_cb(zone, idx, args->orig_data);
>>
>> The above code converts zone->wp by minus data_offset for
>> non-BLK_ZONE_COND_NOT_WP condition. And for other necessary conditions,
>> I just check whether the underlying device driver updates write pointer
>> properly (as I observed in other drivers), if not then drop a warning
>> and fix the write pointer to the expected value.
> 
> The wp essentially comes from the drive. Except for a full zone, the
> value is passed on as is by the driver. The physical device driver does
> not "set" the wp.
> 
>> Now the write pointer is only fixed when it was wrong value. If the
>> underlying device driver does not maintain the value properly, we figure
>> out and fix it.
> 
> The wp will be a wrong value only if the drive you are using has a
> firmware bug. The "fixing" needed is because bcache device needs
> remapping (off-by-one-zone) of the physical device zone
> information. That is for bcache to do. And that remapping needs to be
> done carefully since some wp values are undefined. Your code above as
> is will for instance change the wp value from "undefined"
> (0xffffffffffffffff for drives out there, generally, but it could be
> anything) to "undefined - data_offset" for any readonly or offline
> zone. The result is still "undefined"... Doing that kind of operation
> on the wp is not necessary at all and does not serve any useful
> purpose.

I see. Now it is more clear to me. Thanks.

Coly Li
