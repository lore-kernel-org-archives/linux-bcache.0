From: Coly Li <colyli@suse.de>
Subject: Re: [RFC PATCH v2 1/4] block: change REQ_OP_ZONE_RESET from 6 to 13
Date: Sat, 16 May 2020 21:05:39 +0800
Message-ID: <f57da1e7-1563-db1e-8730-8daca219cbe7@suse.de>
References: <20200516035434.82809-1-colyli@suse.de>
 <20200516035434.82809-2-colyli@suse.de> <20200516123801.GB13448@lst.de>
 <fc0fd3c9-ea46-7c62-2a57-abd64e79cd08@suse.de>
 <20200516125027.GA13730@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34670 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726206AbgEPNFs (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 16 May 2020 09:05:48 -0400
In-Reply-To: <20200516125027.GA13730@lst.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, damien.lemoal@wdc.com, hare@suse.com, axboe@kernel.dk, linux-bcache@vger.kernel.org, kbusch@kernel.org, Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@fb.com>, Johannes Thumshirn <johannes.thumshirn@wdc.com>, Shaun Tancheff <shaun.tancheff@seagate.com>

On 2020/5/16 20:50, Christoph Hellwig wrote:
> On Sat, May 16, 2020 at 08:44:45PM +0800, Coly Li wrote:
>> Yes you are right, just like REQ_OP_DISCARD which does not transfer any
>> data but changes the data on device. If the request changes the stored
>> data, it does transfer data.
> 
> REQ_OP_DISCARD is a special case, because most implementation end up
> transferring data, it just gets attached in the low-level driver.
> 

Yes, REQ_OP_ZONE_RESET and REQ_OP_ZONE_RESET_ALL are quite similar to
REQ_OP_DISCARD. Data read from the LBA range of reset zone is not
suggested and the content is undefined.

For bcache, similar to REQ_OP_DISCARD, REQ_OP_ZONE_RESET and
REQ_OP_ZONE_RESET_ALL are handled in same way: If the backing device
supports discard/zone_reset, and the operation successes, then cached
data on SSD covered by the LBA range should be invalid, otherwise users
will read outdated and garbage data.

We should treat REQ_OP_ZONE_RESET and REQ_OP_ZONE_RESET_ALL being in
WRITE direction.

Coly Li
