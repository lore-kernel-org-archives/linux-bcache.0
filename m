From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 4/4] MAINTAINERS: mark bcache as orphan
Date: Tue, 24 May 2016 07:43:24 -0700
Message-ID: <1464101004.1835.14.camel@perches.com>
References: <alpine.LNX.2.00.1605241634270.31937@cbobk.fhfr.pm>
	 <alpine.LNX.2.00.1605241636520.31937@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1605241636520.31937@cbobk.fhfr.pm>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Kosina <jikos@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, Eric Wheeler <bcache@lists.ewheeler.net>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On Tue, 2016-05-24 at 16:38 +0200, Jiri Kosina wrote:

> The submitted patches are not being reacted upon, and Jens is only pi=
cking=A0
> up stable fixes on an rather ad-hoc basis.
>=20
> Link: lkml.kernel.org/r/574462C5.40307@kernel.dk
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
> =A0MAINTAINERS | 2 +-
> =A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5f83015..c9906d6 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2288,7 +2288,7 @@ BCACHE (BLOCK LAYER CACHE)
> =A0M:=A0=A0=A0=A0=A0Kent Overstreet <kent.overstreet@gmail.com>
> =A0L:=A0=A0=A0=A0=A0linux-bcache@vger.kernel.org
> =A0W:=A0=A0=A0=A0=A0http://bcache.evilpiepirate.org
> -S:=A0=A0=A0=A0=A0Maintained
> +S:=A0=A0=A0=A0=A0Orphan
> =A0F:=A0=A0=A0=A0=A0drivers/md/bcache/

Sections marked as Orphan generally
don't also have a named maintainer.

Should Kent still be listed here?
