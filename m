Received: from va-2-35.ptr.blmpb.com (va-2-35.ptr.blmpb.com [209.127.231.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85F741C2E1
	for <linux-bcache@vger.kernel.org>; Tue, 31 Mar 2026 15:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774971998; cv=none; b=bw1rh7yzH+Zt7FUXyz5IFatN9msikPUoQLZu/rOA5AmjkvtXMhLY2TMg+S8vR3ie2S3lIM4LUPz/1SLWXlKeSIFL/z29t8R4aJ2+cc8w9hCtOMS60coL9mu4aJG6kH7RVEbEKx5zERM2ChU1rnQzP4XAi6VtlpETG3EDBJvIVEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774971998; c=relaxed/simple;
	bh=Szjz4J3nwfEKaqt2W+kIBMGKUml8yGW05RmqvNMDGp0=;
	h=In-Reply-To:From:Subject:Content-Type:To:Cc:Message-Id:References:
	 Content-Disposition:Date:Mime-Version; b=RCF6fsbTihJLfeSiumuMeUwIdC+eu89CAdQjHm37QVA4Aw9fMIuxSnten3UF+CUb1PIkxM0pVcrKodAOA59dpv7g+qsAkiT0TfRnpZl3EK9gx7H+7zGNOh0HelIw8FQJqS4AlAiGpPy9lWen91E6rFMTsJEsocYs698A7a/zJ7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=bRuI5+fb; arc=none smtp.client-ip=209.127.231.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="bRuI5+fb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1774971989;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=B8wO7cDbATzgaSwsM+4IGf3F/yIxHwTzfJJne+RGZlc=;
 b=bRuI5+fbrdnVNErIYVQBy0xquzlNwcAoXZDBvbRfSwl80uv4ZTugi1qUAE2TJlS7JClZT/
 4w/AYBV20tK8YYfNmuLmgof0UGv1ffoMELsx7HLMo0EH0hqH1VMXd6Utqwe1nz5OlRoDJx
 DOe+N9MB7mU0kQkADgyeabkmqoXUMFYtgphGmywFB/TKBEe3PQlpv3tX+/nIZFWF35qZu0
 IP3qWFUMz7r6gP0/3UJoOznI/y/XTzTWeSVbq6PgX0it5lPFUL5WcD6h4LaVpEraplY4Sn
 kEaCyWN0lMNmAYRYAdvuzxv3dJTQrB7MtePYbcO7dwc9S1Ige66+xkUqcL+WiA==
X-Lms-Return-Path: <lba+269cbec53+72cd04+vger.kernel.org+colyli@fnnas.com>
X-Original-From: Coly Li <colyli@fnnas.com>
In-Reply-To: <acsmG8w-ZbYvEip0@studio.local>
From: "Coly Li" <colyli@fnnas.com>
Subject: Re: [PATCH v3] bcache: fix cached_dev.sb_bio use-after-free and crash
Content-Type: text/plain; charset=UTF-8
To: <mingzhe.zou@easystack.cn>, <axboe@kernel.dk>
Cc: <colyli@kernel.org>, <linux-bcache@vger.kernel.org>, <zoumingzhe@qq.com>, 
	<zoumingzhe@outlook.com>
Message-Id: <acvrq_PBzn4T2TqH@studio.local>
References: <20260330131153.69705-1-mingzhe.zou@easystack.cn> <acsmG8w-ZbYvEip0@studio.local>
Received: from studio.local ([120.245.64.217]) by smtp.feishu.cn with ESMTPS; Tue, 31 Mar 2026 23:46:26 +0800
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Date: Tue, 31 Mar 2026 23:46:25 +0800
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0

On Tue, Mar 31, 2026 at 09:56:18AM +0800, Coly Li wrote:
> On Mon, Mar 30, 2026 at 09:11:53PM +0800, mingzhe.zou@easystack.cn wrote:
> > From: Mingzhe Zou <mingzhe.zou@easystack.cn>
> > 
> > In our production environment, we have received multiple crash reports
> > regarding libceph, which have caught our attention:
> > 
> > ```
> > [6888366.280350] Call Trace:
> > [6888366.280452]  blk_update_request+0x14e/0x370
> > [6888366.280561]  blk_mq_end_request+0x1a/0x130
> > [6888366.280671]  rbd_img_handle_request+0x1a0/0x1b0 [rbd]
> > [6888366.280792]  rbd_obj_handle_request+0x32/0x40 [rbd]
> > [6888366.280903]  __complete_request+0x22/0x70 [libceph]
> > [6888366.281032]  osd_dispatch+0x15e/0xb40 [libceph]
> > [6888366.281164]  ? inet_recvmsg+0x5b/0xd0
> > [6888366.281272]  ? ceph_tcp_recvmsg+0x6f/0xa0 [libceph]
> > [6888366.281405]  ceph_con_process_message+0x79/0x140 [libceph]
> > [6888366.281534]  ceph_con_v1_try_read+0x5d7/0xf30 [libceph]
> > [6888366.281661]  ceph_con_workfn+0x329/0x680 [libceph]
> > ```
> > 
> > After analyzing the coredump file, we found that the address of dc->sb_bio
> > has been freed. We know that cached_dev is only freed when it is stopped.
> > 
> > Since sb_bio is a part of struct cached_dev, rather than an alloc every time.
> > If the device is stopped while writing to the superblock, the released address
> > will be accessed at endio.
> > 
> > This patch hopes to wait for sb_write to complete in cached_dev_free.
> > 
> > Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
> > 
> 
> Hi Mingzhe,
> 
> Yeah, this patch is in better shape. Thank for the fix up again.
> 
> > ---
> > v2: fix the crash caused by not calling closure_init in v1
> > v3: pair the down and up of semaphore sb_write_mutex
> > ---
> >  drivers/md/bcache/super.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> > index 64bb38c95895..97d9adb0bf96 100644
> > --- a/drivers/md/bcache/super.c
> > +++ b/drivers/md/bcache/super.c
> > @@ -1373,6 +1373,14 @@ static CLOSURE_CALLBACK(cached_dev_free)
> >  
> >  	mutex_unlock(&bch_register_lock);
> >  
> > +	/*
> > +	 * Wait for any pending sb_write to complete before free.
> > +	 * The sb_bio is embedded in struct cached_dev, so we must
> > +	 * ensure no I/O is in progress.
> > +	 */
> > +	down(&dc->sb_write_mutex);
> > +	up(&dc->sb_write_mutex);
> > +
> >  	if (dc->sb_disk)
> >  		folio_put(virt_to_folio(dc->sb_disk));
> >  
> 
> The patch itself is good. But the previous one (based on closre_sync()) is
> in Jens block-tree. Let me ask.
> 
> Hi Jens,
> 
> Should Mingzhe send a incremental patch based on commit b36478a1fece in
> block-7.0 branch of linux-block tree? Or Just use this patch to replace
> the in-linux-block-tree one?
> 

Hi Mingzhe,

Considering no responds from Jens at this moment, I assume that an incremental
patch againt the already-in-linux-block patch might be more convenient for him.
Then he can simply apply the incremental patch without extra rebase stuffs.

Can you re-compose a patch against block-7.0 branch of linux-block tree?

Thanks.

Coly Li
