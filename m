From: Junhui Tang <tang.junhui.linux@gmail.com>
Subject: Re: [PATCH 2/2] add some safety checks for label store interface of
 flash dev in sysfs
Date: Sat, 15 Sep 2018 09:20:11 +0800
Message-ID: <CA+NNRhER-MdM=ufG0-gOPRvGysR5FuDvFRJtRNf7TX6yQDpH7w@mail.gmail.com>
References: <20180914101259.4169-1-cdbdyx@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180914101259.4169-1-cdbdyx@163.com>
Sender: linux-kernel-owner@vger.kernel.org
To: cdbdyx@163.com
Cc: colyli@suse.de, Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

Seems something wrong
when  size =3D SB_LABEL_SIZE and   u->label[size - 1] !=3D '\n'
please check again.

---------------------------------------------------------------------------
Tang Junhui
Forever me is me
---------------------------------------------------------------------------

Dongbo Cao <cdbdyx@163.com> =E4=BA=8E2018=E5=B9=B49=E6=9C=8814=E6=97=A5=E5=
=91=A8=E4=BA=94 =E4=B8=8B=E5=8D=886:13=E5=86=99=E9=81=93=EF=BC=9A
>
> do some checks on the label's length and ending.
>
> Signed-off-by: Dongbo Cao <cdbdyx@163.com>
> ---
>  drivers/md/bcache/sysfs.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index e64c718f..cce793ef 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -447,8 +447,15 @@ STORE(__bch_flash_dev)
>         }
>
>         if (attr =3D=3D &sysfs_label) {
> +               if (size > SB_LABEL_SIZE)
> +                       return -EINVAL;
>                 memcpy(u->label, buf, SB_LABEL_SIZE);
> -               bch_uuid_write(d->c);
> +               if (size < SB_LABEL_SIZE)
> +                       u->label[size] =3D '\0';
> +               if (size && u->label[size - 1] =3D=3D '\n')
> +                       u->label[size - 1] =3D '\0';
> +               if(d->c)
> +                       bch_uuid_write(d->c);
>         }
>
>         if (attr =3D=3D &sysfs_unregister) {
> --
> 2.17.1
>
>
