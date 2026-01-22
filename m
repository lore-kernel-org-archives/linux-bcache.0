Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3011B34E777
	for <linux-bcache@vger.kernel.org>; Thu, 22 Jan 2026 14:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769091994; cv=none; b=YYLeeyQyWUvU3elqJwr1SMWxrncffdAZR/Tod9OoWhZxV3LxXiPMhY5+b5rSuPz782Vh4wQF1MllmtCDmOf/AiWKEy2fRiVXm9+VdbO6dLldkR+pWfye3UOV+1gJlX3V8tIRQoHqYijvtyEyE4S6B4KFdct6MKtjmgMfD6Por24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769091994; c=relaxed/simple;
	bh=ZHu3tvmAxx/ny807Qmav1uryRUjV6KS6597dZCE2Eug=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ZEMiZEjdfYgFLgoa/XPzH57Ni30nggcj+7RJII0F+vUmxMkCUS1I31FRKu1fp5niBysniWunQP5bZPN0RKSZu04/71VgkuWCO/RJa50SkAev9I0nk1AOMpR+ip20n85rRHvAHV0AnLM9Ibq081tpyIkK9ih7ZS4hD/nsC+cusIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=AJBkVLAl; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="AJBkVLAl"
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-459ac606f0bso642602b6e.0
        for <linux-bcache@vger.kernel.org>; Thu, 22 Jan 2026 06:26:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769091991; x=1769696791; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2Iz07gzDxA35yxkdomcfE9aNLnQIXSu1I/Og/R66TZU=;
        b=AJBkVLAlAthGx4W/efZyFZnm2F6SMmPdODw5jl3ZSbQjFeOc14tg6EWGC5TT/KVGYP
         FbLDp4qym4Y9YlGnHYgZVr4LMHY+JVwtldGxSa/ORMaq9+wb9ZhHug5Bxl9kef0F/93+
         ZNhzU77YqhjFIWqLNL347Nd0DhmccPyGC+iKus2Vpj39GMGnqKyLK5tbN75LxHhyyZxA
         55yYiqPpBsTmpMfyvEhgPgJ6EAe7Y47CnDdN9Y8kbzJRUWzhWgm1Kmyz0J+cr4NhBIcs
         tXIbYh/WAAOqZI+r7hAA52v6IkHAtBspmka5rkhaJV9WYjY4hNg4udzmoPHG1T+ntzQ1
         cSxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769091991; x=1769696791;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2Iz07gzDxA35yxkdomcfE9aNLnQIXSu1I/Og/R66TZU=;
        b=e/RIOIUI1sfZMbmD+m394J0Q0w9DQ6vT20q2/Yy7hA0i6dpcgF1TRniWg+AvFJhhkV
         bJJMbscDNtbY0BWX/aGbXzxH6PeaxNSOJ3ft23KiGLFS/kpBJjtQoQ/RQQzu/QnlyqUy
         MoXl2ahcjEq/FP5hMKtHYMIfBIXOsseLnR/C9Q405ArJ82WcaM93WxGfAiYEBlg3uTdl
         Szeu3VaPQVPdwYGnHzpwj+aCvWicIpsLzW78/LAL9PwFvz/nlj3iDEeY8G3SFdIYSOyL
         OCLlaDIWdcm56yILzhj9O2vQQXfIKRFWZqs5e+VDXGDr1dL1O78kagCl4ypPpxHKaP05
         Rd0Q==
X-Gm-Message-State: AOJu0Yx96wXDaIjRn7GPn6aPVVRo9UYXZcKlyQpsOyrncHNohmGpc5A6
	Fdwh+iGunRqxpzZUa0lR6+yLNflLvbjkllKtUsU7mphNMITZ4rMl4KGsrda/LZo7+YQ=
X-Gm-Gg: AZuq6aLQGclRFzZDexFkO4sMj8PaxN0dkYp76UxRGGANuZof3TGxFN8hxReNvekMFo5
	k5G+L24fee6gW4r8lm7zX2d2bfroV4pkG4DtbSStt4x4wOQ/jgsuziP0cv6PRNQDm6nfzXsBqRQ
	8tdfPqKABYkImi5G8DL75mc7KrYeyDFxDvXM8RSpj19PGsqD9zXu9PmHfauHA9JKF+U5Mvay9as
	YqhuOD0O6bITxsnU7gZRS9ebu0FTYNnGHnflFtSC021NWbufvByUW+pyyHLAM5XqJHblHLCktjc
	mg57rrETj7EMOPEWA5BVzYs09zlp0qaBEYMwJjZ+7OKqsKgESYQ5lC+lIvvmJ4xL9G6uiwlF8bJ
	f3l7PLGkVUy2l6eiPS0IiBZm1CcOglpeq5R6+PNf1WKKPJX6zcmoHfy7YV4w2p6nyoiXsO9We2n
	RWhfjHcksci3hqmtVjfk1zlwyvhvj1lCN4mIbYDl9tjxrIqvyfaD76AGwy8H0pUbo=
X-Received: by 2002:a05:6808:30a2:b0:450:caf8:ebc8 with SMTP id 5614622812f47-45c9c169726mr9616731b6e.55.1769091986046;
        Thu, 22 Jan 2026 06:26:26 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4044bd5c64asm13773891fac.16.2026.01.22.06.26.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 06:26:25 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: colyli@fnnas.com, kent.overstreet@linux.dev, sashal@kernel.org, 
 hch@infradead.org, zhangshida2026@163.com
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, 
 zhangshida@kylinos.cn, starzhangzsd@gmail.com, 
 Christoph Hellwig <hch@lst.de>
In-Reply-To: <20260122061321.359218-1-zhangshida2026@163.com>
References: <20260122061321.359218-1-zhangshida2026@163.com>
Subject: Re: [PATCH RESEND v3] bcache: use bio cloning for detached device
 requests
Message-Id: <176909198455.303056.14934550192217004133.b4-ty@kernel.dk>
Date: Thu, 22 Jan 2026 07:26:24 -0700
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Thu, 22 Jan 2026 14:13:21 +0800, zhangshida2026@163.com wrote:
> Previously, bcache hijacked the bi_end_io and bi_private fields of
> the incoming bio when the backing device was in a detached state.
> This is fragile and breaks if the bio is needed to be processed by
> other layers.
> 
> This patch transitions to using a cloned bio embedded within a private
> structure. This ensures the original bio's metadata remains untouched.
> 
> [...]

Applied, thanks!

[1/1] bcache: use bio cloning for detached device requests
      commit: 3ef825dfd4e487d6f92b23ee2df2455814583ef4

Best regards,
-- 
Jens Axboe



