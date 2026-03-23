Received: from lf-2-18.ptr.blmpb.com (lf-2-18.ptr.blmpb.com [101.36.218.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D5D324B16
	for <linux-bcache@vger.kernel.org>; Mon, 23 Mar 2026 14:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.36.218.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774276019; cv=none; b=LGEWpK+iG0whMU2rhQTFvJvlVxSvA/Cm3FDFFd4aNd/7RWTvPw2ZZDtnkWOoPl7UJbzRrzjXCoI7Tvw6diU71b0iOvurnU3Y9TzQ6n1loy+Ly6DEAhOq/GzeHmyJk2JC+/+jM2g7MO9Hw3/JlhjhzQqfmgTyTdHRCfU/5Jh7F9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774276019; c=relaxed/simple;
	bh=c2vBy4lVcIfRlJnY/JLjk9aJBWjXGcLAVGwESMzBICM=;
	h=From:Message-Id:Content-Disposition:Cc:Subject:Date:Content-Type:
	 To:Mime-Version:References:In-Reply-To; b=qaLFWt8MtozLiEreT0YMHrN5CLJrUjhbsyxgWP6bl4g1xrKlR1DhTdot9QCvdjbtL3yfDZqYiv6gDoqRYyqWKlWoA7wDh3tsIwzmUFUwJrmvMwIuFExCpRMOM/UJYDsyXYKxOke0P9880Xauc8+tRT+PaogBFv7P0fxpacAIuEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=y9qD5rVt; arc=none smtp.client-ip=101.36.218.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="y9qD5rVt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1774275927;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=ZKs9qm+7p33EuhHLsbiu9PxoeHH8QSzqD34DnCxRPJc=;
 b=y9qD5rVtLKN3zbzdugm9gwVdSbt7Uhes3B+iI0K8SZAESBf8BiniGA8rJL3GqHyqYjsRkD
 ouw/CzKQZARh+KB+e0QrshmPcsK7Gt6Nn39q0eVeu8zX9Q7sSAvVKfw7z5qJJaPRaWl1qD
 umbVYSNy7fHAupj/DTGBX7K7695Bh1SHUL8PWGzrT5h+Iwtgnq+7Z9d/5EvVJUnvFD6p47
 u8vSW+hfnH7gwSdtWMuMxsia6HbkgTpDUCnY54gRH+Mmy3e034T3sc0y/RzZcp3On64Sk0
 SmY8OxQUITxavfVm1A7MyupL0OZpYKnBfps8J9/Zc7vMiklKdGMXOTyOfrPICA==
From: "Coly Li" <colyli@fnnas.com>
Message-Id: <acFJRTyUVeeBi2cD@studio.local>
Content-Disposition: inline
Cc: <colyli@kernel.org>, <linux-bcache@vger.kernel.org>, <zoumingzhe@qq.com>, 
	<zoumingzhe@outlook.com>
Subject: Re: [PATCH v2] bcache: fix cached_dev.sb_bio use-after-free and crash
Date: Mon, 23 Mar 2026 22:25:23 +0800
Content-Type: text/plain; charset=UTF-8
To: <mingzhe.zou@easystack.cn>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260323130119.222252-1-mingzhe.zou@easystack.cn>
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+269c14d55+48a6e6+vger.kernel.org+colyli@fnnas.com>
X-Original-From: Coly Li <colyli@fnnas.com>
In-Reply-To: <20260323130119.222252-1-mingzhe.zou@easystack.cn>
Received: from studio.local ([120.245.64.207]) by smtp.feishu.cn with ESMTPS; Mon, 23 Mar 2026 22:25:24 +0800

On Mon, Mar 23, 2026 at 09:01:19PM +0800, mingzhe.zou@easystack.cn wrote:
> From: Mingzhe Zou <mingzhe.zou@easystack.cn>
> 
> In our production environment, we have received multiple crash reports
> regarding libceph, which have caught our attention:
> 
> ```
> [6888366.280350] Call Trace:
> [6888366.280452]  blk_update_request+0x14e/0x370
> [6888366.280561]  blk_mq_end_request+0x1a/0x130
> [6888366.280671]  rbd_img_handle_request+0x1a0/0x1b0 [rbd]
> [6888366.280792]  rbd_obj_handle_request+0x32/0x40 [rbd]
> [6888366.280903]  __complete_request+0x22/0x70 [libceph]
> [6888366.281032]  osd_dispatch+0x15e/0xb40 [libceph]
> [6888366.281164]  ? inet_recvmsg+0x5b/0xd0
> [6888366.281272]  ? ceph_tcp_recvmsg+0x6f/0xa0 [libceph]
> [6888366.281405]  ceph_con_process_message+0x79/0x140 [libceph]
> [6888366.281534]  ceph_con_v1_try_read+0x5d7/0xf30 [libceph]
> [6888366.281661]  ceph_con_workfn+0x329/0x680 [libceph]
> ```
> 
> After analyzing the coredump file, we found that the address of dc->sb_bio
> has been freed. We know that cached_dev is only freed when it is stopped.
> 
> Since sb_bio is a part of struct cached_dev, rather than an alloc every time.
> If the device is stopped while writing to the superblock, the released address
> will be accessed at endio.
> 
> This patch hopes to wait for sb_write to complete in cached_dev_free.
> 
> It should be noted that we analyzed the cause of the problem, then tell
> all details to the QWEN and adopted the modifications it made.
> 
> Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
> 
> ---
> v2: fix the crash caused by not calling closure_init in v1
> ---
>  drivers/md/bcache/super.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 64bb38c95895..b76edbaaf4f3 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1373,6 +1373,13 @@ static CLOSURE_CALLBACK(cached_dev_free)
>  
>  	mutex_unlock(&bch_register_lock);
>  
> +	/*
> +	 * Wait for any pending sb_write to complete before free.
> +	 * The sb_bio is embedded in struct cached_dev, so we must
> +	 * ensure no I/O is in progress.
> +	 */
> +	down(&dc->sb_write_mutex);
> +

I know what you mean. dc->sb_write cannot be access out of bch_write_bdev_super().
But the above down() method is not comfortable IMHO.

Fortunately when cached_dev_free() is called from cached_dev_flush(), kobjs of
bcache device is delted by kobject_del(&d->kobj), there is no chance to call
bch_write_bdev_super() via sysfs interface. And when cached_dev_free() is called,
other code path calling bch_write_bdev_super() won't happen neither.

So a pair of
	down(&dc->sb_write_mutex);
	up(&dc->sb_write_mutex);
might be enough to make sure the last on-flight bch_write_bdev_super() will
complete?



>  	if (dc->sb_disk)
>  		folio_put(virt_to_folio(dc->sb_disk));
>  
> -- 
> 2.34.1
