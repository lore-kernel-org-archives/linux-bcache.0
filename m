Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E46E345741
	for <linux-bcache@vger.kernel.org>; Wed,  8 Jul 2026 08:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783500380; cv=none; b=owNOv3ZvA9HW3EC1LbfsVoWmkJ1HuRUQKeNDDiFDuAlWKEHkVIIvkch4ClX+Af7/bbzAVLeb+hifunL+ge/8vEY5Hn4mdn5o1Vek3WYBuxPePASK5PY7BTywb2d3EXIaNVFjgUm24p0qkIwtemlAaRs8RrB5P81gR3rMfw2rXxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783500380; c=relaxed/simple;
	bh=2bqw91DMg+zCb+fYIS8CFxJOxWdhbv0Wsb9LQMvrFXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXos2nSIMyY5cbYwjIl+DnxrTaXP7BOmz7hl7gCT3hv6LVbNbAUkcSy2/EXiwPANYdAZMF67H/gP4VuTBN4xPTp3GArn5PDg7jF6tmoRCgQCXCmG6jOSiYQbtD1lCnQy5PynfHvEZI0FbijHNE4KPHAdw0r66bVBvgikq9/6Op0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BKo2crnB; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BKo2crnB"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-381c51fde6bso474001a91.2
        for <linux-bcache@vger.kernel.org>; Wed, 08 Jul 2026 01:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783500378; x=1784105178; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2bqw91DMg+zCb+fYIS8CFxJOxWdhbv0Wsb9LQMvrFXM=;
        b=BKo2crnBegLU6KC6YxSi7sCfbYbhrZb/JQ3NUdO24a+V1cpnV1qnL4bKV3x9jnF2QA
         OPKlAOjQPKExep0jspVe63UHKM+Y0vhbL/88vp2aTkMwqRZeEbBgNZb38bl5Zd29tvkU
         goyBhLoRzPLOW+buzCw/eI6Jth7IYVCvfwnF9z5OdvTczqkCTfsPjNfUZBIsVEJdd6mY
         XbLnw57LCHiEX5fSxmxL8xAp0QY8lZaMudA49rYlbq3NmD40eSB2VyFML+EmisA23YdF
         G8d/9xYVM4lYr60vOBqNjNd2ToocmRBKFQHxPYRlr1p2dyDyzyJq6c5BnUxUC7ih80ns
         cZFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783500378; x=1784105178;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2bqw91DMg+zCb+fYIS8CFxJOxWdhbv0Wsb9LQMvrFXM=;
        b=qNXrG6JYYqdCSyx8g4tJG7zuwgFlK/YafTsFj7buTyr9mF4g3KARBtYlLb8dIWTHHL
         To+sRDZcxSydQ5NeoUMsU3rYkKrHSnXqPa5VdW7YUXR5qmcKOLOcszNhp5u+a7XuYH9d
         wQ6XvArEZANoP4LYXJEm4Aefzfpcf07/z6edYAou15I/e/iJpEdKlZZQHebknQRSErjy
         m6A0T8/Tlj4Xwkvf7ARzHA5mLkkq/wiODDKjn1nzt5377OSGjGNp7zPxMaFJM6/KxcXd
         4LANjPN4vGY+G6zHAPXF7zaZ/kdACt4YX1Z74f1/kDPlSrSxxJ7PUul05Ys/lUsOXZOX
         L0rA==
X-Forwarded-Encrypted: i=1; AHgh+RriXFCBhFwjrH0A1KlA1BKuvkePupB+Cr7Sr9KlJ9hUNxyu25oI8SKWPQSZCI0t7UJjZ3m0Y3JwT6L8SxE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4rfKeAdXLWFAizwmPy9W+IMRD0Ev/tKWhWrwzFawYF179aUiA
	utEyL7GSd5xAoLA+krqWfh9i8dWi+HSD+mz9mWpB10ZX4AYD32bRiz8yXrm+DjaQOU4=
X-Gm-Gg: AfdE7cnj+uYEJb2sQ49fRSkpRbyppuYj8G6/HsYW3RzhKOw1RW9yAZ7Ak2PoFyevEdI
	0hFWmf2PdyeM+opgtUohK/KBM0KrdXkjDWQRptN5VQ4IYk/7x8MW4yIy2Y80lol4BXBz/mmmoe4
	vAPUlPRxvQwwoZmcG12x7b/wb24/As4ubnM1BJfkVmBWJ4kijY+368at+/CzuqPOecT7xgcR1Zh
	3qcCdlJEWA/Hi/Y5Z2HY4lgEsM/Q774lrpL4oeoRdQAoK/oqBMo2mtw/RbNJtbi3cT6hdqkXUHE
	FSrTctr6U03V+y8AEgw9Bk5A+tfDBCmygkBQbFNFLoNQ7Wx7EKTjl/LvZPdlzEfGs3Dfdp2JI0v
	V262yKWZgRVlGz2lu5J2ZSyjjtgv9E/tN7MuZa7a2v0iRQlyXSJVal9VmRRpeh2H+tzN6xKXl8D
	oKEHhLizI=
X-Received: by 2002:a17:90b:57c3:b0:37d:9874:9363 with SMTP id 98e67ed59e1d1-38940057b00mr1541166a91.2.1783500378330;
        Wed, 08 Jul 2026 01:46:18 -0700 (PDT)
Received: from ubuntu.. ([61.144.108.37])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-388e04f9cccsm588291a91.0.2026.07.08.01.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 01:46:18 -0700 (PDT)
From: Jing Wu <realwujing@gmail.com>
To: Coly Li <colyli@fygo.io>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Coly Li <colyli@fnnas.com>,
	linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qiliang Yuan <yuanql9@chinatelecom.cn>
Subject: Re: [PATCH v3] bcache: avoid holding bch_register_lock across cache_set recovery
Date: Wed,  8 Jul 2026 16:46:12 +0800
Message-ID: <20260708084613.411350-1-realwujing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <ak4I5Rkx1ZPjueNv@studio.local>
References: <ak4I5Rkx1ZPjueNv@studio.local>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, Jul 08, 2026 at 04:25:23PM +0800, Coly Li wrote:
> On Mon, Jul 06, 2026 at 10:08:59PM +0800, Qiliang Yuan wrote:
> > Large-scale bcache device registration and concurrent sysfs access can
> > hang unrelated tasks for a long time, e.g.:
> >
> [snipped]
>
> >
> > Co-developed-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
> > Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
> > Signed-off-by: Jing Wu <realwujing@gmail.com>
>
> I just realize this patch was sent out by Qiliang Yuan, but the
> email address is from realwujing@gmail.com which owned by Jing Wu.
>
> How and why does this happen?

Jing Wu and Qiliang Yuan are on the same team. The git send-email
configuration was mixed up when preparing this submission, and the
patch ended up going out under the wrong author address. Apologies
for the confusion.

The solution itself is the result of team collaboration: both of
us worked on the analysis, design, implementation and testing, so
both Signed-off-bys are correct and intentional.

Thanks,
Jing
