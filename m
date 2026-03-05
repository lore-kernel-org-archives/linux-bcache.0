Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975983CF682
	for <linux-bcache@vger.kernel.org>; Thu,  5 Mar 2026 18:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772735861; cv=pass; b=YlYqPcL6BTIeMtq6F1uaUkQQAcrg07/vYMHuyecAeBVPBh3NQXa1TQMTuEkDtkyMCSmnhvAh0hYeRDbPTKKqP938wRom8CN5VhZJBpId7taU5aKU2AfYVqZEGwld4I3exdqyAWfY9auMb8ztDiOoLnCrsZqrYx9kRmhP2K5UydE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772735861; c=relaxed/simple;
	bh=R6dH8XgJiObtxOpcsUX3tskHijiwulWb20uGf7t+NqY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kj6ggUZsXhFqdFiaHCc/q+P5XTdA2cLhhmOtyEbHQNGLFimWiuP2PwqRYEbgPwuMLybSCLLvOzvzSy1pyzINbyAZaMWoEmVFdhMYsaXn88Mk0iUFTL60LwT47r20tcVMnO3Fjde0smvOnyPVMGrjmnBCeCpwCqgv9JNBeOHelJI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GMSvzMaw; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=C6+t+gmv; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GMSvzMaw";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="C6+t+gmv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772735859;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R6dH8XgJiObtxOpcsUX3tskHijiwulWb20uGf7t+NqY=;
	b=GMSvzMawyK+f5DnL6FSGjgCNefvwZroZ0qrfMOOLKMI2sg0Ig/xOie+TP4mLL41GABAdCR
	VUNjfZBvncRkNVM+OQ0xk+g26CqSDtQnm/jgIUItcrp/g+4dZHxxy7o8U7KuzljAnWeoNy
	k25ysmExwfRBSAtcnRTksL9kAzVMUTs=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-520-lVswyKF1OuuBkhbUxzn-qA-1; Thu, 05 Mar 2026 13:37:38 -0500
X-MC-Unique: lVswyKF1OuuBkhbUxzn-qA-1
X-Mimecast-MFC-AGG-ID: lVswyKF1OuuBkhbUxzn-qA_1772735858
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-798541939fdso147918617b3.2
        for <linux-bcache@vger.kernel.org>; Thu, 05 Mar 2026 10:37:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772735858; cv=none;
        d=google.com; s=arc-20240605;
        b=cngGN2843LTd4iT//2IbPvwNv/LRoXst7m/52t5LaMDPF+4Q4gDdv5yZQ9Y2pBufyV
         nofxNfObVKbTHiTrRJ1pgJZ66HwxzSAnHBu9cKDgJMstiVmtfzsSoRIdXGQ2bo3BkMFh
         eWIwGXdqhakky0+dJLOmNYLSYuj6DX1vQhQqBYLKUK26P7rChErC9NkkrgZA4tLfWLmo
         +K6CIDtstSF6XylRaS8ckn9nCqF+nXq5gIpg0Hks6MJLmA7DrL7t7ZyWJfCWXMvYyFgu
         /rWgTQODsjIDIdSP4wmma/oNIAlgzeP2H1ogQjBupp7q3KerIkjxIWDv0AbJjtB9GPWQ
         rbLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=R6dH8XgJiObtxOpcsUX3tskHijiwulWb20uGf7t+NqY=;
        fh=/r2u/nssW7VfQrfHx3orI3q71jlhIFCN0jUsvRADUBs=;
        b=hGmJ7j+gwSlxiJxivLxJ+t8jY5dJAxXTAHII2IKTfq8NUOxfB83qjFhWuNKR2+jTTZ
         2w7Lkg30b/AWeczNtGT1Pop63sZDmhxXcavWXcrcFwj/EtcviFKHDHjznI7ppCf47TTb
         c30+sCD+/Ci47rcJMP4mw6mJL+mEHzuR+wwUkRO40M+bXYnqQoec/kG+URVLBVxqOz1F
         Usa+HUHmWlmW2UhUjOj9FjSsilwPaxPmLEyWWD++9joPghkXQkZlV++wM8NNN4NaI6Dn
         5kvXgtBxKDSDqHGBHPCI/Vawz/e2FdsMWE9hacxcLAA89ebfqqECnIonLfzXv/i4mJFY
         uxRg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772735858; x=1773340658; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R6dH8XgJiObtxOpcsUX3tskHijiwulWb20uGf7t+NqY=;
        b=C6+t+gmvFevtjGdH+DEZ5DMp3y2iKxSjmoSFw10y1/Ru2CoyKo+/bCFruvyq9inHqF
         QcicYjEF6+wQWjpTobI9il3OCo8r/5rIP4lRNSlYfR3A4w5aXpDlppanYC0aUokaPjsD
         RSXWZHdNaHCHDBCIiFe3Qn0XAyeTnLPGzwLIyKPedZIERoGjjis83Xt7qxJNc371vBEs
         UNz9aSn0MvpI5R99iXu8293BzrQIj+9wUJ4XdMY4ThNRzsIhfC6Namz8m4Bo0GofBf5C
         tqU3hEp5pKH+c4avG5DYeHi+w1hdThIjD3UkuTy6+RjSq9frCzpXHdf/i6ySmjXnYSMU
         m2bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772735858; x=1773340658;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=R6dH8XgJiObtxOpcsUX3tskHijiwulWb20uGf7t+NqY=;
        b=ETL/M2YjxEgFevrkbf0nqxcvl0YEhkx0IZrE6v3JRNGOKjbGHf0k1rmyOUXsKDzUET
         xSSot+1+317w69O6UPtchLbEVkmPMNkjMUZWTDunQYrjNcAzDDJq9dEjBpptLMl+yDje
         x/oXl+Ai3keLoZX2w9EU3xxUrXW6iolnMyThebiCw7k9gncOmqpYwBovfRF30iDXZlC8
         arn7z/IJsff5RQlmT8InJG2PHknYIw73X6MEZ103MOfmYCbTDco68p5dhYsYXxWKKfJO
         mSbrMk2QaawrPereFpsPPr7U8Z1c6znMX2CQgQb6WC+kdUEQilpWR+lQKcZU4jkXrVV8
         KPQA==
X-Forwarded-Encrypted: i=1; AJvYcCVIoclIyui/XBQPrJu3AdNvowD+CrPy+VmVxVxt8vhdJNf8y7IK2BX39SX/kF0SQCbwuLQ8SIGaQ4BCAlU=@vger.kernel.org
X-Gm-Message-State: AOJu0YztxNmyVG1IIMV9gxDrCvr51+sIRujECoi0YdPihceOLXtR4N5c
	5C5DC26T3fGD+HrwUY9A+TX4tQEXJRJ8/IvfoR5YcPmPFXSJsdjhICKbetm0Z1s5nO7B4tA9DRF
	PZCmq5Xq5ECquzzV4b2GUE4wTjc4oqgkaIGBL6nPqJgXaHF0TyHPf4p7Z7GgOM5/HIkUumEbcs3
	166FtxqO1qsXnqWJN+PnAVIACId73KHm26+WuBX1YS
X-Gm-Gg: ATEYQzyeBtcNsbvbm+kjKymB6yc4rAUg/0GISzF3KdBWj90Jrq0ukwemeYG2jiimHds
	6nYQu9zXg5zMoCJ/ePuIaIuWHJSo3NQ/Ygp6/mzBHWdmPVdCwCI9he5hr5INS4sV59pHAFsz76x
	WzcxbjhvIUdT41JNLv4R/8qvIxrug/6wjjx8LwJ6kVyQx8C9lnRJbHR+B3kJiw5sC8KmxPyiE6x
	LyXCiNnFOTBfE9BqACN8w+suk0vxAwsvcTZPyAHoeST4a8mpemQp0YkrBFzutRWsQ==
X-Received: by 2002:a05:690c:c513:b0:798:647f:239 with SMTP id 00721157ae682-798c6c01a87mr55056877b3.21.1772735858047;
        Thu, 05 Mar 2026 10:37:38 -0800 (PST)
X-Received: by 2002:a05:690c:c513:b0:798:647f:239 with SMTP id
 00721157ae682-798c6c01a87mr55056657b3.21.1772735857680; Thu, 05 Mar 2026
 10:37:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260304190424.291743-1-agruenba@redhat.com> <20260304190424.291743-5-agruenba@redhat.com>
 <aamP2qNKEmiyXQQH@infradead.org>
In-Reply-To: <aamP2qNKEmiyXQQH@infradead.org>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Thu, 5 Mar 2026 19:37:26 +0100
X-Gm-Features: AaiRm500QkwsYOPyC8DDeTtG7W1JPyGlNX5bDWdmiHocLDeSRR23AHcZAF5cQWI
Message-ID: <CAHc6FU5sEivMqj38xrAXuTxZ0d19LJjxbvoWtsPqm6NYigAEhA@mail.gmail.com>
Subject: Re: [PATCH 4/4] bio: use bio_io_error more often
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, drbd-dev@lists.linbit.com, 
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, 
	Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 5, 2026 at 3:14=E2=80=AFPM Christoph Hellwig <hch@infradead.org=
> wrote:
> On Wed, Mar 04, 2026 at 08:04:09PM +0100, Andreas Gruenbacher wrote:
> > Instead of setting bio->bi_status to BLK_STS_IOERR and calling
> > bio_endio(bio), use the shorthand bio_io_error(bio).
>
> I'm a little torn how good these helpers actually are, as
> hard coding one specific type of error seems to create weird
> code and lead to bugs like the xfs one you fixed yesterday.
>
> Maybe we just need a bio_endio_status() that allows passing the
> status?

I'm not particularly attached to bio_io_error(bio); it's been around
forever but it can be confusing. Any thoughts on replacing it with a
new bio_endio_status(bio, BLK_STS_IOERR) helper instead of keeping two
mechanisms for doing the same thing?

> Also you really need to send one patch per subsystem.

I'm really trying to avoid that for simple, obviously correct,
mechanical changes that can be recreated from scratch any time.

Thanks,
Andreas

