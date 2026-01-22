Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B053826A0B9
	for <linux-bcache@vger.kernel.org>; Thu, 22 Jan 2026 02:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769048494; cv=pass; b=ApJO/guArn5MSC4iPlymT5W9fYPMFCb68VdoDmJdZ4XaZxfJM/3ta2F8g+rhUbneo2JAB3NoVJyRAXTcgYN9rXJBaxBFyf0KshAQOpzMfb7um8erVeHbF5v6/Wwd7ht4WOSUt+c5m0NODcSGiskVEL3yMNadbXwv2F9DJpLWwZs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769048494; c=relaxed/simple;
	bh=C4KF3BvPActUdWRZiQfJOW08ynWFlfUtIE4On78iXiE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N4H6UmYcbMAEf/pbsw7VAiP8X4lMVhcNvPBNQ/EFBuve/PVVW7lEqmAKoPnyzr87gQ+2TZRLQtRdNPp/69qv21dnu0NauM447OhwZrFYW2VjUlIRsvtMsjTQLz/ezq68vGTe9eZdJprGKw32KqmDKPf1ESCaQ79qWEapqm1ARXM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PVQswan1; arc=pass smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PVQswan1"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8947e6ffd30so4706546d6.0
        for <linux-bcache@vger.kernel.org>; Wed, 21 Jan 2026 18:21:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769048491; cv=none;
        d=google.com; s=arc-20240605;
        b=VUM3tZV/D1Skj0HO4H3QGMr9yQu8BMI7INuIjFGpHFBhJhjr+FY6oWEZQdRCNiroHw
         1UiEt84iIEaJ3eNu9efdzq7O9Do/Bt/JJaT0dQnTfmpQR7GrtqQE32XxjRRgvGlQCmgt
         7t3YNdnAp2aMtmzzH0wM9g/v4Vs+QcHsoqrO2r9F4iQLx6EXEL5tq00/bv42z//XHluJ
         J+/eY9ax8nHTQSWKDEtF8wyNhC9w1GZ/mSqGI0Pkh4n2B6HzgMmRaWrhAxt8u1R+HzYQ
         YsFBAke8uVI8ZPT4nRLy0f36nmjxGty55C1jfXu6cXz84/hEhidaPnxs0zwGyZGJXpRC
         s5sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=C4KF3BvPActUdWRZiQfJOW08ynWFlfUtIE4On78iXiE=;
        fh=zamvLumwaHfUxDI56SlG1SdgUhdqG2Rj2AuSmSYKaRA=;
        b=JTMgdd5k9owHiZJokQnnZk3XKdssbVbkQMgI6NAtsTDVFTyh9ar4PIamsGM7/vES9z
         8lKUCIHZF8MpxcFqAZ98kfd5GdnA0015r+Ee86Lre9RRYwjIA0vra9mZ0aAEFJzmiCYH
         mv2w6iudXOwpO0T9EnCozMnUQSB7KXBRuqbi9UT1kZ77AChO6Ag7rR2n9QW8JJ23YV2T
         dyvj5+UHbhA9bjOtqtszY49WXF2shVUVekI12w7x7pnxRGR/0Ejslv6cYMxF2Mwgxfdw
         asqs0tcCAS4iuc61jHClxWTWgl6ocULr2j6nf4He3Zb+Zd0iKZ3LltaTr+OPm55MLa0A
         LUUA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769048491; x=1769653291; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C4KF3BvPActUdWRZiQfJOW08ynWFlfUtIE4On78iXiE=;
        b=PVQswan1o6J5scJIHtAWHHr8TNaj3R43Y/ByveLfXgR5B9Mn9LUlKMKkA9aKZgBFNy
         LEMdnSyY0bNw+tkxcXENKwRkxk6V6HPCVOwGWZJ9Cz+kdX/dbNz00UOeJYpRLczpz77o
         W4w+FV6i3MFrie9RucZGx7ldl7unF75lhMLlEmOBDmZ7ZxoxW/Uod+fm2xOp9Vwxe9X2
         Yh5UssWoxSq8kTqtr+f00juqlwz2XeLJuD02z/QPQyw9FR3ZB7ujmL0/53VyEHOuf32U
         tjm9B+lPJLRb1SOHJOdFObt+xH7/nGVlr+mBlUmCwC7pnFIrIBOQpmIK3XsDNixKpJzY
         BTLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769048491; x=1769653291;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=C4KF3BvPActUdWRZiQfJOW08ynWFlfUtIE4On78iXiE=;
        b=qwTTbZaRdbd26AGljsQzOORzsFRlJCRYgSa3nU+WswJOA7Nqj4KntJXZ3jLQPHxVqT
         Oy5UsrPxvA1o8PJniFBVTdEhskYG16x246evzsshio8d3ZXDGMKVoH3PlpecCcpeaJuR
         VUJ+FsNb6cCBKCS5fmtM6+rnHw9EJMZUHLVWoztahFjuEGmyVSxakVmM0Y8FuBmGluWN
         KDK80n5500IZajvY4JDWYG/XTj7lfvdmxD6tSYp5CzDZ59UoBNpRpPpq4Zp5m8Fw20TS
         3yEqvvH0TQoIkWHW7n9lcswhliHGQxj3zn2nEL23LR2UgHUdEvQLfhvdvy1i2LKJEL7Y
         JfuA==
X-Forwarded-Encrypted: i=1; AJvYcCUBLLtzqcG4lsMfCs3QB+rHQft1LT1cqgJQfjDGKFztyrx+vpCRIf4ZvxB8Mr6fXNFYbnc0bGXAdn+P+nM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzbbrz8NMAJM6d13FIcy2LMqW+saZN72bkkYxCqwkIwHDy5hHXD
	8VVq87d/ZNBsxRqmlLmlkoXJgRmWNXdwKrm4X4eoDCJO9x/sBrZHWfYK+2p44hLnFA5tUe72Lpi
	nlux9OdnHwvEF3+hX4ZWS+GP/hDCgfo7vpkMe
X-Gm-Gg: AZuq6aJ0My7Ig2Wz3pP9e7Xvx1DmU+eEmGbkHRsolWlUEprADzGwlFLtjdM8bNQavX1
	qQOM+huqnmCYfRHAQoYmLXLA4nh+N/ksZGdGR+OdWUnikEQGOm6tC9RnBB5rZ7pKFrculX6wuJr
	QNO4DLQ0AAdiFiIhDJQNk+fx+mJj8waNQX9+GRhuu4Wu97abgg7KRRXl7lU4yrP0XMJZzSl1OZY
	O+0dJLHuvUvqKvBf0iQVPw7xOWwKDx+mVumV3xJthgP5MoAjGOfn2aWCFBozafmkFrWRxc=
X-Received: by 2002:a05:6214:5189:b0:7f1:c596:e1cc with SMTP id
 6a1803df08f44-8942e2c9a62mr280437696d6.19.1769048490607; Wed, 21 Jan 2026
 18:21:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260122013650.321766-1-zhangshida@kylinos.cn>
 <CANubcdUShtRu_t+VACzqpeEUdFtxqP+ErYFr-iWHgwqzD18Pog@mail.gmail.com> <fdc4f3c3-964d-4713-863f-13a1bf20f154@kernel.dk>
In-Reply-To: <fdc4f3c3-964d-4713-863f-13a1bf20f154@kernel.dk>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Thu, 22 Jan 2026 10:20:54 +0800
X-Gm-Features: AZwV_QjsGTtsfPeP1SVy_Pc3THsdreIDz5uIi1sQYJ2K5LjLUdo_dd6J3JVFGFk
Message-ID: <CANubcdUPFU_75YkNORATSFdn05_UeXbm4w90OuJMg1TZj=z5dw@mail.gmail.com>
Subject: Re: Fwd: [PATCH v3] bcache: use bio cloning for detached device requests
To: Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@fnnas.com>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Sasha Levin <sashal@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-bcache@vger.kernel.org, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, zhangshida <zhangshida@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Jens Axboe <axboe@kernel.dk> =E4=BA=8E2026=E5=B9=B41=E6=9C=8822=E6=97=A5=E5=
=91=A8=E5=9B=9B 10:08=E5=86=99=E9=81=93=EF=BC=9A
>
> On 1/21/26 6:40 PM, Stephen Zhang wrote:
> > ---------- Forwarded message ---------
>
> Can you please just send it out as a regular patch? The forward has
> complete whitespace damage (it's all spaces, no tabs), and when you
> forward, b4 doesn't pick it up either. Maybe there's some reason for
> why you are doing these as forwards, if so do tell?
>

Apologies for the formatting issues with the forwarded patch. When I try
using git send-email, I'm encountering server rejection issues.
Interestingly, I found that if I cut the patch content in half, it goes
through without rejection. This suggests there may be a size limit or
specific content filter causing the problem.

I'm investigating which part triggers the rejection and will resend the
patch properly once resolved.

Thank you for your patience,

Shida


> --
> Jens Axboe
>
