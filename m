From: Coly Li <i@coly.li>
Subject: Re: [PATCH] [linux-next] bcache: Remove duplicate inclusion of
 blkdev.h
Date: Sun, 26 Feb 2017 22:45:43 +0800
Message-ID: <c74ff145-37d5-ace3-c65c-d2d6199163ef@coly.li>
References: <20170226060230.11555-1-standby24x7@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:49868 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752244AbdBZPXU (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 26 Feb 2017 10:23:20 -0500
In-Reply-To: <20170226060230.11555-1-standby24x7@gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Masanari Iida <standby24x7@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, kent.overstreet@gmail.com, shli@kernel.org, linux-bcache@vger.kernel.org

On 2017/2/26 下午2:02, Masanari Iida wrote:
> This patch remove duplicate inclusion of blkdev.h in util.h.
> Confirm compile successfully after remove the line.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  drivers/md/bcache/util.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
> index cf2cbc211d83..03af094d0202 100644
> --- a/drivers/md/bcache/util.h
> +++ b/drivers/md/bcache/util.h
> @@ -4,7 +4,6 @@
>  
>  #include <linux/blkdev.h>
>  #include <linux/errno.h>
> -#include <linux/blkdev.h>
>  #include <linux/kernel.h>
>  #include <linux/llist.h>
>  #include <linux/ratelimit.h>
> 
Acked-by: Coly Li <colyli@suse.de>

-- 
Coly Li
