Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.177
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793743086;
	b=tW5UQiZ6Phghd8vEmGV3N3y0dC/EUH1eZno+sU9d4vXT/YF5hERCEmezu/OnqbrWYn5L
	 4NnVBSWqx9Uz2lKXam1c2VKBVnfZJe51eyaZ5PxWbSPfK4YtUxpAhAlfhxvEZWCvt5AS5
	 h+aeNAT7A1DfvTnTFODLnkhJLHboqJSyVnj1pMoe4Zxan/pKkn55dW0XbICDESHT13tQI
	 kpjiqECoVDTWTbgnQuuqXbD4fFa+s3ePDOpIi5LbSnNquvB0Qptyrb5wmKCGUDVKidJ+c
	 V3lS66JgyXfvfBTd9SWUkpAFs8p3YCGpfx0QZ3BkGqipKqbfJy049ucYMHqcB88FvwQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793743086;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=eXfhE46ByNVgLysQds+yI8htZlyiiFA2uPyig/gxm3w=;
	b=Usb3fKBQhnc/VlUzCVRZ+SdeLB2K4BQxOgeczlZ511XP3AzOheJ7P6R+3UObRgx+j24t
	 9nM6SIJE7TOtTop/7wqB+pDwaQhk+8RtrK9XdEhu45GCQIuo21fvzU1TL3FZG2UfeRBxg
	 nWDEF1VOB4G9w1vDSTvb71DsRVSIaYn3w71J7HZsUJnlGor7Ljnq6xhpBa4L8gKBfhFJ1
	 kGZyCreowPSaP/UsSYv6VI3AKeSDQB5yq5IJCxbeHWnagOBuJw0sxfHc9tSqbYvEa8YYS
	 7QfVOIrxztwYzmg0AEOWtgeVwHqRT2lbF2PTffPkrRGGmkmaZY8EJw9duOE/ao2eR6w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=dwK6R528;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.177
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5D9606A31B
	for <linux-bcache@vger.kernel.org>; Tue,  3 Nov 2026 21:58:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B5D9606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=dwK6R528
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5383c97c8cfso29571cf.1
        for <linux-bcache@vger.kernel.org>; Tue, 03 Nov 2026 13:58:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793743085; cv=none;
        d=google.com; s=arc-20260327;
        b=jAQuRvsJscBnJzYCIivq/J3FvrqfGUYJHJsAUuK5EwVUI83cvRcGqj/MjUQzmrQK5D
         Y7EpeGhQqnvLaDyPW4dHX5mPmczwcvZDfbOHrQrdJMmPnj2npYN6NhoF0CmOXzkzh2bn
         zDSPXBHqqsEoFu83/Zc1zTXPTNtTbov92PdO7YMoKry1PArf5aIXzUJSX5C+H/N53JIo
         oOWESEiGoDsHzVtFDEcWUXPoYnGvB9h8YHZrMwSc+KBmcPnpDRkWpaOS5zmz8EB9tC5R
         090kdBfTpZ3oH/v1F9/517iJR6q+uYn3CccrMQ0/PjNdHxU8Isj5h3IJTNuhzeJA4+HF
         yurw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eXfhE46ByNVgLysQds+yI8htZlyiiFA2uPyig/gxm3w=;
        fh=uUK2cqHFhGpZ0D3uFjoJU+qVIZK3+guRocIAzIl1jf0=;
        b=VjSbxLFAmrbFEArnoC2lPuu5WlRtV2TWAYUmAye9LK5rKoPH5vLGjCPgUYTI7CjPev
         rvP33vo/XacKEv5OtsNLpxBhjuiY8bSsFZ0v3bw8/aAD3jzd5yyS4PQpByWfIYIMe7ng
         9D1nnXcKoytZx1gtzU7El1CY/ANr7+EIMjdRByladQdp4UQB+xxdzmBOiKfxiNXW2C8b
         xfn0DFTqV4yLM9axD3gIlKbzPEWJgjRjTw0M0iNaJMSo/bcAa1LohOoSHmiZyWjc4Eg8
         HbX1ZW6eUEvraSi0efHnSkqAO+EggrTDP410k/26qkaRa6CKlOx22lFAET6IDi/8sODe
         HxYQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793743085; x=1794347885; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eXfhE46ByNVgLysQds+yI8htZlyiiFA2uPyig/gxm3w=;
        b=dwK6R528K3S39IyfjydsfTmiX9LFzcMgUu6nD/bXYJxrTqYBDETz4LHTEWG3NvhFdp
         ftUx9Z11He8VAFPjJHRr5bojyw32mmnOTt8LYj+cpgAJa8HRcBJyGAYZUNLX/2nAnnIr
         h1HsE3eB6LxLOi3YlXTAWu0P/8uJVQYMy8o3OUCN1dZrhQxMzeUZ3sVLJC/bIE1XYPZ/
         otjku0JGSireL02eK0A5I6P6ovG/mxXK/0Kx8cWri/wVw+PHskU/xRs8cnTqDzWCJAXy
         N8cMOqB1Txna/jVRUOWDzzwDmH6vTvYrkCiLU2AmRYB155PbWmiR26KDx32bY7K1AQkO
         LjJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793743085; x=1794347885;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eXfhE46ByNVgLysQds+yI8htZlyiiFA2uPyig/gxm3w=;
        b=XIlWCLru5mtRX7+5G1LsDcZ8cdXGVZ3+Ca0ynnU+CiEo9czPr1avOjkTjW2Rw3LOwk
         FBgz5w1JiTIvrSasqeN2X3w0aFSBBuRQULKs8exa4zNsj+38GgCyr4E393v4NMHwLLB8
         JUrBiLDU86IsCxePiIVblmMDchOCLQN2OPUOe5bRH79G0JP2GNB5RIl4Z7wvUFgi9yre
         nvQcdKThZ1Az21MBtmCYtMjzQdwoYF5ZvK6t30GvEFf1c5FSGiDffL/b3MqUp994RJ13
         11HE/2+6KnJuD0Uv19Q7Fv/wrp86mQNZEfz6zEJfgHQuyytJjfGwz1f704xosKgjkdeQ
         ac/w==
X-Gm-Message-State: APuU4Z8MJr56DziSMbAl7TCXGiRLayFVa0ebkDT0rpwAMk1KMhbtEkTw
	uvheE+NeD8hxkcmX6EORVqr4zhos2l0883bry9ng8xO56IbivLa3ta4ejtLUrDiLe/ufjFBvvD6
	al38b0nHbAoDU0FQvTf3Gb18GE/Icslm0lLc/CH2I
X-Gm-Gg: AYBFou3nQ4/edwwtQasIgrOo3qW5nU+20/OxA2d+2jJeZWdgTB134jMdrTaJ+4jnW5a
	lXqr6WeIUCwV1m6s1mJP+Z52WhS4Y4lFYSO3J9dz6aUzEBZ3nKvIk1rijYWuPMP6ZjaJ9FZldjs
	HTKd2saFOvkg8ATfKIqOAKry7YE6sdxJe7ls2pJPobWCAC5EfGxF54jJCBpWvksuqENzJd6WZ0B
	Y96a29WD7SqXO+I+qaTgbrAON7i5YiBWx/WsLhwghwLku1AZXXBJ1JWSCtfY1omiGJ9WmKKxr2I
	Z2jXnnKtznDoPB0k13yVnQsWLYhJzu6PofFJvXFzaqciy42hrl/wtWUvOhN96ABIIFb3YtkKT/k
	JJ24gyxBhTM+K+qjmp4r44QGlzMe3JZnhlPngzijMCiG84BO/sJIs/gfg9p2qWzoTRA==
X-Received: by 2002:a05:622a:250c:b0:534:313:9b4e with SMTP id
 d75a77b69052e-54b2beaaf4amr4792951cf.5.1793743084531; Tue, 03 Nov 2026
 13:58:04 -0800 (PST)
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Post: <mailto:linux-bcache@vger.kernel.org>
List-Help: <mailto:linux-bcache+help@vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-bcache+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261103070122.1208383-1-robertpang@google.com>
In-Reply-To: <20261103070122.1208383-1-robertpang@google.com>
From: Robert Pang <robertpang@google.com>
Date: Tue, 3 Nov 2026 13:57:53 -0800
X-Gm-Features: AclHuK_s85z0JpxqehQwdC_3u-Z0zzJP76eAsxlJmBPLxwKxztS9OJIUR-ZEAB0
Message-ID: <CAJhEC04+1tu_vGVNfc0TicEb9T2wPpFPLqmQRqX0G_k7M3sBwQ@mail.gmail.com>
Subject: Re: [PATCH] bcache: allow more bucket reclaims during garbage collection
To: colyli@fygo.io, kent.overstreet@linux.dev
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dongsheng.yang@easystack.cn, mingzhe.zou@easystack.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 2, 2026 at 11:02=E2=80=AFPM Robert Pang <robertpang@google.com>=
 wrote:
>
> In patch a14a68b76954 ("bcache: allow allocator to invalidate bucket in g=
c"),
> reclaimable buckets are added to the free list for the bucket allocator
> at the start of a GC cycle.
>
> However, once these buckets are allocated, they are no longer marked as
> reclaimable until the GC cycle finishes. Under heavy loads and frequent c=
ache
> updates, all reclaimable buckets can be exhausted before the GC ends, cau=
sing
> the allocator to wait and stalling incoming I/O.
>
> Address this by allowing reclaimable buckets to be reclaimed during GC up=
 to
> the number of generations left before BUCKET_GC_GEN_MAX.
>
> Signed-off-by: Robert Pang <robertpang@google.com>
> ---
>  drivers/md/bcache/alloc.c  | 3 ++-
>  drivers/md/bcache/bcache.h | 2 +-
>  drivers/md/bcache/btree.c  | 5 +++--
>  3 files changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
> index 3ec240ec685d..959d753e7cf6 100644
> --- a/drivers/md/bcache/alloc.c
> +++ b/drivers/md/bcache/alloc.c
> @@ -141,7 +141,8 @@ void __bch_invalidate_one_bucket(struct cache *ca, st=
ruct bucket *b)
>         bch_inc_gen(ca, b);
>         b->prio =3D INITIAL_PRIO;
>         atomic_inc(&b->pin);
> -       b->reclaimable_in_gc =3D 0;
> +       if (b->reclaimable_in_gc)
> +               b->reclaimable_in_gc--;
>  }
>
>  static void bch_invalidate_one_bucket(struct cache *ca, struct bucket *b=
)
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index ec9ff9715081..daae5ac5ffbc 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -200,7 +200,7 @@ struct bucket {
>         uint8_t         gen;
>         uint8_t         last_gc; /* Most out of date gen in the btree */
>         uint16_t        gc_mark; /* Bitfield used by GC. See below for fi=
eld */
> -       uint16_t        reclaimable_in_gc:1;
> +       uint8_t         reclaimable_in_gc; /* no. of times reclaimable in=
 GC */
>  };
>
>  /*
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 27a129d47d0a..fc167868c814 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -1742,9 +1742,10 @@ static void btree_gc_start(struct cache_set *c)
>
>         ca =3D c->cache;
>         for_each_bucket(b, ca) {
> -               b->last_gc =3D b->gen;
>                 if (bch_can_invalidate_bucket(ca, b))
> -                       b->reclaimable_in_gc =3D 1;
> +                       b->reclaimable_in_gc =3D
> +                               BUCKET_GC_GEN_MAX - bucket_gc_gen(b);
> +               b->last_gc =3D b->gen;
>                 if (!atomic_read(&b->pin)) {
>                         SET_GC_MARK(b, 0);
>                         SET_GC_SECTORS_USED(b, 0);
> --
> 2.56.0.398.g882cbad275-goog
>

Hi all,

To provide some additional context on this patch:

  - This commit fixes a recurrence of the I/O stall issue [1]
originally addressed by commit a14a68b76954 ("bcache: allow allocator
to invalidate bucket in gc").
  - The recurrence stems from commit 009073806fbc ("bcache: reduce gc
latency by processing less nodes and sleep less time"), which
introduces longer GC pauses (100 ms) to reduce front IO tail latency
during GC.
  - Due to the longer GC runtime, commit a14a68b76954 becomes
ineffective under heavy cache updates because reclaimable buckets are
rapidly exhausted when each bucket is limited to a single reclaim.
  - This patch extends commit a14a68b76954 to allow buckets to be
reclaimed multiple times, bounded by the BUCKET_GC_GEN_MAX safety
range.

Best regards
Robert Pang

[1] https://lore.kernel.org/linux-bcache/1599736884-5479-1-git-send-email-d=
ongsheng.yang@easystack.cn/
