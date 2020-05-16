From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [RFC PATCH v2 1/4] block: change REQ_OP_ZONE_RESET from 6 to 13
Date: Sat, 16 May 2020 04:06:27 +0000
Message-ID: <BYAPR04MB496596D3B85F70D25A1C6E6986BA0@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20200516035434.82809-1-colyli@suse.de>
 <20200516035434.82809-2-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "hare@suse.com" <hare@suse.com>, "hch@lst.de" <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "kbusch@kernel.org" <kbusch@kernel.org>, Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@fb.com>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, Shaun Tancheff <shaun.tancheff@seagate.com>
List-Id: linux-bcache@vger.kernel.org

On 05/15/2020 08:55 PM, Coly Li wrote:=0A=
>   	REQ_OP_ZONE_FINISH	=3D 12,=0A=
> +	/* reset a zone write pointer */=0A=
> +	REQ_OP_ZONE_RESET	=3D 13,=0A=
=0A=
I think 13 is taken, I found this in block tree branch :-=0A=
for-5.8/block=0A=
=0A=
316         REQ_OP_ZONE_FINISH      =3D 12,=0A=
317         /* write data at the current zone write pointer */=0A=
318         REQ_OP_ZONE_APPEND      =3D 13,=0A=
