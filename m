From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: Zero initialize bucket in bch_allocator_thread
Date: Fri, 8 Mar 2019 10:10:20 +0800
Message-ID: <94c7f399-7101-2297-43e0-834f50c3510f@suse.de>
References: <20190307221054.13126-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190307221054.13126-1-natechancellor@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com, Nick Desaulniers <ndesaulniers@google.com>
List-Id: linux-bcache@vger.kernel.org

On 2019/3/8 6:10 上午, Nathan Chancellor wrote:
> When building with -Wsometimes-uninitialized, Clang warns:
> 
> drivers/md/bcache/alloc.c:333:4: warning: variable 'bucket' is used
> uninitialized whenever 'if' condition is false
> [-Wsometimes-uninitialized]
> 
> fifo_pop expands to a conditional depending on '!fifo_empty(...)', which
> is the same condition as the while loop. It seems Clang can't piece
> together that this condition will never been false as long as we are in
> the while loop because they are the same condition. It's easy enough to
> silence this warning by just explicitly zero initializing bucket.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/396
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Hi Nathan,

Nice catch, I will add it to my for-test. Thanks.

Coly Li

> ---
>  drivers/md/bcache/alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
> index 5002838ea476..c72094901ac6 100644
> --- a/drivers/md/bcache/alloc.c
> +++ b/drivers/md/bcache/alloc.c
> @@ -328,7 +328,7 @@ static int bch_allocator_thread(void *arg)
>  		 * the free list:
>  		 */
>  		while (!fifo_empty(&ca->free_inc)) {
> -			long bucket;
> +			long bucket = 0;
>  
>  			fifo_pop(&ca->free_inc, bucket);
>  
> 


-- 

Coly Li
