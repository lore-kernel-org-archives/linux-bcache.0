From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 2/2] bcache: add undef for macro in function
Date: Wed, 15 Aug 2018 00:25:25 +0800
Message-ID: <a223a080-6fbe-36cb-8085-361294a89c96@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "cdbdyx@163.com" <cdbdyx@163.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, kent.overstreet@gmail.com
List-Id: linux-bcache@vger.kernel.org

On 2018/8/14 10:59 PM, cdbdyx@163.com wrote:
> Hi Coly，
> The three macros is only locally used in func "__cached_dev"，I think
> they should be undefined before leaving the func.
> 

Hi Dongbo,

It is worthy to do this if there is a potential conflict. But they are
defined in sysfs.c and not exported to anywhere else, I guess there
won't be any symbol conflict. Then we don't need to worry about this.

Coly Li


> ---Original---
> *From:* "Coly Li"<colyli@suse.de>
> *Date:* Tue, Aug 14, 2018 20:16 PM
> *To:* "Dongbo Cao"<cdbdyx@163.com>;
> *Cc:*
> "linux-kernel"<linux-kernel@vger.kernel.org>;"linux-bcache"<linux-bcache@vger.kernel.org>;"kent.overstreet"<kent.overstreet@gmail.com>;
> *Subject:* Re: [PATCH 2/2] bcache: add undef for macro in function
> 
> On 2018/8/14 4:16 PM, Dongbo Cao wrote:
>> add undef for macro d_strtoul,d_strtoul_nonzero and d_strtoi_h
>> 
>> Signed-off-by: Dongbo Cao 
>> ---
>>  drivers/md/bcache/sysfs.c | 3 +++
>>  1 file changed, 3 insertions(+)
>> 
>> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
>> index 225b15aa..ed67a290 100644
>> --- a/drivers/md/bcache/sysfs.c
>> +++ b/drivers/md/bcache/sysfs.c
>> @@ -349,6 +349,9 @@ STORE(__cached_dev)
>>   if (attr == &sysfs_stop)
>>   bcache_device_stop(&dc->disk);
>>  
>> +#undef d_strtoul
>> +#undef d_strtoul_nonzero
>> +#undef d_strtoi_h
>>   return size;
>>  }
>>  
>> 
> 
> Hi Dongbo,
> 
> Could you please to provide the motivation why you make this change ?
> 
> Thanks.
> 
> Coly Li
