From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH -next 2/2] bcache: Use max_t() when comparing different
 types
Date: Thu, 06 Feb 2014 01:06:47 -0800
Message-ID: <1391677607.15777.2.camel@joe-AO722>
References: <1389776784-30825-1-git-send-email-geert@linux-m68k.org>
	 <1389776784-30825-2-git-send-email-geert@linux-m68k.org>
	 <1389783998.14001.22.camel@joe-AO722>
	 <CAMuHMdUv_xP-1A950i0U=Petaey-_VosSxh5sk44Gqti-ikY6w@mail.gmail.com>
	 <CAMuHMdVDdGBG0b2BY4PZRGWn-2ts-qz9_OdUdnAE9gMp_zP3jw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdVDdGBG0b2BY4PZRGWn-2ts-qz9_OdUdnAE9gMp_zP3jw@mail.gmail.com>
Sender: linux-next-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kent Overstreet <kmo@daterainc.com>, Neil Brown <neilb@suse.de>, linux-bcache@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux-Next <linux-next@vger.kernel.org>
List-Id: linux-bcache@vger.kernel.org

On Thu, 2014-02-06 at 10:00 +0100, Geert Uytterhoeven wrote:
> On Mon, Feb 3, 2014 at 2:47 PM, Geert Uytterhoeven <geert@linux-m68k.=
org> wrote:
> > On Wed, Jan 15, 2014 at 12:06 PM, Joe Perches <joe@perches.com> wro=
te:
> >> On Wed, 2014-01-15 at 10:06 +0100, Geert Uytterhoeven wrote:
> >>> drivers/md/bcache/btree.c: In function =E2=80=98insert_u64s_remai=
ning=E2=80=99:
> >>> drivers/md/bcache/btree.c:1816: warning: comparison of distinct p=
ointer types lacks a cast
> >> []
> >>> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.=
c
> >> []
> >>> @@ -1813,7 +1813,7 @@ static size_t insert_u64s_remaining(struct =
btree *b)
> >>>       if (b->keys.ops->is_extents)
> >>>               ret -=3D KEY_MAX_U64S;
> >>>
> >>> -     return max(ret, 0L);
> >>> +     return max_t(ssize_t, ret, 0L);
> >>
> >> why not
> >>         return max(ret, 0);
> >
> > Indeed, that also works, on both 32-bit and 64-bit.
> > Will resend, now all the issues moved from -next to Linus' tree.
>=20
> However, sparse doesn't like it, so we'll have to go for v1?

Seems so.
