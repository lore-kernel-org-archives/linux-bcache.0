Received: from sg-1-23.ptr.blmpb.com (sg-1-23.ptr.blmpb.com [118.26.132.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E84314A6C
	for <linux-bcache@vger.kernel.org>; Mon, 26 Jan 2026 07:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769413698; cv=none; b=adNuyTeZlCU0XFBUelpUXelbFO+XwQT1kYJ2FyXzY+dm/MUdCROELHjTX5K+mJ9wpcmmpffoKhhl5D6WO0z2IiKIsNgcBYcYn6QLZdLI8T8yPk9xOJO7xvVyvKvl+0RDTLleoNyHAVC0sMYGbpEnnm9mpYVxUZ2P39lvwIZVL0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769413698; c=relaxed/simple;
	bh=lhqtizufRcF/kknqdLclHVxvEu3NtOMDEucdb1CHC5Y=;
	h=Content-Disposition:References:In-Reply-To:To:From:Message-Id:
	 Subject:Mime-Version:Cc:Date:Content-Type; b=LUtWTbMqsrCU/XsuMHtsZ18F0YUORccoMrVlQHhJduuP6sal4Sqt9i77m9CInwn5qZPzXtacoM9m98+hu27xlJAiyaHzPiuPO81Cu0Jx8ssMs8sI7I7O7jqssNu1aSlqLDk6bTUOx6RTGWEq8tt46COP+q2s6fIytRPg9202KPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=MqpfIcoE; arc=none smtp.client-ip=118.26.132.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="MqpfIcoE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1769413683;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=5ak+8LW8TZ0EA+KF/tdN/t3VOI1N/FGYW+vWx6v4mHQ=;
 b=MqpfIcoEorVqA7JfwVaC3bU8TI6IODEzukinV4ZGPJXvRoN4Tq2KqiuOx5Njieu7uoMHn9
 KUkPJs8zNI3eINhLSZ3iBS/i/aYbPdtBVtVOQ9/6/FeSYPAdYuKkgLYpI7LnqxVaUgT4iS
 f/UyAO5AGgylT5DaLkPLn5C3phg+dUzDAOJduy9E28htOrHV4CuxQajHJRHzThKB2112us
 pLQs3DLUJF9VuXr9a8g/dOJ1q7nDYACQNfpQ5Xp0nWIoQPGby/mjbsVdlOAPLlCyzK96rE
 EaX8TbzqVuwJPGoNWn8JCwc0NTJjAIfybsc+u/fU7A8WyoXm0KMf9cBwRyNn6A==
Content-Disposition: inline
X-Original-From: Coly Li <colyli@fnnas.com>
References: <20260126014209.909491-1-zhangshida2026@163.com>
X-Lms-Return-Path: <lba+269771c31+a9e6c2+vger.kernel.org+colyli@fnnas.com>
In-Reply-To: <20260126014209.909491-1-zhangshida2026@163.com>
To: <zhangshida2026@163.com>
From: "Coly Li" <colyli@fnnas.com>
Message-Id: <aXca3r2-VrdcRBo3@studio.local>
Received: from studio.local ([120.245.64.73]) by smtp.feishu.cn with ESMTPS; Mon, 26 Jan 2026 15:48:00 +0800
Subject: Re: [PATCH] bcache: fix I/O accounting leak in detached_dev_do_request
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Cc: <kent.overstreet@linux.dev>, <hch@infradead.org>, <axboe@kernel.dk>, 
	<linux-bcache@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<zhangshida@kylinos.cn>, <starzhangzsd@gmail.com>
Date: Mon, 26 Jan 2026 15:47:59 +0800
Content-Type: text/plain; charset=UTF-8

On Mon, Jan 26, 2026 at 09:42:09AM +0800, zhangshida2026@163.com wrote:
> From: Shida Zhang <zhangshida@kylinos.cn>
>=20
> When a bcache device is in a detached state, iostat can show 100%
> utilization even after I/O workload completion.
>=20
> This happens because the caller, cached_dev_submit_bio(), calls
> bio_start_io_acct() to begin accounting. However, if the bio hits an
> early exit path in detached_dev_do_request()=E2=80=94either due to an
> unsupported discard request or a bio_alloc_clone() failure=E2=80=94the
> corresponding bio_end_io_acct() is never called. This leaves the
> in-flight counter permanently incremented, causing the kernel to
> report the device as 100% busy.
>=20
> Add the missing bio_end_io_acct() calls to these error/early-exit
> paths to ensure proper I/O accounting.
>=20
> Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>

Can you mention which patch that this one is fixing? It will help a bit
for downstream maintainers for the backport stuffs.

For this patch, you may add,

Acked-by: Coly Li <colyli@fnnas.com>

Thanks for the fixup.

Coly Li

> ---
>  drivers/md/bcache/request.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index a02aecac05c..7d855e66a10 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -1107,6 +1107,7 @@ static void detached_dev_do_request(struct bcache_d=
evice *d,
> =20
>  	if (bio_op(orig_bio) =3D=3D REQ_OP_DISCARD &&
>  	    !bdev_max_discard_sectors(dc->bdev)) {
> +		bio_end_io_acct(orig_bio, start_time);
>  		bio_endio(orig_bio);
>  		return;
>  	}
> @@ -1114,6 +1115,7 @@ static void detached_dev_do_request(struct bcache_d=
evice *d,
>  	clone_bio =3D bio_alloc_clone(dc->bdev, orig_bio, GFP_NOIO,
>  				    &d->bio_detached);
>  	if (!clone_bio) {
> +		bio_end_io_acct(orig_bio, start_time);
>  		orig_bio->bi_status =3D BLK_STS_RESOURCE;
>  		bio_endio(orig_bio);
>  		return;
> --=20
> 2.34.1
>
