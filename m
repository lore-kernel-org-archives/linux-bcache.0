From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH v4 05/13] bcache: stop dc->writeback_rate_update properly
Date: Tue, 30 Jan 2018 10:20:46 +0800
Message-ID: <ccae3e90-f69a-9804-fe8d-3cfd3c453689@suse.de>
References: <1517277425-3641-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54292 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752221AbeA3CU7 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 29 Jan 2018 21:20:59 -0500
In-Reply-To: <1517277425-3641-1-git-send-email-tang.junhui@zte.com.cn>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: mlyle@lyle.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

On 30/01/2018 9:57 AM, tang.junhui@zte.com.cn wrote:
> From: Tang Junhui <tang.junhui@zte.com.cn>
> 
> Hello Coly:
> 
> OK, I got your point now.
> Thanks for your patience.
> 
> And there is a small issue I hope to be modified:
> +#define BCACHE_DEV_WB_RUNNING        4
> +#define BCACHE_DEV_RATE_DW_RUNNING    8
> Would be OK just as:
> +#define BCACHE_DEV_WB_RUNNING        3
> +#define BCACHE_DEV_RATE_DW_RUNNING    4
> 
> Reviewed-by: Tang Junhui <tang.junhui@zte.com.cn>
> 

Hi Junhui,

I will fix that in v5 patch. Thanks for your review :-)

Coly Li


[snip]
