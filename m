Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E4A402BA9
	for <linux-bcache@vger.kernel.org>; Tue, 31 Mar 2026 16:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974865; cv=none; b=qrzDWVMNlayDNqwmmwx7sWaBeD3bjz3pRd/HksKEurwPRVMQUAz3fj+/UHjYL46HgugjIadqpYuR2o+DY3OHWJsJ3zUEzfdyCVQg37whmNOvqbbheWNxygES6T3mRFBUYX+hUP0QqOW8UZ+H54HFrxZF1QjOnFpmehTLlg1pgTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974865; c=relaxed/simple;
	bh=TxpNo/sC8oc2D2UANw/TZAQU9YnmDLPbojn8U5Te3rY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FbDNmJQQE5+hAoBN8od9M2tyCTEhnaAvFO8uSaUJmN6ozV9ZDwj0Uel+OCBCkl5E5RxOuBphPegESE8ftYgCocIbPcGaRk/YmpJmreSAt3tkiRRv+ebPAqMQQvAtlKBBj55abL44iARWjmoK/SwML/b3rqP9yBY7xg91jp/GuF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=T3JEXGDv; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="T3JEXGDv"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-464bba3a9easo3631881b6e.0
        for <linux-bcache@vger.kernel.org>; Tue, 31 Mar 2026 09:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1774974861; x=1775579661; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4JGLbcdlU1bo4DwWqNb+8omInRtfJ447+zlZxuaKqEc=;
        b=T3JEXGDvTELWTwN67uWTiUzrE84E2eKK4L44kPQJ7ivbPic7O6pF+qM4L7OTOuorDU
         YZvxnDwjaujed9B4tE2NZ9mOJqyvmkpjcWTdr3csHjAqqgHOhTNn5et3v71c7viKQzLX
         Lz6wc8SNcGBBEFLU2Aodm4O3keobuiFsMUxU/ipqZc13eNLEOyG84LKitPAeKrA/1cDf
         p4fHWkXeg1HccCs1b8YEntKk+ChTsL10ErZLN8JJMleB+ZzvN/pSMzK4vHgMA8A0dRXw
         TiMhvj9zByeDFEdLoqAW9qEMF8OqptgKF9wTiDaS8QN3BgyqTDH2GTfQeCl1y1aEHZRQ
         cPUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774974861; x=1775579661;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4JGLbcdlU1bo4DwWqNb+8omInRtfJ447+zlZxuaKqEc=;
        b=E1Ckc1jhEDzI0M51qHwHmjbNifef3sUM8219EFUZFXQGjJhZCPWd6eqqAQH6z9nRCl
         4+joOLBTRITz0dBI7+eXNLdbcwBgJweCtPjpMWVwGkD6egIu9sptSO60dHwOsBEY+8wS
         j0Ulg7eNHzS5PQhnTgZ0f7JctEzSj11nu3TLCxnsh9otdTlnakmXMJHGVgeOvA4mBCHw
         3h7veLJP3VovPIxLZDkLFfHn0be403Z2WkV6wgweFmPFZQI/Ul2LGPsMHc3F4hewU41Y
         clyg+9Excm6YcPMSvyvWkdTvmnl+pmoG4kwfTQKFWs6HmZshfWGojQiDrq0XLGHbFK73
         mlZQ==
X-Forwarded-Encrypted: i=1; AJvYcCWXqvoBVCJXezAd/Ro6Dxpu3gD+f5D3P7Pno13biakX5MR75s0VF6V84J+g7En5aT3nBujFwwQgFbFrrl8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqltaaRwgneGFZxK/jAD3voEc7QjjPbv9PrG61cHIQMBH2ygbk
	0xqZa/YBZLjm7AZsOjLXz0+YBzY3rl2l0f7cKvccZPA8arMWe48EJXSrkNtNqGt7Euk=
X-Gm-Gg: ATEYQzz7YtykrTLQIGno6+r0q2OHC4LFZjSKqLdaqrnhcdZ+1OR8pjN04/wENQakxNX
	cyLdccG95Yw0VwVybWKiVqZO1dA0qkMj+uJdWim6q2Vo8Eaz10FSKzvx2Sn3dP2UackmOwKrL9Z
	DE8An5Vef/zl8QXeELJQpP+wyufXuyDA+6UTGqOqDWbUHBx3Y9K5Ta286B0VagDf9OOeJf/3MIG
	gvlW3zVs77vTE7laU4KnLop+c7puuEzLwn7XNmWi0I26b90e4tcc+jlZwNvyO31M5LdF0t5o11Q
	wHC0dHurx/V5j7iqPO+apgWRAbFzR33KQEuR+yQ6cqxUhNq0aaVWeueoZM1RVCHRBVmMmMD99F3
	EvclLyIX8hzH/l5SmqBs1XTVSG8isZ1joWKJByE80uh3fohe6cEQnqt+Qfz0SlC5pxV0UI1nZX+
	FSpHsJIzgSkhOJqXj7TORWcGgqbhfCDRprmSI8qWz5K8yCFLi4brkVi9tPlGpwzh88x4LCl3nKo
	JLYqEaI
X-Received: by 2002:a05:6808:1929:b0:467:a2f:b27d with SMTP id 5614622812f47-46ae018a9aamr15795b6e.37.1774974861490;
        Tue, 31 Mar 2026 09:34:21 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-46aa03e4ab7sm6958099b6e.18.2026.03.31.09.34.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2026 09:34:20 -0700 (PDT)
Message-ID: <99e65e33-faec-49f5-b17b-5b47e5e4754e@kernel.dk>
Date: Tue, 31 Mar 2026 10:34:19 -0600
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] bcache: fix cached_dev.sb_bio use-after-free and crash
To: Coly Li <colyli@fnnas.com>, mingzhe.zou@easystack.cn
Cc: colyli@kernel.org, linux-bcache@vger.kernel.org, zoumingzhe@qq.com,
 zoumingzhe@outlook.com
References: <20260330131153.69705-1-mingzhe.zou@easystack.cn>
 <acsmG8w-ZbYvEip0@studio.local> <acvrq_PBzn4T2TqH@studio.local>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <acvrq_PBzn4T2TqH@studio.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/31/26 9:46 AM, Coly Li wrote:
> On Tue, Mar 31, 2026 at 09:56:18AM +0800, Coly Li wrote:
>> On Mon, Mar 30, 2026 at 09:11:53PM +0800, mingzhe.zou@easystack.cn wrote:
>>> From: Mingzhe Zou <mingzhe.zou@easystack.cn>
>>>
>>> In our production environment, we have received multiple crash reports
>>> regarding libceph, which have caught our attention:
>>>
>>> ```
>>> [6888366.280350] Call Trace:
>>> [6888366.280452]  blk_update_request+0x14e/0x370
>>> [6888366.280561]  blk_mq_end_request+0x1a/0x130
>>> [6888366.280671]  rbd_img_handle_request+0x1a0/0x1b0 [rbd]
>>> [6888366.280792]  rbd_obj_handle_request+0x32/0x40 [rbd]
>>> [6888366.280903]  __complete_request+0x22/0x70 [libceph]
>>> [6888366.281032]  osd_dispatch+0x15e/0xb40 [libceph]
>>> [6888366.281164]  ? inet_recvmsg+0x5b/0xd0
>>> [6888366.281272]  ? ceph_tcp_recvmsg+0x6f/0xa0 [libceph]
>>> [6888366.281405]  ceph_con_process_message+0x79/0x140 [libceph]
>>> [6888366.281534]  ceph_con_v1_try_read+0x5d7/0xf30 [libceph]
>>> [6888366.281661]  ceph_con_workfn+0x329/0x680 [libceph]
>>> ```
>>>
>>> After analyzing the coredump file, we found that the address of dc->sb_bio
>>> has been freed. We know that cached_dev is only freed when it is stopped.
>>>
>>> Since sb_bio is a part of struct cached_dev, rather than an alloc every time.
>>> If the device is stopped while writing to the superblock, the released address
>>> will be accessed at endio.
>>>
>>> This patch hopes to wait for sb_write to complete in cached_dev_free.
>>>
>>> Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
>>>
>>
>> Hi Mingzhe,
>>
>> Yeah, this patch is in better shape. Thank for the fix up again.
>>
>>> ---
>>> v2: fix the crash caused by not calling closure_init in v1
>>> v3: pair the down and up of semaphore sb_write_mutex
>>> ---
>>>  drivers/md/bcache/super.c | 8 ++++++++
>>>  1 file changed, 8 insertions(+)
>>>
>>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>>> index 64bb38c95895..97d9adb0bf96 100644
>>> --- a/drivers/md/bcache/super.c
>>> +++ b/drivers/md/bcache/super.c
>>> @@ -1373,6 +1373,14 @@ static CLOSURE_CALLBACK(cached_dev_free)
>>>  
>>>  	mutex_unlock(&bch_register_lock);
>>>  
>>> +	/*
>>> +	 * Wait for any pending sb_write to complete before free.
>>> +	 * The sb_bio is embedded in struct cached_dev, so we must
>>> +	 * ensure no I/O is in progress.
>>> +	 */
>>> +	down(&dc->sb_write_mutex);
>>> +	up(&dc->sb_write_mutex);
>>> +
>>>  	if (dc->sb_disk)
>>>  		folio_put(virt_to_folio(dc->sb_disk));
>>>  
>>
>> The patch itself is good. But the previous one (based on closre_sync()) is
>> in Jens block-tree. Let me ask.
>>
>> Hi Jens,
>>
>> Should Mingzhe send a incremental patch based on commit b36478a1fece in
>> block-7.0 branch of linux-block tree? Or Just use this patch to replace
>> the in-linux-block-tree one?
>>
> 
> Hi Mingzhe,
> 
> Considering no responds from Jens at this moment, I assume that an incremental
> patch againt the already-in-linux-block patch might be more convenient for him.
> Then he can simply apply the incremental patch without extra rebase stuffs.
> 
> Can you re-compose a patch against block-7.0 branch of linux-block tree?

Yes send a new patch, I'm not going to rebase the tree just to fold in
a fix for a patch that's deep in the stack. The fixup doesn't even
mention which patch it's fixing either...

-- 
Jens Axboe

