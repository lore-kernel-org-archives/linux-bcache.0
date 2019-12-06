From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 1/2] [PATCH] bcache: cached_dev_free needs to put the sb
 page
Date: Fri, 6 Dec 2019 17:42:39 +0800
Message-ID: <c7b68715-8033-3219-f51d-072a86af3b30@suse.de>
References: <1575622543-22470-1-git-send-email-liangchen.linux@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1575622543-22470-1-git-send-email-liangchen.linux@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Liang Chen <liangchen.linux@gmail.com>
Cc: kent.overstreet@gmail.com, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2019/12/6 4:55 下午, Liang Chen wrote:
> Same as cache device, the buffer page needs to be put while
> freeing cached_dev.  Otherwise a page would be leaked every
> time a cached_dev is stopped.
> 
> Signed-off-by: Liang Chen <liangchen.linux@gmail.com>

I have this in my for-test directory, thanks.

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
> 


-- 

Coly Li
