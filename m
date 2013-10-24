From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH] bcache: Fixed incorrect order of arguments to
 bio_alloc_bioset()
Date: Thu, 24 Oct 2013 13:04:06 +0100
Message-ID: <20131024120406.GY14598@kernel.dk>
References: <1382481353-4300-1-git-send-email-kmo@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1382481353-4300-1-git-send-email-kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Tue, Oct 22 2013, Kent Overstreet wrote:
> Signed-off-by: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
> Cc: linux-stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # >= v3.10
> ---
>  drivers/md/bcache/request.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index b6a74bc..2a7f0dd 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -1000,7 +1000,7 @@ static void request_write(struct cached_dev *dc, struct search *s)
>  
>  		if (bio->bi_rw & REQ_FLUSH) {
>  			/* Also need to send a flush to the backing device */
> -			struct bio *flush = bio_alloc_bioset(0, GFP_NOIO,
> +			struct bio *flush = bio_alloc_bioset(GFP_NOIO, 0,
>  							     dc->disk.bio_split);
>  
>  			flush->bi_rw	= WRITE_FLUSH;

Woops... Added.

-- 
Jens Axboe
