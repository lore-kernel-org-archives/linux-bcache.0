From: Coly Li <i@coly.li>
Subject: Re: [PATCH 09/19] bcache: update bio->bi_opf bypass/writeback REQ_
 flag hints
Date: Sun, 2 Jul 2017 02:49:20 +0800
Message-ID: <f9976cdb-dcff-ac98-9a18-2d06b2d4c475@coly.li>
References: <20170629134510.GA32385@infradead.org>
 <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
 <1498855388-16990-9-git-send-email-bcache@lists.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1498855388-16990-9-git-send-email-bcache@lists.ewheeler.net>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: bcache@lists.ewheeler.net
Cc: linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, hch@infradead.org, axboe@kernel.dk, Eric Wheeler <git@linux.ewheeler.net>, Eric Wheeler <bcache@linux.ewheeler.net>
List-Id: linux-bcache@vger.kernel.org

On 2017/7/1 上午4:42, bcache@lists.ewheeler.net wrote:
> From: Eric Wheeler <git@linux.ewheeler.net>
> 
> Bypass if:     bio->bi_opf & (REQ_RAHEAD|REQ_BACKGROUND)
> 
> Writeback if:  op_is_sync(bio->bi_opf) || bio->bi_opf & (REQ_META|REQ_PRIO)
> 

Hi Eric,

Could you please explain a bit how the above policy is designed ? I'd
like to understand it more.

Thanks.

Coly


> Signed-off-by: Eric Wheeler <bcache@linux.ewheeler.net>
> ---
>  drivers/md/bcache/request.c   | 3 +++
>  drivers/md/bcache/writeback.h | 3 ++-
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index a95609f..4629b0c 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -386,6 +386,9 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
>  	     op_is_write(bio_op(bio))))
>  		goto skip;
>  
> +	if (bio->bi_opf & (REQ_RAHEAD|REQ_BACKGROUND))
> +		goto skip;
> +
>  	/* If the ioprio already exists on the bio, use that.  We assume that
>  	 * the upper layer properly assigned the calling process's ioprio to
>  	 * the bio being passed to bcache. Otherwise, use current's ioc. */
> diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
> index cd82fe8..ea2f92e 100644
> --- a/drivers/md/bcache/writeback.h
> +++ b/drivers/md/bcache/writeback.h
> @@ -81,7 +81,8 @@ static inline bool should_writeback(struct cached_dev *dc, struct bio *bio,
>  		return true;
>  	}
>  
> -	return op_is_sync(bio->bi_opf) || in_use <= CUTOFF_WRITEBACK;
> +	return op_is_sync(bio->bi_opf) || bio->bi_opf & (REQ_META|REQ_PRIO)
> +		|| in_use <= CUTOFF_WRITEBACK;
>  }
>  
>  static inline void bch_writeback_queue(struct cached_dev *dc)
> 
