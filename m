From: Liang Chen <liangchen.linux@gmail.com>
Subject: Re: [PATCH] bcache: release the allocated id, not its multiple of BCACHE_MINORS
Date: Fri, 23 Jun 2017 19:39:30 +0800
Message-ID: <CAKhg4tKSiwFjM+SW=1ZhezdzDX215-+Ci_2xxpBM0MNuNvT32g@mail.gmail.com>
References: <1498202111-30469-1-git-send-email-liangchen.linux@gmail.com> <OF8F24365F.31FA34A2-ON48258148.00287923-48258148.002900E3@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:33240 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751287AbdFWLjc (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 23 Jun 2017 07:39:32 -0400
In-Reply-To: <OF8F24365F.31FA34A2-ON48258148.00287923-48258148.002900E3@zte.com.cn>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: bcache@linux.ewheeler.net, colyli@suse.de, linux-bcache@vger.kernel.org, linux-bcache-owner@vger.kernel.org, linux-kernel@vger.kernel.org

Sure! I will find you there:)

On Fri, Jun 23, 2017 at 3:28 PM,  <tang.junhui@zte.com.cn> wrote:
> Hello Liang chen:
>
> Please see this patch:
>
> http://www.spinics.net/lists/linux-bcache/msg04572.html
>
> Do you have a wechat account? please add me: tangjunhui1984
>
> We can talk more about bcache.
>
> Thanks.
>
>
>
> =E5=8F=91=E4=BB=B6=E4=BA=BA:         Liang Chen <liangchen.linux@gmail.co=
m>
> =E6=94=B6=E4=BB=B6=E4=BA=BA:         linux-bcache@vger.kernel.org,
> =E6=8A=84=E9=80=81:        linux-kernel@vger.kernel.org, colyli@suse.de,
> bcache@linux.ewheeler.net, Liang Chen <liangchen.linux@gmail.com>
> =E6=97=A5=E6=9C=9F:         2017/06/23 15:16
> =E4=B8=BB=E9=A2=98:        [PATCH] bcache: release the allocated id, not =
its multiple of
> BCACHE_MINORS
> =E5=8F=91=E4=BB=B6=E4=BA=BA:        linux-bcache-owner@vger.kernel.org
> ________________________________
>
>
>
> The id passed to ida_simple_remove has to be the one originally
> allocated with ida_simple_get, not the one after multipling by
> BCACHE_MINORS.
>
> Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
> ---
> drivers/md/bcache/super.c | 5 +++--
> 1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index e57353e..9f64477 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -734,7 +734,8 @@ static void bcache_device_free(struct bcache_device *=
d)
>                  if (d->disk && d->disk->queue)
>                                   blk_cleanup_queue(d->disk->queue);
>                  if (d->disk) {
> -                                  ida_simple_remove(&bcache_minor,
> d->disk->first_minor);
> +                                  ida_simple_remove(&bcache_minor,
> +
> d->disk->first_minor / BCACHE_MINORS);
>                                   put_disk(d->disk);
>                  }
>
> @@ -784,7 +785,7 @@ static int bcache_device_init(struct bcache_device *d=
,
> unsigned block_size,
>
>                  if (!(d->bio_split =3D bioset_create(4, offsetof(struct =
bbio,
> bio))) ||
>                      !(d->disk =3D alloc_disk(BCACHE_MINORS))) {
> -                                  ida_simple_remove(&bcache_minor, minor=
);
> +                                  ida_simple_remove(&bcache_minor, minor=
 /
> BCACHE_MINORS);
>                                   return -ENOMEM;
>                  }
>
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
