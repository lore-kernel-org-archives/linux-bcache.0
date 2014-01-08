From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: [PATCH 1/3] bcache: For back device, stripe_size get the small
 value between "1 << 31" and the io_opt of request_queue of back device.
Date: Wed, 8 Jan 2014 13:33:03 -0800
Message-ID: <20140108213303.GF7291@kmo-pixel>
References: <201401081939186527303@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:34703 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbaAHVbq (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 8 Jan 2014 16:31:46 -0500
Received: by mail-pb0-f44.google.com with SMTP id rq2so2118845pbb.3
        for <linux-bcache@vger.kernel.org>; Wed, 08 Jan 2014 13:31:46 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <201401081939186527303@gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-bcache <linux-bcache@vger.kernel.org>

On Wed, Jan 08, 2014 at 07:39:21PM +0800, majianpeng wrote:
> Let's the stripe_size of back device is io_opt of request_queue make
> good sense.
> 
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/md/bcache/super.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index c57bfa0..21f77c1 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -759,11 +759,15 @@ static int bcache_device_init(struct bcache_device *d, unsigned block_size,
>  			      sector_t sectors)
>  {
>  	struct request_queue *q;
> +	struct cached_dev *dc;
>  	size_t n;
>  	int minor;
>  
> +	dc = container_of(d, struct cached_dev, disk);
> +	q = bdev_get_queue(dc->bdev);
> +
>  	if (!d->stripe_size)
> -		d->stripe_size = 1 << 31;
> +		d->stripe_size = min_t(unsigned, 1 << 31, q->limits.io_opt);
>  
>  	d->nr_stripes = DIV_ROUND_UP_ULL(sectors, d->stripe_size);

We only care about stripe size if we're trying to flush dirty data by
stripe - this is for writeback with raid5/6 stripe awareness. There's
currently no way to enable this functionality, the patch that enables it
is going into 3.14.

If we don't have that stuff enabled, we only care about stripes insofar
as we have to track dirty data at _some_ granularity.
