Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30D83B7752
	for <linux-bcache@vger.kernel.org>; Tue,  7 Apr 2026 13:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775568294; cv=none; b=uabPltfjPAIFbK0L2kylEFNpsv7OcMfNlvbRnZt/LD8py2eFJ+OhPSbjT/AZQWVaBGqgXGi70N4UPN5YsE0KeYD2AyQZ3yJEke5zmPeBRWyiihXLqNccIfLKZ0y513nRQTt+QyJa1TsFGMsquE2+9yCyxWF/jpkd+GrsZKoRSnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775568294; c=relaxed/simple;
	bh=ML8hQ+RDkDYF0vRa27veS2xyDpBAgnpCY4uGGQJk1jU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PKKZpAa+BnbiEhZKX38zftyBIQFRFmvKGzznvAKm9i68kfzRWw1pJKzc34cRjNgoByTAlGKHTEExlFIj+Lymh29hu5yF8zVn4F8Azn8eVIuTSxv1IoEXKWKJ6etMj25HFuZzdzjJPGA9853kuHkMnqUec3vYy1bf3ncVLD4/lAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=hbTIqpRi; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="hbTIqpRi"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7dbe437b072so1081570a34.2
        for <linux-bcache@vger.kernel.org>; Tue, 07 Apr 2026 06:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1775568292; x=1776173092; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LIlGMFl769ErvOEnjrJuw36z8dA8eoDWuwsu+42XFMI=;
        b=hbTIqpRiYw13Q6xvgNW/YRiI89FvOZ7oOQPMbgxySuF7mXmNqAfqS6+u0sxKmR4kEL
         c+z+9hf9G5w4kRE6rMxZNfiKsKtE0rHTd6IU4ikqg7lIT3X0wd5/hiHZLl0SXljVWOg9
         jkxVAwTwUZJdb5DTPYrvBDFgmto1KuW3gmxU6t5d0UXXkfSOdyjwi1mnAyQQRRTt2aAq
         AYrQAVQHIZmudWvcQOvEk70oZ/e2FDlnahNj72g/8zId4xXWB6FhInKQRfYy2SPIbS4c
         Q0mqUMJKu4+jPL8Qe9bOHxalbBpesxMpM/FM08DYkv63f80Q72Sq+AxLAm8aGebhUFur
         ZC1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775568292; x=1776173092;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LIlGMFl769ErvOEnjrJuw36z8dA8eoDWuwsu+42XFMI=;
        b=tBdLiFXkUUtCu9iW3IKll0AMmqkkc+QeXvS4kwU3d6L1He1ZoxVUgItbTtM6t3sFfx
         eTgt42ED4qrGrvlQqa2q5ONfCQo6FzL/9id2diqyxyNaMPKaxDvojuHorblHwtzq8+Qo
         ZcIwtN5tyyJsZBMH3ecIBYHVtDPuwTtaFwkgZgt5St2MoBdJOOdK1iNTeeKiS38DOQmF
         OZIC/NIEeJJgsXaZsUNjk4rfmEw5vcpDczqbb6T+8s0fbhfkssENYM2BHbmZotEoXNZD
         ixE0uVrNxVfPC3/yU5E+TsW99dhgWW9HvcJ8qQrmTS40SJejqQQIg+VrWxZ4prn3QZFB
         MYPg==
X-Forwarded-Encrypted: i=1; AJvYcCXEhblTEJTGI6uLmRZMNMBiIHnrZ22Rl3Wz/YNFRBIE/AWwq+qlsDC6ytp3noaCGYe147C9PyRVre1vg0o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw35xVQyPI2ea9/XkTZ54EqHIbELftbsys7AVL4sFAvEKqwjuDO
	xew4pXWopLoV7y0aDyDuyPJXzBaBydsRyzRFNAlrMEoVl+6+EDWYhSk0Byqn8d0iaa4=
X-Gm-Gg: AeBDieu7eo+L8F+M6GvoK2mZwrm1nFwhRRUf3KUTJM9SAissGvCawfjAenU16lOGQZy
	PAsI1jzQTvppORyY+ADwqvrIwG4VBakBTXWfvnZtRcMln53fFQibS/hV62+2fUpwvYlF3C41vGm
	VQuPc6Sd9gusvrtrzQSJa4bHTimBeCXtr4HBcDftgatOta5epLit3meZztIFp0JxyixeKajnX4p
	urUc/xhpN7AAnt1143snsUMLV5Fbw+8mV/gIJhkKx7/19+3DjqrDE83d+aclXu/h0yLSMw+Lbff
	nmVlp0DIRRqp1rbNnP3nW/BdRSkPwYTJ69/thhepsssAECCSWXV1odSlkWa+ysOnf20IgskTmIW
	Rg8OGfbfZCUACrEHKrv6iGdnNOFW1IeKgFM7+k+8/cSglgnnE6m93uThmUnEFfUsWFX4xeqn/rZ
	GpGeaquVm5ak64qELJOHXrYfRwTHotl9Ik5chm0MF5YKEfaQz2fwBkgttC+oRMG7QVCBG3JRvQG
	RrhIU95
X-Received: by 2002:a05:6830:67f8:b0:7d7:e6cb:836f with SMTP id 46e09a7af769-7dbb74f5958mr9616730a34.19.1775568291643;
        Tue, 07 Apr 2026 06:24:51 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dba72fd29bsm11836521a34.17.2026.04.07.06.24.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2026 06:24:51 -0700 (PDT)
Message-ID: <9e030c6f-f894-4794-81ca-e3c1a3ce5787@kernel.dk>
Date: Tue, 7 Apr 2026 07:24:50 -0600
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
 <2ca022fe-d448-4436-9b83-010cc664caa2@kernel.dk>
 <C1947BCB-F33B-49E3-A091-5F23972C480B@fnnas.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <C1947BCB-F33B-49E3-A091-5F23972C480B@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/7/26 7:19 AM, Coly Li wrote:
>> 2026?4?7? 20:44?Jens Axboe <axboe@kernel.dk> ???
>>
>> On 4/7/26 3:28 AM, Coly Li wrote:
>>>> 2026?4?3? 19:11?Jens Axboe <axboe@kernel.dk> ???
>>>>
>>>> On 4/2/26 10:21 PM, colyli@fnnas.com wrote:
>>>>> From: Mingzhe Zou <mingzhe.zou@easystack.cn>
>>>>>
>>>>> In the previous patch ("bcache: fix cached_dev.sb_bio use-after-free and
>>>>> crash"), we adopted a simple modification suggestion from AI to fix the
>>>>> use-after-free.
>>>>>
>>>>> But in actual testing, we found an extreme case where the device is
>>>>> stopped before calling bch_write_bdev_super().
>>>>>
>>>>> At this point, struct closure sb_write has not been initialized yet.
>>>>> For this patch, we ensure that sb_bio has been completed via
>>>>> sb_write_mutex.
>>>>
>>>> Presumably this should have a:
>>>>
>>>> Fixes: fec114a98b87 ("bcache: fix cached_dev.sb_bio use-after-free and crash")
>>>>
>>>> but for some reason it does not. I'll add it.
>>>
>>> I did it on purpose. Because this patch is in Linux-stable and not in mainline,
>>> I am not sure whether it is proper to reference the linux-block tree commit id.
>>>
>>> This is why the patch title is mentioned in commit log, but commit id skipped.
>>
>> Why is the patch in stable and not in mainline?! That should generally
>> never happen.
> 
> Oops, My fingers movement diverged from my brain. I thought
> linux-block, but typed linux-stable?.
> 
> I meant, when the patch merged from linux-block to Linus tree, maybe
> the commit id changes for some unexpected reason. So I didn?t
> reference the Fixes tag with linux-block tree commit id.

It'll never change going into Linus's tree, that's how git works. If I
have a rare rebase for whatever reason, I fixup the Fixes shas. So
always put them in there, there's never a reason NOT to do so.

-- 
Jens Axboe
