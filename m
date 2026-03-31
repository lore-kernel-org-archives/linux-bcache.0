Received: from va-2-28.ptr.blmpb.com (va-2-28.ptr.blmpb.com [209.127.231.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A0C244685
	for <linux-bcache@vger.kernel.org>; Tue, 31 Mar 2026 01:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774922196; cv=none; b=LvJkRk+iHs7vxcSZkuX/xw8BqLcA5Sdktrl+5//HaCG/56nOj1Uiy7krh6na7iCmuW+HG35UmJpB2jVSMb+4mwIOV7hAWq4rHTZpkaMLJBekxFTDUBbRuCUyHvyj4nerM56mVFzKYcKj4aKncbhqORxpKuXdnSPWwNSgOG8Kmn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774922196; c=relaxed/simple;
	bh=0UP3yGlxi/4r95qkiwnW++Ud/xrF8OdwRLApZCt02tc=;
	h=Content-Type:Content-Disposition:Mime-Version:From:References:To:
	 Cc:Date:Message-Id:In-Reply-To:Subject; b=tXWpAFSRJ9y3giNJKTNdFRc/wQyu/BWoBB6uJEm11+TdxP0W982Sw1H92d+LcEVL5VXSBMoKA+YPzQXbq7LJZoNN2MwQQ3GQtyt+KZfqcbmgHX/XA1e1vkPYfiiYdZ+FIwwJM2oOOJz5BecWaqFRsHPJZQXNCjT+4X4K97ofHfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=MTJqSp5g; arc=none smtp.client-ip=209.127.231.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="MTJqSp5g"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1774922182;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=8I9QInqfetuFmmtGqZwTyzOOrTim5WzG16S9wMZfaDk=;
 b=MTJqSp5gFrTQ2srjqSR4kQgw3ZD5xHmnTCB/irVqNpoBQf2fVrKnASjai+yshEHBdni10L
 48IOdP5XyJmxpYEsm9Tu5Rx6GA602kphdtnZfCsLClRNkucEy8kxrXcRT/VwU/AdH2dm52
 aNICJaiXM2fpo+gMDGEAjAQuIn3e+LfiYKxu7sgTMN4PrKCIiQNvkPiRHl/ymCRvMf6H+v
 Z0v6kOIoeLP10kzKrjo6Z1zOuRGxAai1BDcvR7pUtjB+EgX1TUYxQrkKwKhRwQ71NS/I3a
 ELbXtXurJwm9AvlTzgy7lAK7Xa8H3yZ6ZYLo0++L4VmDVPuuE+5AgAv/OeMAOQ==
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
From: "Coly Li" <colyli@fnnas.com>
References: <20260330131153.69705-1-mingzhe.zou@easystack.cn>
Received: from studio.local ([120.245.64.217]) by smtp.feishu.cn with ESMTPS; Tue, 31 Mar 2026 09:56:19 +0800
To: <mingzhe.zou@easystack.cn>, <axboe@kernel.dk>
Cc: <colyli@kernel.org>, <linux-bcache@vger.kernel.org>, <zoumingzhe@qq.com>, 
	<zoumingzhe@outlook.com>
Date: Tue, 31 Mar 2026 09:56:18 +0800
Message-Id: <acsmG8w-ZbYvEip0@studio.local>
In-Reply-To: <20260330131153.69705-1-mingzhe.zou@easystack.cn>
X-Lms-Return-Path: <lba+269cb29c4+4d328c+vger.kernel.org+colyli@fnnas.com>
X-Original-From: Coly Li <colyli@fnnas.com>
Subject: Re: [PATCH v3] bcache: fix cached_dev.sb_bio use-after-free and crash

On Mon, Mar 30, 2026 at 09:11:53PM +0800, mingzhe.zou@easystack.cn wrote:
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
> Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
> 

Hi Mingzhe,

Yeah, this patch is in better shape. Thank for the fix up again.

> ---
> v2: fix the crash caused by not calling closure_init in v1
> v3: pair the down and up of semaphore sb_write_mutex
> ---
>  drivers/md/bcache/super.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 64bb38c95895..97d9adb0bf96 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1373,6 +1373,14 @@ static CLOSURE_CALLBACK(cached_dev_free)
>  
>  	mutex_unlock(&bch_register_lock);
>  
> +	/*
> +	 * Wait for any pending sb_write to complete before free.
> +	 * The sb_bio is embedded in struct cached_dev, so we must
> +	 * ensure no I/O is in progress.
> +	 */
> +	down(&dc->sb_write_mutex);
> +	up(&dc->sb_write_mutex);
> +
>  	if (dc->sb_disk)
>  		folio_put(virt_to_folio(dc->sb_disk));
>  

The patch itself is good. But the previous one (based on closre_sync()) is
in Jens block-tree. Let me ask.

Hi Jens,

Should Mingzhe send a incremental patch based on commit b36478a1fece in
block-7.0 branch of linux-block tree? Or Just use this patch to replace
the in-linux-block-tree one?

Thanks in advance for your hint.

Coly Li
