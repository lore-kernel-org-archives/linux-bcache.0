Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F3D3859C7
	for <linux-bcache@vger.kernel.org>; Fri,  3 Apr 2026 11:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775214669; cv=none; b=Tpe6RZTr/Iy2pbmn/qFElDgLcRihQdKb69d7WabWBW68NWlqs8Pv7cSemTzlJ87ZAjpAOxIt2b+GH+1Rr59nN1DzMm8JJJNVB1tu7UUpbI/G4VI3mt9UOm9S4j8xhBsplio0UGLom9kRZCg54oMVmaYTzP5Gea2N6EcHfPwKaQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775214669; c=relaxed/simple;
	bh=DVkFWb24aH89y9V7/vcCKLX6r2OjdlK8zdG5Sm5OJ/s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lcJlAvJFQu/YbQhauqi5mFQqgXgHY4hR7x7tGvjAuBPkHxQG/4Ul2uvVvJiBArrgcm6NYcneEo8/5jL83MxR1xvh3jLMnEQQwDsj4GlkqTjVlpVL/7b9NuXd+ZT8ID3EYMLPVwnKK83y6AycOol8PlN4g5ZqFLl7LnRVekcdYaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=X7MxVIi7; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="X7MxVIi7"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7d75371d873so1687649a34.3
        for <linux-bcache@vger.kernel.org>; Fri, 03 Apr 2026 04:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1775214666; x=1775819466; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q+tzv+p4LGHBYc8XJYjQNa0s8szhRBBBtAbWfuRiEpE=;
        b=X7MxVIi7IACwzljRcCCBgVo+l4VijPuXCsZ9RT6hOhk7TifUcniaoWQ0YmWf/VLupX
         HG7ctDBILEeNPI7CaMSg0iIfSubGjUm0bsIro7SzeGtTt/4158n+O70EGvGYd0IN2Kwx
         UVKRdpSJq3QX48jCxOPLcVO9oTRqsAVPKQVX+NvzkYA8fP+CTyLeh34yJhQIcIHqDDnx
         Qiap43uNHMhYyrffmPs4XvyiJCQRukgNV8vjctvU3pjGPjs01OmXffR4PnaACHDysNM5
         2vybwHxAh635dQs26azt+eVsyF5fZNXDTq/XrecyELg1L1Jkl7CFJpZquqmlD/aEG0Px
         LcgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775214666; x=1775819466;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q+tzv+p4LGHBYc8XJYjQNa0s8szhRBBBtAbWfuRiEpE=;
        b=dTf72Sk7yLkPRe3+ZjACDoeZLyzbB8UeKrn1BMS8oHzeTl6R5zHOx70y0u9+drqUh/
         opc6c1JwQSuvfyWPX10AgpZvwx1r7Hsp3Nur+PXeZHAub8qQhLBQLyTDyYynGLhHgN3H
         Z7ha2hrDEUO2uVd2IF0Ma6jCEYWbknAp29gFa8Ep0RhDs9NkB7azsyHZ3TBJ5DniwQo7
         9VK2sws6Vs5HzMrZqZsgMrsXlsW/cVfTzHFS3dGcsypPrqVjFbSiRmM8tkUoRbuaP0YG
         2Mm9VdCFxO1u1ujgKezX+X36N/rqsDIKiFoOcSSqTNRUt9zoZGLUBsGTET01CQpud7im
         RCNQ==
X-Forwarded-Encrypted: i=1; AJvYcCUkgiZiTLLcc6wlZpyaA6K5mBwh6+7GX4I2PvsacVt/4j83C5ifSBe0cbaMKnb7faVfbp3qxLYxtH3AQCo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCZx+Voppvts0C89jpYAg8S/kCKvJXphyo6W3GRanWNDqaeMyN
	GwH3ZkGWLVtiypmp3yfmP2OAy4QOh0AUrXbmFoFzMWSnPvlTUSPA8fHG9K51YfU+czKRc1qMzNA
	KMAjWh3g=
X-Gm-Gg: ATEYQzzHwUh6eMds8KFMtMriJcTMfYUEU3b801fFBZDXIbj556675I7aZ+mF+nXR8z/
	fJ0CgpHahvbcE5xLHfpHPuVE08d0lGEjgPv8/AbsBE/lMIbVQXwjH6XZmxgJzpTMQqCFhI55s6U
	C3+5ZQqtCGW0iioKBgeBIHgqA4VfrqubQZj1peNzVaRwABojQxOi03MYbdgiFodz41yujMDlgZb
	HwlS0jMThwx0oUpcLbUqHuqlsWRa6ScWPF3Ne+StvLLoY4Qsr4pxUD6YkijHn9MPLX3cw7QbCNV
	YeQn7kDx8eM6K12dH9th/K+x8Pazc0C1XCgPHVsgo+2B3h7kymHRSz+PlyjX/Qy2Haq4daGPgIC
	9wk5+ytvLMGI2Kkuv91uHZ7ZQBcQ5jZXmitXKggZaXxZZxjHmLE1ycPnEGPJdVkiDxQo+/9RoCP
	l8Eb7LbVmpJHdw2b8sbHiKga2GdFai9uwNv6wUmV+7vqZOSZaIDdGlSzWaoGJd+cWleUn96Bp/N
	Wa2W94xUQ==
X-Received: by 2002:a05:6820:81c4:b0:67c:27a7:8c4b with SMTP id 006d021491bc7-682203485c3mr1521957eaf.54.1775214665811;
        Fri, 03 Apr 2026 04:11:05 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-680a8d1d2cfsm3347420eaf.13.2026.04.03.04.11.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Apr 2026 04:11:05 -0700 (PDT)
Message-ID: <bf06ffae-23c8-4629-a963-c6c6ffdeb4e1@kernel.dk>
Date: Fri, 3 Apr 2026 05:11:04 -0600
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcache: fix uninitialized closure object
To: colyli@fnnas.com
Cc: linux-block@vger.kerenl.org, linux-bcache@vger.kernel.org,
 Mingzhe Zou <mingzhe.zou@easystack.cn>
References: <20260403042135.2221247-1-colyli@fnnas.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260403042135.2221247-1-colyli@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/2/26 10:21 PM, colyli@fnnas.com wrote:
> From: Mingzhe Zou <mingzhe.zou@easystack.cn>
> 
> In the previous patch ("bcache: fix cached_dev.sb_bio use-after-free and
> crash"), we adopted a simple modification suggestion from AI to fix the
> use-after-free.
> 
> But in actual testing, we found an extreme case where the device is
> stopped before calling bch_write_bdev_super().
> 
> At this point, struct closure sb_write has not been initialized yet.
> For this patch, we ensure that sb_bio has been completed via
> sb_write_mutex.

Presumably this should have a:

Fixes: fec114a98b87 ("bcache: fix cached_dev.sb_bio use-after-free and crash")

but for some reason it does not. I'll add it.

-- 
Jens Axboe

