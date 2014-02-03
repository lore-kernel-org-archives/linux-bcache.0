From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH -next 2/2] bcache: Use max_t() when comparing different types
Date: Mon, 3 Feb 2014 14:47:20 +0100
Message-ID: <CAMuHMdUv_xP-1A950i0U=Petaey-_VosSxh5sk44Gqti-ikY6w@mail.gmail.com>
References: <1389776784-30825-1-git-send-email-geert@linux-m68k.org>
	<1389776784-30825-2-git-send-email-geert@linux-m68k.org>
	<1389783998.14001.22.camel@joe-AO722>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1389783998.14001.22.camel@joe-AO722>
Sender: linux-next-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Kent Overstreet <kmo@daterainc.com>, Neil Brown <neilb@suse.de>, linux-bcache@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux-Next <linux-next@vger.kernel.org>
List-Id: linux-bcache@vger.kernel.org

On Wed, Jan 15, 2014 at 12:06 PM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2014-01-15 at 10:06 +0100, Geert Uytterhoeven wrote:
>> drivers/md/bcache/btree.c: In function =E2=80=98insert_u64s_remainin=
g=E2=80=99:
>> drivers/md/bcache/btree.c:1816: warning: comparison of distinct poin=
ter types lacks a cast
> []
>> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> []
>> @@ -1813,7 +1813,7 @@ static size_t insert_u64s_remaining(struct btr=
ee *b)
>>       if (b->keys.ops->is_extents)
>>               ret -=3D KEY_MAX_U64S;
>>
>> -     return max(ret, 0L);
>> +     return max_t(ssize_t, ret, 0L);
>
> why not
>         return max(ret, 0);

Indeed, that also works, on both 32-bit and 64-bit.
Will resend, now all the issues moved from -next to Linus' tree.

> I think it odd that:
>
> drivers/md/bcache/bset.h:static inline size_t bch_btree_keys_u64s_rem=
aining(struct btree_keys *b)
>
> and:
>
> static size_t insert_u64s_remaining(struct btree *b)
> {
>         ssize_t ret =3D bch_btree_keys_u64s_remaining(&b->keys);
>
>         /*
>          * Might land in the middle of an existing extent and have to=
 split it
>          */
>         if (b->keys.ops->is_extents)
>                 ret -=3D KEY_MAX_U64S;
>
>         return max(ret, 0L);
> }
>
> so the only use of that size_t inline is cast to ssize_t

If the value returned by bch_btree_keys_u64s_remaining() is smaller
than KEY_MAX_U64S, it must stay negative after the subtraction,
instead of wrapping around to a big positive number. That's why ret is
ssize_t and not size_t.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-=
m68k.org

In personal conversations with technical people, I call myself a hacker=
=2E But
when I'm talking to journalists I just say "programmer" or something li=
ke that.
                                -- Linus Torvalds
