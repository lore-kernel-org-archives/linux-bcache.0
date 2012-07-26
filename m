From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] bcache: Update git repository address in user document
Date: Thu, 26 Jul 2012 14:07:41 -0700
Message-ID: <20120726210741.GG8673@moria.home.lan>
References: <1343327778-27374-1-git-send-email-guoliang@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1343327778-27374-1-git-send-email-guoliang-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Liang Guo <bluestonechina-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liang Guo <guoliang-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Thanks, applied.

On Fri, Jul 27, 2012 at 02:36:18AM +0800, Liang Guo wrote:
> Signed-off-by: Liang Guo <guoliang-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
> ---
>  Documentation/bcache.txt |    4 ++--
>  1 =E4=B8=AA=E6=96=87=E4=BB=B6=E8=A2=AB=E4=BF=AE=E6=94=B9=EF=BC=8C=E6=
=8F=92=E5=85=A5 2 =E8=A1=8C(+)=EF=BC=8C=E5=88=A0=E9=99=A4 2 =E8=A1=8C(-=
)
>=20
> diff --git a/Documentation/bcache.txt b/Documentation/bcache.txt
> index d42b876..6928299 100644
> --- a/Documentation/bcache.txt
> +++ b/Documentation/bcache.txt
> @@ -3,8 +3,8 @@ nice if you could use them as cache... Hence bcache.
> =20
>  Wiki and git repositories are at:
>    http://bcache.evilpiepirate.org
> -  http://evilpiepirate.org/~kent/linux-bcache.git
> -  http://evilpiepirate.org/~kent/bcache-tools.git
> +  http://evilpiepirate.org/git/linux-bcache.git
> +  http://evilpiepirate.org/git/bcache-tools.git
> =20
>  It's designed around the performance characteristics of SSDs - it on=
ly allocates
>  in erase block sized buckets, and it uses a hybrid btree/log to trac=
k cached
> --=20
> 1.7.10.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
