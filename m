Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73485399346
	for <linux-bcache@vger.kernel.org>; Fri,  9 Oct 2026 22:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791584419; cv=pass; b=UyNvsj1miKqZIWMW1SPyL+Xl309E8EyHSr40Yppugxn2Q+0kFIBLjGu6+2Nm8tMz21VO/LMmyp3Qmh3siGhxsIeyzR6CaofVDC3+IaN9QXVQsjADUWQCRqxFM3UnyJdQ3gT8VJrlEyg7r/qCi6fvKYUgvI/wPScg35cWtV6rxBs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791584419; c=relaxed/simple;
	bh=PgwmGuw1zNCeYJ4qMywnr2UJb9ioZir99Vs8zzDOKz0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tmk3muwstJ4sQVPU0zEpq01IdmMKNHirBdB8JBbAQXk+XNwowDC+uqu6/+keAYRnSFT4Sjza+bS6vcMr/RRIpaJbXNOCc3gKiSdWhD7c1P80XLqsvZIMfIw0aRWlSGfd3fMzP+2T5585uIbsfkU1q2TXUxf3IjcDn+CZ7ZJ0ZOs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iwzPeGL3; arc=pass smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iwzPeGL3"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6acb57c2b88so236333a12.2
        for <linux-bcache@vger.kernel.org>; Fri, 09 Oct 2026 15:20:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791584416; cv=none;
        d=google.com; s=arc-20260327;
        b=UPiKXRj7+1B5mt0ETgxUe5OBTiuC/ktIel8gPi0rZwUvgjBrF8njAGD2AUoM1XpEZp
         KI2jcbIVJBMPF3M2DCbWZuO+bn2b6y79Ilr9fk9JnFn6QeYpRTjYTgTAcms1YV2hb2m3
         OtfpdWME2kKQtcfJBGIxiAEq3tcaSTU9Q0IDJuw0RpHam0EayXMSMDtwzJg5l54R2N4S
         UYozcBIXJtAahFmBXuwGUjRPO9Vl1Ph7ntQHXbTKDjTiPXRoEkrfewCnKET/5fiYQ+DC
         8qkgWX+NJ+GHTKF8MzeScsaFIB9oJQh2iBRj71O+8NFVwgGuVH+4ICSvQJtiAk0E5TS4
         rWLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+GW4IS6o1LJAcPN9SYF127puFlWBP/gNfh8ql8XeLT0=;
        fh=y0CUZlbo5gvYRSa3dXVxIm3KeKxbHkINlz7tsZkiv6Q=;
        b=Wp98uLHsUWsUikCznJA0xEu866CYRGf9MkftibzOIN3CjUzLWf7r6qqZqdZXDNC+oS
         Ddyoz4JsQIweMLEzmDj14IffDfeLV95Bsqkt9vuphzBW94lyfO+d4pnx6N4qBYe/c60E
         tElqrEqFDDw3pk3XIxj09miC1rd7lWlXvI1qLGrtGCtiaYjhOvjQhxv95/icEd6LGKU4
         E2ZsIX5PwD2qZToUfc1jyVxlPe9i8ED5Unf8S6h/C1dEIaT+yWIAmvjBcYHNk9GEmhFJ
         xmgRQK3KwRLy63noHjXtjsxhVXmLkrFj4yvrwzKUcvqPOcs5C0fdKqYP1m3wBgk5lPI+
         Bd1w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791584416; x=1792189216; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+GW4IS6o1LJAcPN9SYF127puFlWBP/gNfh8ql8XeLT0=;
        b=iwzPeGL3dz6wPlwAXU2ZCiPac9s6uXZZGfuPFZAD7zQ5PKrXb3uPmX8kFgNwz3zFL2
         w+qSYyT0bi0Jy6lcnJSM9TCMa0Y7EQKygEx+K5PF9TIHcy+mTQ3Vdb5D+2d1KMWWUmje
         tsSjk/+InLgALaF6LVeAi0rOTjuSii58R7CPslgkH0n2aVTAY9YdtJJ0DWoECsF/X+aL
         yGgb0yx/X/orLHNexXregO3BzvHfobIeMRRk8/W32e4pEZolz6RQ8/KiZF5Wm3j8Qx7t
         1Rjqu+/ApPgMyyQTjZfkVcnWzk/JmQEZUOX30pikj14ihc9p4Imjc6FmmQU7zsTBLdoJ
         T8XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791584416; x=1792189216;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+GW4IS6o1LJAcPN9SYF127puFlWBP/gNfh8ql8XeLT0=;
        b=CdOo9lWQHUy3IzoJKILSPhQwJH8T1JqqzqEa0OKAKhhO8lRyx3o0b1Rt2s8NR+UIyg
         Wz/ldZKSgzCXhDlFvB/EQfT2aGUfHdLYZ+LO5WHVpescRNa9MLriKar5kjocf25q/C59
         /TFwCrKsgGPDV3QnOAKspMI3LeAAMQ6d/txiiKkhPpoSnVudVmLu7yubhqkfPhTBP2+Q
         s62aWyF8inh/IRNgnfThYUQNbOvn1YwT0ecI0D0u+CZACM0Nm4syfjwiAxljZ7Na1P4e
         3hQ8Y38yKSsgsaHR7njM6/O6ayk21dsPc1E8BLH77KbYwHST4WkG16OOAL7pbi20ajO3
         cBYw==
X-Gm-Message-State: AFq9FYIJKkwLHxJW3QiSRffxO5jDwZG4q/Zr6XUsh8e3L900D2/IkGlZ
	+nL+5SWoep22tF5Uk163prRFe+eJvjWqEN0lxOLHLwiYvE7HGJXtSiUaLjoEqbO7LCkseqgBMEK
	7ApQn3UXZUlEHTiXJ5okGY+BXQ67qf8SY+IbD
X-Gm-Gg: AYBFou2qWRazqBqQFVFdBmcHjxOG8Df6r8dLyIZPDCnnMZSfAlTQ5aqEKWXsBd7E0Z4
	uKoFX0BlSRklr6lVvFsJJnFeDK+HiPN0/HVKFzKIE65KET/patOq0Wlbezv/EYOAWmagAslwiGy
	kvvYdKyEJhhkTlmLZDvCM/W4tCx8k4oCC3QKlx8p4qC5TWC76Tq0GypIRLsf6OJhXVsRGt93vbB
	bUsuj+MXrm0dLl/isLFjSGFXwnxHBQGwYwaBMm5nq/61iTWgSTIPlKGBT4ezpg+kC6rFsZfjSOf
	jVx483e2OS4weiVmZtwirPDii/+64l/odPya8tcAFctVLQtMW9aErCWgdizggyrO2UZW39nA8pa
	VxgXJVVtWhuNOdJOG6Of1C4FMF54LRiUnOnOgjB5UBNYph6L8npAdU7qGDJDBQ3M7ko3AEyGSYM
	nV6RR7iY4GjhPjbXEcHuH3+SctGKjkCFO993E5yBOg6Puo47kewoydFNy7GyP4d4InKg==
X-Received: by 2002:a05:6402:4005:b0:6aa:f02c:dd96 with SMTP id
 4fb4d7f45d1cf-6b17c25d31fmr2914886a12.11.1791584416248; Fri, 09 Oct 2026
 15:20:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261004233523.516891-1-rosenp@gmail.com> <ashiQ98Qmie63mB2@studio.local>
 <CAKxU2N8WtY+=dhSTfyu=8ujEwnkcfV9PEkXxuTLHthwksDhTxw@mail.gmail.com> <2051AAAB-4FC9-4093-825A-ADFEE5438EB7@fygo.io>
In-Reply-To: <2051AAAB-4FC9-4093-825A-ADFEE5438EB7@fygo.io>
From: Rosen Penev <rosenp@gmail.com>
Date: Fri, 9 Oct 2026 15:20:04 -0700
X-Gm-Features: AclHuK91qLOuh_bhI7HYZ-oxSWH1gL9kepMuJvhWwdn_2yB_YhubWH2ATVmFMIY
Message-ID: <CAKxU2N_nub+OcvZ_ROBMMHpkH=up+OJzmahW-9J5xN29nFRCHQ@mail.gmail.com>
Subject: Re: [PATCH] bcache: fix kernel-doc warning on CLOSURE_CALLBACK
To: Coly Li <colyli@fygo.io>
Cc: linux-bcache@vger.kernel.org, Kent Overstreet <kent.overstreet@linux.dev>, 
	open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 8, 2026 at 9:54=E2=80=AFPM Coly Li <colyli@fygo.io> wrote:
>
> > 2026=E5=B9=B410=E6=9C=889=E6=97=A5 12:09=EF=BC=8CRosen Penev <rosenp@gm=
ail.com> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > On Thu, Oct 8, 2026 at 8:41=E2=80=AFPM Coly Li <colyli@fygo.io> wrote:
> >>
> >> Hi Rosen,
> >>
> >> On Sun, Oct 04, 2026 at 04:35:23PM +0800, Rosen Penev wrote:
> >>> bch_data_insert() is defined through the CLOSURE_CALLBACK() macro, wh=
ich
> >>> kernel-doc cannot see through, so the kernel-doc comment above it
> >>> produces:
> >>>
> >>>  request.c:308 function parameter 'bch_data_insert' not described in =
'CLOSURE_CALLBACK'
> >>>  request.c:308 expecting prototype for bch_data_insert(). Prototype w=
as for CLOSURE_CALLBACK() instead
> >>>
> >>> Turn it into a regular block comment, and drop the @cl line along
> >>> with the kernel-doc markup.
> >>>
> >>> Assisted-by: LLM
> >>
> >> The patch is fine to me. Can you provide the detailed LLM name here?
> > It was Opencode's Big Pickle IIRC. Current documentation says to just s=
ay LLM.
>
> Documentation file coding-assistants.rst suggests,
>
>  43 Attribution
>  44 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>  45
>  46 When AI tools contribute to kernel development, proper attribution
>  47 helps track the evolving role of AI in the development process.
>  48 Contributions should include an Assisted-by tag in the following form=
at::
>  49
>  50   Assisted-by: LLM [TOOL1] [TOOL2]
>  51
>  52 * ``[TOOL1] [TOOL2]`` are optional specialized analysis tools used
>  53   (e.g., coccinelle, sparse, smatch, clang-tidy)
>  54
>  55 Basic development tools (git, gcc, make, editors) should not be liste=
d.
>  56
>  57 Example::
>  58
>  59   Assisted-by: LLM coccinelle sparse
>
> Yes,  only listing LLM is the bottom line, and list the detailed model na=
me is better.
>
> If you don=E2=80=99t want to post v2 patch, you can give me a line of Ass=
isted-by: , I can replace it in the patch.
Assisted-by: Opencode:Big-Pickle
>
> Thanks.
>
> Coly Li
>
>
> >>
> >>> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> >>
> >> Thanks.
> >>
> >> Coly Li
> >>
> >>> ---
> >>> drivers/md/bcache/request.c | 3 +--
> >>> 1 file changed, 1 insertion(+), 2 deletions(-)
> >>>
> >>> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.=
c
> >>> index 3fa3b13a410f..e7f097346d64 100644
> >>> --- a/drivers/md/bcache/request.c
> >>> +++ b/drivers/md/bcache/request.c
> >>> @@ -285,9 +285,8 @@ static CLOSURE_CALLBACK(bch_data_insert_start)
> >>>      }
> >>> }
> >>>
> >>> -/**
> >>> +/*
> >>>  * bch_data_insert - stick some data in the cache
> >>> - * @cl: closure pointer.
> >>>  *
> >>>  * This is the starting point for any data to end up in a cache devic=
e; it could
> >>>  * be from a normal write, or a writeback write, or a write to a flas=
h only
> >>> --
> >>> 2.56.0
