From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH v2 1/4] block: change REQ_OP_ZONE_RESET from 6 to 13
Date: Sat, 16 May 2020 14:50:27 +0200
Message-ID: <20200516125027.GA13730@lst.de>
References: <20200516035434.82809-1-colyli@suse.de> <20200516035434.82809-2-colyli@suse.de> <20200516123801.GB13448@lst.de> <fc0fd3c9-ea46-7c62-2a57-abd64e79cd08@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <fc0fd3c9-ea46-7c62-2a57-abd64e79cd08@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, damien.lemoal@wdc.com, hare@suse.com, axboe@kernel.dk, linux-bcache@vger.kernel.org, kbusch@kernel.org, Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@fb.com>, Johannes Thumshirn <johannes.thumshirn@wdc.com>, Shaun Tancheff <shaun.tancheff@seagate.com>
List-Id: linux-bcache@vger.kernel.org

On Sat, May 16, 2020 at 08:44:45PM +0800, Coly Li wrote:
> Yes you are right, just like REQ_OP_DISCARD which does not transfer any
> data but changes the data on device. If the request changes the stored
> data, it does transfer data.

REQ_OP_DISCARD is a special case, because most implementation end up
transferring data, it just gets attached in the low-level driver.
