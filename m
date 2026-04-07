Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F27B3B38AF
	for <linux-bcache@vger.kernel.org>; Tue,  7 Apr 2026 12:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775565847; cv=none; b=NlaD4Glrg1BeAU65WGXcK0zAORoQvQo1xdfWFrGNmb39nq0AgT4jfcLx4Q3L6C9TfBe3mpFyEC0K2wRD4Nrs5ZY0g9GvICEmMS7n8TB+piCW21LZ983Z0g51aMECOutpWiX80F9cVVdsHc6iI1yja/uqePn2y4ARKZkGNaixIQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775565847; c=relaxed/simple;
	bh=MG4+qieNtGRhzogJmskTJtzs8yBd+thT9AIt4G7Kjm8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CLm0Kw+N2yLMNwyNEuAFhpjCzPIRYlHbHvrwhunfRA1XxZfJfG815ki/AI3s0OXzb1ORIxHI34NsVsa3igVuYlY6LtBVvUxlhPF3/S5h0WPSMuWKlVTCqm4pb4mx5aOf1QCKMJtcv44MzyhdnpqArfq0PfXonKTe1SXpTwuuTvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=eglgQo5L; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="eglgQo5L"
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-682fce74c06so3034189eaf.3
        for <linux-bcache@vger.kernel.org>; Tue, 07 Apr 2026 05:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1775565844; x=1776170644; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qe6Yoy81YMsABqOvK1hF99sn5Ls42w8OgrcydzKgpho=;
        b=eglgQo5Lp1dftQ+SpvR3/sV3zXLS5bs4xfm0Mu0/N2l7BLKChouZF17wN/pn/oOPfi
         +Z+JPkA/0cf7/LtP8mM2mmzG+Ft2ANQxZL5rok6wDVtPnFFzNGRmbwi0RrWz+QJ6z7O7
         amqcn09lF8kuy0+7LduG2Ykx7rlgv7HvwTxNC/tNuNVHRUM3e2FV42ycaLMp2mKv2y4M
         9MGDbS9bUJsOs6Yg5jXMGEVTFsEXkzmv8J7sDXfkX6l9X5IgMzwX67Hw77hHv8mO7ZhJ
         PC0fIsAMCVHoGO+UfgJdzfjhP9IBLbgAliJopwGvZPCrFj91lJYAwJvERLi5rRLNr8GI
         ssSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775565844; x=1776170644;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qe6Yoy81YMsABqOvK1hF99sn5Ls42w8OgrcydzKgpho=;
        b=dvr6tz+Mu8fXXy/XEAh6QTYpy+ZdxCdpZA21LcGwJ2uJRAOSzkJoP6YRKye4E1+JgV
         c3PSAPNRGV6fONwKZdq1Nh395gZhYFhemcIWA4kJ0dc9BkS+7AjDOTHdP6+FfWDgI04O
         ByjJKvHaTLbwXs+vifINXDUM6FdQl1SaVBSmSkXPH4hMwmPEBU7MATL5rbKBtkyWwlUO
         lG5G2jIm4YL7lHS0RRGoDMIVprEURsybvUICB5HJxCydOmGEEjgN0FCvoJ8bn61BywWJ
         IacydVMuvrdj+cR+Hj6oJPT7d/922xNlt9khTefmaQzvP7G1dXunxSF7+Ie2Kembb4zW
         14MA==
X-Forwarded-Encrypted: i=1; AJvYcCVyeWn23tOgQGwPcTqaishhVYRrV116uLhk/6bd2pCWhyeL9MTfWc1nIPjiPIT+4S4/cEVQXTWeFxxETsA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLLyHOz3kYR+n4Ybv6xazqJ158smBuNc3sQkmW3EDVHqHU25+X
	kPAK7gPqQEpjFpnkF5BCuzJBupFPG2zWnWWyNqNaHyUaA1RtKHHpcniPD/yqjVFgxpb5uv0vOgO
	9vu3531s=
X-Gm-Gg: AeBDiesKchtZziZDRS86Xt7K9okpzbBaUECb0mGOVEvwjoUgRtn5EmGGy+HT9pOXu+I
	BQCsvQt1ScQj9hI9yuyD1SpP5MTlQbSVaLlaSMkj/9HuxYTTAM4FHEqJNauvwG0iC1lUkVv3SIE
	4AOk7/1rOIknHo0GViZHVhN2JeujMO7XKiz4cPwFZqfalX8IfTYc9/t6cYMfMm3xQq+glcYCXGe
	JQ1gZtchLVtf8sZf2OX/eeQTxT6tdarWQyKWbUsQC5s4tXTBzEcf9YcDxNz/+mJKy9QPNv6BYhR
	NbW1xbEywoxmdyikRW+5GOZdiQzG4FwbWeq30Ltb/ojsS53VT2DAVqCkxlt/Boz/K8dRWQsWjrK
	E1fNBuhupIOqKITMaHjh6yQMUgQ12q39X5E1YmOhSw9dChmCGn4BQS0MMQonbe9EfLy0mLhjHuT
	47ombAQNmme+utzfLwwM3MVQ6TnmskDukDFDkQuX4mp8RWPp2BABC2iDzVXwrpM8WRNtA1Pb1Iv
	NV/GEPGbw==
X-Received: by 2002:a05:6820:4c11:b0:67d:fba3:abe7 with SMTP id 006d021491bc7-6821d53c52dmr11231684eaf.2.1775565843804;
        Tue, 07 Apr 2026 05:44:03 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-42344076923sm7600587fac.13.2026.04.07.05.44.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2026 05:44:03 -0700 (PDT)
Message-ID: <2ca022fe-d448-4436-9b83-010cc664caa2@kernel.dk>
Date: Tue, 7 Apr 2026 06:44:02 -0600
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcache: fix uninitialized closure object
To: Coly Li <colyli@fnnas.com>
Cc: linux-block@vger.kerenl.org, linux-bcache@vger.kernel.org,
 Mingzhe Zou <mingzhe.zou@easystack.cn>
References: <20260403042135.2221247-1-colyli@fnnas.com>
 <bf06ffae-23c8-4629-a963-c6c6ffdeb4e1@kernel.dk>
 <17585F9E-8055-444F-A40E-50CD0AA92F72@fnnas.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <17585F9E-8055-444F-A40E-50CD0AA92F72@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/7/26 3:28 AM, Coly Li wrote:
>> 2026?4?3? 19:11?Jens Axboe <axboe@kernel.dk> ???
>>
>> On 4/2/26 10:21 PM, colyli@fnnas.com wrote:
>>> From: Mingzhe Zou <mingzhe.zou@easystack.cn>
>>>
>>> In the previous patch ("bcache: fix cached_dev.sb_bio use-after-free and
>>> crash"), we adopted a simple modification suggestion from AI to fix the
>>> use-after-free.
>>>
>>> But in actual testing, we found an extreme case where the device is
>>> stopped before calling bch_write_bdev_super().
>>>
>>> At this point, struct closure sb_write has not been initialized yet.
>>> For this patch, we ensure that sb_bio has been completed via
>>> sb_write_mutex.
>>
>> Presumably this should have a:
>>
>> Fixes: fec114a98b87 ("bcache: fix cached_dev.sb_bio use-after-free and crash")
>>
>> but for some reason it does not. I'll add it.
> 
> I did it on purpose. Because this patch is in Linux-stable and not in mainline,
> I am not sure whether it is proper to reference the linux-block tree commit id.
> 
> This is why the patch title is mentioned in commit log, but commit id skipped.

Why is the patch in stable and not in mainline?! That should generally
never happen.

-- 
Jens Axboe
