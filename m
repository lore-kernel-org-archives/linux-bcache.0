From: Junhui Tang <tang.junhui.linux@gmail.com>
Subject: Re: [PATCH] bcache: remove unnecessary null poiner check in cache_set_free
Date: Tue, 11 Sep 2018 08:59:52 +0800
Message-ID: <CA+NNRhEo-qryWzGoVbUtQVSbOhbTTwVuzAA7DYmTOcVN8oYehQ@mail.gmail.com>
References: <1536406766-27021-1-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1536406766-27021-1-git-send-email-zhongjiang@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: zhongjiang@huawei.com
Cc: colyli@suse.de, Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

This patch is NOT OK to me=EF=BC=8Cmaybe many cache in a  cache_set, and so=
me
cache are not registered yet, so ca is possible NULL.
zhong jiang <zhongjiang@huawei.com> =E4=BA=8E2018=E5=B9=B49=E6=9C=888=E6=97=
=A5=E5=91=A8=E5=85=AD =E4=B8=8B=E5=8D=887:52=E5=86=99=E9=81=93=EF=BC=9A
>
> The iterator in for_each_cache is never null, therefore, remove
> the redundant null pointer check.
>
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
> ---
>  drivers/md/bcache/super.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 94c756c..2d26f9e 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1513,12 +1513,11 @@ static void cache_set_free(struct closure *cl)
>         bch_btree_cache_free(c);
>         bch_journal_free(c);
>
> -       for_each_cache(ca, c, i)
> -               if (ca) {
> -                       ca->set =3D NULL;
> -                       c->cache[ca->sb.nr_this_dev] =3D NULL;
> -                       kobject_put(&ca->kobj);
> -               }
> +       for_each_cache(ca, c, i) {
> +               ca->set =3D NULL;
> +               c->cache[ca->sb.nr_this_dev] =3D NULL;
> +               kobject_put(&ca->kobj);
> +       }
>
>         bch_bset_sort_state_free(&c->sort);
>         free_pages((unsigned long) c->uuids, ilog2(bucket_pages(c)));
> --
> 1.7.12.4
>
