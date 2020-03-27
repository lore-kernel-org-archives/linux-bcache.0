From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [PATCH 4/5] block: simplify queue allocation
Date: Fri, 27 Mar 2020 16:24:25 +0000
Message-ID: <SN4PR0401MB3598AD1669D1F5BFCA4F20379BCC0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200327083012.1618778-1-hch@lst.de>
 <20200327083012.1618778-5-hch@lst.de>
 <SN4PR0401MB3598BF20E4DCF8F1B129625E9BCC0@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <20200327112131.GA1096@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:5760 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbgC0QY1 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Mar 2020 12:24:27 -0400
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>

On 27/03/2020 12:21, Christoph Hellwig wrote:=0A=
> Because the two variants are rather pointless.  And this might get=0A=
> more people to actually pass a useful node ID instead of copy and=0A=
> pasting some old example code. =0A=
=0A=
So then everybody will copy the NUMA_NO_NODE ones and in X years someone =
=0A=
will come up with a wrapper passing in NUMA_NO_NODE to =0A=
blk_alloc_queue_node(), because he/she didn't read the commit history.=0A=
=0A=
But if I'm the only one objecting to it,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
