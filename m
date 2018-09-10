From: Junhui Tang <tang.junhui.linux@gmail.com>
Subject: Re: [PATCH] bcache: remove redundant condition before debugfs_remove
Date: Mon, 10 Sep 2018 08:50:11 +0800
Message-ID: <CA+NNRhENeguvt7dXY=F_2NaD=ihMbAQ8R-MN9mZf73YmU9mEwQ@mail.gmail.com>
References: <1536411327-30127-1-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1536411327-30127-1-git-send-email-zhongjiang@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: zhongjiang@huawei.com
Cc: colyli@suse.de, Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

LGTM

Reviewed-by: tang.junhui.linux@gmail.com
zhong jiang <zhongjiang@huawei.com> =E4=BA=8E2018=E5=B9=B49=E6=9C=888=E6=97=
=A5=E5=91=A8=E5=85=AD =E4=B8=8B=E5=8D=889:08=E5=86=99=E9=81=93=EF=BC=9A
>
> debugfs_remove has taken the IS_ERR_OR_NULL into account. Just
> remove the unnecessary condition.
>
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
> ---
>  drivers/md/bcache/super.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 2d26f9e..a3d2a94 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1506,8 +1506,7 @@ static void cache_set_free(struct closure *cl)
>         struct cache *ca;
>         unsigned int i;
>
> -       if (!IS_ERR_OR_NULL(c->debug))
> -               debugfs_remove(c->debug);
> +       debugfs_remove(c->debug);
>
>         bch_open_buckets_free(c);
>         bch_btree_cache_free(c);
> --
> 1.7.12.4
>
