Received: from va-2-52.ptr.blmpb.com (va-2-52.ptr.blmpb.com [209.127.231.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5234538F251
	for <linux-bcache@vger.kernel.org>; Sat, 13 Jun 2026 15:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781364656; cv=none; b=GaG1hzHsDVU0vBf+KOOlfB3cnXlZ3ZclrvyAnatVeiPiMwyYk8vO2HkiAQzJv84Vqooiv4BN9/CsUHy5iJ7WeSmzdZqrymszbgDl/gDpnTLsVatC+flWe7GcrzZLBs24KRBOZhxCncEaXAUl7F4w86344oEpmLibaZNhXAk0Bls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781364656; c=relaxed/simple;
	bh=nLBRFuGy/Lcdex1xbm7S1MkwajWmAI98NOmaBeM7tcc=;
	h=In-Reply-To:Cc:Subject:Mime-Version:Message-Id:Content-Type:From:
	 Date:To:References; b=kJKioE2mJiaJ1mLUDOoyQ0q3ogshanEZ98G/V3sfFm0nOQE1CUT/v9qRWrSwnURwOsoVoflb5yn/dQ9O5/aKVNWdfFQCmjLVVAT+38qo36VthJI5kolbGFDwwEIZNkK7VX8IotiG2u18nWqah6MrePH0+K1vunzpqW0qdxp5/kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=mFmEYiJs; arc=none smtp.client-ip=209.127.231.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="mFmEYiJs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1781364640;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=p1M9GIUIb+CnZmw4OzBE/a+RoVFm8jbl6K0gVEhBtCI=;
 b=mFmEYiJsZJxprQE3RXkCi/POZWl38UyhQRYDlrEvn5FZD1kJT3NEzoHyQ9AEGZTxjH0lvS
 tw3DrBJp/pmd1KJkm8wXA7cz+PMKR/CMWPZQjeQuZWCVMvLCtxo8VfvF7+DxAj4L1lAb1b
 WzTnI2vog0B+Pch6Vbc/VTMLbFMiuAy8LuOH1rExc5CJgC5iPmKqqRAzv9OVphSTZx3zbE
 Raz1EhpifQIPqxF1XZocveRh6OCSBVg5bGB0u+m6zVTxn8iFYO2NZvzTb2DZYfBJXh6ifE
 mz+Rd6LgfMRrJl/ZR2olMLdCL+9L0U/BV1JSXbjzVXQI9C6rvjyhAxEut+K1cA==
X-Mailer: Apple Mail (2.3864.600.51.1.1)
In-Reply-To: <178136456783.1954753.8358889895275169463.b4-ty@b4>
Cc: <linux-bcache@vger.kernel.org>, <linux-block@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH Resend] MAINTAINERS: Update Coly Li's email address
Received: from smtpclient.apple ([120.245.64.89]) by smtp.larksuite.com with ESMTPS; Sat, 13 Jun 2026 15:30:38 +0000
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Coly Li <colyli@fygo.io>
Message-Id: <52796FE1-D803-4697-99B1-C75D05DC9154@fygo.io>
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26a2d779f+266c81+vger.kernel.org+colyli@fygo.io>
Content-Transfer-Encoding: quoted-printable
From: "Coly Li" <colyli@fygo.io>
Date: Sat, 13 Jun 2026 23:30:26 +0800
To: "Jens Axboe" <axboe@kernel.dk>
References: <20260613150458.682707-1-colyli@fygo.io> <178136456783.1954753.8358889895275169463.b4-ty@b4>

> 2026=E5=B9=B46=E6=9C=8813=E6=97=A5 23:29=EF=BC=8CJens Axboe <axboe@kernel=
.dk> =E5=86=99=E9=81=93=EF=BC=9A
>=20
>=20
> On Sat, 13 Jun 2026 23:04:58 +0800, colyli@fygo.io wrote:
>> I switch to colyli@fygo.io as my current email address.
>=20
> Applied, thanks!
>=20
> [1/1] MAINTAINERS: Update Coly Li's email address
>      commit: c7c76f9232bd34835d821f14abdc5fafc17bc938

Thanks a lot!

Coly Li
