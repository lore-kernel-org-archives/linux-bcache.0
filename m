Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A172874FB
	for <linux-bcache@vger.kernel.org>; Fri,  3 Apr 2026 11:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775214707; cv=none; b=Y+VMQdDRHhQZdZRFOJe4l+Zv+YOMoSSVqqFt1zEfbn3sxpiX6kMITwywTTA8s7qNeKia7V36yMoBkrEOHcCgA/0wW6OEQMArX3pSAsSyC7x1MzVWeuagKPSoHneHVE791gXsfkWhaJZifQa2grwetk/zg6kVCwF1tU2rdn0EHVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775214707; c=relaxed/simple;
	bh=ENVs3b97sKzpTRUoyd1iARXbZap9ypnQbZw6LfbrLxk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=fRdgfGNLwQd9l8JBcMNzEM8OIwDDMHNIar9Xfrw8K9Pszs2LktZTc4rTi+Cu9JfWy5cPn4La/RWto+e8qHOgx2aSisHht9I+5G9l8DJKXxixH/SYJ5gUC/SXMgPrm7NvcvWFXCNu/wZot4GxfQy/2GngwJTCYXymp4uXsnFxURg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=dNXbIuSh; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="dNXbIuSh"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-4042fe53946so725532fac.3
        for <linux-bcache@vger.kernel.org>; Fri, 03 Apr 2026 04:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1775214704; x=1775819504; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hnAUvsT+JGPMQomq6uttwrVxbr2x+5m7RSnNiJlf60g=;
        b=dNXbIuShx8okadY6hzMrNNuHe3zVu8akWPYMe8VPOx0XfYtVCEw9Oy2UO3JqYnB4HW
         i6Z80NWnIdYgY3lbnnz5+kUxsjVvmyM3Hoa/YmevAAXwsbhDjgxTnd5dBmtnKLXAwFIb
         8u+YLUZvtiXOMEj/6IpvnhPNr89ILfb0+YVLEb0jGeIecFdW7yc1ZwkJYDOYWSY0BONT
         hiX8/Rdrcnemw9hdM2UL3Zh26VbO6A9aCJZvKepuJL2+GnY6XYXyEWvME3AnhSIOsf2l
         71e6f13dy3k6gOftgjdxU29BxUE9d2jwt7QXbf4ysQ4bcMBqx6KuRgAsEFoEzad2gO55
         D1Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775214704; x=1775819504;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hnAUvsT+JGPMQomq6uttwrVxbr2x+5m7RSnNiJlf60g=;
        b=aZLDMHTKB800B85twe1tqCHziiQeDAJrlFN69p5AQuBRcf32hIyvtxrMu90cX3iHlY
         2gi4i8gbkscvNkJDQAf/99pGXQ3sG74WP8+7Nq0/14ZqM2s5OK5Ah7IcTZYFx//uj/U6
         PwcQiZjJuFQT330KqthTJUgjlerc4h2PsrZep4ITOTwdmdQN1BBC1a1+s4PfYQxgIQ/Q
         1ASoXqMPk09HWW3cKSnqljcp281RtR05M3sygJsL9mUGdK/0dQ4r8oIFTve3u9NGxeg9
         eFCOkgC6H2vh/j+p4gITBEbqyRtUUHS1FcU2geqjptBPwYKKLcwU7lV9xAa7m3klUL1d
         zMXQ==
X-Forwarded-Encrypted: i=1; AJvYcCWxYOQII8DxPf43DTbTw9ukaB0wF4hXU8ETgQvRAfpaicQTiNuic8ly9yopHzofrkwZDTkc7gYJeFlSevU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx56fDAkHWP7j1+OITcUNfLhodkM/AF/eb6xdDsjUge1rmy3o3J
	3S7ZKnfO0mCn+L9m5IsN6tZkE870hnFi4wjEc7N2W/TepBW3tvoUUz4w6X2TuZDtZSWUz4LOY1A
	6/vh+Tss=
X-Gm-Gg: AeBDiett85j1xSDZcgBEM/co7dCkSlOXYndgOQLi0Rflfi0DstJ2rbe4hV4IbBpdC1W
	KgZjhMnG1kbkQgIpmeAPJGug6dpQuuA5uiJzgGVxaPdtvDy0X1CWW6LquSaDZ9r+WJj7o7cm1AZ
	HUFJ/wcyl/KL1v8HvWaDgbn+5iy8Y+2so6mAlyK4+/rNmYNDe98x52TraXLEhP4G54+FIjacb9G
	rH+QU87F5fPUZp16tkvqmInpqV9Az4eBG91jTOs0D2qbICjpXvXXWErRnlVviJ3iS+rGH9GmLG+
	eo7fStxsVkI87Q4FLc3aMn31iARq/Fco9r1esumkc9tt1gwIZxsxs0FCuDUe00Q+fevUw7Ffl6z
	N34AMrqbGCnnyzp3yI0BqOK5HA8VAdr9B5BfYwjMe+0rSHp643YWTw+ksUiVdlVkc6/+TPgAxTr
	wuAz/2xId2bKxebD0YeaqlSAOodHe8soFHLC9qGAqj8ziujBfzdGyz7cA7RT0wFyj+Df6pwYWii
	SSb
X-Received: by 2002:a05:6870:8883:b0:417:48fe:a8ce with SMTP id 586e51a60fabf-4230fbf010amr1276063fac.4.1775214704495;
        Fri, 03 Apr 2026 04:11:44 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-422eaf2c7c3sm4487097fac.5.2026.04.03.04.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 04:11:43 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: colyli@fnnas.com
Cc: linux-block@vger.kerenl.org, linux-bcache@vger.kernel.org, 
 Mingzhe Zou <mingzhe.zou@easystack.cn>
In-Reply-To: <20260403042135.2221247-1-colyli@fnnas.com>
References: <20260403042135.2221247-1-colyli@fnnas.com>
Subject: Re: [PATCH] bcache: fix uninitialized closure object
Message-Id: <177521470357.492849.17679855367583434577.b4-ty@b4>
Date: Fri, 03 Apr 2026 05:11:43 -0600
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.1


On Fri, 03 Apr 2026 12:21:35 +0800, colyli@fnnas.com wrote:
> In the previous patch ("bcache: fix cached_dev.sb_bio use-after-free and
> crash"), we adopted a simple modification suggestion from AI to fix the
> use-after-free.
> 
> But in actual testing, we found an extreme case where the device is
> stopped before calling bch_write_bdev_super().
> 
> [...]

Applied, thanks!

[1/1] bcache: fix uninitialized closure object
      commit: 20a8e451ec1c7e99060b1bbaaad03ce88c39ddb8

Best regards,
-- 
Jens Axboe



