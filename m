Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40FCD3033D6
	for <linux-bcache@vger.kernel.org>; Wed,  8 Jul 2026 11:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783510825; cv=none; b=lZY+1G0/IAVbVfNBZPHxICexbAoeteiSkAEVGchXyymZqkaVAS8mPrjxXXucUarfBW/tjMnvLNDOtbXwnseCdMNecn4kHpSHrXWw7nzehfxoCrD0x48+Nyf/lPxSujqlfhJhOMZnmZtF0SBe5uyihPjZmlXZB6nVYp6S39A6ahA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783510825; c=relaxed/simple;
	bh=OIQyyLO0zJ+PNu2ofArWEriykpiCgrFXUPJTHRyk73w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bf5UFETDZVY/CeEFwueBtIgzR0z0zHTnPKNKxqZEixZYAyZG2DU5E7o3P8784CArJFg0UaUfVwrzvaaMsGhJ98ZiSwapIbhIGVT0yQVeV5br62uvl/CLqf4q/oHYXzsJEJZEB9SJ56zTuc/WoW3Uau4Fv76/mdZHDcwv9YNIMzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cn9qSX/d; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cn9qSX/d"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-847e6f03df8so620170b3a.0
        for <linux-bcache@vger.kernel.org>; Wed, 08 Jul 2026 04:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783510824; x=1784115624; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Kum7zT5ULm8yKFF8kTVrwfIO5VqML4mOCTNgOZriMwA=;
        b=Cn9qSX/dstDgWli3Hm4ifbv1n1Gm6LragXsvcpY1aGc20Nm+eum+W5aWvuHr70fjEs
         4/lwEevuXC1vpDbjVTrdYX1JMswRkhKcPcZ9LPk5oEkftDA9IvP8ilpFxkc9jhHfazli
         CbrqJAjD+qlfFa2+550VN5w3e4jSaO+BSOYKrqaeSCtNPO9yWKOOuA8ud4eX5n8J/aDD
         zh3scsIHJOkfEkZu1QjO9bugbqJGDVyHatunvCui1fOQgnVA4+mFsepA1AsXkLPr9/tg
         KQYTGCKTrNtLoIDLZdw3J8hfPkfnYZMCWPYjEDyFtcQgdyg+ksUk0w8bzZ+T7ER91wlF
         wFwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783510824; x=1784115624;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Kum7zT5ULm8yKFF8kTVrwfIO5VqML4mOCTNgOZriMwA=;
        b=qk5AIFCB+tB6WjX71wZM3NiradfhHw0RaIfxecaWQCTROJr7QZxopkO20nBBYVbyF0
         Qeh0CtJFd94Z1ylvlHv/7ZVOAaL0HPl0LhxHUtO1lzJXqCBY9uOkXr2Z0wC438DxULXA
         jWes+Tqo8CApDRQoJ9AztYTW76PJZmPl1NJZS+58hllh1Y1w6JtSNE2DxmlXZfwo2WPi
         pXBh1hG8yZit0KcM6Yjg4+hYk019sd7YgHvSoS+rAXss/fxhNJ6lS1LfKIQbgcE5L3EM
         aswZgwzA0RukT9cwoRn5OUID6d7rg7a0DLLYLWdwxtkHIoSJlJcO/XCt0I9kNsQiX959
         RruA==
X-Forwarded-Encrypted: i=1; AHgh+Ro+gR4P4s5z65E9Q41eat8yCGxHcCZK3SLNMELNl9EjsgqMalLkIX/H830WuhjbmEeDqjOjfMCUrG7iagM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPJAcQVrU7OmvKSzMQQnX4d+K7jVJ4ZPtC+FuXRqs1xQGfy67M
	8k2lYzy9qtEfrvwACdWEvkp7OJT1/Ma/AIjS9wTYW+HIO6Tv1ZtDE17Z
X-Gm-Gg: AfdE7cmm4tpyCEgyBdp0lSWAKbn6/u+XaUpAUmslreZnAN0uwxAD3R02XbF4RoasnZ0
	H76qQXv1MEMrZ5BZenkcmbzmc9MZ6LRg6K6Xh9Ub/z3TiDz6VaN2jIkU38Yy9lNoq5Gt1DQ4Alm
	G6vg7ET6osUqenG76BLAGdNl707VP974v/t/+Xelnow0CcJbuNkUiChZhSHAZueO0swKMik7FNY
	QA56yWa8yzae/9uh/r6FUxmKTbKOgWy6KiYgUTYDC1QWjU+p1RGwSNTCJl4QbNH52qsVfNxM/jw
	UnqKXlp5CY++UplswfdMhd5bcehurUVu0nc7h6cHgxjXxo2oDDRJDys5VU3Po9DlP76dOy84cCF
	ZRJzxAWWOcUuGRZrc21CS7suinj2NUq+CkpcDqfrzctk8FRQTtC9uHzs53hsoYoQzDNFMPpx4L3
	6orcWc6W8=
X-Received: by 2002:a05:6a00:c8c:b0:847:902a:57b5 with SMTP id d2e1a72fcca58-84843675521mr2618120b3a.35.1783510823518;
        Wed, 08 Jul 2026 04:40:23 -0700 (PDT)
Received: from ubuntu.. ([61.144.108.37])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6b97bbesm7186796b3a.17.2026.07.08.04.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 04:40:23 -0700 (PDT)
From: Jing Wu <realwujing@gmail.com>
To: colyli@fygo.io
Cc: kent.overstreet@linux.dev,
	colyli@fnnas.com,
	linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yuanql9@chinatelecom.cn,
	akpm@linux-foundation.org,
	kuba@kernel.org,
	brauner@kernel.org,
	eddyz87@gmail.com
Subject: Re: [PATCH v3] bcache: avoid holding bch_register_lock across cache_set recovery
Date: Wed,  8 Jul 2026 19:40:16 +0800
Message-ID: <20260708114017.2095355-1-realwujing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <ak4zj99pJClmDEva@studio.local>
References: <ak4zj99pJClmDEva@studio.local>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Wed, Jul 08, 2026 at 07:35:23PM +0800, Coly Li wrote:
> On Wed, Jul 08, 2026 at 04:49:07PM +0800, Jing Wu wrote:
> > On Wed, Jul 08, 2026 at 04:25:23PM +0800, Coly Li wrote:
> > > On Mon, Jul 06, 2026 at 10:08:59PM +0800, Qiliang Yuan wrote:
> > > > Large-scale bcache device registration and concurrent sysfs access can
> > > > hang unrelated tasks for a long time, e.g.:
> > > >
> > > [snipped]
> > >
> > > >
> > > > Co-developed-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
> > > > Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
> > > > Signed-off-by: Jing Wu <realwujing@gmail.com>
> > >
> > > I just realize this patch was sent out by Qiliang Yuan, but the
> > > email address is from realwujing@gmail.com which owned by Jing Wu.
> > >
> > > How and why does this happen?
> > 
> > Jing Wu and Qiliang Yuan are on the same team. The git send-email
> > configuration was mixed up when preparing this submission, and the
> > patch ended up going out under the wrong author address. Apologies
> > for the confusion.
> > 
> > The solution itself is the result of team collaboration: both of
> > us worked on the analysis, design, implementation and testing, so
> > both Signed-off-bys are correct and intentional.
> > 
> 
> It seems all patches authored by Qiliang Yuan used realwujing@gmail.com
> as the email address, even your name didn't show up in the patches.
> Since you and Qiliang are in same team, why you didn't use
> chinatelecom.cn email address in your SOB ?
> 
> This is not a common situation, so I need to make it clear for the
> supply chain security reason.

The chinatelecom.cn domain is China Telecom's corporate email. It
has strict anti-spam policies, and emails from that domain are
frequently rejected or bounced by upstream mail servers due to the
high volume of phishing emails originating from Chinese IP ranges.
We have had cases where maintainers tried to reply to our
chinatelecom.cn addresses and the messages were silently dropped,
which is obviously not ideal for kernel development.

That's why we use Gmail for kernel submissions — it's simply more
reliable for getting patches delivered and receiving replies. We'll
make sure the author identity and SoB chain are correct in future
submissions. Thanks for your patience.

Thanks,
Jing
