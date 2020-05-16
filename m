From: Coly Li <colyli@suse.de>
Subject: Re: [RFC PATCH v2 1/4] block: change REQ_OP_ZONE_RESET from 6 to 13
Date: Sat, 16 May 2020 17:33:00 +0800
Message-ID: <e370efac-b011-9fca-14f2-541b923ee350@suse.de>
References: <20200516035434.82809-1-colyli@suse.de>
 <20200516035434.82809-2-colyli@suse.de>
 <BYAPR04MB496596D3B85F70D25A1C6E6986BA0@BYAPR04MB4965.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45746 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726280AbgEPJdM (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 16 May 2020 05:33:12 -0400
In-Reply-To: <BYAPR04MB496596D3B85F70D25A1C6E6986BA0@BYAPR04MB4965.namprd04.prod.outlook.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "hare@suse.com" <hare@suse.com>, "hch@lst.de" <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "kbusch@kernel.org" <kbusch@kernel.org>, Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@fb.com>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, Shaun Tancheff <shaun.tancheff@seagate.com>

On 2020/5/16 12:06, Chaitanya Kulkarni wrote:
> On 05/15/2020 08:55 PM, Coly Li wrote:
>>   	REQ_OP_ZONE_FINISH	= 12,
>> +	/* reset a zone write pointer */
>> +	REQ_OP_ZONE_RESET	= 13,
> 
> I think 13 is taken, I found this in block tree branch :-
> for-5.8/block
> 
> 316         REQ_OP_ZONE_FINISH      = 12,
> 317         /* write data at the current zone write pointer */
> 318         REQ_OP_ZONE_APPEND      = 13,
> 

Aha, sure. Then I have to look at 15.

Thanks for the hint.

Coly Li
