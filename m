From: Slava Pestov <sp@datera.io>
Subject: Re: [PATCH] bcache: add mutex lock for bch_is_open
Date: Fri, 18 Jul 2014 00:12:25 -0700
Message-ID: <CACHGV4LA+-V18t+d3vJvXj5KHqOfchgTzp7KNHxgW2-ubu1gYw@mail.gmail.com>
References: <1405267739-5063-1-git-send-email-samuel.huo@gmail.com>
	<1405267739-5063-2-git-send-email-samuel.huo@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:33644 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbaGRHM0 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 18 Jul 2014 03:12:26 -0400
Received: by mail-oa0-f50.google.com with SMTP id g18so2448251oah.37
        for <linux-bcache@vger.kernel.org>; Fri, 18 Jul 2014 00:12:25 -0700 (PDT)
In-Reply-To: <1405267739-5063-2-git-send-email-samuel.huo@gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jianjian Huo <samuel.huo@gmail.com>
Cc: linux-bcache@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>

Nice catch, applied.

On Sun, Jul 13, 2014 at 9:08 AM, Jianjian Huo <samuel.huo@gmail.com> wrote:
> Since bch_is_open will iterate linked list bch_cache_sets and
> uncached_devices, it needs bch_register_lock.
>
> Signed-off-by: Jianjian Huo <samuel.huo@gmail.com>
> ---
>  drivers/md/bcache/super.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 92dcbfd..3391c53 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1933,10 +1933,12 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>         if (IS_ERR(bdev)) {
>                 if (bdev == ERR_PTR(-EBUSY)) {
>                         bdev = lookup_bdev(strim(path));
> +                       mutex_lock(&bch_register_lock);
>                         if (!IS_ERR(bdev) && bch_is_open(bdev))
>                                 err = "device already registered";
>                         else
>                                 err = "device busy";
> +                       mutex_unlock(&bch_register_lock);
>                 }
>                 goto err;
>         }
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
