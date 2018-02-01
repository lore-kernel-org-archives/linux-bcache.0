From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH v4 01/13] bcache: set writeback_rate_update_seconds in
 range [1, 60] seconds
Date: Thu, 1 Feb 2018 13:44:00 -0800
Message-ID: <37cb226a-2335-89d6-26f7-af611c70586b@lyle.org>
References: <20180127142406.89741-1-colyli@suse.de>
 <20180127142406.89741-2-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:39591 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751715AbeBAVoF (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 1 Feb 2018 16:44:05 -0500
Received: by mail-pl0-f67.google.com with SMTP id o13so4549229pli.6
        for <linux-bcache@vger.kernel.org>; Thu, 01 Feb 2018 13:44:05 -0800 (PST)
In-Reply-To: <20180127142406.89741-2-colyli@suse.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org

On 01/27/2018 06:23 AM, Coly Li wrote:
> dc->writeback_rate_update_seconds can be set via sysfs and its value can
> be set to [1, ULONG_MAX].  It does not make sense to set such a large
> value, 60 seconds is long enough value considering the default 5 seconds
> works well for long time.
> 
> Because dc->writeback_rate_update is a special delayed work, it re-arms
> itself inside the delayed work routine update_writeback_rate(). When
> stopping it by cancel_delayed_work_sync(), there should be a timeout to
> wait and make sure the re-armed delayed work is stopped too. A small max
> value of dc->writeback_rate_update_seconds is also helpful to decide a
> reasonable small timeout.
> 
> This patch limits sysfs interface to set dc->writeback_rate_update_seconds
> in range of [1, 60] seconds, and replaces the hand-coded number by macros.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> Reviewed-by: Hannes Reinecke <hare@suse.com>

[snip]

> ---
>  drivers/md/bcache/sysfs.c     | 3 +++
>  drivers/md/bcache/writeback.c | 2 +-
>  drivers/md/bcache/writeback.h | 3 +++
>  3 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index b4184092c727..a74a752c9e0f 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -215,6 +215,9 @@ STORE(__cached_dev)
>  	sysfs_strtoul_clamp(writeback_rate,
>  			    dc->writeback_rate.rate, 1, INT_MAX);
>  
> +	sysfs_strtoul_clamp(writeback_rate_update_seconds,
> +			    dc->writeback_rate_update_seconds,
> +			    1, WRITEBACK_RATE_UPDATE_SECS_MAX);
>  	d_strtoul_nonzero(writeback_rate_update_seconds);

Doesn't the above line need to be removed for this to work?

Mike
