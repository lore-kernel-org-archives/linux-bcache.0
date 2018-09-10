From: Junhui Tang <tang.junhui.linux@gmail.com>
Subject: Re: [PATCH] bcache: remove unecessary condition check before debugfs_remove_recursive
Date: Mon, 10 Sep 2018 08:50:28 +0800
Message-ID: <CA+NNRhFgQbdPjoX0ePP1fM5rFiBnrD5PLtxs2fE92Xg5V=_ing@mail.gmail.com>
References: <1536413350-31523-1-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1536413350-31523-1-git-send-email-zhongjiang@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: zhongjiang@huawei.com
Cc: colyli@suse.de, Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

LGTM

Reviewed-by: tang.junhui.linux@gmail.com
zhong jiang <zhongjiang@huawei.com> =E4=BA=8E2018=E5=B9=B49=E6=9C=888=E6=97=
=A5=E5=91=A8=E5=85=AD =E4=B8=8B=E5=8D=889:41=E5=86=99=E9=81=93=EF=BC=9A
>
> debugfs_remove_recursive has taken IS_ERR_OR_NULL into account. So just
> remove the condition check before debugfs_remove_recursive.
>
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
> ---
>  drivers/md/bcache/debug.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
> index 06da66b..8c53d87 100644
> --- a/drivers/md/bcache/debug.c
> +++ b/drivers/md/bcache/debug.c
> @@ -249,8 +249,7 @@ void bch_debug_init_cache_set(struct cache_set *c)
>
>  void bch_debug_exit(void)
>  {
> -       if (!IS_ERR_OR_NULL(bcache_debug))
> -               debugfs_remove_recursive(bcache_debug);
> +       debugfs_remove_recursive(bcache_debug);
>  }
>
>  void __init bch_debug_init(struct kobject *kobj)
> --
> 1.7.12.4
>
