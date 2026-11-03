Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.169
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793744878;
	b=R4kxkNvtmpndwptUgGz0HEQ/HFVVX8ZUNO1Az9VnTePcLk/qmOLNvCFlBXrzwvqUOjAj
	 etDsq7IUGTe/QE4rcD+pyQwq1PNkgwk2hS9KwOwEtTKhr49U3RZK5+thSyCuHn4UbKLI5
	 vffPONO+kOG/y96qR9KOOZYhBmqlU2qQZHHV28IRb/apN7b7n1cauAZ9KWysITvokAAB/
	 sU7C0fF+s+tSF8lQZ1t7KZsbLsQGWIvK+w4fY/KZj66NzknfABbJvdy46JHoYPX/j7CqC
	 yYCmMmsS2ePBe8qTQgKm1ATUjZF6M0Mq8XqDXw0F5FAyoNZythtiVGod3b3UMPEPyow==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793744878;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=U6sOeMDVcAvnCgHIdX2jRiq2c1v5uHZOJD+0XTCDNiI=;
	b=EbD/veoJ00z/nXwECM6aRs/o6LoPZDhFgJUWvhJOSTdDRF+lAiJl8UJFhjoHCf8sf4D2
	 WlsrNpezu7Z3Rz0sSRcf8NsoevR9W27yL7u81i0BUBB5R2CA4xzVdEEerpMOxGr8ZHOJk
	 NlTTLUoONKfikdsfKlrp4IJxwSrhBewqQbxWSCf+B0F1CIxwTE+goxFGsf0L1JrP8KXu9
	 23heC59cI8HL5aVbsUXFz2ljrbJ9pCvTnTQxP80vpeNwvDpv/GR+KU4g5vIKDE888Xjp2
	 LkTt3Abn8mmO0k7h/Nr8c0FxNyPo8Id1QoZVzpY5JhldUn1nwufrOcQZIlOEVCw9wHA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=g7pPR470;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.169
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26508606A31B
	for <linux-bcache@vger.kernel.org>; Tue,  3 Nov 2026 22:27:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 26508606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=g7pPR470
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5383c97c8cfso38461cf.1
        for <linux-bcache@vger.kernel.org>; Tue, 03 Nov 2026 14:27:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793744877; cv=none;
        d=google.com; s=arc-20260327;
        b=f46ZDNkQ4k4258N95CTn8PtY3hbVfMZPQfPJ9mfDvD8hAJ9uKIiNbkVra5amsZqwpA
         A5BzShvdzD43BsQGS1ircxfE4VLcicYnmhXlV4lw+kalcKZ+rTKQLMnqzv/qmbrhevo2
         GfXQPYjsYWErrujcptcmZCkyfTYzXvwfBtRv8NnxkYUfoUIA1gDbiq60OOUINV7DeXiQ
         /4K04SWCqGxGRIvfVvTI3ZU2GLL+wKqGXg/9TiRhp+zegwsmCGxDDMHggTpqvQy7GZXI
         azFM++LxuTDb5v+EQgN92C1FwLYzATLTpYGBaFzj+RW5O5wpadixWLqdO2kIB85O2BsR
         KVYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=U6sOeMDVcAvnCgHIdX2jRiq2c1v5uHZOJD+0XTCDNiI=;
        fh=bHd1dYgj14LKM3jeHP2+42qCzyvF19odYPk6bSiX6Zg=;
        b=qNpJ/FmIFB4b6WhVoigWiTA3ra84O3MwJNgPm3bs+VF5WLdcZTQmdR4CuIyb0XEc6E
         jPgc9eLNgm8ltLG8gbmzpG0ssRT/6EppoXMolgrunxVfbFcwIxcRJbey+SgpjAFy4tZk
         KQjq/aoTVtzGI3Q2fpr85qYgXoIa0SNBHJedBoG4ElaBleDurxeNkQpAXypq426Oh0rE
         RiAkX8xT1OzsYBN0H6wx7bs1EjGf7jMjlm3JVKIbXwcJsCWTKCaa8JSfjtzyXu3jiieG
         WNtpQqw7Bs5HtySGtwElUewF7AoZieT/COA1OtWXI73/EphfVwW+ZszvbvJJg+DUVIzK
         /fNA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793744877; x=1794349677; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=U6sOeMDVcAvnCgHIdX2jRiq2c1v5uHZOJD+0XTCDNiI=;
        b=g7pPR470Cacpaxyq4bouZC5n+xAsKKXcWKRnDviJizeavWvuP+QVqEvi0u8zdOX65A
         sMQm04l1bjCw2aXHRB3dF/LeGiKgY5LOIUVG4gDEyv0SHS96/pClIJreiJx5ppi6LjrY
         eijCb/+dkNxT0KFC2NnbfedPtHUI4fmkqUjcSXademL4yPQ3oU1OQRlB9g530/IyP8BU
         sZxDXi/bqc4ZegEcQmLHjjavdguBpDsC/jJ102zP2NuVZgNjtoFtDeGmzlusXQiyUSKG
         jngfHDfSVTs0iUeLa8qFUaUOeBQYA0AVTG1Vy0Js0PoVcpZMNcGPShLgMCH9KXSJNY/i
         CIMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793744877; x=1794349677;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U6sOeMDVcAvnCgHIdX2jRiq2c1v5uHZOJD+0XTCDNiI=;
        b=f69VjWkXidzW64HtPrd6apN2/QuaUeNzvH2ZTv/R//gBBbutiWrPEDgCbDutuyLNEl
         vIUILC2s7FfeJu17/xtGaSNsKAYXL0g62IMk8sUAgGwn5TRF2Uo0z1yOU7/yaCoR3Vbs
         bV+YL1cRFVVi4/ImRGCWWWHMxMvtrhvQp10jIL3VEhTxa4HJLuqK6N3sKJdsG9edwHZP
         cJokz1b3m2Llh1fsgXRCRUanhe97wTGbrFT+vqRwnJE1/ISeskNMSH0+SIKD6H3qw6Lt
         YZqBsyOfv6+uc5zHtc+sORt239rgZf0VzLLUXM3GcAYQy5UkW8Bd8ijCvTftAlw4I4Ev
         rE4Q==
X-Gm-Message-State: APuU4Z8xa7kFd9jXSD81dwGgRdsgjebmea/+CyyRf30dAJN7cvz5LXQq
	6RK0fDIwObpZyse/dppkN4Do7Hwrfrz7bfsr5HCDoohYzGq9Uft4roNDV4dDebEjiqxXQ1gDsCQ
	g/kN4YK9jzX+vaJOefukImq37hPen3w3IDOsiIa2h
X-Gm-Gg: AYBFou3pn387lqZiclNu7V3N0uUjnwpVJsVIfYNRjgfXYTSo2M2iWKE8GUZwg5j87Om
	ZmbJWzuuhK+DLOzhIqFPALhIXNCB71P2rljbHI8tZCdKVIuSiJQwKEZBT/RSW7MTdjhtejF99Ss
	da6Jbi/5yaJdkZdbBkUfEufJF6w0rjizZN0gLaa4+2fqrcsquYcX3Yu1+/4UIcpIHM3Qs7vXa7N
	QfvCsAV39mpG8bWnYp1ozOosCyaM22yQ447BWqmaZxh+qCwPZj2R3VCd8ieGIycRxAni3MsWlYH
	MHOCasZMN6TTuTX8DTh876tnJjQCvzyFSUR0dT2aNx/IXb1TsXy9VHnzC4w8PrCKtMChHg9oez9
	MsdsyQbt22icbK6wuhWVYeKfKcNiaadqYvpvd59XCoSv1PVPVbetqFH56gn32yy9lRfdk9JAKNL
	/Eo9fZWxiTI+M=
X-Received: by 2002:a05:622a:2b07:b0:542:fc60:fe23 with SMTP id
 d75a77b69052e-54b2a80e855mr5349021cf.3.1793744876064; Tue, 03 Nov 2026
 14:27:56 -0800 (PST)
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Post: <mailto:linux-bcache@vger.kernel.org>
List-Help: <mailto:linux-bcache+help@vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-bcache+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261103070407.1211071-1-robertpang@google.com>
In-Reply-To: <20261103070407.1211071-1-robertpang@google.com>
From: Robert Pang <robertpang@google.com>
Date: Tue, 3 Nov 2026 14:27:44 -0800
X-Gm-Features: AclHuK_ZoXvD-8aoB7BiBr9V6B5ChZ0ecv0eLMPp_diX0MDcPttP-OdgfME7Vps
Message-ID: <CAJhEC051dpSeqoMR4-w-feaEdR90xW_g9O91RiZ0HJoUM6CofA@mail.gmail.com>
Subject: Re: [PATCH] bcache: fix available bucket accounting in bucket allocation
To: colyli@fygo.io, kent.overstreet@linux.dev
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 2, 2026 at 11:04=E2=80=AFPM Robert Pang <robertpang@google.com>=
 wrote:
>
> In bch_bucket_alloc(), a cache set's avail_nbuckets is decremented whenev=
er a
> bucket is allocated, assuming that the bucket becomes unavailable once
> allocated. However, when a bucket is allocated but the GC mark is unset o=
r
> reclaimable, it is available still. This false counter decrement leads to=
 an
> inflated in-use measurement, which triggers cache bypasses once CUTOFF_CA=
CHE_ADD
> is reached, persisting until the next garbage collection cycle.
>
> Fix this by ensuring avail_nbuckets is only decremented when the allocate=
d
> bucket is already marked and not in the GC_MARK_RECLAIMABLE state.
>
> Signed-off-by: Robert Pang <robertpang@google.com>
> ---
>  drivers/md/bcache/alloc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
> index 3ec240ec685d..2d0cb9b414ac 100644
> --- a/drivers/md/bcache/alloc.c
> +++ b/drivers/md/bcache/alloc.c
> @@ -446,7 +446,8 @@ long bch_bucket_alloc(struct cache *ca, unsigned int =
reserve, bool wait)
>                 b->prio =3D INITIAL_PRIO;
>         }
>
> -       if (ca->set->avail_nbuckets > 0) {
> +       if (ca->set->avail_nbuckets > 0 &&
> +           GC_MARK(b) && GC_MARK(b) !=3D GC_MARK_RECLAIMABLE) {
>                 ca->set->avail_nbuckets--;
>                 bch_update_bucket_in_use(ca->set, &ca->set->gc_stats);
>         }
> --
> 2.56.0.398.g882cbad275-goog
>

Hi all,

Here is some more context on this fix. This issue was observed during
the investigation of [1]. We believe this is a latent issue exposed by
longer garbage collection durations following commit 009073806fbc
("bcache: reduce gc latency by processing less nodes and sleep less
time") to reduce front IO tail latency during GC.

Best regards,
Robert Pang

[1] https://lore.kernel.org/linux-bcache/CAJhEC04+1tu_vGVNfc0TicEb9T2wPpFPL=
qmQRqX0G_k7M3sBwQ@mail.gmail.com/T/#m0be3c1a4a63427ed7b233a3f753a55fcded69d=
05
