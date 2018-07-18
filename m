From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH v3 3/3] lib/test_crc: Add test cases for crc calculation
Date: Wed, 18 Jul 2018 22:53:46 +0800
Message-ID: <a654b141-dafc-2dcc-19ff-c34edf558578@suse.de>
References: <20180717145525.50852-1-colyli@suse.de>
 <20180717145525.50852-4-colyli@suse.de>
 <346998e5-8798-e8f0-ccaa-a9d4810b68f5@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <346998e5-8798-e8f0-ccaa-a9d4810b68f5@infradead.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Kate Stewart <kstewart@linuxfoundation.org>
List-Id: linux-bcache@vger.kernel.org

On 2018/7/18 12:57 AM, Randy Dunlap wrote:
> Hi,
> 
> On 07/17/2018 07:55 AM, Coly Li wrote:
> 
>> diff --git a/lib/test_crc.c b/lib/test_crc.c
>> new file mode 100644
>> index 000000000000..441bf835fbd3
>> --- /dev/null
>> +++ b/lib/test_crc.c
>> @@ -0,0 +1,138 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * CRC test driver
>> + *
>> + * Copyright (C) 2018 Coly Li <colyli@suse.de>
>> + *
> 
>> +
>> +static int __init test_crc_init(void)
>> +{
>> +	int i;
>> +	int v, err = 0;
>> +
>> +	pr_info("Kernel CRC consitency testing:\n");
> 
> 	                    consistency
> 

Fixed in v4 series. Thanks.

Coly Li


[snipped]
