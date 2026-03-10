Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6026643DA21
	for <linux-bcache@vger.kernel.org>; Tue, 10 Mar 2026 09:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773135034; cv=pass; b=CQin2GArBZSr+re1xKEqLPMjp7pkzchopBnPwVn5oros6uZE5o0IIrjqJyIn9qXLgHLN+kJOLuPFeqRoxPMGlMCJhXfPjq4BuRF19/4a8rFU4p2D5bCdPI2WXgNuw/WbL84rUoQYRhNQoux9/q2qCtNqxCCnRI1GsFXimimva4Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773135034; c=relaxed/simple;
	bh=L0d2ilx4eHr2s2WQk//cXKOMyF7eCafo5gDeTlAlZko=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mGiRR98s/xf/9rv1dHGj3gYEr3llDq3+b1nEz+l8XiLDj/W5xy4QatrM2pWGTb+w1pOQJUgpvfvChK/VFdoFFoazfOGIf/0nJne2BYMkdgFkFajjt8vRt3mg3I9CqwZft0QCie8VtRNaJsV3vPaeW9mkBVjrdttfEvV8zICTieg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WFpIYoDW; arc=pass smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WFpIYoDW"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-899e87b04d8so161007016d6.3
        for <linux-bcache@vger.kernel.org>; Tue, 10 Mar 2026 02:30:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773135032; cv=none;
        d=google.com; s=arc-20240605;
        b=DhJfWEF0AQ0nFq8WNUj4NVqezwm8XLm4pLksYfbmlVhZYB1FGwE+R0rjVsB2Mkru/g
         s6sPoHlPJm0NEKjmlmIxw3ccTNDqpXOKZZhP2wUBUC/2fc0+ZV0wbBZr8AVpkEd9PT8t
         Agv2kpn46ljBgpGRZiylv9OpvbJYNKBc7TwSCLiJ6uuTs9FuMwVT3HLP/wfUk9cgz3Uc
         XHoAB2uPNVaHEBMyTdYITJlxEZZ8G7v3skra28Rkl3zjFvgJPgq+GL/PxfxFS4wg2XwM
         70DBwQg507AGqGtyGUNCg9po8/rqS0kqq2ONF6EVCBIqwMOTcL7k2jeYjB6D59m66hWA
         p2qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=L0d2ilx4eHr2s2WQk//cXKOMyF7eCafo5gDeTlAlZko=;
        fh=lmZQOyeEb72hKS0El/PuObfT5iElH388K3D+c0Qr18s=;
        b=YrNFY3W9ptLZXWmwzrrOJL5M+hjZSbdC0ijzLmzjLujYbx0EWb+VKIQyZfh5ZbpnH0
         T4xt5z1ore6wMW+pTwphLFlR3CYpcpjCzYKAKqKMNIvA0K1HAt2yY7Y/9hBk+tZOx98m
         ogb0j8RuFJLG/RgwLowLfas5Nav/1dXWL6fWFerNxgIL3wWdAtdZVPrM7+mTrVVUAirv
         t17kwO0wrpnTqoBil3eGRbpsTwuvKRRU8aORCqR9mbNpWTwKmRHz8xlyeBW76UUfXoCF
         Uq3m4fxpsf6cGqfizzuGneX37EmN5OEB3CGx8vQRBlqGtq7mFh/z4/l5YVgwukcE/iMu
         ntxQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773135032; x=1773739832; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L0d2ilx4eHr2s2WQk//cXKOMyF7eCafo5gDeTlAlZko=;
        b=WFpIYoDW85mqsCPnRunvRPVHakO778wNdFA81NiPoHBhtFqZhVjx2dLxhkqnxTA6/c
         Vx7ci5i6g5GFYAZwd0bIAigPEXHRWgPlanv6grU0ajwfZySngHyLaHUhbA44kat5/pek
         5VIuWJi4ivyn+M2hypyR0hpPcf+liihmFVIQGmxE5iBpI4dqx9llOLBeR+CxKC2UH/9V
         pjvy23qY/muGlwshspBRQtpPZROCKihYDioyGFdblIqgeD5gdb9/ywaa6TsCl7NHYBMK
         21Rd/QThlr5RSEFeJmsiNGgT2aBnT9AZ930/jDKEP+3P6YcqywhmwNuQiTPE8qAh1OAY
         xh6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773135032; x=1773739832;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=L0d2ilx4eHr2s2WQk//cXKOMyF7eCafo5gDeTlAlZko=;
        b=MGcjm0IQ1X9TkyvDwh+EtOHGelJL4t/9s6QE917ONFPYkuIsLK8wX/Y4GLFTckKIYR
         HFDx+cRB8fN7ZbDW2hOwuGmQvj+QyNJN9OfQUUqsnKq3Z9eddISvsnFKKwAgU2nVVOZH
         iNXbwr42CW+0GaKBtEta8p82271aRutVqaWmXxCzrEGK17DzXPoJT5b8suZza0KnroAp
         LbUmshOBnFMm4hsgA2+BeAHyUjz1SofXi8aN4lbu78Ka2mEVGT75tMo/1OylUlM4Vyr3
         nyle8Zdith3MunehboUaeQuyLWU/tKwXsi/NYy56C4vzLTeM7OI36ygoaJrWjJvedVLS
         79gw==
X-Forwarded-Encrypted: i=1; AJvYcCUShHpo3Q2rV7kQtf2T62Zc9eKiIyCuZc9I3QsnseQAmDm/CbsKRJ6vWmAy1Gs5m8P+vZL46yxA/BI+SS0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxaQACnWA0b2E7b1oFRvyr23e7L4fjGiDN7R8H6SVX8YN29l873
	NXuWYSAqPQ1COssvOyPAbvCc6q/Z1sAqwdXyivzVrNngBiepkd6zA18w24LvbCn5mQ3gjiZQ5nC
	Y4PTDseVnAFJAGIlZsdX24hZSUTljP7k=
X-Gm-Gg: ATEYQzw7LmdTpz73Q1/Vny0ubPozRmGLQgwuh/b9m13sjOBYMSQpI1pt6QvwJlljYNn
	N/H/X1odHz8fitISVkDRamv+wsHbF2Uo5QS1SRStcyFMpKdLQX8S451plEkD+ttMfRyUwUboorC
	0JGZ6e83kqb4IhjrJjZv4/5JB++nLsl06pAGWEXVoaeD+Kjjypv/hYhPtzBe1Zkg0gsp/WTfSGP
	Q1NkPShemwGRSAgaxW8eVujkOMtbi2aQ/iIy2glfUwIa1QTHJEF3m4iFecsoHv7fZOX9JBTaV7t
	7e3vBgs=
X-Received: by 2002:a05:6214:e8b:b0:89a:116b:e67d with SMTP id
 6a1803df08f44-89a30ad6c0dmr227011126d6.37.1773135032404; Tue, 10 Mar 2026
 02:30:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260305-bcache-v5-0-04cd4c9080d7@suse.de> <20260305-bcache-v5-2-04cd4c9080d7@suse.de>
 <aarFVqxrXF9Bah31@shinmob> <baa3a723-2f9c-4e10-9d42-b4152de92df2@flourine.local>
 <aav7vTM7IerMwsT4@shinmob>
In-Reply-To: <aav7vTM7IerMwsT4@shinmob>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Tue, 10 Mar 2026 17:29:56 +0800
X-Gm-Features: AaiRm531AQK6W83oVfyfdl7CaQuHywGOjzjWLWtuvzLamYUJA-NsVM86mhjx1HM
Message-ID: <CANubcdVc-cP4dAZs_mkTG3rYVYa5Z2ihd3Crp2J-GRDUYpGGhg@mail.gmail.com>
Subject: Re: [PATCH blktests v5 2/3] bcache: add bcache/002
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Daniel Wagner <dwagner@suse.de>, "hch@infradead.org" <hch@infradead.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Coly Li <colyli@fnnas.com>, 
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, 
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, 
	"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com> =E4=BA=8E2026=E5=B9=B43=
=E6=9C=887=E6=97=A5=E5=91=A8=E5=85=AD 18:24=E5=86=99=E9=81=93=EF=BC=9A
>
...
>
> May I ask you to share what kind of devices you used to recreate the fail=
ure?
> Also, could you share the kernel .config to recreate the failure? I would=
 like
> use them to recreate the failure on my test system.
>

Hmm, I tried to reproduce the issue again but couldn't.
