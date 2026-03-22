Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681D4364026
	for <linux-bcache@vger.kernel.org>; Sun, 22 Mar 2026 14:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774189781; cv=none; b=jYDLVuyZ5Jh+hWAcs2VKVef2kzVvhUPpL+QpMdh0D0huQ5654PovaMXX1Y+31Nwd6Tyvrv36vZcI6j70R8V/j2UrgZ8WOPOKFUfCpu5BbYyPvl1oz5uq1EmCv5IJG0swBvbTu/bK9MwJZqRQ9tXnJQOJU3+7wKFr/1SVoXOIi1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774189781; c=relaxed/simple;
	bh=DHiLsipr4skFAI+dJq2lPNkENskIRoxGBtjbvilllQQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dHfUy1pLAKDuxryi2Ag/hiCVGIfPtrU+v8cqJY0r60VC17TFiDxpdWHnqLuuDJKAjVadPe/DBEVjC+FXy5JnSOhGPF1IHc9aKCHj7bL+7Tcyt7QBHEYWahBy2NFzaFHwKwUDQ+hdA60dsio7D40lFOYKUxdlRai4BiBkFaFZ4QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=eJKoAS44; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="eJKoAS44"
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-46808125d28so545985b6e.1
        for <linux-bcache@vger.kernel.org>; Sun, 22 Mar 2026 07:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1774189778; x=1774794578; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lj7ZP+p/L2RJvrz7ry3hoB/fyFvBi0CD/xL/gfPc3sw=;
        b=eJKoAS44s/4R1MiBBfNxH7IW1vC5PV/uGmFgPJqqx6X6wX2aB0VogrrLKaUj5Usc8A
         BKHtDYO4HGN7+dEikHy/vrid/RMPCHz+0TMPRMBhAKwL941vSHKChWhqCclp9P+xvFMC
         YTI21LLuHjEewtKU3lSJjC1GGqi+re+r6oA1ePHKFzea3zGOSNfI/aFrXRRs/m91HqBU
         GanHBwuBsP+uS/K3wiU2RtZb7J6LEH2C01eSUNza/U+iQDB1ubJJCkiRCPL7lRNOwx4s
         uDrmhH/6QlVY1hrCQPphPwvDNtQGljM6w+hamrvHDxN/M/Ar7kBmjm3W8/7WkhuUdvzK
         3C6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774189778; x=1774794578;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lj7ZP+p/L2RJvrz7ry3hoB/fyFvBi0CD/xL/gfPc3sw=;
        b=ddVUlxT6Okzt//0glaTB4fc4kcNFkJoUtrR6fWlvZ7YhVe9ahHC9zs+L64S94jdHx+
         8bCWX8H0QVIfJllNnyOpDlyVP+/jH6q8z5P3r2z5iTGoW3JJUI4QJ7LhPVMFoe/W1ZUY
         1Vm338sVZrc1vqNy5sdivu4ER4lYnyem1TUSBdQsxZGXasFV+BsQUR8rUZ7hCG9uMfGk
         xq8vSq15P5xTZpj/KJwL4vlb9mDTnfJxxc8Pi6NboQ3B6W0y9R3TTsAW1pDrTB7YmbKj
         /Wn+Yvp7VL6/1oV8oHfFUub4GyWZORsSpx7wsghnr6GKMESr2uZqinpvwgoA9xQatT62
         UDnA==
X-Gm-Message-State: AOJu0YyQYVxDe+IIFRYTEPrCOmtJEtAueYmW4gDRC4WTi1zYWG+zjY0Z
	IbMm4YisYzzQMg6lNor1u3TYXP5Nbmy9KBO1DRY1P9k37Evytroo66OQwPPdaNr41RQ=
X-Gm-Gg: ATEYQzxms5/U6xvQNJ8pNVgzhnznSXxrtZJ7B61i7fboCX0MGWJK9Xyu+4Y7ZpD8Ht0
	IAXT1fJxovjwWSmvbZugf1pOQSTQ9h0QREkHSpQxmpvyprp2COVYKpYKiYYsV9YRNAhIS58oA5J
	+tMGQsjU1geUXu49hPujw60+V7R/5kxxLvgHokluQbWqjr1mdnSlxuIChrt1vyYQuHbBd8M4ToN
	Kuqm+Mcqqd/pjQiHPH0R4RiQ9i9VqhZ9cGb/a0Jz2FKvx+DpxhAZwNHxy2XKXse0DOrfbpp0kA8
	9QDMPuX/CTHfu5yTU/ZxhRbTUTdOS6h42Qm1GrUINlraarZPnuhbEdIBR+dSvxa3kjDqPAwNTq2
	DQN7nRkNGrij/brKFuJqxcueEJpeHLtCYgeixgZKzMDMhqICFeDZrlVOuXCqPy+D9j5XQUrzAEh
	SpsmDt59hNttE+yZflQuiVhIR9TbNz4X1bhCDDQ8u1+AgBgpZyiwdvNwinsTdwwA+wm92EHjV+J
	jG0RmKRLg==
X-Received: by 2002:a05:6808:22a8:b0:467:de0e:feb6 with SMTP id 5614622812f47-467e5d23aa7mr5512040b6e.11.1774189777965;
        Sun, 22 Mar 2026 07:29:37 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-467e7ecc226sm5318041b6e.11.2026.03.22.07.29.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2026 07:29:36 -0700 (PDT)
Message-ID: <19ffae4b-1a53-4d5b-b641-7b429ff0199f@kernel.dk>
Date: Sun, 22 Mar 2026 08:29:35 -0600
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] bcache: fix cached_dev.sb_bio use-after-free and crash
To: colyli@fnnas.com, axboe@kernel.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
 Mingzhe Zou <mingzhe.zou@easystack.cn>, stable@vger.kernel.org
References: <20260322134102.480107-1-colyli@fnnas.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260322134102.480107-1-colyli@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/22/26 7:41 AM, colyli@fnnas.com wrote:
> Change log,
> v2, fix emiail address type to stable kerenl.

Thankfully no typos in v2...

-- 
Jens Axboe
