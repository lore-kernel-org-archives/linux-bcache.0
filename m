From: Coly Li <i@coly.li>
Subject: Re: [PATCH 04/19] bcache: fix wrong cache_misses statistics
Date: Sun, 2 Jul 2017 01:58:55 +0800
Message-ID: <20989a81-8448-96c8-f8b6-f3e3fec7c3cc@coly.li>
References: <20170629134510.GA32385@infradead.org>
 <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
 <1498855388-16990-4-git-send-email-bcache@lists.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1498855388-16990-4-git-send-email-bcache@lists.ewheeler.net>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Tang Junhui <tang.junhui@zte.com.cn>
Cc: bcache@lists.ewheeler.net, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, hch@infradead.org, axboe@kernel.dk, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2017/7/1 上午4:42, bcache@lists.ewheeler.net wrote:
> From: Tang Junhui <tang.junhui@zte.com.cn>
> 
> Some missed IOs are not counted into cache_misses, this patch fix this
> issue.

Could you please explain more about,
- which kind of missed I/O are mot counted
- where cache_missed is located

This will help the patch to be more understandable.

> 
> Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
> Reviewed-by: Eric Wheeler <bcache@linux.ewheeler.net>
> Cc: stable@vger.kernel.org

[snip]

> @@ -758,7 +760,7 @@ static void cached_dev_read_done_bh(struct closure *cl)
>  	struct cached_dev *dc = container_of(s->d, struct cached_dev, disk);
>  
>  	bch_mark_cache_accounting(s->iop.c, s->d,
> -				  !s->cache_miss, s->iop.bypass);
> +				  !s->cache_missed, s->iop.bypass);
>  	trace_bcache_read(s->orig_bio, !s->cache_miss, s->iop.bypass);


Should the above line be changed to,
	trace_bcache_read(s->orig_bio, !s->cache_missed, s->iop.bypass);
as well ?


[snip]

Thanks.

-- 
Coly Li
