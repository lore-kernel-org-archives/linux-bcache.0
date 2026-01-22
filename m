Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A552DFA5B
	for <linux-bcache@vger.kernel.org>; Thu, 22 Jan 2026 02:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769048569; cv=none; b=NBPhZ5SWx8aX351YkGLPet3odKtp0IsWKhACVttrr6h6lOa1EQLY3acssmDpDBg0d3yYd9FN0ZaigbP12b5inlWt/ClJliEozwTJWVxRTJrRWl1+UupTVjKTY8ckGUrLHFAxAGo03ia2n8HFuGXa1j1Ftz2x225hNE3QULnY+PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769048569; c=relaxed/simple;
	bh=8N7sHE05QAVjA4X6tSFTaXLOEQvitlC8qE6XblFCb3s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IMpQLncGQdMVDcNzSsDwQyFmbf0IjIAxEEYi/SgIWKtSEyMvACF8WTHbNeL3Blp9cSv0NbRZ659q2hKEkEKK3M63eOayKsIVo8QXNl05oa8O6ub2UThtFeqN8/KBlbd2NNDKHwZtvh/I9LCyFHidcHPZJcPEjyJlHwRCq9Hchs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0Pb06ilC; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0Pb06ilC"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7cfd53a8c31so887546a34.1
        for <linux-bcache@vger.kernel.org>; Wed, 21 Jan 2026 18:22:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769048566; x=1769653366; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MEP8+0IHjkkP349I+NcO1qYCGBGNCd/M9M64ITgYTzc=;
        b=0Pb06ilCw5WVuyLkYIuS1jjuXorWmb7IdapsqtT7lC0L1izbOcHWnIdlzG4s9HVCuP
         rgF2HPXYE5ULi65c4G/dzZHjvi4sJbO0+S2qavC2LOBJP/fpKP0XQyxHbIG/EYlJWcQD
         DR96KMvNrpzFIZY9sQch/e/CyvF29+UpVi5amM3sJVWMoeb7P7Frn7CQPa2jZPWHyCfr
         3Dro3zaVFp9azebRmO68l9vQiedt42TLIKbiT+04geZ6PgkzOuJPCLyF67olnbuLuF9e
         /vFucVogBr3mkhqEovVok13purF0MQ2lbVrsT0pfclKha+I7um3Z4InP8m6Fhk+WXyoa
         9DAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769048566; x=1769653366;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MEP8+0IHjkkP349I+NcO1qYCGBGNCd/M9M64ITgYTzc=;
        b=STJyA1tx1rv1ZnzTwHNKjTMPaxbiX8LVUXmhTvM4c+LDvxXoItC7d+vK00m9Bl3IAN
         QAaxIMrzPvAhEaffB3+Nsp/a3Z9gBpmgPOKowMP28thHYBqi8aJTXXmFcbSdCKvxZJCp
         QAgOUqikxP0Xizq5/oZ0p4SIF5hf+TrObcDPGGlu8HnRKEJalVURJFEsVi/IJN9ceyq1
         YJXjPPbtdeo9ViIkOaE9drdUBGbcKyd9GMDpDlSRPukikNwjs91HW/L8Mxqax8mugqza
         vW8EYVGHGK7NJZuldiCYtFpZSA+JhjI6zl2yBGKfj1x7CqypAAt3qvQ+WMY0+IzbtnEk
         t1UA==
X-Forwarded-Encrypted: i=1; AJvYcCWZmOr0zPUkjAx4+np9YH54Zq+dY1hVVRJ5tpEORqTQ+mkS5vzoCxxb3mZ+VeFT3G+ZgvGSGsNA3R8HgR8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUWZGbakHKU442fWG+wGIpAKQi1Y53HcHT+wWhMzonIlG2OCFI
	9ewqAcn40Qel2q4zEnm7k02s+76dCoep41mlhA8zQGCB9MaSicQxYwlRcxR5iICbFo8=
X-Gm-Gg: AZuq6aJILi4nRL4e0k0LYUyqawvRQExUaXgpSltvf42XlQg3f3Da98rk7ufF+XP8amV
	LT9Wi80Ib+lhKUzw1ru0WfoWfqfsOba+C6K/E2YXWUifJCxS01evoilfm86V2hCImtqO0ZVkL8B
	wXSRUiTrsF9xYk3yKn3dmBmxVAJ7dpEnOgSvbHyg7IfyQqTeY/TpgO1D8D9upJXI0j2hBJxkzhu
	NpJJz5PTcMbZK4Ur85nV6RksgNgF1wZ6TU0ujklwhfsrJ+XLPy/QzD5INJUo/XQcCDiwQor2fRn
	MaRCsUvho07sKZziOimjYImT0ZclzbrM9IQRjQEjTI5seinZpbmjdQFyseUX7sQsNRqr25/rdQ6
	D8QpCpR2gNmYpCeakPpS0iDa4Je+DbpQgCeVA5QFrorHD8CYIWQqx8yG1434YHCPbxiB3X6tOLC
	v79/2rPKqi0xzMlfPJbsmLwPqwX7pMHnZItCpmeGa1CZsmlDN6uICfGhCcJfAXGgLZqp3v6A==
X-Received: by 2002:a05:6820:490e:b0:661:14e0:4ab4 with SMTP id 006d021491bc7-662c1ab88c5mr752305eaf.27.1769048566154;
        Wed, 21 Jan 2026 18:22:46 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-662bdd1c0dasm1094867eaf.15.2026.01.21.18.22.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jan 2026 18:22:45 -0800 (PST)
Message-ID: <0a1bd601-7f66-428e-ae1a-4972f383258f@kernel.dk>
Date: Wed, 21 Jan 2026 19:22:44 -0700
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Fwd: [PATCH v3] bcache: use bio cloning for detached device
 requests
To: Stephen Zhang <starzhangzsd@gmail.com>
Cc: Coly Li <colyli@fnnas.com>, Kent Overstreet <kent.overstreet@linux.dev>,
 Sasha Levin <sashal@kernel.org>, Christoph Hellwig <hch@infradead.org>,
 linux-bcache@vger.kernel.org,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 zhangshida <zhangshida@kylinos.cn>
References: <20260122013650.321766-1-zhangshida@kylinos.cn>
 <CANubcdUShtRu_t+VACzqpeEUdFtxqP+ErYFr-iWHgwqzD18Pog@mail.gmail.com>
 <fdc4f3c3-964d-4713-863f-13a1bf20f154@kernel.dk>
 <CANubcdUPFU_75YkNORATSFdn05_UeXbm4w90OuJMg1TZj=z5dw@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CANubcdUPFU_75YkNORATSFdn05_UeXbm4w90OuJMg1TZj=z5dw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 1/21/26 7:20 PM, Stephen Zhang wrote:
> Jens Axboe <axboe@kernel.dk> 于2026年1月22日周四 10:08写道：
>>
>> On 1/21/26 6:40 PM, Stephen Zhang wrote:
>>> ---------- Forwarded message ---------
>>
>> Can you please just send it out as a regular patch? The forward has
>> complete whitespace damage (it's all spaces, no tabs), and when you
>> forward, b4 doesn't pick it up either. Maybe there's some reason for
>> why you are doing these as forwards, if so do tell?
>>
> 
> Apologies for the formatting issues with the forwarded patch. When I try
> using git send-email, I'm encountering server rejection issues.
> Interestingly, I found that if I cut the patch content in half, it goes
> through without rejection. This suggests there may be a size limit or
> specific content filter causing the problem.
> 
> I'm investigating which part triggers the rejection and will resend the
> patch properly once resolved.

Can you put it in a git tree? Your original patches seem to have been
applied by Coly just fine, so maybe just go that route again?

-- 
Jens Axboe

