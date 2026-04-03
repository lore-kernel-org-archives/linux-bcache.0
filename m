Received: from va-2-27.ptr.blmpb.com (va-2-27.ptr.blmpb.com [209.127.231.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D267E45BE3
	for <linux-bcache@vger.kernel.org>; Fri,  3 Apr 2026 04:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775189061; cv=none; b=ZgdjhreOMgM2et5kxu9oQqEV1UOIiseyTJgbuNgVBuBvtW5nDwZ5kcjUeVnb27N3l4exO+fXkP3E0IG1Lea5+jXH0tWz/8awkOB97u9Lawa2Rx9ixfFZIQg55xryA/iO7sUdGnlKXFpG3+wVuVpOS91c+KuiksnGCWtAxsMljkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775189061; c=relaxed/simple;
	bh=kCgKy66qwdnOZH6DAWmNKqYyzfjPyV1ZIX5lmnSsQ4M=;
	h=Cc:References:Subject:Message-Id:To:From:Mime-Version:
	 Content-Disposition:In-Reply-To:Content-Type:Date; b=bIHCPFGe6gnQl7tr865r4ekx/VfpLu4723Dy+uc6uE6zwHVJj2+QLCYkk8XQNGq4QndC2ymUlt18KloTSkX7PMA8+jQDEiOgfXxK3PJ0I+3jqdE3mfNYxlAyMYYugARYOOfHjChRKQ/oBLHfyo2NGG4bl/QsR2XJp+y/jlukrCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=XVMX0gO0; arc=none smtp.client-ip=209.127.231.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="XVMX0gO0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1775189048;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=9+1kut5xWQiAeDVdE765s+t2Er2z6uJsCdeNY8js7io=;
 b=XVMX0gO06Hn1hHrrky0MLJYFmAtGvbbWOfyuDpVqVii3mTbvJ6Xo7gWcHzLPh4AXpHSrDz
 5LCaV8wbl467DBxRJv2ZxNnktCi+0NR//425eeB37eYrA3cFOcG3onsUnYKIj5cqM7ROBZ
 fUKY/YNm+5GRivrQdpQ2YVZd+oocAQ8ekAnBOgfgd2Hh02qGX0+sBNO8JmLHMU6Mvciky4
 wq7M25ZpvD2mhKA85RPmRE6s7dJy0b7oynyMtDoBbNQgeRtWWwYTujYMysIQRa3bgvafDE
 ABVseyUJl3J3+hIoCOY+Fu5EjJTFLv0+b0AqGR+3JIcOCAL2N8r4y8zEtYNpTA==
Cc: <colyli@kernel.org>, <linux-bcache@vger.kernel.org>, <zoumingzhe@qq.com>, 
	<zoumingzhe@outlook.com>
References: <20260402130353.1099802-1-mingzhe.zou@easystack.cn>
Subject: Re: [PATCH] bcache: fix uninitialized closure object
Message-Id: <ac87Xq4zNhOJ64Cx@loaclhost>
To: <mingzhe.zou@easystack.cn>
From: "Coly Li" <colyli@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+269cf3c36+fd3b74+vger.kernel.org+colyli@fnnas.com>
Content-Disposition: inline
In-Reply-To: <20260402130353.1099802-1-mingzhe.zou@easystack.cn>
Received: from loaclhost ([120.245.64.217]) by smtp.feishu.cn with ESMTPS; Fri, 03 Apr 2026 12:04:05 +0800
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Date: Fri, 3 Apr 2026 12:04:04 +0800
X-Original-From: Coly Li <colyli@fnnas.com>

On Thu, Apr 02, 2026 at 09:03:53PM +0800, mingzhe.zou@easystack.cn wrote:
> From: Mingzhe Zou <zoumingzhe@qq.com>
> 
> In the previous patch(bcache: fix cached_dev.sb_bio use-after-free and crash),
> we adopted a simple modification suggestion from AI to fix the use-after-free.
> 
> But in actual testing, we found an extreme case where the device is stopped
> before calling bch_write_bdev_super().
> 
> At this point, struct closure sb_write has not been initialized yet.
> 
> For this patch, we ensure that sb_bio has been completed via sb_write_mutex.
> 
> Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>

It looks good to me. I will refine the commit log and submit.

Thanks.

Coly Li

> ---
>  drivers/md/bcache/super.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 6627a381f65a..97d9adb0bf96 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1378,7 +1378,8 @@ static CLOSURE_CALLBACK(cached_dev_free)
>  	 * The sb_bio is embedded in struct cached_dev, so we must
>  	 * ensure no I/O is in progress.
>  	 */
> -	closure_sync(&dc->sb_write);
> +	down(&dc->sb_write_mutex);
> +	up(&dc->sb_write_mutex);
>  
>  	if (dc->sb_disk)
>  		folio_put(virt_to_folio(dc->sb_disk));
> -- 
> 2.34.1
