Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739D937E5E1
	for <linux-bcache@vger.kernel.org>; Fri,  9 Oct 2026 04:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791519006; cv=pass; b=Ux4Pfz9yRDZcmAX0C1s3d1nyp/TKi6OEw9wA0AHVpwmxZMKWnLIuCPV8fkZ/W04sMbtHULxhBYibo9RJF+Z7hOK+5td9q0oT/DK0b8bpbljOQcWJjB3HnEncZXwxj4rU7awnUzxv+4g0z/1yDpcsKNW1wN7RdtQmjHj46R4yyoE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791519006; c=relaxed/simple;
	bh=NPttGRQsFZMlYlWq7ACnEyxHFvnrxryCdv97VywA4yU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DDzk+AunKdlAVqlvtcgBLp5ljZboUXTTpLkhFW3kvX6z5IGo/LTWi+rusyo2v1f1h022NmkPTBDS2NLbaIfVOyqPt6K0kJs0/9YLq1mtFc5X7DUWzY8cLBEq5DAef+f1fBegoxuxYpJHgcVpFbAV2DmB4s56wxA/MXo+GoZlY18=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=p6d+iwRm; arc=pass smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p6d+iwRm"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c2e5e090746so366600566b.0
        for <linux-bcache@vger.kernel.org>; Thu, 08 Oct 2026 21:09:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791518996; cv=none;
        d=google.com; s=arc-20260327;
        b=iSYFNNro2a1RxXjX5dkXd2SdyuQ7i9/uFrUNyeDtO/ilxSQrjhpf0VFaWgRcSC6D+m
         /KTCx1VnuQmnWRCGrmLxSVz7EMIvvfntafb4IyKLoQkTRDdquVe0aN7TCYbAhM/85wi0
         N0/0JgSWIQgd5KA4sFQzXQCZ3GJeJ8ahR3e2U2jBnESuva5D0XQT8b9Nu9DDYjHh2yvT
         gQQKa7w++7CYYxgpflw6MMCeamKTIIjlvZVS4buy7rSwWFLkcoZEH0GFNMP1xijlj/3V
         q6DW467yN1i4CbKLHoxh2MXWvsVM9EMB/a+NN6iz/6ydsVz+0PqAasrjITus8nnAKTI7
         LrLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=s0w22iAxwWX3zCufP/m+FoKgPyaiXV2DxPNqJeKo2Y8=;
        fh=y0CUZlbo5gvYRSa3dXVxIm3KeKxbHkINlz7tsZkiv6Q=;
        b=ayYEIaJPsKnlJckMDt3so3na6nbxfN/0jyPctVPbD9j0Ck2r9t/fBYg/Rgx7XSP6/d
         oXA1LoGBSrvoZuDU1i5/AreiRAayC3OVRLwm85/0DtDOv1KV+EjMTJjEzb0MJMr4b1Gy
         zC4qSrDY+QVh4k7IGYINpOOcDrp97zymwuDsdvd5TAZ2326s+yCxQ2BgZYJRXfE/8Y+2
         kpcw7IgfiGHhYh94Mv7rnPhk7MFW/uqFGRGukFlu5Mhjay210sp8xPdOGCcNWQGLRCib
         0aDCNrTf2vAwcMgMZYnVJyNX/2nbFPtfU1qVRIFTi8PfUPHt88r7jwIa6vNWvhuhZznK
         qn3w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791518996; x=1792123796; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=s0w22iAxwWX3zCufP/m+FoKgPyaiXV2DxPNqJeKo2Y8=;
        b=p6d+iwRm2x7LWaIkCMasRyU2yPdVda2HJWuUN8G/H3h7LwLkWevqmmbL7R8P3BGKZ2
         GV4Gq0gzVR6d728XeL5QV0nfse+EQfJOdOEt78o7kslfz7C/9NgZrZT1PZ74km4OCvCi
         noNV08SqDMdCNM3l1HrBbhJhQtY7ukO6GzMIDExpHDSIuhCJm9SoYjcpg0aUzo9hxn7S
         /t0wP+rX2hT022VHOVHpV+q0LGRwwED4585VIcCZnJP6IT0zdqMKm3Xcz12aIY4TSh2U
         PkVdNj7+diullU+IB1OEyQ1wS/m5r2k332sxNNP1FHTFAZiO7/R+Czp0e/1TYqZzEdrV
         5yiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791518996; x=1792123796;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s0w22iAxwWX3zCufP/m+FoKgPyaiXV2DxPNqJeKo2Y8=;
        b=OXkS509c7ip9Gtqg+DV8bqyx3QbPTqJrhYt54bJY2gueA+6Q9e9BC37L2inNtZXex5
         YgkYW14ezYg+ZFLPA6+dqOeO7sFwOba6zySFV4v46MVP9IZBiD/y7qjDW4ej34t9FDYK
         cb2L6/qP6PfQoKc3XbJR31AUuuNUV5gfjYpajR6aG9e4/TxFwyNMfm8HoIdTvtlRKftX
         eNj0pUOiwxqEE6W52j8RfZm5arM2Zpq6eRGP3Val9qn+LN205xsWcHIQ0ce92FEAkwnT
         ia21zEy4Gm4tY6REsQQuQG3Oeuh1MX/HKfr8KJJlETxAB5fHX39MwGjgmiAi9CU9nHeR
         viRg==
X-Gm-Message-State: AFuF++leP2jKCtpl3BsDYjQMQZ54bQMiTEWZM2FS2c9HX7Ly0hj8H9ZT
	0l8NDkTKGf6kypj/NNyrwBYDS9ip1WgtA/EZGb3iOVeBFu557Jxl1uTUWHL8gwsVDo4IP2D2uoH
	DhzKA0nicaGiTJNioJD4wftmPUTZ2ov8=
X-Gm-Gg: AYBFou0DtfesO3DbBg8bIADDIdlcwWNcE2NF76ZeoM4SzTh0ad7NsYHKygtQpoEtQKm
	ij7cRRtaNpTxahWpbKOlGdQFcR6MKd/XuGiMyxan6UkKTsdWSedRqYVaCMRoLkZUtwm2rbdkIGD
	S+aECB1NTqHIf13CTt/yyUk7bwEZ2G/a2PSNF42G27fwnxagB1Osk+EYcpS2U18IcJLzEnZEpJo
	ZL8B+mQFKD4Xl+/4vxKLRdIRXN/q8fwTZks/47nbCZ7gdLellGg0WRH6ZkoIbdgkD5ZkY6JGvzH
	WTjHaMO67IYjRiDJtP4ni8mfkP/EEesPgD4GfTE4JKyK4YADV0Dwtwaz6oSBwcb1vcuNtwjAGDp
	ENn74El3+gGPz95cp3UxJyeIoVnaVLL7G028hiAZLjZTtDTIUlf+iReiTU4PNSRZCX06aAdjBiz
	FlthDcd4D60yqFY5DifZcYYQNyEQ94UXH8H6oN7MUtEaT79BCEyW2rDVKIniUNa9NYiyQ=
X-Received: by 2002:a17:906:dc8c:b0:c31:8984:7fad with SMTP id
 a640c23a62f3a-c31a9feb114mr51812266b.15.1791518996327; Thu, 08 Oct 2026
 21:09:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261004233523.516891-1-rosenp@gmail.com> <ashiQ98Qmie63mB2@studio.local>
In-Reply-To: <ashiQ98Qmie63mB2@studio.local>
From: Rosen Penev <rosenp@gmail.com>
Date: Thu, 8 Oct 2026 21:09:45 -0700
X-Gm-Features: AclHuK_UrczYSgWiELM86QENzwDdfuoi_HLVyZFd-zZES-cUZQQiE5vhNbu5RWc
Message-ID: <CAKxU2N8WtY+=dhSTfyu=8ujEwnkcfV9PEkXxuTLHthwksDhTxw@mail.gmail.com>
Subject: Re: [PATCH] bcache: fix kernel-doc warning on CLOSURE_CALLBACK
To: Coly Li <colyli@fygo.io>
Cc: linux-bcache@vger.kernel.org, Kent Overstreet <kent.overstreet@linux.dev>, 
	open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 8, 2026 at 8:41=E2=80=AFPM Coly Li <colyli@fygo.io> wrote:
>
> Hi Rosen,
>
> On Sun, Oct 04, 2026 at 04:35:23PM +0800, Rosen Penev wrote:
> > bch_data_insert() is defined through the CLOSURE_CALLBACK() macro, whic=
h
> > kernel-doc cannot see through, so the kernel-doc comment above it
> > produces:
> >
> >   request.c:308 function parameter 'bch_data_insert' not described in '=
CLOSURE_CALLBACK'
> >   request.c:308 expecting prototype for bch_data_insert(). Prototype wa=
s for CLOSURE_CALLBACK() instead
> >
> > Turn it into a regular block comment, and drop the @cl line along
> > with the kernel-doc markup.
> >
> > Assisted-by: LLM
>
> The patch is fine to me. Can you provide the detailed LLM name here?
It was Opencode's Big Pickle IIRC. Current documentation says to just say L=
LM.
>
> > Signed-off-by: Rosen Penev <rosenp@gmail.com>
>
> Thanks.
>
> Coly Li
>
> > ---
> >  drivers/md/bcache/request.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> > index 3fa3b13a410f..e7f097346d64 100644
> > --- a/drivers/md/bcache/request.c
> > +++ b/drivers/md/bcache/request.c
> > @@ -285,9 +285,8 @@ static CLOSURE_CALLBACK(bch_data_insert_start)
> >       }
> >  }
> >
> > -/**
> > +/*
> >   * bch_data_insert - stick some data in the cache
> > - * @cl: closure pointer.
> >   *
> >   * This is the starting point for any data to end up in a cache device=
; it could
> >   * be from a normal write, or a writeback write, or a write to a flash=
 only
> > --
> > 2.56.0
