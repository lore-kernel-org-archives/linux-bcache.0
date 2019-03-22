From: Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: [PATCH] bcache: avoid clang -Wunintialized warning
Date: Fri, 22 Mar 2019 09:03:50 -0700
Message-ID: <20190322160350.GE21978@archlinux-ryzen>
References: <20190322143507.1256436-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190322143507.1256436-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Coly Li <colyli@suse.de>, Kent Overstreet <kent.overstreet@gmail.com>, clang-built-linux@googlegroups.com, Nick Desaulniers <ndesaulniers@google.com>, Jens Axboe <axboe@kernel.dk>, Shenghui Wang <shhuiw@foxmail.com>, Hannes Reinecke <hare@suse.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On Fri, Mar 22, 2019 at 03:35:00PM +0100, Arnd Bergmann wrote:
> clang has identified a code path in which it thinks a
> variable may be unused:
> 
> drivers/md/bcache/alloc.c:333:4: error: variable 'bucket' is used uninitialized whenever 'if' condition is false
>       [-Werror,-Wsometimes-uninitialized]
>                         fifo_pop(&ca->free_inc, bucket);
>                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/md/bcache/util.h:219:27: note: expanded from macro 'fifo_pop'
>  #define fifo_pop(fifo, i)       fifo_pop_front(fifo, (i))
>                                 ^~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/md/bcache/util.h:189:6: note: expanded from macro 'fifo_pop_front'
>         if (_r) {                                                       \
>             ^~
> drivers/md/bcache/alloc.c:343:46: note: uninitialized use occurs here
>                         allocator_wait(ca, bch_allocator_push(ca, bucket));
>                                                                   ^~~~~~
> drivers/md/bcache/alloc.c:287:7: note: expanded from macro 'allocator_wait'
>                 if (cond)                                               \
>                     ^~~~
> drivers/md/bcache/alloc.c:333:4: note: remove the 'if' if its condition is always true
>                         fifo_pop(&ca->free_inc, bucket);
>                         ^
> drivers/md/bcache/util.h:219:27: note: expanded from macro 'fifo_pop'
>  #define fifo_pop(fifo, i)       fifo_pop_front(fifo, (i))
>                                 ^
> drivers/md/bcache/util.h:189:2: note: expanded from macro 'fifo_pop_front'
>         if (_r) {                                                       \
>         ^
> drivers/md/bcache/alloc.c:331:15: note: initialize the variable 'bucket' to silence this warning
>                         long bucket;
>                                    ^
> 
> This cannot happen in practice because we only enter the loop
> if there is at least one element in the list.
> 
> Slightly rearranging the code makes this clearer to both the
> reader and the compiler, which avoids the warning.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Yes, I like this much better than my patch, thanks!

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

> ---
>  drivers/md/bcache/alloc.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
> index 5002838ea476..f8986effcb50 100644
> --- a/drivers/md/bcache/alloc.c
> +++ b/drivers/md/bcache/alloc.c
> @@ -327,10 +327,11 @@ static int bch_allocator_thread(void *arg)
>  		 * possibly issue discards to them, then we add the bucket to
>  		 * the free list:
>  		 */
> -		while (!fifo_empty(&ca->free_inc)) {
> +		while (1) {
>  			long bucket;
>  
> -			fifo_pop(&ca->free_inc, bucket);
> +			if (!fifo_pop(&ca->free_inc, bucket))
> +				break;
>  
>  			if (ca->discard) {
>  				mutex_unlock(&ca->set->bucket_lock);
> -- 
> 2.20.0
> 
