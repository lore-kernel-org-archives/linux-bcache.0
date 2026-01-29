Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149BA31A56C
	for <linux-bcache@vger.kernel.org>; Thu, 29 Jan 2026 02:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769652461; cv=none; b=EUfUck9m6TMqQlVeN5Ke6U+Aa2oUwAm71MnLI8cqM9gfobjfBKjzFgDHgYOmCJBXEoPfwblkQ1ZUkH5KtQ1QxotCzU/+WuE/OQf2sI7E5z39Ayg6EWbkzrcrC9pa2Rikx0njyTfiYO4DnSfBQ/Ra/ETmCf6sBR2TkUSutQMvbpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769652461; c=relaxed/simple;
	bh=bacW6gtNl06dEZs+cbp2e+Z6rn7KN+k9r9uHG6KcT8E=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=P1uNq9QCULQaIaqcDgVMSDSCKudnrVZXuI/rccPBcO1aCfR9NgYoisCx1Yn9Wn9nLlLDeJVrs1y7+VkfwWomBbMKr/3Dq9EMMehQAKJGBtP2OpAHWCjba3QFQbceCYKafnodfn9MV/EZPcodfjODdICS/LxSrhLjgd1Y4Ns6cNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BkDHMOz8; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BkDHMOz8"
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-662f5c4665eso215401eaf.2
        for <linux-bcache@vger.kernel.org>; Wed, 28 Jan 2026 18:07:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769652449; x=1770257249; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/a/OwQj+PVEv30iLi8MyCsqlP4Ex4C2otjo4OVfqMGs=;
        b=BkDHMOz8VDGxzc1JP844K7eIy6MjzDTIdKHZGELkvk3spWDltrXOKtWVIsMRNcr1XS
         8vL0HiCXyclnqQCK8phbfGD55d+aK6oLW74B+zfBnI67qoRSE0lvdzuQb3IdBZ7djZZW
         tJoIouyyBWMl5kofkMV5TJ5vQYldGO3vY1b4xTu+p5s6H6bqBaaXCPBrWTq2Q31hBqMD
         X/cZ8Nh5CFb+Zf49YcAlKM/PSDNI1XucmuiQkk6eVknmjHehWnGY4mWwvyzK9bUk9+71
         mJyxUZbUvznJTO/Lmp3N8GVL+ewYHGShaLXM9Z7KvEdotDd9vG0jEFd/9XVCfSFSjesB
         jYmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769652449; x=1770257249;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/a/OwQj+PVEv30iLi8MyCsqlP4Ex4C2otjo4OVfqMGs=;
        b=GGgIke76KALI6t4ThoJivhGFonfzevY7YRdi+lOdbu8lbeCmE6JoPTtJfk1USrb/Fb
         sx2hyZmQuwyUIErDHxR7+WeVAklj1HYi+oh5zC1KqmtwaDe8Kfth0rPv3SUCCWLDWc0e
         rPoNHOqkTDvEurm5n2MiyHEWc+GxRjUXannO5TakpClmwFyFQlZa3JP8eLl8AzZwcrS4
         8I+DJJTOmaldJZq5q6Tb2Gpu+RIR1L58hxFCv1whRb7Mo6Ms5h3/W+5tvQAOdCROiNRN
         HN1bnh6125+CcTxXlfd38k+4jW1/Xb6EEs5ZZXQ7slArhN2VQM9OovJdmxY1K1Kmz6wl
         PV6Q==
X-Gm-Message-State: AOJu0YwtboJpCDQEcMa2P0uwNqZIQ7gSgZGs481tetfIaG0IBku/kjF0
	UehHByKVxsvY/hK0UUWqm99Sh+cTSgMwkMK8do+OIDnB4VunEcHZNIvxubwxlQavUneg4TTtyVx
	A5tMXYkk=
X-Gm-Gg: AZuq6aKxOqHSkxOlBAdp7EUIBQf5aaW+9luat/AX8iPAAnUWbpUDlxciCAGrEqPt+tw
	1Lrs9Z4Sc6Nt/Fb4KIRY1mzCjGmIZkG7/htzhDWuptH7EP79GM3YzrvOKISYK3EuY4jDY19Xg9E
	7Y+rOLJwHdTXq2wfRiOc2imCWJ0sCgIiIqAddb20uO1ONHW0wk3aCmu3CHw+Q8y9WcLGVs82mOs
	2VXBt+SFdZPZ8NMG8sqXd8j0jDPM6kVlUEawW5IkoZzU183wFYRTJ9CJXePmoLOT+YWmpbeAhZD
	Qvi5IAu9lnQkIGUyDkK4rGPRZiB2NzWVp6FzQQoiioJ5ifIaFAKcaS0nn2P3TZCG6aa+aGxpyTk
	oAXY9NpT6GnKrUgh+KZWbZNP8JUUoHp5ge37CLv+YdT7TRAL8dClOqtqJE4Pk6CaTe+e3+/F+eU
	GnXlAiK8Gb2c/NKyv+RymlzAnrS0nTyAYLg8nHeb3KZHxJog==
X-Received: by 2002:a05:6820:1622:b0:662:c415:6b5d with SMTP id 006d021491bc7-662f20df6fcmr4289159eaf.64.1769652449345;
        Wed, 28 Jan 2026 18:07:29 -0800 (PST)
Received: from [127.0.0.1] ([99.196.128.240])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-662f9a35b3csm2529154eaf.14.2026.01.28.18.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 18:07:28 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: colyli@fnnas.com, kent.overstreet@linux.dev, hch@infradead.org, 
 zhangshida2026@163.com
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, 
 zhangshida@kylinos.cn, starzhangzsd@gmail.com
In-Reply-To: <20260127082112.1114158-1-zhangshida2026@163.com>
References: <20260127082112.1114158-1-zhangshida2026@163.com>
Subject: Re: [PATCH v3 0/2] bcache: fix I/O accounting leak
Message-Id: <176965244085.445345.14457521939729169467.b4-ty@kernel.dk>
Date: Wed, 28 Jan 2026 19:07:20 -0700
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Tue, 27 Jan 2026 16:21:10 +0800, zhangshida2026@163.com wrote:
> This series addresses an I/O accounting leak where detached bcache
> devices could report 100% utilization in iostat after completion
> of discard requests.
> 
> Changes since v2:
> - Omitting the dead NULL check for bio_alloc_clone() (suggested by hch).
> - Updated the Fixes tag for the accounting leak.
> 
> [...]

Applied, thanks!

[1/2] bcache: remove dead code in detached_dev_do_request
      commit: 6ea84d7a92cb0b30aaf7d2066a69e28e27932332
[2/2] bcache: fix I/O accounting leak in detached_dev_do_request
      commit: 4da7c5c3ec34d839bba6e035c3d05c447a2f9d4f

Best regards,
-- 
Jens Axboe



