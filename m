Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66313403AE3
	for <linux-bcache@vger.kernel.org>; Wed,  8 Jul 2026 08:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783500554; cv=none; b=BvF5wCobjgZJdjrIxpkVkqF6OHTOTi6uqmp4sSG+ZCCZZtlKfZ4HszpHNPvQaAhmyBqn9t+RU+ed/6qStpU/l8AUidUf+mYw5WLJjuu/NGzqob31I836em2z4XXkl75VuLqgAYd8SPxUi4zG7YBieafSf1fwf5BwjDdjnglHjFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783500554; c=relaxed/simple;
	bh=2bqw91DMg+zCb+fYIS8CFxJOxWdhbv0Wsb9LQMvrFXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sWS5+xfVEGt7Fq7WfGaR75udsz1XPx4V/HXeXlvACE4cRO/TDKoa/fmRpr4tR9/g13AOkpCIiGouHgOvsNfnl5WRk/UvgKMzgHOZWJrUKMnmjNucEpmbQPnHGDKSpZs6N4DukvzODQ1wLq2+t83k//vmogYjTPlKackQMcf3yBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hW9HYRhr; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hW9HYRhr"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-845b6d9bf39so389108b3a.1
        for <linux-bcache@vger.kernel.org>; Wed, 08 Jul 2026 01:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783500553; x=1784105353; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2bqw91DMg+zCb+fYIS8CFxJOxWdhbv0Wsb9LQMvrFXM=;
        b=hW9HYRhrf7m7otgjYElIpmx2X924RfXoegfm+f5jPLqVM76H0CM0VpCQ5epDiN2L0k
         x81Y9Asg3TqpamG8dz4+qNrbijZ0fq9o07eG3G90mhmhLocEB4bMZo9zqPHUdZx3Cq+0
         ABPdNE4I7DgJgYUoshrKNt/pYBsgIyrpXSBLOjbyqax20CsDFfC/ucm1Ef+Sw1ibnC5p
         Ds+s1PKuRcEDGBvG2XS4J4VHWnJTOB0mE2nzdp5k+6OQwtWmgcH6bBsM0nuEw1olfVp5
         mTW8KwQo8DV4ET4QiKOCjkkkTdQrQQWHyeAX94XLfApvldYyEz79cDqNBlPKviYgXwNm
         +TRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783500553; x=1784105353;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2bqw91DMg+zCb+fYIS8CFxJOxWdhbv0Wsb9LQMvrFXM=;
        b=X0By1dEPy7u6QX7LCuLnbK9CVRB2xPbiMdGEQYNXdmSjywzT8wcwy85/s53Jt1Pmac
         SW3/+PPQAxSGf1O41HmK8bGb6DYoLQsuplxeh/Wxz5s+E1QV+LnX5KtELGzrNV2KbFiE
         SP4kIiifFlbSlkMAyvmmR6FcRGubk3TkBIGF12GBIn/ARsbRtaDNPUTXisHGCpI6KwRV
         QcFufL2RGfkdguL3QEXTy04AqZTHZ2T0EUqgaMQTgAa7AP0AMNq5QZEH1YNKgBkSCF7M
         DvAqlXu2gJ532mSXObmuRjexuqT1pvudLHDqtjy7wm1WDFycG7y9Gf8nSX7c8YCNeoPO
         HXHA==
X-Forwarded-Encrypted: i=1; AHgh+RouoCcWn82UNaPNLuFNlVx9VYilqFI77WCJIQu91Se8wRE9c8iQNU4vWXYJLoR9EelVfQVn0IHgnbgkJME=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQDuyLIWg24JDIWSVA7NC0RVcjwWFhfdNonovwsM9RZcV5JiXp
	Taw2/c2zrc8mE06RexYrRY6BFTFFSA8YRLrgy0Y5aqlUuNhNvOTMOBbo
X-Gm-Gg: AfdE7cnzfUGnm5e+W7mPydpCN/wlBxuk7ewapOv+QRYgOF0M/OsIleOPyl4GmnVHbNk
	u5WZum/r9PefeAQTDUsBcLqlFOU+ZARP+pkkds3lW8h49Ch7JYh9JCM9LQ79ooGQ8OY3xxLxKtz
	VQsVVYIDc8OKnNp40NStOxp3CUya7ulEaunjCw/4Ix5CNVCEbN5nITAiNMCNSVuDWQUHo/sOl8Z
	nVkUARy6g5SskvH21RQ3WBJAabCfS08lTL8P3UdD3k7PwKyYUIE2SDHHDmprf7Jv+fmkXJGIPUM
	7M6l0lSl1nFsniiY4dAUhdrgr4EwwfjBIJ0buNg6vovqk6/Dq49SMz4xsZ7JocuGkPD8haTpp9V
	XS11aaKmPIhmxvffa8WVkoPt1wP5NQqgn8FQ+V+KMWmSZUjVo5L79dQknNPxnxyAedWBLRzf1Y8
	fhOSn/g74=
X-Received: by 2002:a05:6a00:a0c:b0:848:2ef5:50db with SMTP id d2e1a72fcca58-8484301f75dmr1587652b3a.35.1783500552674;
        Wed, 08 Jul 2026 01:49:12 -0700 (PDT)
Received: from ubuntu.. ([61.144.108.37])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6bc9f5dsm6709694b3a.27.2026.07.08.01.49.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 01:49:12 -0700 (PDT)
From: Jing Wu <realwujing@gmail.com>
To: colyli@fygo.io
Cc: kent.overstreet@linux.dev,
	colyli@fnnas.com,
	linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yuanql9@chinatelecom.cn
Subject: Re: [PATCH v3] bcache: avoid holding bch_register_lock across cache_set recovery
Date: Wed,  8 Jul 2026 16:49:07 +0800
Message-ID: <20260708084907.436861-1-realwujing@gmail.com>
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
