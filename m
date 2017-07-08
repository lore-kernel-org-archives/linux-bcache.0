From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 19/19] bcache: Update continue_at() documentation
Date: Sun, 9 Jul 2017 02:12:04 +0800
Message-ID: <ac46765e-ce55-8c08-bdeb-1c0c577b3fcc@suse.de>
References: <20170629134510.GA32385@infradead.org>
 <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
 <1498855388-16990-19-git-send-email-bcache@lists.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1498855388-16990-19-git-send-email-bcache@lists.ewheeler.net>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: bcache@lists.ewheeler.net, linux-block@vger.kernel.org
Cc: linux-bcache@vger.kernel.org, hch@infradead.org, axboe@kernel.dk, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: linux-bcache@vger.kernel.org

On 2017/7/1 上午4:43, bcache@lists.ewheeler.net wrote:
> From: Dan Carpenter <dan.carpenter@oracle.com>
> 
> continue_at() doesn't have a return statement anymore.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Coly Li <colyli@suse.de>

Thanks.

Coly

> ---
>  drivers/md/bcache/closure.h | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/md/bcache/closure.h b/drivers/md/bcache/closure.h
> index 1ec84ca..295b7e4 100644
> --- a/drivers/md/bcache/closure.h
> +++ b/drivers/md/bcache/closure.h
> @@ -312,8 +312,6 @@ static inline void closure_wake_up(struct closure_waitlist *list)
>   * been dropped with closure_put()), it will resume execution at @fn running out
>   * of @wq (or, if @wq is NULL, @fn will be called by closure_put() directly).
>   *
> - * NOTE: This macro expands to a return in the calling function!
> - *
>   * This is because after calling continue_at() you no longer have a ref on @cl,
>   * and whatever @cl owns may be freed out from under you - a running closure fn
>   * has a ref on its own closure which continue_at() drops.
> @@ -340,8 +338,6 @@ do {									\
>   * Causes @fn to be executed out of @cl, in @wq context (or called directly if
>   * @wq is NULL).
>   *
> - * NOTE: like continue_at(), this macro expands to a return in the caller!
> - *
>   * The ref the caller of continue_at_nobarrier() had on @cl is now owned by @fn,
>   * thus it's not safe to touch anything protected by @cl after a
>   * continue_at_nobarrier().
> 
