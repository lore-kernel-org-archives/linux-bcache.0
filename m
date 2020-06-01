From: Coly Li <colyli@suse.de>
Subject: Re: [RFC PATCH v4 3/3] bcache: reject writeback cache mode for zoned
 backing device
Date: Tue, 2 Jun 2020 00:09:27 +0800
Message-ID: <72c84579-d4be-acb4-7fcb-d773ab847fd5@suse.de>
References: <20200522121837.109651-1-colyli@suse.de>
 <20200522121837.109651-4-colyli@suse.de>
 <CY4PR04MB3751EF222D4DFFB9C05AB38EE7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44504 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726075AbgFAQJd (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 1 Jun 2020 12:09:33 -0400
In-Reply-To: <CY4PR04MB3751EF222D4DFFB9C05AB38EE7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>

On 2020/5/25 09:26, Damien Le Moal wrote:
> On 2020/05/22 21:19, Coly Li wrote:
>> Currently we don't support writeback mode for zoned device as backing
>> device. So reject it by sysfs interface.
>>
>> This rejection will be removed after the writeback cache mode support
>> for zoned device gets done.
>>
>> Signed-off-by: Coly Li <colyli@suse.de>
>> Cc: Damien Le Moal <damien.lemoal@wdc.com>
>> Cc: Hannes Reinecke <hare@suse.com>
>> Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>> ---
>>  drivers/md/bcache/sysfs.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
>> index 323276994aab..41bdbc42a17d 100644
>> --- a/drivers/md/bcache/sysfs.c
>> +++ b/drivers/md/bcache/sysfs.c
>> @@ -359,6 +359,11 @@ STORE(__cached_dev)
>>  		if (v < 0)
>>  			return v;
>>  
>> +		if ((unsigned int) v == CACHE_MODE_WRITEBACK) {
>> +			pr_err("writeback mode is not supported for zoned backing device.\n");
>> +			return -ENOTSUPP;
>> +		}
>> +
>>  		if ((unsigned int) v != BDEV_CACHE_MODE(&dc->sb)) {
>>  			SET_BDEV_CACHE_MODE(&dc->sb, v);
>>  			bch_write_bdev_super(dc, NULL);
>>
> 
> Do you have a similar check in bcache user tools at format time ? Or is the
> cache mode specified only when the bcache device is started ?

Yes I do the cache mode check in bcache-tools, and if user sets
writeback mode, bcache-tools will inform user and switch it to
writethrough mode explicitly.

> 
> Looks good.
> 
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
> 

Thank you for the review!

Coly Li
