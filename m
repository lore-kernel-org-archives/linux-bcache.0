From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: add cond_resched() in __bch_cache_cmp()
Date: Thu, 7 Mar 2019 18:34:16 +0800
Message-ID: <24916a71-39ff-7324-ad12-9d79cc68d0da@suse.de>
References: <1551935728-243664-1-git-send-email-shile.zhang@linux.alibaba.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1551935728-243664-1-git-send-email-shile.zhang@linux.alibaba.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: shile.zhang@linux.alibaba.com
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2019/3/7 1:15 下午, shile.zhang@linux.alibaba.com wrote:
> From: Shile Zhang <shile.zhang@linux.alibaba.com>
> 
> Read /sys/fs/bcache/<uuid>/cacheN/priority_stats can take very long
> time with huge cache after long run.
> 
> Signed-off-by: Shile Zhang <shile.zhang@linux.alibaba.com>

Hi Shile,

Do you test your change ? It will be helpful with more performance data
(what problem that you improved).

Thanks.

Coly Li

> ---
>  drivers/md/bcache/sysfs.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index 557a8a3..028fea1 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -897,6 +897,7 @@ static void bch_cache_set_internal_release(struct kobject *k)
>  
>  static int __bch_cache_cmp(const void *l, const void *r)
>  {
> +	cond_resched();
>  	return *((uint16_t *)r) - *((uint16_t *)l);
>  }
>  
> 


-- 

Coly Li
