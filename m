Received: from lf-2-58.ptr.blmpb.com (lf-2-58.ptr.blmpb.com [101.36.218.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB92374736
	for <linux-bcache@vger.kernel.org>; Wed, 27 May 2026 15:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.36.218.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779895735; cv=none; b=SvaPRbNzRg0XsRiScazpheH8S91F1wpNiDvOWSg3cuCA048RIlVLLU6DkUasy8NYVy7ebYO3ALQdPSe8A7noyqxFokKoGO3uNgzQmp+2iSm2uKbCjh+pgQXa1eWbyvvkH4KelRrqoI7B2faSUScLj1TCm1HuQW9zIADxglY3vWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779895735; c=relaxed/simple;
	bh=G38R7IirhyaAN2g/HQiJaLL/+ZpEMHBqiWHvFkN4EyY=;
	h=To:Cc:Subject:Date:In-Reply-To:From:Message-Id:Content-Type:
	 Mime-Version:References; b=ZNwRFVpz2yYG4jaaL1Kg2xzTZ7HaTFYREt+IUnUOchbUoDM+s74DAlRnIxZe6aTDwgWWcOWMxw0AIcb3j+tImzbWBgNmgvppL9XGAA3emIWHSSP6Jy1qg1N33KpVBAJRmtwuf305ow+1Kgm122Ail/8jTzBQfWB9gh8K7VZZbvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=VKr0VRES; arc=none smtp.client-ip=101.36.218.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="VKr0VRES"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1779895678;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=JYPdKoAzL3ZEjRd7aoQiEFoSCUFy3dt8gQj7BFxvOT8=;
 b=VKr0VRESugzgNUtHfyZm9em2RFvCZb/VtxVGWNZ4FTBHhhWpRA5fH6EebpGhhXd1cyaK6X
 d2oyu3p7cDGQz+LU+hj7K+OsMASAFUo4ODuv8wxhoXJmMkr7Xvw3w3fr3zZk2Kkv/J9tDe
 VeytvDCa8lsS2ltaV8B7gVJlpImYZM8LMOldD+0apwhJkqcRkTTXXz/ncAZzuxpIj1Irid
 RaR0JSk5UK2wjcm1x7G5XREWlS+bx4MQ9aRBJtR8ZSDs71brSA64VAtwxPqrAAi0OT43fz
 eFGoOOpWL0mM6YGhiFelJZFfe2yKf1d4vT9GP7teS5R0BeK5UmEEtOoe5UQvZA==
To: "Ankit Kapoor" <ankitkap@google.com>
Cc: <kent.overstreet@linux.dev>, <linux-bcache@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] bcache: fix stale data race between read cache miss and bypass write
Date: Wed, 27 May 2026 23:27:45 +0800
In-Reply-To: <20260527134109.2659134-1-ankitkap@google.com>
From: "Coly Li" <colyli@fygo.io>
X-Mailer: Apple Mail (2.3864.600.51.1.1)
Content-Transfer-Encoding: quoted-printable
Received: from smtpclient.apple ([120.245.64.106]) by smtp.larksuite.com with ESMTPS; Wed, 27 May 2026 15:27:57 +0000
Message-Id: <276F8058-A9F0-4EFE-B2DF-4A5D9575EBD9@fygo.io>
X-Original-From: Coly Li <colyli@fygo.io>
X-Lms-Return-Path: <lba+26a170d7e+bbbc10+vger.kernel.org+colyli@fygo.io>
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <ahRNUlU60mx9ESd1@studio.local> <20260527134109.2659134-1-ankitkap@google.com>

> 2026=E5=B9=B45=E6=9C=8827=E6=97=A5 21:41=EF=BC=8CAnkit Kapoor <ankitkap@g=
oogle.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi Coly,
>=20
> Thank you for the feedback, for confirming the issue, and for the guidanc=
e.
>=20
>> Hi Ankit,
>>=20
>> Yes, I confirm this is an issue that must be solved. Nice catch!
>>=20
>> On Thu, May 21, 2026 at 04:39:25PM +0800, Ankit Kapoor wrote:
>>> A race condition exists between a read cache miss and a bypass write
>>> due to either congestion or sequential bypass, that causes stale data
>>> to be cached when the read cache miss runs concurrently with a bypass
>>> write targeting the same sectors.
>>=20
>> This patch fixes the stale data issue in run time, but if power failure
>> happens inside the race window, after boot up again, the stale data
>> still exists in cache for following read hits.
>>=20
>> And your fix invalidate the key after on-disk bio completed, which makes
>> such stale data window by power failure longer.
>=20
> While I initially hoped that serializing the operations would suffice, I
> completely agree with your point regarding the power-failure risk
> which shall be addressed.
>=20
>> To solve all the stale data race both for run time and power failure
>> condition, could you please consider the following proposal.
>>=20
>> Maintain a data structure to hold all invalidate range from by-pass
>> write, record/insert the invalidation range before bch_data_insert(),
>> and after cached_dev_write_complete(), clear/remove the invalidation
>> range.
>>=20
>> For a cache-miss read, if there is any invalidation range refcount
>> exists, check all non-zero refcount ranges, if any range overlaps with
>> the cache-miss read range, do NOT update the missing bkey back to btree
>> and only read data from backing device.
>=20
> I am now working on a new implementation to track the in-flight=20
> sectors currently being written, exactly as you suggested here.
>=20
>> Here you need to design a efficient data structure both for performance
>> and memory consumption. I would sugguest to maintain chunk refcounts
>> which mapping multiple 32MB ranges on cache device (current max key size
>> if I remember correctly) range. You may look at how md raid maintains
>> the legacy bitmap refcount, hope that code can give you any hint.
>=20
> Thanks, I will look into the md raid legacy bitmap reference implementati=
on for
> hints. In the meantime, could you please recommend any specific fio
> configurations or workloads you prefer for evaluating the memory
> overhead and performance impact of this change?

Maybe you can use a large and fast SSD as backing device, and do full rando=
m I/O with write around mode.
Then try to setup the race windows, that the in-memory refcount may occupy =
a more memory.

I don=E2=80=99t suggest to use a tree-like structures. Just use a refcount =
to cover 32MB range on backing device, it can be faster.
If a cache-miss read overlay a refcount covered range, change it to read-wi=
thout-refill-cache.  To avoid the refcounts
Occupy too much memory, if a page=E2=80=99s refcounts are all zero, you may=
 think of releasing this page. This is what I mentioned
how md bitmap manages the pages of bits. Maybe the idea may help a little b=
it.


>=20
> I will send a v2 patch series as soon as the tracking mechanism is ready
> and thoroughly tested.

Thank you, for catch this issue and work on the fix.

Coly Li
