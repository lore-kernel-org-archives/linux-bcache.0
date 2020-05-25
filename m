From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [PATCH] block: change REQ_OP_ZONE_RESET and REQ_OP_ZONE_RESET_ALL
 to be odd numbers
Date: Mon, 25 May 2020 04:01:38 +0000
Message-ID: <BYAPR04MB4965739982A9642376B4F52686B30@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20200522132309.112794-1-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:14629 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgEYEBk (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 25 May 2020 00:01:40 -0400
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "hare@suse.com" <hare@suse.com>, "hch@lst.de" <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@fb.com>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, Keith Busch <kbusch@kernel.org>, Shaun Tancheff <shaun.tancheff@seagate.com>

On 5/22/20 6:25 AM, Coly Li wrote:=0A=
>   	/* write data at the current zone write pointer */=0A=
>   	REQ_OP_ZONE_APPEND	=3D 13,=0A=
> +	/* reset a zone write pointer */=0A=
> +	REQ_OP_ZONE_RESET	=3D 15,=0A=
> +	/* reset all the zone present on the device */=0A=
> +	REQ_OP_ZONE_RESET_ALL	=3D 17,=0A=
>   =0A=
>   	/* SCSI passthrough using struct scsi_request */=0A=
>   	REQ_OP_SCSI_IN		=3D 32,=0A=
> =0A=
=0A=
Looks good to me.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
