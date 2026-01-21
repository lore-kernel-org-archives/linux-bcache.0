Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7C132D7F9
	for <linux-bcache@vger.kernel.org>; Wed, 21 Jan 2026 14:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769007041; cv=none; b=RUnPAODI7B2kfANO1FTQTIoxB0yFeeFi2iDBSZGy5pIZ2ANqNKFkGfhzqbKgBB1W/fjdkoO4680iqu4pX2fkBnERoi5uYBZMhHbTIcbW+ikzMCtf2SZ90WKRn5sinDk9FfVYU5EAcCrXLTMWFY8465SUG+Ie8H5zfnrwkP7qbYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769007041; c=relaxed/simple;
	bh=0jPBam5Q0XlcH82AkofZ5TSJX16nlvo89QANHmjwHg0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n/6RXdSla7/8gdX3bAqZnv3CbxcfBnmdbBwm/bGeWfkhElrIlKIFbw0XWySqBxxiDhG5P+lIj0JpUvilynsWXT78wE8VamGc1Kl0GjATYrbSOtS2ScEA4S2Phzsiv7zuddiJA5xBW6aeK1H6Mn6OxoO1ScKJMWvBQKOitzsY3i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=J5X7khoW; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="J5X7khoW"
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-45c7400259bso2476518b6e.3
        for <linux-bcache@vger.kernel.org>; Wed, 21 Jan 2026 06:50:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769007039; x=1769611839; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bKCZ2kL61GxUt9gCcsS/HsR42Z2vIGjGZ0QhKRsI9a4=;
        b=J5X7khoWkhJQjlZESgX32G5/t1SlxqiaBWD4s4LMS1lXyIToopsswGFWYl2H0/biOJ
         RtEmokKv/WqzsKNQc2r0cmrK52h7y/MnmwErYvHACwwi1cUJiLb8UnVUUugTiMgjjSK9
         HaCDjVK7gJj4bd2nNIr5rqKJY+Vy2wTdxsf7e7NIKwr8nqg7i20m+ankai/MaUpWbHMd
         bb1Px9kxV2N5qoM1a/lU1Ih7bmN3UY7ojDol4WSG98+M/thHxHiTT7YfyWHniLwskK2A
         2t07npFPAggz9S6kde2VyN9WtdIVktzXGrJExwnMxwhyae05FrS8jZ+BMT6TyvHtfrDm
         htoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769007039; x=1769611839;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bKCZ2kL61GxUt9gCcsS/HsR42Z2vIGjGZ0QhKRsI9a4=;
        b=mTB1fluiOExZg41Xc7n22sJ3f7NnyrpSgZ2rsgqXv4K658K8ldSxgWPmjuK2XhIrah
         BnieQbd82G2XQba77xzCnrp1iSwRznUaqArGBhoAHYJVL5llHAoJuR1HOYCBzaDJ7E1E
         Hepeb8q/24h1TFiPFGaqRHkJSyCE/dG4p1QOTc7dn/f+zButh3gezo1dXuc6Z+vosdy4
         suC2+SqoRXMu26lsoQJ3MOn+2G3pFfsO4JeDlizXMlobKhnEpHYP2u6pUu/l8cKRWoae
         d0KEcFuedtV3AxMsJm+wvCyXGdp1yt2PvfAA6I+QToxB6BTP6ximm1isHRJW2yk4stxJ
         Jp+Q==
X-Forwarded-Encrypted: i=1; AJvYcCUmjnj0OaCBBdGALiY7mpxbjZ5xFtwAjPAbWZ1qrywOs6kXxGUjp8qEcSCMFtfUBHZ6I2Q9XnQvYRmLJ5I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8Dtvkdu3lPfcp6fRcFM+1F803M2BXwd51gYrc9X6cd5ITHeR+
	qARx+63zHFd7mQGO758EA8auQ0aST4lEEtrjL0ySvNhTJcpGp2fOIYgLZtBWh9RpMfA=
X-Gm-Gg: AZuq6aLrhKj/coZXEI67px2GrwvOS8wWdHUQDPDL88wOwaCUbizXHTWWqL+52cOvpoo
	XRen1bs/dxWDpFkKTvLy8JcD9oMC+3q2+sFRF5asZoT9JxtrLw74/cEOQPZMqTZk+LjE+OJU915
	8/thyhrV++A0fQ04piWKPH0Np/VUu8kA8Jd7akW0CQUH5fEHj/qCkQYdHXQR43T5qXz6H+CK+vj
	Gmrd944lizFjN27DT9m+74ntNh5KuORkmLtXnwSDCM+Vx5wRHAViaf6U3Tx0eO82p+Hp46I4B/I
	oPbtQy4OlfeoTl2uoVGYhCb1iG+OaLLL4hVW6WU635v2bJRiq7p2Fl82cQDM9D0kjlQZW+ZK9Y8
	ybIpAxJE+XaqzW9TsHams9NJkkhHv66I/T7bQi12KwPi9/6lGPh/X+ma8tKCo+megGbU+rMSzD7
	/hRqteyRaHp7vs9j27Oocn4uVyOtZWqYPQxYa9Rh0yPRtD8O8POR8EAWkSOvdTOZPz9MOX
X-Received: by 2002:a05:6808:f90:b0:453:50af:c3bf with SMTP id 5614622812f47-45c9d859132mr7012530b6e.36.1769007038904;
        Wed, 21 Jan 2026 06:50:38 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4044bd5b00esm11255467fac.15.2026.01.21.06.50.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jan 2026 06:50:38 -0800 (PST)
Message-ID: <9a928d95-f027-4f0d-b34b-ca028ad36046@kernel.dk>
Date: Wed, 21 Jan 2026 07:50:37 -0700
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Fwd: [PATCH v2] bcache: use bio cloning for detached device
 requests
To: Stephen Zhang <starzhangzsd@gmail.com>, Coly Li <colyli@fnnas.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 Sasha Levin <sashal@kernel.org>, Christoph Hellwig <hch@infradead.org>,
 linux-bcache@vger.kernel.org,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 zhangshida <zhangshida@kylinos.cn>
References: <20260120023535.9109-1-zhangshida@kylinos.cn>
 <CANubcdXsWsdueYf_aN9FSm+hnE-rpXx_hHhwP9_Z1ni1YGEH9Q@mail.gmail.com>
 <aW-DHlpo4dzKRB8K@studio.local>
 <322136ff-95f6-49f6-9126-05845f25b4e8@kernel.dk>
 <aXAoi9wTa7VWUiPj@studio.local>
 <CANubcdUT+PoGs3j=0ZN5jsntU-hNGHRFQoucKJZvYGXxFC75ng@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CANubcdUT+PoGs3j=0ZN5jsntU-hNGHRFQoucKJZvYGXxFC75ng@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 1/21/26 4:55 AM, Stephen Zhang wrote:
> Coly Li <colyli@fnnas.com> 于2026年1月21日周三 09:34写道：
>>
>> On Tue, Jan 20, 2026 at 08:01:52AM +0800, Jens Axboe wrote:
>>> On 1/20/26 7:46 AM, Coly Li wrote:
>>>>> @@ -949,6 +950,11 @@ static int bcache_device_init(struct
>>>>> bcache_device *d, unsigned int block_size,
>>>>>                         BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
>>>>>                 goto out_ida_remove;
>>>>>
>>>>> +       if (bioset_init(&d->bio_detach, 4,
>>>>                                     ^^^^^-> I feel 4 might be a bit small
>>>> here. bio_detached set is for normal IO when backing device is not
>>>> attached to a cache device. I would suggest to set the pool size to
>>>> 128 or 256.
>>>
>>> Absolutely not, 4 is more than plenty. The pool elements are only ever
>>> used if allocations fail, to guarantee forward progress. Setting aside
>>> 128 or 256 for that case is utterly wasteful, you only need a couple. 4
>>> is a good number, if anything it should be smaller (2).
>>
>> Hi Jens,
>>
>> Thanks for the information. Please correct me if I am wrong for the following
>> text,
>> - If the backing is a normal SSD raid0, the IOPS without attached cache device
>> might be more than thousands. In this case, I assume 128 or 256 might be more
>> tolerant.
>> - I see what ‘4’ means, just not sure/comfortable when memory pressure is high.
>> And reserving 128/256 will occupy around 0.5~1MB memory, I feel such extra
>> memory is acceptable in bcache use case.
>>
>> Don't get me wrong, I totally trust you. If '4' works well enough for high
>> memory pressure condition for detached bcache device, it is cool.
>>
>> Thanks in advance.
>>
>> Coly Li
> 
> Hi Jens, Coly,
> 
> Regarding the discussion on the bio_detached pool size: while 4 is
> sufficient to guarantee forward progress, some high-load environments
> may prefer a larger reserve to minimize allocation latency under
> extreme memory pressure.
> 
> To provide a middle ground, I propose adding a generic bioset_resize()
> interface to the block layer and exposing it through a new bcache
> sysfs attribute 'detached_pool_size'.
> 
> This allows us to keep the default value conservative (e.g., 4) to
> avoid unnecessary memory overhead, while giving users the flexibility
> to tune the emergency reserves based on their specific hardware and
> workload requirements.
> 
> The patch is attached below. Does this look like a reasonable
> compromise?

Guys, just stop. 4 is fine. Take a look at the default biosets and
what reserve amount they use. I'd recommend you do some testing and
check how often the reserves are _actually_ used, and once you do
that, then you'll see why this isn't necessary at all.

I thought the idea was to make some progress on getting this fixed.
Let's please do that and get it queued.

-- 
Jens Axboe

