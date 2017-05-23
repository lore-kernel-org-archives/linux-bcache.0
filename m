From: Coly Li <i@coly.li>
Subject: Re: [PATCH] bcache: inherit underlying queue limits for bcache
 drivers
Date: Tue, 23 May 2017 23:57:58 +0800
Message-ID: <eacc847f-c4a9-6786-0bf8-40ee725fdab9@coly.li>
References: <1495527253-11008-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:34726 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757596AbdEWP6m (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 23 May 2017 11:58:42 -0400
In-Reply-To: <1495527253-11008-1-git-send-email-tang.junhui@zte.com.cn>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: kent.overstreet@gmail.com, linux-bcache@vger.kernel.org

On 2017/5/23 下午4:14, tang.junhui@zte.com.cn wrote:
> From: "tang.junhui" <tang.junhui@zte.com.cn>
> 
> We'd better let the stacking driver inherit underlying queue limits,
> so, we can avoid the unnessary mergering in the top layer, and It leads
> a 10% performance promotion in large sequential IO reading testing as
> follows:
> 

Hi Junhui,

I don't get the point why there is unnecessary merging in the upper
layer, and how the unnecessary merging can be avoided by set a queue limit.

And from the testing, I see total data size is around 21GB which is not
convinced enough. Is it possible to use a large enough data size, e.g.
512GB or 1TB ?

Thanks.

> before:
> [root@ceph192-9-9-151 ~]# dd if=/dev/bcache3p2 of=/dev/zero bs=1M
> count=20480 iflag=direct
> 20480+0 records in
> 20480+0 records out
> 21474836480 bytes (21 GB) copied, 173.424 s, 124 MB/s
> 
> after:
> [root@ceph192-9-9-151 tjh]# dd if=/dev/bcache3p2 of=/dev/zero bs=1M
> count=20480 iflag=direct
> 20480+0 records in
> 20480+0 records out
> 21474836480 bytes (21 GB) copied, 151.107 s, 142 MB/s
> 
> Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
> ---
>  drivers/md/bcache/super.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 3a19cbc..615782c 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1129,6 +1129,8 @@ static int cached_dev_init(struct cached_dev *dc, unsigned block_size)
>  	if (ret)
>  		return ret;
>  
> +	blk_queue_stack_limits(dc->disk.disk->queue, q);
> +
>  	set_capacity(dc->disk.disk,
>  		     dc->bdev->bd_part->nr_sects - dc->sb.data_offset);
>  
> 


-- 
Coly Li
