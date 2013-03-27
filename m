From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next 1/3] bcache: Add missing #include <linux/prefetch.h>
Date: Wed, 27 Mar 2013 11:21:50 -0700
Message-ID: <20130327182150.GB25906@google.com>
References: <1364406990-20541-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1364406990-20541-1-git-send-email-geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Wed, Mar 27, 2013 at 06:56:28PM +0100, Geert Uytterhoeven wrote:
> m68k/allmodconfig:
>=20
> drivers/md/bcache/bset.c: In function =E2=80=98bset_search_tree=E2=80=
=99:
> drivers/md/bcache/bset.c:727: error: implicit declaration of function=
 =E2=80=98prefetch=E2=80=99
>=20
> drivers/md/bcache/btree.c: In function =E2=80=98bch_btree_node_get=E2=
=80=99:
> drivers/md/bcache/btree.c:933: error: implicit declaration of functio=
n =E2=80=98prefetch=E2=80=99

Thanks, applied! The other two I already have a patch queued up for.
