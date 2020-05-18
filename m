From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [RFC PATCH v2 1/4] block: change REQ_OP_ZONE_RESET from 6 to 13
Date: Mon, 18 May 2020 05:09:23 +0000
Message-ID: <BYAPR04MB4965F50C13415E486F519DC986B80@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20200516035434.82809-1-colyli@suse.de>
 <20200516035434.82809-2-colyli@suse.de>
 <BY5PR04MB69005621AE920061F7FD383CE7B80@BY5PR04MB6900.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <Damien.LeMoal@wdc.com>, Coly Li <colyli@suse.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "hch@lst.de" <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "kbusch@kernel.org" <kbusch@kernel.org>, Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@fb.com>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, Shaun Tancheff <shaun.tancheff@seagate.com>
List-Id: linux-bcache@vger.kernel.org

On 5/17/20 5:33 PM, Damien Le Moal wrote:=0A=
> As Chaitanya pointed out, this is already used. Please rebase on Jens=0A=
> block/for-5.8/block branch.=0A=
> =0A=
> I do not see any problem with this change, but as Christoph commented, si=
nce=0A=
> zone reset does not transfer any data, I do not really see the necessity =
for=0A=
> this. Zone reset is indeed data-destructive, but it is not a "write" comm=
and.=0A=
> But following DISCARD and having the op number as an odd number is OK I t=
hink.=0A=
Let's keep reset consistent with discard and write-zeroes.=0A=
