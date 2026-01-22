Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4877034CFA1
	for <linux-bcache@vger.kernel.org>; Thu, 22 Jan 2026 02:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769047690; cv=none; b=AJ3kC4+RxcEGSUtnN/cR1VnBAeb9vSZJI/xLuttHsGs8T0y8lWWERLAPxBjwAOXbXm27U9lXdCpB6ud7npETGB2I95f0KGB9ngMb0QihHFsi35xBPCLNTiiR/YUi5r+Vy9QB8N1ZUi6keATPtl4CswK/Jkp5ayssY3CjczPpRuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769047690; c=relaxed/simple;
	bh=AjhroaK0abF/9nlJPdhXGlLySTJjEzxeJ66A7helGi8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MqX48pYalbcIk8efVV1ATAyE9gftHlAfC/Dj43k4ywVTJW55LniA0QTGITgsJfzQG9xsYg9iQuXRkO5t/hxJfmE/SrinKEsz+y9FyZUYYqaxDSifytmCijY6Xjl46QAC7Rk7rWildMhaiyDfBxoQB6ddXDti/DFgIGRkQrx2RQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=w3rbtjDR; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="w3rbtjDR"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7cfd9b898cdso183830a34.2
        for <linux-bcache@vger.kernel.org>; Wed, 21 Jan 2026 18:08:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769047687; x=1769652487; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hDM/CneHISIzoaQoHmni4wRWu9xdMLgAb8dKO4Hy7w8=;
        b=w3rbtjDRAWQkyFTxytcK/+ibk7P4zpLPItjmKebUya+gZLFenWZXEEvtvGMDyLwH5Z
         5Xv7KB0nBixJxMWoE0xGfBB8KSKpfWa6WNvUTQcRcVwBTwnLWeSW50GRD/5ICIuAUanG
         AWGLXCM29gC+ux1yn9rD712ejFY/dxsh7UpegGA3YnsmktxvRYv+wJf7aH8u1GOzd4Ql
         cGuJ+7LJl6/4em/RbrV62sk9DiRov7Zidn59HhciJobMvGFionVn5me5RQJy3Ominn7q
         dI/7fDO2vKHIyu9Z0tVJhVEh/3b03i3WtQWl+3udM71hO87SfaUXeNXvUpi/OOv0tpby
         7ebw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769047687; x=1769652487;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hDM/CneHISIzoaQoHmni4wRWu9xdMLgAb8dKO4Hy7w8=;
        b=nOKFpmPGPuVd0/pPl8qEua204VjUtuLzQdEaOyz0ihqq3YF7dUTuoSxnKZ5eWoXKpq
         KnNgsEzpcrjrkEBcQmKfnXaOFdJsMUGn4vYGNwyf/+rVpczsKbD2SDk5zQjdECJm6UHD
         z+fpFmRc3fM+cvG9M8gvePpN0IScGqHPa+UWpi1Wc2v1QpDRkUyRsU5OFT93KkS5G3PY
         MjBaX79/lQnEHX37S43CwjW8GyeLzSZqRrjny9lKcDdFSfvaeIRV7vLHLjqEFvWoqed5
         G4X/hjx6m3yVqx0msQU41JBVR+FDHV3H9r0wJbQpkt1U5h/b9UbFR9iGdW/M4HfojZoc
         gUUA==
X-Gm-Message-State: AOJu0YxgHxboZnaVL/Uu42SvuS9KDTH35O5Z2bmCPHr5kPZtp1Z+JHuS
	tOoyLpcHWJcD3o8E8EoCA498pjjuLQNnH7KBNPG6WxaA3lYDcEaQ9+sRXjIFlbmZhMZeqP4cdCM
	ZRVoBwuU=
X-Gm-Gg: AZuq6aL+vv09gvfDRagUVN8N/4LiDOgEdlOAcQsMDlDATMTDLLCkdCTNxwGA6NCAfK4
	mhVX8zpYI/4Fun8KKPGi9NohIeR8iVRaCj+GgsBT02L8fUFJMmyzYgr9Jx5OQTb92XmMzEsCDcK
	15s4O+3nuhs02ozORmYmk7qp5+f4uhYV3nAdJRgMhOFdIDPVi8HezHNaehs3/WaaikQu5sCJjZM
	27v9bR0eZn0ZirKdOgsJyCjkF43YPrrndyGBqcnZvKCcA4XW157S0FXu3tYNzekTF3/tnBjfdeG
	zibB+CsVwQpz4WAw/EBmRYg5wHtaDJfffImLHPMgzPWdVnH0fr7E3AsQ/DDSpkEbljlAvD2FRCs
	ju5UVW+wL7irrOxHt0tn7rSDz20jfaR8Tzprgf5xUcy8EZJC79PFKOL66x5Y90L+aWUKhy3Xt5k
	Gj4R9j3RSNymKNT2863+inHvPJRHIVnBBJjoTt7vZlgpAtk2YFYGoxXV2+SPNA3htVeIGT4w==
X-Received: by 2002:a05:6830:44ac:b0:7cf:e539:dcf0 with SMTP id 46e09a7af769-7d140a52858mr3713041a34.10.1769047687185;
        Wed, 21 Jan 2026 18:08:07 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf2b5aaesm12098190a34.31.2026.01.21.18.08.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jan 2026 18:08:06 -0800 (PST)
Message-ID: <fdc4f3c3-964d-4713-863f-13a1bf20f154@kernel.dk>
Date: Wed, 21 Jan 2026 19:08:05 -0700
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Fwd: [PATCH v3] bcache: use bio cloning for detached device
 requests
To: Stephen Zhang <starzhangzsd@gmail.com>, Coly Li <colyli@fnnas.com>,
 Kent Overstreet <kent.overstreet@linux.dev>, Sasha Levin
 <sashal@kernel.org>, Christoph Hellwig <hch@infradead.org>
Cc: linux-bcache@vger.kernel.org,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 zhangshida <zhangshida@kylinos.cn>
References: <20260122013650.321766-1-zhangshida@kylinos.cn>
 <CANubcdUShtRu_t+VACzqpeEUdFtxqP+ErYFr-iWHgwqzD18Pog@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CANubcdUShtRu_t+VACzqpeEUdFtxqP+ErYFr-iWHgwqzD18Pog@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/21/26 6:40 PM, Stephen Zhang wrote:
> ---------- Forwarded message ---------

Can you please just send it out as a regular patch? The forward has
complete whitespace damage (it's all spaces, no tabs), and when you
forward, b4 doesn't pick it up either. Maybe there's some reason for
why you are doing these as forwards, if so do tell?

-- 
Jens Axboe

