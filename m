Received: from va-2-39.ptr.blmpb.com (va-2-39.ptr.blmpb.com [209.127.231.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DD93B635F
	for <linux-bcache@vger.kernel.org>; Tue,  7 Apr 2026 13:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775567977; cv=none; b=PiKSwOgI5qCab+jeKWqXdUl5jweXltz7mvOl7WqGlvIcKBONqx+RgnLe+wxdbY8ADhQ4mmro4doWaB2DyVHxkQHBvJIKHEenB+iKkO8khzpmxT/pYnPjraDI3g37ztL+IEK5BveBk+9J2e8zlA4X2i/YRng0vzebjljJ3dTI/q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775567977; c=relaxed/simple;
	bh=X70zt8B77n4NXE2tWT7YlZkbSlIgpqSyBjy3aoURTrk=;
	h=References:From:Subject:Mime-Version:Content-Type:Message-Id:
	 In-Reply-To:To:Cc:Date; b=Ft+hzwkwM08j9kTdaNfiQsfH47pFy8xS2/ZEagleeXzfC+HnyehoqvB261iSLwOwDV/LKJWnl62fNNQ3c+NWCN5GvuaRgyb63gqH8XJXveRY6OUwy6GcRnZQtXMZ8PMFejVfkBle884MOzdoTOq1Z+d0RKSGKl+6EhtWtPfjOOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=fZMIrmRH; arc=none smtp.client-ip=209.127.231.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="fZMIrmRH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1775567968;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=X70zt8B77n4NXE2tWT7YlZkbSlIgpqSyBjy3aoURTrk=;
 b=fZMIrmRH5b7XC1toOTI7jYl1KsyDCd6rHrsk0zeYieFBCt3AgiRcyVe/7Syf/iIlV40qD7
 qJuPa8oE6GGbcYOW2Eq9fEzcdL98xdoJ+x83RK3WIcXO+I9gi/Yy3AmyQzkg2hyJR1fI2P
 eN1fMVN9WXJEUdfOwDfB5GLyNuSza3A/86FPG3uXLeqNjx6aTOY6so5Aj3UDUTyiGBBUZj
 nlUHPV3EDy49d2Nn7MGhw5z9FGwaTKL+rme/hSRu6imtvjKOJ3o83hbYuGE1zRboMQOTWa
 HRovDTDm3IoharlZibj8MZxby2EFylxt2uvfPBX34PEOv7LplYTIb3I2fUztdA==
References: <20260403042135.2221247-1-colyli@fnnas.com> <bf06ffae-23c8-4629-a963-c6c6ffdeb4e1@kernel.dk> <17585F9E-8055-444F-A40E-50CD0AA92F72@fnnas.com> <2ca022fe-d448-4436-9b83-010cc664caa2@kernel.dk>
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+269d5045e+effec5+vger.kernel.org+colyli@fnnas.com>
From: "Coly Li" <colyli@fnnas.com>
Subject: Re: [PATCH] bcache: fix uninitialized closure object
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Mailer: Apple Mail (2.3864.500.181)
X-Original-From: Coly Li <colyli@fnnas.com>
Message-Id: <C1947BCB-F33B-49E3-A091-5F23972C480B@fnnas.com>
Received: from smtpclient.apple ([120.245.64.217]) by smtp.feishu.cn with ESMTPS; Tue, 07 Apr 2026 21:19:25 +0800
In-Reply-To: <2ca022fe-d448-4436-9b83-010cc664caa2@kernel.dk>
To: "Jens Axboe" <axboe@kernel.dk>
Cc: <linux-block@vger.kerenl.org>, <linux-bcache@vger.kernel.org>, 
	"Mingzhe Zou" <mingzhe.zou@easystack.cn>
Date: Tue, 7 Apr 2026 21:19:14 +0800

> 2026=E5=B9=B44=E6=9C=887=E6=97=A5 20:44=EF=BC=8CJens Axboe <axboe@kernel.=
dk> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On 4/7/26 3:28 AM, Coly Li wrote:
>>> 2026?4?3? 19:11?Jens Axboe <axboe@kernel.dk> ???
>>>=20
>>> On 4/2/26 10:21 PM, colyli@fnnas.com wrote:
>>>> From: Mingzhe Zou <mingzhe.zou@easystack.cn>
>>>>=20
>>>> In the previous patch ("bcache: fix cached_dev.sb_bio use-after-free a=
nd
>>>> crash"), we adopted a simple modification suggestion from AI to fix th=
e
>>>> use-after-free.
>>>>=20
>>>> But in actual testing, we found an extreme case where the device is
>>>> stopped before calling bch_write_bdev_super().
>>>>=20
>>>> At this point, struct closure sb_write has not been initialized yet.
>>>> For this patch, we ensure that sb_bio has been completed via
>>>> sb_write_mutex.
>>>=20
>>> Presumably this should have a:
>>>=20
>>> Fixes: fec114a98b87 ("bcache: fix cached_dev.sb_bio use-after-free and =
crash")
>>>=20
>>> but for some reason it does not. I'll add it.
>>=20
>> I did it on purpose. Because this patch is in Linux-stable and not in ma=
inline,
>> I am not sure whether it is proper to reference the linux-block tree com=
mit id.
>>=20
>> This is why the patch title is mentioned in commit log, but commit id sk=
ipped.
>=20
> Why is the patch in stable and not in mainline?! That should generally
> never happen.

Oops, My fingers movement diverged from my brain. I thought linux-block, bu=
t typed linux-stable=E2=80=A6.

I meant, when the patch merged from linux-block to Linus tree, maybe the co=
mmit id changes
for some unexpected reason. So I didn=E2=80=99t reference the Fixes tag wit=
h linux-block tree commit
id.

Coly Li
