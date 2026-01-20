Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB1744CAC8
	for <linux-bcache@vger.kernel.org>; Tue, 20 Jan 2026 15:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768921320; cv=none; b=AMPLty4qpbUeWWKqEncvsuxKnOoUp3WmPiRYRqwND5YhrzTYtk6r8Ky+3u4xYh8DM75g930tYlQPK4kCtQIY1LnJR4RKXK4Ljdkr+gpG9CIhK6jYviug60CtuiNxLmpdrDSZtFG22ODL1f/E7Xgk6vFJNWt/fzwd2xR+lE4DpQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768921320; c=relaxed/simple;
	bh=3XP0J5pGfbP2euqkR42A9B20YBqPzmvqIFqNLuS5yQs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IyGXgPEb8YvEiVs6v8WEqbEv5txmrS05AvKTqo35g9JJI1Xn+l5uQKrPRnL5bFG2I/p8BKhOfJHCKW9PWMtOllE5vIaQk+Em/sRKU/p/+AaALBQNqT+hCg7tQeHYppxM0JD5aWO0GeZ77Nl04TKeUzJXYhKAYRQOBXlFXjlDe3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0A1N3Cls; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0A1N3Cls"
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-6610cddd4b5so1368278eaf.0
        for <linux-bcache@vger.kernel.org>; Tue, 20 Jan 2026 07:01:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768921316; x=1769526116; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Yg9R+t7MOtkP7IYAtG+DfNdA+14/RyqhvsTb2uHlMzU=;
        b=0A1N3Clspd46emKucDQAOvlKQD53x9LwGt2H3+aNU9s8g6XMnKe9hM2QQbd0AjBnH9
         3h8D1HwiLE61PwP3NiookO5gt5k0q0rUJ+bsr8eW2gY0GOKvrEuiXuW5yy26xyZOHuWu
         k08TkM4BWe7XOlSznGn6pmvv/1bDhyUASspMGs1RTFtRHrmSAGPnC3zUTFSYShTmRgkH
         FNkl+PDmLet3I3zZZEOnzKFdPk2CbCHO5OE1mf7dloipTIILygzLypMAhUmYYSL9jss7
         MTxbBf6TUI4sGtmxqhbnMFMTMY2FiR3rDFILCIdby47QbuDeO25rCWFd01wCP3IoUoXj
         Oc4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768921316; x=1769526116;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yg9R+t7MOtkP7IYAtG+DfNdA+14/RyqhvsTb2uHlMzU=;
        b=L7dYf9lXV0GBU1XewjwOeY9kmeh/N1jXbvVFHeLSSjrxcvKWENRAmDt8OZ4+iAPijb
         HB2DILUSV8cL/83dBfWioJb4/PDOSJbfLzh3C+MPVtHOzCNE3TTd0zYHMwDSloaQcQxu
         NP8CTVXbYH/m/NL8t8++Wzwwu4ChZqJMBoJlkGl2FI1CyqCQQdfGxtJYRZ9TFca0SVXD
         MPA+jmzJ4whAJmizQAEkFK8qmIdUgBfOeNe/NosjAajKexR5kmVD153No1xn3C80bW1E
         nvEQj4uJClQwsZ1POrLD3dXvaRS17Cs1T7FM+RVkDLdLtOdPVrCqUycgnlvIO5cjuRQO
         D93w==
X-Forwarded-Encrypted: i=1; AJvYcCUJd/yZ0x8E8pPzt6qZJyKByrr89Nnt3U0kfJA8B3GpwbOALBl7sKgdndsmVmoTYCstcoakH5Mi/YZFRLY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyx9MWFAxp4dGfd+zI9y0q1NvzRvNXWewX53K5TxktWwR6jVkVi
	Mv3h+uy0FJz+B26r1+4Tgwer+NBGxK2Q+yxu+qf4UNgPlWIit2PCftYFbxa3hQZjkpr7J8OVv2s
	L5IX9I98=
X-Gm-Gg: AY/fxX5rlRh8T63Oi9DEVM/hYM2aHzPttP1t0tq3dzBmX477CCNvB4ssrw2ru80mEex
	8Tu/atlVHWp3n+wR0+SJ3ockc53kMzsTOaeScy6a+wMKCcVl+4pGU09TY6SUluwFKKP8PmedTNr
	nusg38hRJjxxOHgbHttD+I2KFBtnE/EagS+pzmjVqJS/gOeLJ6Md49qM0UFYtJVvC34G+IoImr9
	tfW/aZIppVMBJmSE4Ze9peKEukKJPKmyR02hXppwukXMDXvaCkSarlN+ioV0Nq+dBsA92t08xgS
	k/+iM1G1VvIxeQxnf6wQ5aBNefXvJguoU8KQyt2Z9evLqPUeKGDpOHBA5zNQ5jI/1OnOOo5xR0s
	CDCq7Twa/trrDbEluptpYeR0+PBQj+uvY1Osh1EGlkE7/9rcjhQNCzBxWUIhjMahUe+kfsgsLul
	gl7DEPfwNTg08fuTrU3D5CvNFtWPbcM4I8rlneIRK2V8plPJQDHjmKSMsNDTI3T3DOZBzfJs6pd
	8RnABE=
X-Received: by 2002:a05:6820:4c06:b0:659:9a49:8e54 with SMTP id 006d021491bc7-661188e2502mr6098915eaf.36.1768921316355;
        Tue, 20 Jan 2026 07:01:56 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-66289e3af7dsm4925094eaf.14.2026.01.20.07.01.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jan 2026 07:01:54 -0800 (PST)
Message-ID: <322136ff-95f6-49f6-9126-05845f25b4e8@kernel.dk>
Date: Tue, 20 Jan 2026 08:01:52 -0700
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Fwd: [PATCH v2] bcache: use bio cloning for detached device
 requests
To: Coly Li <colyli@fnnas.com>, Stephen Zhang <starzhangzsd@gmail.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 Sasha Levin <sashal@kernel.org>, Christoph Hellwig <hch@infradead.org>,
 linux-bcache@vger.kernel.org,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 zhangshida <zhangshida@kylinos.cn>
References: <20260120023535.9109-1-zhangshida@kylinos.cn>
 <CANubcdXsWsdueYf_aN9FSm+hnE-rpXx_hHhwP9_Z1ni1YGEH9Q@mail.gmail.com>
 <aW-DHlpo4dzKRB8K@studio.local>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aW-DHlpo4dzKRB8K@studio.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/20/26 7:46 AM, Coly Li wrote:
>> @@ -949,6 +950,11 @@ static int bcache_device_init(struct
>> bcache_device *d, unsigned int block_size,
>>                         BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
>>                 goto out_ida_remove;
>>
>> +       if (bioset_init(&d->bio_detach, 4,
> 					^^^^^-> I feel 4 might be a bit small
> here. bio_detached set is for normal IO when backing device is not
> attached to a cache device. I would suggest to set the pool size to
> 128 or 256.

Absolutely not, 4 is more than plenty. The pool elements are only ever
used if allocations fail, to guarantee forward progress. Setting aside
128 or 256 for that case is utterly wasteful, you only need a couple. 4
is a good number, if anything it should be smaller (2).

-- 
Jens Axboe
