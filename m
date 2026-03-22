Received: from va-2-29.ptr.blmpb.com (va-2-29.ptr.blmpb.com [209.127.231.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2C62EC0AE
	for <linux-bcache@vger.kernel.org>; Sun, 22 Mar 2026 07:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774163079; cv=none; b=ljvuZ5Uzg6OdqSe8cao8XQl71FReUmHey9UH7kIgOvGMPrHl+1f6wUwyaVVAyhUoUdZWV8ybvKnCS+HYuFThOAEkz7SD9gxIPGmQEJSbxrtmPDv5hRVltpd7C8EbDkzW6n3usFOitQA6ioNYv+GLfoGsXlYYxZ6MDwuAd7C/ucI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774163079; c=relaxed/simple;
	bh=N2r2ZwHy3bSID/xKfQnlq1HuIMvtcJB7hIs6C/Mq2TQ=;
	h=Content-Disposition:In-Reply-To:To:Date:Message-Id:Content-Type:
	 References:Mime-Version:Cc:From:Subject; b=jZNWFytSD2/4bmiGiCyjijI0K+klCEO9cTOaRsseaOTES/OTjfA0NTuUAof2RiV1lrnhbvAbwOrOnjYKZFz09oBnPziCOhkvpicGbuLSCn0LOyC2/Fw4PLBUr3QxlxX1gukUg2rjyVB/8iuQWjM5xxpLaui85fDNNA60LLO84tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=MdQR6M/O; arc=none smtp.client-ip=209.127.231.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="MdQR6M/O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1774163065;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=kjthUs98Nimw4ixrwkmcMAZAPt0ayTvEBwYpMeej+Hs=;
 b=MdQR6M/OECgguYg1yG4vq0xz/mXyd5TXLmxix4rx0cMp4scGZYayOlTs5OdsIYDX0hX7zu
 vmKseJO+ZCkmrOncpArajn/f/ASMtbNid4GA51IFlXQrT1qFrAY2tfIF1qmnUBwFqODSQB
 0oCKcCBBZSdzVcqNXnbcbyaMCh0/B6PeINMU5ID2e5tGl+G71r9soe0vEy/NXDFwjK0clN
 2X2Cz8Wu15eIcM+4c16XWRTbRM+5WtOlSj6Iv9y7KbHzvANCehih7PqQmKZScbxFcfGbF6
 uQ/mDVxuhcqvkii/V+0DEq9UqQucYBlLlDKL0VGs05k3larD4CshUmhS7hKvoQ==
Content-Disposition: inline
In-Reply-To: <20260318125349.193622-1-mingzhe.zou@easystack.cn>
To: <mingzhe.zou@easystack.cn>
Date: Sun, 22 Mar 2026 15:04:22 +0800
Message-Id: <ab-UMcft6zJt3nE0@studio.local>
Content-Type: text/plain; charset=UTF-8
X-Original-From: Coly Li <colyli@fnnas.com>
References: <20260318125349.193622-1-mingzhe.zou@easystack.cn>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from studio.local ([120.245.64.207]) by smtp.feishu.cn with ESMTPS; Sun, 22 Mar 2026 15:04:22 +0800
X-Lms-Return-Path: <lba+269bf9477+7c189f+vger.kernel.org+colyli@fnnas.com>
Content-Transfer-Encoding: 7bit
Cc: <colyli@kernel.org>, <linux-bcache@vger.kernel.org>, <zoumingzhe@qq.com>, 
	<zoumingzhe@outlook.com>
From: "Coly Li" <colyli@fnnas.com>
Subject: Re: [PATCH] bcache: fix cached_dev.sb_bio use-after-free and crash

On Wed, Mar 18, 2026 at 08:53:49PM +0800, mingzhe.zou@easystack.cn wrote:
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

Nice catch. I will add a Fixes tag and CC stable.

Thanks.

Coly Li

> ---
>  drivers/md/bcache/super.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 64bb38c95895..6627a381f65a 100644
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
> +	closure_sync(&dc->sb_write);
> +
>  	if (dc->sb_disk)
>  		folio_put(virt_to_folio(dc->sb_disk));
>  
> -- 
> 2.34.1
> 
