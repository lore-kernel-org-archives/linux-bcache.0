Return-Path: <SRS0=M8tx=A4=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3750AC433EC
	for <linux-bcache@archiver.kernel.org>; Fri, 17 Jul 2020 21:14:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 119AC20717
	for <linux-bcache@archiver.kernel.org>; Fri, 17 Jul 2020 21:14:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgGQVOY (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Fri, 17 Jul 2020 17:14:24 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:54132 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgGQVOY (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 17 Jul 2020 17:14:24 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 81F271C0BD7; Fri, 17 Jul 2020 23:14:21 +0200 (CEST)
Date:   Fri, 17 Jul 2020 23:14:20 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Qinglang Miao <miaoqinglang@huawei.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] memory: Convert to DEFINE_SHOW_ATTRIBUTE
Message-ID: <20200717211420.GA4140@amd>
References: <20200716090303.13154-1-miaoqinglang@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
In-Reply-To: <20200716090303.13154-1-miaoqinglang@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2020-07-16 17:03:03, Qinglang Miao wrote:
> From: Yongqiang Liu <liuyongqiang13@huawei.com>
>=20
> Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.
>=20
> Signed-off-by: Yongqiang Liu <liuyongqiang13@huawei.com>
> ---
>  drivers/memory/emif.c               | 22 ++--------------------
>  drivers/memory/tegra/tegra124-emc.c | 14 +-------------
>  2 files changed, 3 insertions(+), 33 deletions(-)
>=20
> diff --git a/drivers/memory/emif.c b/drivers/memory/emif.c
> index 58a82eea5..aab8ddad7 100644
> --- a/drivers/memory/emif.c
> +++ b/drivers/memory/emif.c
> @@ -131,16 +131,7 @@ static int emif_regdump_show(struct seq_file *s, voi=
d *unused)
>  	return 0;
>  }
> =20
> -static int emif_regdump_open(struct inode *inode, struct file *file)
> -{
> -	return single_open(file, emif_regdump_show, inode->i_private);
> -}
> -
> -static const struct file_operations emif_regdump_fops =3D {
> -	.open			=3D emif_regdump_open,
> -	.read_iter			=3D seq_read_iter,
> -	.release		=3D single_release,
> -};
> +DEFINE_SHOW_ATTRIBUTE(emif_regdump);

This is not equivalent (and I guess changelog should mention that).

Along with other changes, we get:

        .owner          =3D THIS_MODULE,
        .llseek         =3D seq_lseek,

=2E Is that okay thing to add?
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl8SFKwACgkQMOfwapXb+vKdwgCgjCF3E0BpUkXhEQaCJxb5Tope
PPUAn0wflSY2RbBWEqdQudvWxNTPIPO4
=hwT1
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
