From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/5] block: simplify queue allocation
Date: Fri, 27 Mar 2020 12:21:31 +0100
Message-ID: <20200327112131.GA1096@lst.de>
References: <20200327083012.1618778-1-hch@lst.de> <20200327083012.1618778-5-hch@lst.de> <SN4PR0401MB3598BF20E4DCF8F1B129625E9BCC0@SN4PR0401MB3598.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <SN4PR0401MB3598BF20E4DCF8F1B129625E9BCC0@SN4PR0401MB3598.namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-bcache@vger.kernel.org

On Fri, Mar 27, 2020 at 10:11:08AM +0000, Johannes Thumshirn wrote:
> On 27/03/2020 09:34, Christoph Hellwig wrote:
> > -struct request_queue *blk_alloc_queue(gfp_t gfp_mask)
> > -{
> > -	return blk_alloc_queue_node(gfp_mask, NUMA_NO_NODE);
> > -}
> > -EXPORT_SYMBOL(blk_alloc_queue);
> 
> Why are you removing the non _node() variant? The memory allocation 
> function for instance have this indirection as well and I don't think it 
> simplifies a lot passing NUMA_NO_NODE in each block driver.

Because the two variants are rather pointless.  And this might get
more people to actually pass a useful node ID instead of copy and
pasting some old example code.
