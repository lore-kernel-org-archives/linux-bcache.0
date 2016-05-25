From: Jiri Kosina <jikos@kernel.org>
Subject: Re: [PATCH 4/4] MAINTAINERS: mark bcache as orphan
Date: Wed, 25 May 2016 07:07:12 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1605250705210.31937@cbobk.fhfr.pm>
References: <alpine.LNX.2.00.1605241634270.31937@cbobk.fhfr.pm>  <alpine.LNX.2.00.1605241636520.31937@cbobk.fhfr.pm> <1464101004.1835.14.camel@perches.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49401 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670AbcEYFHM (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 25 May 2016 01:07:12 -0400
In-Reply-To: <1464101004.1835.14.camel@perches.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kent.overstreet@gmail.com>, Eric Wheeler <bcache@lists.ewheeler.net>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 24 May 2016, Joe Perches wrote:

> > The submitted patches are not being reacted upon, and Jens is only =
picking=A0
> > up stable fixes on an rather ad-hoc basis.
> >=20
> > Link: lkml.kernel.org/r/574462C5.40307@kernel.dk
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> > ---
> > =A0MAINTAINERS | 2 +-
> > =A01 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 5f83015..c9906d6 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -2288,7 +2288,7 @@ BCACHE (BLOCK LAYER CACHE)
> > =A0M:=A0=A0=A0=A0=A0Kent Overstreet <kent.overstreet@gmail.com>
> > =A0L:=A0=A0=A0=A0=A0linux-bcache@vger.kernel.org
> > =A0W:=A0=A0=A0=A0=A0http://bcache.evilpiepirate.org
> > -S:=A0=A0=A0=A0=A0Maintained
> > +S:=A0=A0=A0=A0=A0Orphan
> > =A0F:=A0=A0=A0=A0=A0drivers/md/bcache/
>=20
> Sections marked as Orphan generally
> don't also have a named maintainer.
>=20
> Should Kent still be listed here?

Thanks for the remark. I'd leave this up to Jens, as apparently at the =
end=20
of the day he's the one relaying stability bugfixes upstream; so it mig=
ht=20
actually make sense to have him listed there eventually (while keeping =
the=20
Orphan status).

--=20
Jiri Kosina
SUSE Labs
