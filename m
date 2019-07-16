From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 12/12] closures: fix a race on wakeup from closure_sync
Date: Tue, 16 Jul 2019 18:47:27 +0800
Message-ID: <8381178e-4c1e-e0fe-430b-a459be1a9389@suse.de>
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
 <20190610191420.27007-13-kent.overstreet@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190610191420.27007-13-kent.overstreet@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

Hi Kent,

On 2019/6/11 3:14 上午, Kent Overstreet wrote:
> Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
Acked-by: Coly Li <colyli@suse.de>

And also I receive report for suspicious closure race condition in
bcache, and people ask for having this patch into Linux v5.3.

So before this patch gets merged into upstream, I plan to rebase it to
drivers/md/bcache/closure.c at this moment. Of cause the author is you.

When lib/closure.c merged into upstream, I will rebase all closure usage
from bcache to use lib/closure.{c,h}.

Thanks in advance.

Coly Li

> ---
>  lib/closure.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/closure.c b/lib/closure.c
> index 46cfe4c382..3e6366c262 100644
> --- a/lib/closure.c
> +++ b/lib/closure.c
> @@ -104,8 +104,14 @@ struct closure_syncer {
>  
>  static void closure_sync_fn(struct closure *cl)
>  {
> -	cl->s->done = 1;
> -	wake_up_process(cl->s->task);
> +	struct closure_syncer *s = cl->s;
> +	struct task_struct *p;
> +
> +	rcu_read_lock();
> +	p = READ_ONCE(s->task);
> +	s->done = 1;
> +	wake_up_process(p);
> +	rcu_read_unlock();
>  }
>  
>  void __sched __closure_sync(struct closure *cl)
> 


-- 

Coly Li
