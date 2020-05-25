From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [RFC PATCH v4 3/3] bcache: reject writeback cache mode for zoned
 backing device
Date: Mon, 25 May 2020 01:26:34 +0000
Message-ID: <CY4PR04MB3751EF222D4DFFB9C05AB38EE7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200522121837.109651-1-colyli@suse.de>
 <20200522121837.109651-4-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
List-Id: linux-bcache@vger.kernel.org

On 2020/05/22 21:19, Coly Li wrote:=0A=
> Currently we don't support writeback mode for zoned device as backing=0A=
> device. So reject it by sysfs interface.=0A=
> =0A=
> This rejection will be removed after the writeback cache mode support=0A=
> for zoned device gets done.=0A=
> =0A=
> Signed-off-by: Coly Li <colyli@suse.de>=0A=
> Cc: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> Cc: Hannes Reinecke <hare@suse.com>=0A=
> Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
> ---=0A=
>  drivers/md/bcache/sysfs.c | 5 +++++=0A=
>  1 file changed, 5 insertions(+)=0A=
> =0A=
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c=0A=
> index 323276994aab..41bdbc42a17d 100644=0A=
> --- a/drivers/md/bcache/sysfs.c=0A=
> +++ b/drivers/md/bcache/sysfs.c=0A=
> @@ -359,6 +359,11 @@ STORE(__cached_dev)=0A=
>  		if (v < 0)=0A=
>  			return v;=0A=
>  =0A=
> +		if ((unsigned int) v =3D=3D CACHE_MODE_WRITEBACK) {=0A=
> +			pr_err("writeback mode is not supported for zoned backing device.\n")=
;=0A=
> +			return -ENOTSUPP;=0A=
> +		}=0A=
> +=0A=
>  		if ((unsigned int) v !=3D BDEV_CACHE_MODE(&dc->sb)) {=0A=
>  			SET_BDEV_CACHE_MODE(&dc->sb, v);=0A=
>  			bch_write_bdev_super(dc, NULL);=0A=
> =0A=
=0A=
Do you have a similar check in bcache user tools at format time ? Or is the=
=0A=
cache mode specified only when the bcache device is started ?=0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
