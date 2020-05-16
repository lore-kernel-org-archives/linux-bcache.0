From: Coly Li <colyli@suse.de>
Subject: Re: [RFC PATCH v2 1/4] block: change REQ_OP_ZONE_RESET from 6 to 13
Date: Sat, 16 May 2020 20:44:45 +0800
Message-ID: <fc0fd3c9-ea46-7c62-2a57-abd64e79cd08@suse.de>
References: <20200516035434.82809-1-colyli@suse.de>
 <20200516035434.82809-2-colyli@suse.de> <20200516123801.GB13448@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59570 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726206AbgEPMoz (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 16 May 2020 08:44:55 -0400
In-Reply-To: <20200516123801.GB13448@lst.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, damien.lemoal@wdc.com, hare@suse.com, axboe@kernel.dk, linux-bcache@vger.kernel.org, kbusch@kernel.org, Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@fb.com>, Johannes Thumshirn <johannes.thumshirn@wdc.com>, Shaun Tancheff <shaun.tancheff@seagate.com>

On 2020/5/16 20:38, Christoph Hellwig wrote:
> On Sat, May 16, 2020 at 11:54:31AM +0800, Coly Li wrote:
>> For a zoned device, e.g. host managed SMR hard drive, REQ_OP_ZONE_RESET
>> is to reset the LBA of a zone's write pointer back to the start LBA of
>> this zone. After the write point is reset, all previously stored data
>> in this zone is invalid and unaccessible anymore. Therefore, this op
>> code changes on disk data, belongs to a WRITE request op code.
>>
>> Current REQ_OP_ZONE_RESET is defined as number 6, but the convention of
>> the op code is, READ requests are even numbers, and WRITE requests are
>> odd numbers. See how op_is_write defined,
> 
> The convention is all about data transfer, and zone reset does not
> transfer any data.
> 

Yes you are right, just like REQ_OP_DISCARD which does not transfer any
data but changes the data on device. If the request changes the stored
data, it does transfer data.

This is why in patch "block: set bi_size to REQ_OP_ZONE_RESET bio" I set
bi_size to the REQ_OP_ZONE_RESET and REQ_OP_ZONE_RESET_ALL bios.

Coly Li
