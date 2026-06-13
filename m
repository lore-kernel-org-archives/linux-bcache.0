Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF733783AD
	for <linux-bcache@vger.kernel.org>; Sat, 13 Jun 2026 15:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781364578; cv=none; b=GNFRpDOx9yt6BW//5AVQmYs5O8g4YEIm+kd77jgwd+XtDEk2IX4VSLfxx7QCioItgywptyUFyS0X5byCoOV2Mfkr/SUDYG5HEHQFj0SF/YyHN0VDCMb7QREMtvdhXLoFVGJdL3lV1YRizYRW65fu7fbAFEp+NVxamM5eCwe7FUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781364578; c=relaxed/simple;
	bh=fFIRwCWA8q3dej1RdrEStjRSns+yvMUX5NiRkJaQ+hM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=hu1NIkCN2gQX+sJilHyPgqQTLOiQit3hmzoP1UNk+2B/0U2mv7GNwCfkjTjiKHxF2HlMItyGVvSn6qKe6A0J/cvpbw8FpeFycFez4ZhZ83yJz2PWzgbai8MUC3zEtaMUYCQE+rKAmjDX4z05YEyaVQbHDM99rtbJ0Ir9rwaqKy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=LzbG9FMC; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="LzbG9FMC"
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-4862ed6ab36so1192846b6e.1
        for <linux-bcache@vger.kernel.org>; Sat, 13 Jun 2026 08:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781364569; x=1781969369; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2qCxWSvvu3zunkbXkGJtZHkiWrjdF/DdrDjNA4zR0mU=;
        b=LzbG9FMC5kR5AE0X2yyLaTPCeH85hw3JhPbCMlpy/I+g2r1CSBvmBTS8GuU88wIgBt
         DLnQMfA6ttGM4uQUHJIRLVY0vhx/kNu6lYsKLEkbF59CqeA+30ltIlrODGEbY9V2aE35
         STClc446mxMZ1BnpXvpdT+ODB+PRwEphVLP8gYMTZHxFL43MLhA7E4y3xyCqe9dtJ1cv
         fCxWV+V9y54NRnHiePCK7pL4GkXHWvLYvho4xSYPMWkdY4I5krV5C798BKWE0o1HbZVb
         X6aE43sGH1YQjG8cFLRpIdUkOtElnw5DmcnaIfQFovbd+uva8E844XIFM5wkI45IMOR9
         L84A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781364569; x=1781969369;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2qCxWSvvu3zunkbXkGJtZHkiWrjdF/DdrDjNA4zR0mU=;
        b=Vze6FVl+Naeh4Vi1UEandofuR4jCRWOpLYU/LyVapnE4TNp3TRj7TpFRhGhvFgLFz1
         nHTveal7ilgaiu2zon6/SqQmxVhXsaluEw45dy7cE2pqsz5IazN3Lw+xGYmjxWYApQkV
         U0lTMNFThR9Ur8uXGSG41DpWjefAFO1JU/gmiIPlastKvscdWqv0vZJoJwKG3wGIdXj9
         ZhW7gPfpLu6HJ284O6/SEgfyf2lP3fZlkvQLS+coFHOLXHVEz/kMP33t81NyM1VZVK4k
         xk3BFH1TLdE9zcvVaNupPckMF+KPDoTPtU8VdZHAZet1x80iDAXjiJzg2JK1NllVOh4F
         hgfA==
X-Gm-Message-State: AOJu0Yw6bgOl40io/71JjMMSgjdslssAkFU2xf/yNUbujsZiQxaPOOIw
	+ot3Sin3vKjtBmPMffItVDViqmXVv43cqFWV7VnUnazh9KOvh51LP/PwIjDXoxb/8daB8/JFO4J
	/Qlbin/c=
X-Gm-Gg: Acq92OHXruXI1ifbJcIf8COuuQ1wMsZ5NJRNmHV53wvJWm84IszFzJ3Pf1jfZZJExep
	n5abKnj10T5HCCZQ5W/k43Vbfv+FlvPaXI0qQbc/eY7nPp1tywtv3bef76z4dfxJhBHGDsE+mfX
	JmEPRueUzj/kqaRFUgxWQA3K0DSxEAiIMxpaxJyMilCKaRRBjaYXkJ0JgHrpYvRwOzDOYWcxh3L
	41rYwHJ8vW6hTr9pwE36bHk+bOSYOate9FdENeEOn3K29Rbcf3LcoQnt85Y/wg/m4rpI4telNND
	2K3baPj5i/MX08yBh61qvgKD5xsPfFclY4NyEPxgn6pAgX8bgF9Ce6Id1lDSK/cvSN8vm/kN0uZ
	Kln0ktMDAIjJdaqIIsrg19xYtC69P77gyIcJ0Z9IAXUcqa22n0Si35D6o/e0fW8ouhMAJDM2wVY
	TGVsLWp9cEfRtAVMUPRCpxpiAlhpRfW9jnYvyFIOqpq7cbO3G2iPER/G5sH3BjCa5L36calRX7c
	2su/QBUUwW7SLI=
X-Received: by 2002:a05:6808:170f:b0:485:4815:de29 with SMTP id 5614622812f47-4872f38e113mr4990697b6e.6.1781364569575;
        Sat, 13 Jun 2026 08:29:29 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-48758491556sm125203b6e.9.2026.06.13.08.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 08:29:28 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: colyli@fygo.io
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260613150458.682707-1-colyli@fygo.io>
References: <20260613150458.682707-1-colyli@fygo.io>
Subject: Re: [PATCH Resend] MAINTAINERS: Update Coly Li's email address
Message-Id: <178136456783.1954753.8358889895275169463.b4-ty@b4>
Date: Sat, 13 Jun 2026 09:29:27 -0600
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2


On Sat, 13 Jun 2026 23:04:58 +0800, colyli@fygo.io wrote:
> I switch to colyli@fygo.io as my current email address.

Applied, thanks!

[1/1] MAINTAINERS: Update Coly Li's email address
      commit: c7c76f9232bd34835d821f14abdc5fafc17bc938

Best regards,
-- 
Jens Axboe



