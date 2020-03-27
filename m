From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 4/5] block: simplify queue allocation
Date: Fri, 27 Mar 2020 10:26:53 -0600
Message-ID: <a2110f00-6d27-1567-2725-3afb2e83ea5f@kernel.dk>
References: <20200327083012.1618778-1-hch@lst.de>
 <20200327083012.1618778-5-hch@lst.de>
 <SN4PR0401MB3598BF20E4DCF8F1B129625E9BCC0@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <20200327112131.GA1096@lst.de>
 <SN4PR0401MB3598AD1669D1F5BFCA4F20379BCC0@SN4PR0401MB3598.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <SN4PR0401MB3598AD1669D1F5BFCA4F20379BCC0@SN4PR0401MB3598.namprd04.prod.outlook.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, Christoph Hellwig <hch@lst.de>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-bcache@vger.kernel.org

On 3/27/20 10:24 AM, Johannes Thumshirn wrote:
> On 27/03/2020 12:21, Christoph Hellwig wrote:
>> Because the two variants are rather pointless.  And this might get
>> more people to actually pass a useful node ID instead of copy and
>> pasting some old example code. 
> 
> So then everybody will copy the NUMA_NO_NODE ones and in X years someone 
> will come up with a wrapper passing in NUMA_NO_NODE to 
> blk_alloc_queue_node(), because he/she didn't read the commit history.

If you care about numa-node, then you are generally using it for other
allocations as well, so it should come naturally. If you don't, then
the copy/paste is fine. Better to expose it as the main API, so people
don't miss it.

-- 
Jens Axboe
