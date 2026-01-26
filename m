Received: from sg-1-11.ptr.blmpb.com (sg-1-11.ptr.blmpb.com [118.26.132.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6539332EA8
	for <linux-bcache@vger.kernel.org>; Mon, 26 Jan 2026 15:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769439670; cv=none; b=ryYARkQ2OVQ7BLNOqb5e2GFa4OqySa9Ol+RjgkAjx474yHd5CoyjOZJG7rbu3wqxMEcnkpwhAjtxHM+LgCC+WzPjTfG4adNJnq06g6IxAsFFq+TAh5qI9aVluSMjn0NkrYrJ22kJ6aZBl6xKUWcYRS23Mz2h2JsCbRViv9NuPhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769439670; c=relaxed/simple;
	bh=0sqXalhk30u8tLLlSdNhmsJJqL9qLf60nr9d85075Wg=;
	h=Message-Id:Content-Disposition:To:Cc:From:Subject:In-Reply-To:
	 Content-Type:Mime-Version:References:Date; b=Y0e6Bl8C+D2cQ/2BUsvLv/avOEjxBmCTz0axzJS0So0uo/bBg6sdXBkn7pIt+fKSEg4UvRsERIUWd1A606UMdrvhmsJjarmZlJkmihdIgJMctony47XJHVNteBIe8PV/WxxQvUn7WqUzaPoSVk1m7ZIUZJkF+O1DvfkjsQpX2AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=AMHJUG4l; arc=none smtp.client-ip=118.26.132.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="AMHJUG4l"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1769439661;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=9FBAuPS8DrD2kMqb/NiPBLX6Dxb8ezCORnugE57za/w=;
 b=AMHJUG4lwyivToUgYmta2lnO06Pj/VcwiSMV1Y3kzZKgbRvBxUupWynydzYoSoKRampXJS
 3dvj6o/h2eueWf9OFC6ov+4U9vd8lnRopHQ1xOECsFWQY/YcAMPcYepxuogy/AYSniaFFX
 H1EFkW40XyKAP5Xk5jdxlxjyeRS9ckxViIBFJL5u7d5K1gJ+PyEHgNxOebvBo+nlZIyA6c
 vBKKsiL8yPbBBboey9j5q0Yy24Wb7uR3IdRSGLJztbDyJJ0or2oIOTN4lApsqe/k4ChRJe
 c2WSlpUgHRaVKPBKnzymDtPgohn94VlMBXK0D2wsg2Jr6vJqkrbmJbSWnYCiHw==
Message-Id: <aXd_QlcF1h9qeULs@studio.local>
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Received: from studio.local ([120.245.64.73]) by smtp.feishu.cn with ESMTPS; Mon, 26 Jan 2026 23:00:58 +0800
To: "Christoph Hellwig" <hch@infradead.org>
Cc: <zhangshida2026@163.com>, <kent.overstreet@linux.dev>, <axboe@kernel.dk>, 
	<osandov@fb.com>, <bvanassche@acm.org>, <linux-bcache@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <zhangshida@kylinos.cn>, 
	<starzhangzsd@gmail.com>
From: "Coly Li" <colyli@fnnas.com>
Subject: Re: [PATCH v2] bcache: fix I/O accounting leak in detached_dev_do_request
In-Reply-To: <aXdjqueZ8d8Se61A@infradead.org>
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260126092854.971870-1-zhangshida2026@163.com> <aXdjqueZ8d8Se61A@infradead.org>
X-Lms-Return-Path: <lba+2697781ab+8f1b29+vger.kernel.org+colyli@fnnas.com>
Date: Mon, 26 Jan 2026 23:00:56 +0800
X-Original-From: Coly Li <colyli@fnnas.com>

On Mon, Jan 26, 2026 at 04:52:58AM +0800, Christoph Hellwig wrote:
> On Mon, Jan 26, 2026 at 05:28:54PM +0800, zhangshida2026@163.com wrote:
> > From: Shida Zhang <zhangshida@kylinos.cn>
> >=20
> > When a bcache device is in a detached state, iostat can show 100%
> > utilization even after I/O workload completion.
> >=20
> > This happens because the caller, cached_dev_make_request(), calls
> > bio_start_io_acct() to begin accounting. However, if the bio hits an
> > early exit path in detached_dev_do_request()=E2=80=94either due to an
> > unsupported discard request or a bio_alloc_clone() failure=E2=80=94the
> > corresponding bio_end_io_acct() is never called. This leaves the
> > in-flight counter permanently incremented, causing the kernel to
> > report the device as 100% busy.
> >=20
> > Add the missing bio_end_io_acct() calls to these error/early-exit
> > paths to ensure proper I/O accounting.
> >=20
> > Fixes: d62e26b3ffd28 ("block: pass in queue to inflight accounting")
>=20
> I don't think that is correct.  This was just a trivial calling
> convention change.
>=20

Hi Shida,

This Fixes tag is misleading. The correct to-be-fixed patch is commit
3ef825dfd4e4 ("bcache: use bio cloning for detached device requests")
in linux-block/block-6.19 branch.

Since this patch is not upstreamed yet, the sha-1 commit id might be
changed, so reference the patch name might be fine IMHO.


> From doing a quick git-blame chain this looks like the culprit:
>=20
> bc082a55d25c837341709accaf11311c3a9af727
> Author: Tang Junhui <tang.junhui@zte.com.cn>
> Date:   Sun Mar 18 17:36:19 2018 -0700
>=20
>     bcache: fix inaccurate io state for detached bcache devices
>=20
>=20
> > +		bio_end_io_acct(orig_bio, start_time);
> >  		bio_endio(orig_bio);
> >  		return;
> >  	}
> > @@ -1114,6 +1115,7 @@ static void detached_dev_do_request(struct bcache=
_device *d,
> >  	clone_bio =3D bio_alloc_clone(dc->bdev, orig_bio, GFP_NOIO,
> >  				    &d->bio_detached);
> >  	if (!clone_bio) {
> > +		bio_end_io_acct(orig_bio, start_time);
> >  		orig_bio->bi_status =3D BLK_STS_RESOURCE;
> >  		bio_endio(orig_bio);
> >  		return;
>=20
> This is begging to use a goto label to share code, if it weren't for the
> fact that bio_alloc_clone with GFP_NOIO will never return NULL because
> both because the bio itself and the crypt or integrity information are
> backed by mempool.
>=20
> So this second copy of the code is actually dead and should be removed
> in a prep patch before this one.  Sorry for not catching this earlier.

Hi Christoph,

Do you mean after using a goto lebal to share code, the second part will
be dead code? Just make sure I don't misunderstand your text.

Thanks.

Coly Li
