Received: from va-2-38.ptr.blmpb.com (va-2-38.ptr.blmpb.com [209.127.231.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57413B388D
	for <linux-bcache@vger.kernel.org>; Tue,  7 Apr 2026 14:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775571018; cv=none; b=GOUxc9RMBGLKpsiH9UALOhTeSvptQXUEaO8zsjRSDhOLFUrsfNczZHIM6BZRnDA5uRH3rzPAuLhorVf/8iHlxPHb4Mtn7nOzDARRwEaVM0CeoTYwfa0mBnKs9XO4EfgSMrTblkCKfu/Bm9Ni6dxja592dY/BPmir/oeRo0Coki8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775571018; c=relaxed/simple;
	bh=nGgMQ7xjhL1x3rxjRnAorlcS1xxtT809BhbRbwnq0fM=;
	h=Mime-Version:Content-Type:To:Subject:References:From:Date:
	 Message-Id:In-Reply-To:Cc; b=WMiseZ4NyYhka+8ASZTCrXC8O9hzJcg1xrTcAuLHajn0W9xwAw7sNsgfhawNNJXWWnYO0HLjK3HvMizBA2fKj6cNRfviXxZ5hMCmyz3gTRvmg6mZoRfLNOlFcKPvNDpOiuvBkKPuFUJDGTjyyzl8DmdJb6XD3Wjeuivhcv4xGbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=N8g8AkjF; arc=none smtp.client-ip=209.127.231.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="N8g8AkjF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1775571010;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=nGgMQ7xjhL1x3rxjRnAorlcS1xxtT809BhbRbwnq0fM=;
 b=N8g8AkjF2dcMa0a5bCrZZ0cdiNvQWzNKlu38orT+aO8nk+0KepWSZh6+ztEWnRmeH51ZO1
 XcOWQ0TjjG5EoofqOmSl+CW8jILpuWHoxvvBROQ+6s4r1vO53sIGKVKrawCkcIx5nil64O
 JEZ8ClOEprtIONhUAmhommigfCpsRA80P60vy/Meyo6WBm9bfcBI6O7JaCSTTZmQ3wISaA
 9Yngld6adA2Y2Ugq4zCI7FRSiUlZiVIMhNeb7GT9SF1WMpUMfhqyEzw1HL0qQR25EfsvZ1
 K9YSd2O42KPeWz44biq9TwoYV4mrO1K3J25vPzxUEc71l3yK8pLDvy1k6nHCnA==
X-Mailer: Apple Mail (2.3864.500.181)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: "Jens Axboe" <axboe@kernel.dk>
Subject: Re: [PATCH] bcache: fix uninitialized closure object
References: <20260403042135.2221247-1-colyli@fnnas.com> <bf06ffae-23c8-4629-a963-c6c6ffdeb4e1@kernel.dk> <17585F9E-8055-444F-A40E-50CD0AA92F72@fnnas.com> <2ca022fe-d448-4436-9b83-010cc664caa2@kernel.dk> <C1947BCB-F33B-49E3-A091-5F23972C480B@fnnas.com> <9e030c6f-f894-4794-81ca-e3c1a3ce5787@kernel.dk>
Received: from smtpclient.apple ([120.245.64.217]) by smtp.feishu.cn with ESMTPS; Tue, 07 Apr 2026 22:10:08 +0800
From: "Coly Li" <colyli@fnnas.com>
Date: Tue, 7 Apr 2026 22:09:56 +0800
Message-Id: <F899796B-67C2-4131-AF4E-1A7AC8C7DA4B@fnnas.com>
In-Reply-To: <9e030c6f-f894-4794-81ca-e3c1a3ce5787@kernel.dk>
Cc: <linux-block@vger.kerenl.org>, <linux-bcache@vger.kernel.org>, 
	"Mingzhe Zou" <mingzhe.zou@easystack.cn>
X-Original-From: Coly Li <colyli@fnnas.com>
X-Lms-Return-Path: <lba+269d51041+007996+vger.kernel.org+colyli@fnnas.com>

> 2026=E5=B9=B44=E6=9C=887=E6=97=A5 21:24=EF=BC=8CJens Axboe <axboe@kernel.=
dk> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On 4/7/26 7:19 AM, Coly Li wrote:
>>> 2026?4?7? 20:44?Jens Axboe <axboe@kernel.dk> ???
>>>=20
>>> On 4/7/26 3:28 AM, Coly Li wrote:
>>>>> 2026?4?3? 19:11?Jens Axboe <axboe@kernel.dk> ???
>>>>>=20
>>>>> On 4/2/26 10:21 PM, colyli@fnnas.com wrote:
>>>>>> From: Mingzhe Zou <mingzhe.zou@easystack.cn>
>>>>>>=20
>>>>>> In the previous patch ("bcache: fix cached_dev.sb_bio use-after-free=
 and
>>>>>> crash"), we adopted a simple modification suggestion from AI to fix =
the
>>>>>> use-after-free.
>>>>>>=20
>>>>>> But in actual testing, we found an extreme case where the device is
>>>>>> stopped before calling bch_write_bdev_super().
>>>>>>=20
>>>>>> At this point, struct closure sb_write has not been initialized yet.
>>>>>> For this patch, we ensure that sb_bio has been completed via
>>>>>> sb_write_mutex.
>>>>>=20
>>>>> Presumably this should have a:
>>>>>=20
>>>>> Fixes: fec114a98b87 ("bcache: fix cached_dev.sb_bio use-after-free an=
d crash")
>>>>>=20
>>>>> but for some reason it does not. I'll add it.
>>>>=20
>>>> I did it on purpose. Because this patch is in Linux-stable and not in =
mainline,
>>>> I am not sure whether it is proper to reference the linux-block tree c=
ommit id.
>>>>=20
>>>> This is why the patch title is mentioned in commit log, but commit id =
skipped.
>>>=20
>>> Why is the patch in stable and not in mainline?! That should generally
>>> never happen.
>>=20
>> Oops, My fingers movement diverged from my brain. I thought
>> linux-block, but typed linux-stable?.
>>=20
>> I meant, when the patch merged from linux-block to Linus tree, maybe
>> the commit id changes for some unexpected reason. So I didn?t
>> reference the Fixes tag with linux-block tree commit id.
>=20
> It'll never change going into Linus's tree, that's how git works. If I
> have a rare rebase for whatever reason, I fixup the Fixes shas. So
> always put them in there, there's never a reason NOT to do so.

This is a clear hint. Thanks.

Coly Li
