From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH v2 1/4] block: change REQ_OP_ZONE_RESET from 6 to 13
Date: Sat, 16 May 2020 14:38:01 +0200
Message-ID: <20200516123801.GB13448@lst.de>
References: <20200516035434.82809-1-colyli@suse.de> <20200516035434.82809-2-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200516035434.82809-2-colyli@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-block@vger.kernel.org, damien.lemoal@wdc.com, hare@suse.com, hch@lst.de, axboe@kernel.dk, linux-bcache@vger.kernel.org, kbusch@kernel.org, Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@fb.com>, Johannes Thumshirn <johannes.thumshirn@wdc.com>, Shaun Tancheff <shaun.tancheff@seagate.com>
List-Id: linux-bcache@vger.kernel.org

On Sat, May 16, 2020 at 11:54:31AM +0800, Coly Li wrote:
> For a zoned device, e.g. host managed SMR hard drive, REQ_OP_ZONE_RESET
> is to reset the LBA of a zone's write pointer back to the start LBA of
> this zone. After the write point is reset, all previously stored data
> in this zone is invalid and unaccessible anymore. Therefore, this op
> code changes on disk data, belongs to a WRITE request op code.
> 
> Current REQ_OP_ZONE_RESET is defined as number 6, but the convention of
> the op code is, READ requests are even numbers, and WRITE requests are
> odd numbers. See how op_is_write defined,

The convention is all about data transfer, and zone reset does not
transfer any data.
