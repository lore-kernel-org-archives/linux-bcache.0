From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [PATCH -next 1/3] bcache: Add missing #include <linux/prefetch.h>
Date: Wed, 27 Mar 2013 12:50:50 -0700
Message-ID: <20130327195050.GB22232@google.com>
References: <1364406990-20541-1-git-send-email-geert@linux-m68k.org>
 <20130327182150.GB25906@google.com>
 <51533A2E.2000501@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51533A2E.2000501@infradead.org>
Sender: linux-next-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On Wed, Mar 27, 2013 at 11:27:58AM -0700, Randy Dunlap wrote:
> On 03/27/13 11:21, Kent Overstreet wrote:
> > On Wed, Mar 27, 2013 at 06:56:28PM +0100, Geert Uytterhoeven wrote:
> >> m68k/allmodconfig:
> >>
> >> drivers/md/bcache/bset.c: In function =E2=80=98bset_search_tree=E2=
=80=99:
> >> drivers/md/bcache/bset.c:727: error: implicit declaration of funct=
ion =E2=80=98prefetch=E2=80=99
> >>
> >> drivers/md/bcache/btree.c: In function =E2=80=98bch_btree_node_get=
=E2=80=99:
> >> drivers/md/bcache/btree.c:933: error: implicit declaration of func=
tion =E2=80=98prefetch=E2=80=99
> >=20
> > Thanks, applied! The other two I already have a patch queued up for=
=2E
>=20
>=20
> On i386 and x86_64, I also see this build problem:
>=20
> drivers/md/bcache/bset.c:885:4: error: implicit declaration of functi=
on '__WARN' [-Werror=3Dimplicit-function-declaration]
>=20
>=20
> Do you also have a patch for it?

Nope - looks like __WARN() doesn't exist if CONFIG_BUG=3Dn, whoops.

Adding this to the queue:

commit 796c213186b850b3e6e8d5fd5799b0fd74721ea3
Author: Kent Overstreet <koverstreet@google.com>
Date:   Wed Mar 27 12:47:45 2013 -0700

    bcache: Use WARN_ONCE() instead of __WARN()
   =20
    Signed-off-by: Kent Overstreet <koverstreet@google.com>

diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
index d4f2164..cb4578a 100644
--- a/drivers/md/bcache/bset.c
+++ b/drivers/md/bcache/bset.c
@@ -883,7 +883,7 @@ struct bkey *bch_btree_iter_next(struct btree_iter =
*iter)
 		iter->data->k =3D bkey_next(iter->data->k);
=20
 		if (iter->data->k > iter->data->end) {
-			__WARN();
+			WARN_ONCE(1, "bset was corrupt!\n");
 			iter->data->k =3D iter->data->end;
 		}
=20
