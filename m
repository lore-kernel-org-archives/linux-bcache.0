From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [PATCH 4/5] block: simplify queue allocation
Date: Fri, 27 Mar 2020 10:11:08 +0000
Message-ID: <SN4PR0401MB3598BF20E4DCF8F1B129625E9BCC0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200327083012.1618778-1-hch@lst.de>
 <20200327083012.1618778-5-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-bcache@vger.kernel.org

On 27/03/2020 09:34, Christoph Hellwig wrote:=0A=
> -struct request_queue *blk_alloc_queue(gfp_t gfp_mask)=0A=
> -{=0A=
> -	return blk_alloc_queue_node(gfp_mask, NUMA_NO_NODE);=0A=
> -}=0A=
> -EXPORT_SYMBOL(blk_alloc_queue);=0A=
=0A=
Why are you removing the non _node() variant? The memory allocation =0A=
function for instance have this indirection as well and I don't think it =
=0A=
simplifies a lot passing NUMA_NO_NODE in each block driver.=0A=
