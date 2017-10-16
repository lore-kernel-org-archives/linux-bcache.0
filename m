From: Coly Li <i@coly.li>
Subject: Re: [PATCH] bcache: writeback rate clamping: make 32 bit safe
Date: Tue, 17 Oct 2017 01:52:33 +0800
Message-ID: <4c2ec14d-112c-5f32-5860-b5ea1836785a@coly.li>
References: <20171016173447.27253-1-mlyle@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:53534 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753012AbdJPRwi (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 16 Oct 2017 13:52:38 -0400
In-Reply-To: <20171016173447.27253-1-mlyle@lyle.org>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk

On 2017/10/17 上午1:34, Michael Lyle wrote:
> Sorry this got through to linux-block, was detected by the kbuilds test
> robot.  NSEC_PER_SEC is a long constant; 2.5 * 10^9 doesn't fit in a
> signed long constant.
> 
> Signed-off-by: Michael Lyle <mlyle@lyle.org>

I forgot i386 config... sorry too...

Reviewed-by: Coly Li <colyli@suse.de>

Thanks to Michael for the fix.

Coly Li

> ---
>  drivers/md/bcache/util.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
> index 4dbe37e82877..e548b8b51322 100644
> --- a/drivers/md/bcache/util.c
> +++ b/drivers/md/bcache/util.c
> @@ -238,8 +238,8 @@ uint64_t bch_next_delay(struct bch_ratelimit *d, uint64_t done)
>  	 * don't let us sleep more than 2.5 seconds (so we can notice/respond
>  	 * if the control system tells us to speed up!).
>  	 */
> -	if (time_before64(now + NSEC_PER_SEC * 5 / 2, d->next))
> -		d->next = now + NSEC_PER_SEC * 5 / 2;
> +	if (time_before64(now + NSEC_PER_SEC * 5LLU / 2LLU, d->next))
> +		d->next = now + NSEC_PER_SEC * 5LLU / 2LLU;
>  
>  	if (time_after64(now - NSEC_PER_SEC * 2, d->next))
>  		d->next = now - NSEC_PER_SEC * 2;
