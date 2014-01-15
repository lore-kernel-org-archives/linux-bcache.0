From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH -next 2/2] bcache: Use max_t() when comparing different
 types
Date: Wed, 15 Jan 2014 03:06:38 -0800
Message-ID: <1389783998.14001.22.camel@joe-AO722>
References: <1389776784-30825-1-git-send-email-geert@linux-m68k.org>
	 <1389776784-30825-2-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1389776784-30825-2-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kent Overstreet <kmo@daterainc.com>, Neil Brown <neilb@suse.de>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On Wed, 2014-01-15 at 10:06 +0100, Geert Uytterhoeven wrote:
> drivers/md/bcache/btree.c: In function =E2=80=98insert_u64s_remaining=
=E2=80=99:
> drivers/md/bcache/btree.c:1816: warning: comparison of distinct point=
er types lacks a cast
[]
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
[]
> @@ -1813,7 +1813,7 @@ static size_t insert_u64s_remaining(struct btre=
e *b)
>  	if (b->keys.ops->is_extents)
>  		ret -=3D KEY_MAX_U64S;
> =20
> -	return max(ret, 0L);
> +	return max_t(ssize_t, ret, 0L);

why not
	return max(ret, 0);

I think it odd that:

drivers/md/bcache/bset.h:static inline size_t bch_btree_keys_u64s_remai=
ning(struct btree_keys *b)

and:

static size_t insert_u64s_remaining(struct btree *b)
{
	ssize_t ret =3D bch_btree_keys_u64s_remaining(&b->keys);

	/*
	 * Might land in the middle of an existing extent and have to split it
	 */
	if (b->keys.ops->is_extents)
		ret -=3D KEY_MAX_U64S;

	return max(ret, 0L);
}

so the only use of that size_t inline is cast to ssize_t
