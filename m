Received: from sg-1-12.ptr.blmpb.com (sg-1-12.ptr.blmpb.com [118.26.132.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A507344020
	for <linux-bcache@vger.kernel.org>; Thu, 22 Jan 2026 03:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769053195; cv=none; b=sQabmQKK114XaD3KK2pirSni96J9rLIO47/769ve29EQn092z0C/UOtHYC2MJgoYannlZjKDGJB92Hz7rTjL5xljl1GUh6WHqnlyKh3KDKUeUhzicI0874F+rdKi06VBMTj/ZBoi+blOd8b3OMGs6K81yO7f/S9LNB9lvZu1zB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769053195; c=relaxed/simple;
	bh=0M3NbFxDlLaEnbxOLuewPZcqhu5hY957FmOdxAF8WrI=;
	h=From:Date:Content-Type:In-Reply-To:To:Cc:Subject:Mime-Version:
	 Message-Id:References; b=bwv31Tr/aImvb+fZFsbXeCZMVak2WYpqcSepF9gO/wYeYXb7m1q7frQ3MINi2veihLO/XbzX6hKA9fBSZVkSTBTeedn4+5m+CQSSm9oyfaY9ihnOAXaBAXRhJeqE/JbY1HPARVMvtFRd0s75uZ8qQ+ULPVJ0mFl61XHUAgnjCus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=DLUCm26S; arc=none smtp.client-ip=118.26.132.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="DLUCm26S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1769053179;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=obpTP7ZNlYj+s/oH44OZfVFTYLFki17fBsQGDJoMdrI=;
 b=DLUCm26S1mPLRnp0nRFegu4TRf45UzpadT5UqjyVz2pnsZSAE5SHfDjAVLOSitFq3D7pl6
 3ILHntBoIuyQLfct3RXod3SkuV9YSJVssa9uFRS6BELX4/dcuXOaAjOaFgJ6OIMdr6c3KF
 AxvkSP/l6WSDs5BiY6nBVJKf1ZvJ8scrKHUlzVrYpahLYZKYs2a+2IIfYleyJhnmv8B2PE
 fmK+LLYEfDT1oQoEWPn9kH/5VHwSOMh9a9kyE7SIeZ1plB0gyAdYyT8DbsFsWUqgRn0TV+
 lkZSb302yPO4Bd3+uUCvQ+S/99uhPhUviZdHtUjw4Pwn3ebb4a4qwSxo6riO3Q==
X-Mailer: Apple Mail (2.3864.300.41.1.7)
From: "Coly Li" <colyli@fnnas.com>
Date: Thu, 22 Jan 2026 11:39:25 +0800
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Original-From: Coly Li <colyli@fnnas.com>
In-Reply-To: <9a928d95-f027-4f0d-b34b-ca028ad36046@kernel.dk>
To: "Jens Axboe" <axboe@kernel.dk>
Cc: "Stephen Zhang" <starzhangzsd@gmail.com>, 
	"Kent Overstreet" <kent.overstreet@linux.dev>, 
	"Sasha Levin" <sashal@kernel.org>, 
	"Christoph Hellwig" <hch@infradead.org>, <linux-bcache@vger.kernel.org>, 
	"Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>, 
	"zhangshida" <zhangshida@kylinos.cn>
Subject: Re: [PATCH v2] bcache: use bio cloning for detached device requests
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+269719bf9+0abd45+vger.kernel.org+colyli@fnnas.com>
Message-Id: <EA9A1644-0B59-4945-87D6-E67C65C4E4A3@fnnas.com>
References: <20260120023535.9109-1-zhangshida@kylinos.cn> <CANubcdXsWsdueYf_aN9FSm+hnE-rpXx_hHhwP9_Z1ni1YGEH9Q@mail.gmail.com> <aW-DHlpo4dzKRB8K@studio.local> <322136ff-95f6-49f6-9126-05845f25b4e8@kernel.dk> <aXAoi9wTa7VWUiPj@studio.local> <CANubcdUT+PoGs3j=0ZN5jsntU-hNGHRFQoucKJZvYGXxFC75ng@mail.gmail.com> <9a928d95-f027-4f0d-b34b-ca028ad36046@kernel.dk>
Received: from smtpclient.apple ([120.245.64.73]) by smtp.feishu.cn with ESMTPS; Thu, 22 Jan 2026 11:39:36 +0800

> 2026=E5=B9=B41=E6=9C=8821=E6=97=A5 22:50=EF=BC=8CJens Axboe <axboe@kernel=
.dk> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On 1/21/26 4:55 AM, Stephen Zhang wrote:
>> Coly Li <colyli@fnnas.com> =E4=BA=8E2026=E5=B9=B41=E6=9C=8821=E6=97=A5=
=E5=91=A8=E4=B8=89 09:34=E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>> On Tue, Jan 20, 2026 at 08:01:52AM +0800, Jens Axboe wrote:
>>>> On 1/20/26 7:46 AM, Coly Li wrote:
>>>>>> @@ -949,6 +950,11 @@ static int bcache_device_init(struct
>>>>>> bcache_device *d, unsigned int block_size,
>>>>>>                        BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
>>>>>>                goto out_ida_remove;
>>>>>>=20
>>>>>> +       if (bioset_init(&d->bio_detach, 4,
>>>>>                                    ^^^^^-> I feel 4 might be a bit sm=
all
>>>>> here. bio_detached set is for normal IO when backing device is not
>>>>> attached to a cache device. I would suggest to set the pool size to
>>>>> 128 or 256.
>>>>=20
>>>> Absolutely not, 4 is more than plenty. The pool elements are only ever
>>>> used if allocations fail, to guarantee forward progress. Setting aside
>>>> 128 or 256 for that case is utterly wasteful, you only need a couple. =
4
>>>> is a good number, if anything it should be smaller (2).
>>>=20
>>> Hi Jens,
>>>=20
>>> Thanks for the information. Please correct me if I am wrong for the fol=
lowing
>>> text,
>>> - If the backing is a normal SSD raid0, the IOPS without attached cache=
 device
>>> might be more than thousands. In this case, I assume 128 or 256 might b=
e more
>>> tolerant.
>>> - I see what =E2=80=984=E2=80=99 means, just not sure/comfortable when =
memory pressure is high.
>>> And reserving 128/256 will occupy around 0.5~1MB memory, I feel such ex=
tra
>>> memory is acceptable in bcache use case.
>>>=20
>>> Don't get me wrong, I totally trust you. If '4' works well enough for h=
igh
>>> memory pressure condition for detached bcache device, it is cool.
>>>=20
>>> Thanks in advance.
>>>=20
>>> Coly Li
>>=20
>> Hi Jens, Coly,
>>=20
>> Regarding the discussion on the bio_detached pool size: while 4 is
>> sufficient to guarantee forward progress, some high-load environments
>> may prefer a larger reserve to minimize allocation latency under
>> extreme memory pressure.
>>=20
>> To provide a middle ground, I propose adding a generic bioset_resize()
>> interface to the block layer and exposing it through a new bcache
>> sysfs attribute 'detached_pool_size'.
>>=20
>> This allows us to keep the default value conservative (e.g., 4) to
>> avoid unnecessary memory overhead, while giving users the flexibility
>> to tune the emergency reserves based on their specific hardware and
>> workload requirements.
>>=20
>> The patch is attached below. Does this look like a reasonable
>> compromise?
>=20
> Guys, just stop. 4 is fine. Take a look at the default biosets and
> what reserve amount they use. I'd recommend you do some testing and
> check how often the reserves are _actually_ used, and once you do
> that, then you'll see why this isn't necessary at all.
>=20
> I thought the idea was to make some progress on getting this fixed.
> Let's please do that and get it queued.

Yes, let=E2=80=99s get the fix in firstly.

Thanks.


Coly Li
