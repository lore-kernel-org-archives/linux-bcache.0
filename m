From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 11/12] closures: closure_wait_event()
Date: Tue, 11 Jun 2019 18:25:22 +0800
Message-ID: <3130eb62-e3b7-12d7-e724-7d549c68b6cf@suse.de>
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
 <20190610191420.27007-12-kent.overstreet@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190610191420.27007-12-kent.overstreet@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2019/6/11 3:14 上午, Kent Overstreet wrote:
> Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>

Acked-by: Coly Li <colyli@suse.de>

Thanks.

Coly Li

> ---
>  include/linux/closure.h | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/include/linux/closure.h b/include/linux/closure.h
> index 308e38028c..abacb91c35 100644
> --- a/include/linux/closure.h
> +++ b/include/linux/closure.h
> @@ -379,4 +379,26 @@ static inline void closure_call(struct closure *cl, closure_fn fn,
>  	continue_at_nobarrier(cl, fn, wq);
>  }
>  
> +#define __closure_wait_event(waitlist, _cond)				\
> +do {									\
> +	struct closure cl;						\
> +									\
> +	closure_init_stack(&cl);					\
> +									\
> +	while (1) {							\
> +		closure_wait(waitlist, &cl);				\
> +		if (_cond)						\
> +			break;						\
> +		closure_sync(&cl);					\
> +	}								\
> +	closure_wake_up(waitlist);					\
> +	closure_sync(&cl);						\
> +} while (0)
> +
> +#define closure_wait_event(waitlist, _cond)				\
> +do {									\
> +	if (!(_cond))							\
> +		__closure_wait_event(waitlist, _cond);			\
> +} while (0)
> +
>  #endif /* _LINUX_CLOSURE_H */
> 


-- 

Coly Li
