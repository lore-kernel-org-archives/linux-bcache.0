Received: from va-2-27.ptr.blmpb.com (va-2-27.ptr.blmpb.com [209.127.231.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957E029B77C
	for <linux-bcache@vger.kernel.org>; Tue,  7 Apr 2026 09:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775554145; cv=none; b=s27iWI7fPAZbQyK2ufEhWZFpfDRiXqp/eTUj17qulJMPIXpqWTsQYogV3cuCqgf7z2XGrIQtxtu8maO/0cirRwYpuoAmfmdUeSwydQw3LIvSkrQFR8E2dK9lYl6QfDPSV/Fe5j7ZJSWbQnT+a7B5xn621g7j9ela4/M72WwuzRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775554145; c=relaxed/simple;
	bh=SWDHEcPRwFfx8bdaOrtnZ65R3vTwrIXjdZgodsWGpuE=;
	h=Cc:Mime-Version:References:In-Reply-To:Date:From:Subject:To:
	 Message-Id:Content-Type; b=M2qAP7dl+oTrNGyX2CsQRxs5CRm/xTPKWLeofqD6i9HLea32s18FmrxeEP7x0LUruKWB4Qg+oWThbwv1vwtg1Nm4vbr4NKgyhO7kQTgsnQrFOzdZiTlyaWuGOXx5EaZZJ0NhHFUYhxKcGgJgZGUllIREBimxX78Bv8Wk1X3AbLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=kFLOcOjI; arc=none smtp.client-ip=209.127.231.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="kFLOcOjI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1775554133;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=SWDHEcPRwFfx8bdaOrtnZ65R3vTwrIXjdZgodsWGpuE=;
 b=kFLOcOjIP/bxWp/QKngM8wNdUy0riwgShMjgD8vobYscHM1WGsYGyb06bYP+cEIIXKeakF
 ErnAVwSe+LF8V7ZeTz1O5HoWU+2HzDr9vqdXwHsCW3J/zMW4s010V924f2/Q0LULWvDrXE
 oBdKC4LuvkBO4CpV1l+EhYn9oO5JUmEM4imFZYXhOkKAxRsqGcrAIE8D3aKQmCjk9FQKJw
 UJwwGqRWNRdP5Fuv0C+8X97wV0cpi2DD+ShGnNfAfsOXHrCeezNT8cl3vvSZZANAN8poqm
 JSMGcxyam58vpVENbr/S8SjTfPEoDwYryxsDZds/47fMK6nj2wz4VtxCU0RWHg==
Cc: <linux-block@vger.kerenl.org>, <linux-bcache@vger.kernel.org>, 
	"Mingzhe Zou" <mingzhe.zou@easystack.cn>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+269d4ce53+85ecc1+vger.kernel.org+colyli@fnnas.com>
Content-Transfer-Encoding: quoted-printable
References: <20260403042135.2221247-1-colyli@fnnas.com> <bf06ffae-23c8-4629-a963-c6c6ffdeb4e1@kernel.dk>
In-Reply-To: <bf06ffae-23c8-4629-a963-c6c6ffdeb4e1@kernel.dk>
Date: Tue, 7 Apr 2026 17:28:38 +0800
Received: from smtpclient.apple ([120.245.64.217]) by smtp.feishu.cn with ESMTPS; Tue, 07 Apr 2026 17:28:49 +0800
From: "Coly Li" <colyli@fnnas.com>
Subject: Re: [PATCH] bcache: fix uninitialized closure object
To: "Jens Axboe" <axboe@kernel.dk>
Message-Id: <17585F9E-8055-444F-A40E-50CD0AA92F72@fnnas.com>
X-Mailer: Apple Mail (2.3864.500.181)
Content-Type: text/plain; charset=UTF-8
X-Original-From: Coly Li <colyli@fnnas.com>

> 2026=E5=B9=B44=E6=9C=883=E6=97=A5 19:11=EF=BC=8CJens Axboe <axboe@kernel.=
dk> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On 4/2/26 10:21 PM, colyli@fnnas.com wrote:
>> From: Mingzhe Zou <mingzhe.zou@easystack.cn>
>>=20
>> In the previous patch ("bcache: fix cached_dev.sb_bio use-after-free and
>> crash"), we adopted a simple modification suggestion from AI to fix the
>> use-after-free.
>>=20
>> But in actual testing, we found an extreme case where the device is
>> stopped before calling bch_write_bdev_super().
>>=20
>> At this point, struct closure sb_write has not been initialized yet.
>> For this patch, we ensure that sb_bio has been completed via
>> sb_write_mutex.
>=20
> Presumably this should have a:
>=20
> Fixes: fec114a98b87 ("bcache: fix cached_dev.sb_bio use-after-free and cr=
ash")
>=20
> but for some reason it does not. I'll add it.

I did it on purpose. Because this patch is in Linux-stable and not in mainl=
ine,
I am not sure whether it is proper to reference the linux-block tree commit=
 id.

This is why the patch title is mentioned in commit log, but commit id skipp=
ed.

Thanks for adding it.

Coly Li
