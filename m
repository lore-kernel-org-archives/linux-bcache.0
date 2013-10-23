From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: Re: [PATCH] bcache: Fixed incorrect order of arguments to bio_alloc_bioset()
Date: Wed, 23 Oct 2013 13:06:03 +0400
Message-ID: <CACaajQskzQdSGJ_8hG-1t7L173jTaN4poYbM8NX_sP_-9kUt8A@mail.gmail.com>
References: <1382481353-4300-1-git-send-email-kmo@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1382481353-4300-1-git-send-email-kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Does this can crash or destroy data? Does i need more speed to apply
it to my own kernel or i can wait?
Thanks!

2013/10/23 Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>:
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
>                 if (bio->bi_rw & REQ_FLUSH) {
>                         /* Also need to send a flush to the backing device */
> -                       struct bio *flush = bio_alloc_bioset(0, GFP_NOIO,
> +                       struct bio *flush = bio_alloc_bioset(GFP_NOIO, 0,
>                                                              dc->disk.bio_split);
>
>                         flush->bi_rw    = WRITE_FLUSH;
> --
> 1.8.4.rc3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
