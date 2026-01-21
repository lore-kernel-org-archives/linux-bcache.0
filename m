Received: from sg-1-22.ptr.blmpb.com (sg-1-22.ptr.blmpb.com [118.26.132.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC96D145FE0
	for <linux-bcache@vger.kernel.org>; Wed, 21 Jan 2026 01:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768959271; cv=none; b=PliD7jpqAkGLfYDL4XPIwUQWmh1d5GFtaNBlQDn7qxU+8aiK6KhpwItL8OPHPVtzGoO1SKU2yzejChMmoIQ91SVhDMET1IkBy+pTlQW5hDHZCC190Ukc426N4DutT8AcT1wPyFxaOEjyfqZuv4Nk9XDdvKyewDB118h7mNGJI/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768959271; c=relaxed/simple;
	bh=y3PVpSScK++/4e4pPM9GBuMI17CD2/TZmvEozG2qw04=;
	h=References:Content-Disposition:Message-Id:Content-Type:Cc:Subject:
	 Date:In-Reply-To:From:Mime-Version:To; b=P6bq2W/yGLCYC9YcnisggeGOqfMH2jugAFCeNZe3HhRupUDX7fJo80vyWM6l7C6R4REw5aXtNSd4wgyFS5IX/auu9U/WSuNOjG45cAzW7Zuk7Z45GFbHW5AIHeU4tVXiLQTI3rVMmBd+7Pq30eR61wXt9DJiEosd+fQymNHpESc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=jqG1nv9D; arc=none smtp.client-ip=118.26.132.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="jqG1nv9D"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1768959245;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=FrVIxHmquChNWOo5TOWcWc+9laf6sixRbflaW9a2h/Q=;
 b=jqG1nv9D7vDX7wp5KyRhQBc/lLWthI1v3pbTnSNmA2dxOwa7OzKeb6f1ffQ70CrnDjAf+H
 RB7FImnxZrPDpio87NjGx0wm9SxWv2fEnTj4HAaIUjYXrIyVpV2iJ8Bj8TageUrbOBftxG
 3TrNb3cFjRZ/wjXTqUfhSIMl3X22XNK6Vt5ImO9vpfLgejlEz3uAAjOdiciU4/ble/fv20
 o0nkWion80Ynss2SJ2nEkmpT1P2Bo9HDlEscMK3lqM8YeYuQpbw07PnEAjE42wCwb77lUQ
 3VyusqkPCACm4fSgtffLE58KCTTDs60rQVw7tXlIRJ9CH9KXRBXc47I+Hf0A3g==
References: <20260120023535.9109-1-zhangshida@kylinos.cn> <CANubcdXsWsdueYf_aN9FSm+hnE-rpXx_hHhwP9_Z1ni1YGEH9Q@mail.gmail.com> <aW-DHlpo4dzKRB8K@studio.local> <322136ff-95f6-49f6-9126-05845f25b4e8@kernel.dk>
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Message-Id: <aXAoi9wTa7VWUiPj@studio.local>
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+269702d0b+42f500+vger.kernel.org+colyli@fnnas.com>
Cc: "Stephen Zhang" <starzhangzsd@gmail.com>, 
	"Kent Overstreet" <kent.overstreet@linux.dev>, 
	"Sasha Levin" <sashal@kernel.org>, 
	"Christoph Hellwig" <hch@infradead.org>, <linux-bcache@vger.kernel.org>, 
	"Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>, 
	"zhangshida" <zhangshida@kylinos.cn>
Subject: Re: Fwd: [PATCH v2] bcache: use bio cloning for detached device requests
Date: Wed, 21 Jan 2026 09:34:01 +0800
In-Reply-To: <322136ff-95f6-49f6-9126-05845f25b4e8@kernel.dk>
From: "Coly Li" <colyli@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Coly Li <colyli@fnnas.com>
Received: from studio.local ([120.245.64.73]) by smtp.feishu.cn with ESMTPS; Wed, 21 Jan 2026 09:34:02 +0800
To: "Jens Axboe" <axboe@kernel.dk>

On Tue, Jan 20, 2026 at 08:01:52AM +0800, Jens Axboe wrote:
> On 1/20/26 7:46 AM, Coly Li wrote:
> >> @@ -949,6 +950,11 @@ static int bcache_device_init(struct
> >> bcache_device *d, unsigned int block_size,
> >>                         BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
> >>                 goto out_ida_remove;
> >>
> >> +       if (bioset_init(&d->bio_detach, 4,
> > 					^^^^^-> I feel 4 might be a bit small
> > here. bio_detached set is for normal IO when backing device is not
> > attached to a cache device. I would suggest to set the pool size to
> > 128 or 256.
>=20
> Absolutely not, 4 is more than plenty. The pool elements are only ever
> used if allocations fail, to guarantee forward progress. Setting aside
> 128 or 256 for that case is utterly wasteful, you only need a couple. 4
> is a good number, if anything it should be smaller (2).

Hi Jens,

Thanks for the information. Please correct me if I am wrong for the followi=
ng
text,
- If the backing is a normal SSD raid0, the IOPS without attached cache dev=
ice
might be more than thousands. In this case, I assume 128 or 256 might be mo=
re
tolerant.
- I see what =E2=80=984=E2=80=99 means, just not sure/comfortable when memo=
ry pressure is high.
And reserving 128/256 will occupy around 0.5~1MB memory, I feel such extra
memory is acceptable in bcache use case.

Don't get me wrong, I totally trust you. If '4' works well enough for high
memory pressure condition for detached bcache device, it is cool.

Thanks in advance.

Coly Li
