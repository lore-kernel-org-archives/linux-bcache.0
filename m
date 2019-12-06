From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [PATCH 1/2] [PATCH] bcache: cached_dev_free needs to put the sb
 page
Date: Fri, 6 Dec 2019 23:08:55 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1912062308370.11561@mx.ewheeler.net>
References: <1575622543-22470-1-git-send-email-liangchen.linux@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1575622543-22470-1-git-send-email-liangchen.linux@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Liang Chen <liangchen.linux@gmail.com>
Cc: colyli@suse.de, kent.overstreet@gmail.com, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On Fri, 6 Dec 2019, Liang Chen wrote:

> Same as cache device, the buffer page needs to be put while
> freeing cached_dev.  Otherwise a page would be leaked every
> time a cached_dev is stopped.
> 
> Signed-off-by: Liang Chen <liangchen.linux@gmail.com>


+cc stable?

--
Eric Wheeler


> ---
>  drivers/md/bcache/super.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 77e9869345e7..a573ce1d85aa 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1275,6 +1275,9 @@ static void cached_dev_free(struct closure *cl)
>  
>  	mutex_unlock(&bch_register_lock);
>  
> +	if (dc->sb_bio.bi_inline_vecs[0].bv_page)
> +		put_page(bio_first_page_all(&dc->sb_bio));
> +
>  	if (!IS_ERR_OR_NULL(dc->bdev))
>  		blkdev_put(dc->bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
>  
> -- 
> 2.17.0
> 
> 
