From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: [PATCH] fix a leak in bch_cached_dev_run()
Date: Sat, 1 Nov 2014 13:38:16 -0700
Message-ID: <20141101203816.GA22219@kmo-pixel>
References: <20141030054208.GE7996@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:58700 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758762AbaKAUgR (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sat, 1 Nov 2014 16:36:17 -0400
Received: by mail-pa0-f52.google.com with SMTP id fa1so9802830pad.39
        for <linux-bcache@vger.kernel.org>; Sat, 01 Nov 2014 13:36:17 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20141030054208.GE7996@ZenIV.linux.org.uk>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org

On Thu, Oct 30, 2014 at 05:42:09AM +0000, Al Viro wrote:
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -878,8 +878,11 @@ void bch_cached_dev_run(struct cached_dev *dc)
>  	buf[SB_LABEL_SIZE] = '\0';
>  	env[2] = kasprintf(GFP_KERNEL, "CACHED_LABEL=%s", buf);
>  
> -	if (atomic_xchg(&dc->running, 1))
> +	if (atomic_xchg(&dc->running, 1)) {
> +		kfree(env[1]);
> +		kfree(env[2]);
>  		return;
> +	}
>  
>  	if (!d->c &&
>  	    BDEV_STATE(&dc->sb) != BDEV_STATE_NONE) {

Thanks, applied
