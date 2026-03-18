Received: from va-2-38.ptr.blmpb.com (va-2-38.ptr.blmpb.com [209.127.231.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44CA3921C7
	for <linux-bcache@vger.kernel.org>; Wed, 18 Mar 2026 11:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773834450; cv=none; b=UW8fLhPvj4FUyxQLzKc4DOyLITy9MdJNiZTDywqHufnnHXKyf7gqbb/oU6KhPXKhS8hPliv/kifJBvoCQ9DHx5NZQjhKKiMjChU0mZbXdvSiE1ILijkkNOMngQEfA6zTohQM/CJkKlAaTEswsmD+f4OpBP//ZbE58SYTMSpCz8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773834450; c=relaxed/simple;
	bh=mNZQsCgJbsC1QFPTorsu+hIni35yTjf6aupxuwaXyfk=;
	h=Content-Disposition:Content-Type:From:Subject:In-Reply-To:To:Cc:
	 Date:Message-Id:Mime-Version:References; b=eChAjhk68OIfAdKN3BjT1T7eX6yI//NPk4nLsxPClFwut5a4WsBL6z35OupZY5eD/sqZr+RxiHSRseP+SgHuILJjyeliVogtltfhn5AsrC6wpHez5LNo/JuUJU1+TTnxAz8QQ8pfEOlou68aQTw1EndMZcV27EfQ44zo/woPl1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=yApzobVX; arc=none smtp.client-ip=209.127.231.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="yApzobVX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1773834438;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=8f7/jUBkpSOKvRIcuVKsHW+vQ0NmQF4a3nJVy0l8zxA=;
 b=yApzobVXRFigowgLz3A1i6xyEK5gCPOlBi2QzdrAvFosbQxHXFtHahnNuKR9FIFmXpb5uK
 3MHaDT0iTSoueyUIlqB6n0HHu775zYvPttuvoZC7E7EHp7dqo9ChyRDCzz3E1sUI748B2H
 kmsJWC3rKff3C3XfWB4kcZ5QZ2suTwZMx80YMDaXgz8ae+sFrzRAWOyfESU7ts62vzau/Z
 dd46m4WqNTiH3sbRH2eTJSHpO98hMMTHUIlZEB4G4K0A42RZIwU/lrLRETz+p60kro6udO
 wGRVVeoJ68/NiGpMhlFbI5TmP7lWt1T2VveKZkndpWvmITnQCRf2irS76xqXmw==
Content-Disposition: inline
Received: from studio.local ([120.245.64.207]) by smtp.feishu.cn with ESMTPS; Wed, 18 Mar 2026 19:47:15 +0800
Content-Type: text/plain; charset=UTF-8
From: "Coly Li" <colyli@fnnas.com>
Subject: Re: [PATCH] bcache: convert bch_register_lock to rw_semaphore
In-Reply-To: <20260318-wujing-bcache-v1-1-f0b9aaf3f81d@gmail.com>
To: "Qiliang Yuan" <realwujing@gmail.com>
Cc: "Kent Overstreet" <kent.overstreet@linux.dev>, 
	<linux-bcache@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Wed, 18 Mar 2026 19:47:14 +0800
X-Lms-Return-Path: <lba+269ba90c4+eea83e+vger.kernel.org+colyli@fnnas.com>
Content-Transfer-Encoding: 7bit
Message-Id: <abqFB7e0KWxBV08Y@studio.local>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260318-wujing-bcache-v1-1-f0b9aaf3f81d@gmail.com>
X-Original-From: Coly Li <colyli@fnnas.com>

On Wed, Mar 18, 2026 at 03:52:46PM +0800, Qiliang Yuan wrote:
> Refactor the global bch_register_lock from a mutex to an rw_semaphore to
> resolve severe lock contention and hung tasks (State D) during large-scale
> bcache device registration and concurrent sysfs access.
> 
> Representative call trace from logs:
> [  243.082130] INFO: task bcache_cache_se:3496 blocked for more than 121 seconds.
> [  243.130817] Call trace:
> [  243.134161]  __switch_to+0x7c/0xbc
> [  243.138461]  __schedule+0x338/0x6f0
> [  243.142847]  schedule+0x50/0xe0
> [  243.146884]  schedule_preempt_disabled+0x18/0x24
> [  243.152400]  __mutex_lock.constprop.0+0x1d4/0x5ec
> [  243.158002]  __mutex_lock_slowpath+0x1c/0x30
> [  243.163170]  mutex_lock+0x50/0x60
> [  243.167397]  bch_cache_set_store+0x40/0x80 [bcache]
> [  243.173175]  sysfs_kf_write+0x4c/0x5c
> [  243.177735]  kernfs_fop_write_iter+0x130/0x1c0
> [  243.183077]  new_sync_write+0xec/0x18c
> [  243.187724]  vfs_write+0x214/0x2ac
> [  243.192022]  ksys_write+0x70/0xfc
> [  243.196234]  __arm64_sys_write+0x24/0x30
> [  243.201057]  invoke_syscall+0x50/0x11c
> [  243.205705]  el0_svc_common.constprop.0+0x158/0x164
> [  243.211483]  do_el0_svc+0x2c/0x9c
> [  243.215696]  el0_svc+0x20/0x30
> [  243.219648]  el0_sync_handler+0xb0/0xb4
> [  243.224384]  el0_sync+0x160/0x180
> 
> This addresses the long-standing issue where a single slow bcache device
> initialization could block the entire system's bcache management path.

Yes, this is an already know issue. The root cause is becasue all meta data and
data buckets on cache device are shared among all cached devices. When a cached
device is attached to or detached from cache device, there is no better method
to distinct meta data/data from different cached device, a big bch_register_lock
is the have-to choice.

I see the issue you want to solve, but it is hard due to the above root cause.
And for your patch, there is obvious regression. I will list it in line.



> Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
> ---
>  drivers/md/bcache/bcache.h  |  2 +-
>  drivers/md/bcache/request.c | 18 +++++-----
>  drivers/md/bcache/super.c   | 85 +++++++++++++++++++++++++--------------------
>  drivers/md/bcache/sysfs.c   | 82 ++++++++++++++++++++++++++++++++++++++++---
>  drivers/md/bcache/sysfs.h   |  8 ++---
>  5 files changed, 139 insertions(+), 56 deletions(-)
> 
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 8ccacba855475..7ab36987e945b 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -1003,7 +1003,7 @@ void bch_write_bdev_super(struct cached_dev *dc, struct closure *parent);
>  extern struct workqueue_struct *bcache_wq;
>  extern struct workqueue_struct *bch_journal_wq;
>  extern struct workqueue_struct *bch_flush_wq;
> -extern struct mutex bch_register_lock;
> +extern struct rw_semaphore bch_register_lock;
>  extern struct list_head bch_cache_sets;

This is a headache change, because you change global bch_register_lock data
type, it may break kernel ABI and bring up hard life for downstream kernel
maintainers.

[snipped]

> @@ -2029,8 +2029,12 @@ static int run_cache_set(struct cache_set *c)
>  			goto err;
>  
>  		err = "error in recovery";
> -		if (bch_btree_check(c))
> +		downgrade_write(&bch_register_lock);
> +		if (bch_btree_check(c)) {
> +			up_read(&bch_register_lock);
> +			down_write(&bch_register_lock);
>  			goto err;
> +		}
>  
>  		bch_journal_mark(c, &journal);
>  		bch_initial_gc_finish(c);

Consider one of the regressions, before bch_btree_check() is called, the cache
set kobjects are created and linked already. It means the cache set sysfs inter-
face can be accessed before calling bch_tree_check(). In the above code there
is a gap/window between up_read() and down_write(), if down_write() is blocked
by other reader from other thread, and someone triggers the unregister sysfs
interface, try to image what will happen? I don't see this is broken issue, but
it looks really uncomfortable.

Current mutex will make sure such parital initalization circumstances won't
happen.

This is one example, and not the only one.

[snipped]

Coly Li
