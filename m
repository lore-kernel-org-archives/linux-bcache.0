From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 1/3] bcache: drop obsolete comments
Date: Sat, 27 Jul 2019 22:12:11 +0800
Message-ID: <e7645bf9-cfe1-107f-b212-7aaf6ea1f2e2@suse.de>
References: <1564222799-10603-1-git-send-email-baiyaowei@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1564222799-10603-1-git-send-email-baiyaowei@cmss.chinamobile.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Cc: kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2019/7/27 6:19 下午, Yaowei Bai wrote:
> Unused list was killed by commit 2531d9ee61fa ("bcache: Kill unused freelist")
> but left these comments, let's drop them.
> 
> This patch doesn't introduce functional change.
> 
> Signed-off-by: Yaowei Bai <baiyaowei@cmss.chinamobile.com>

Hi Yaowei,


> ---
>  drivers/md/bcache/alloc.c | 13 +++----------
>  drivers/md/bcache/super.c |  3 ---
>  2 files changed, 3 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
> index 6f77682..c22c260 100644
> --- a/drivers/md/bcache/alloc.c
> +++ b/drivers/md/bcache/alloc.c
> @@ -33,13 +33,6 @@
>   * If we've got discards enabled, that happens when a bucket moves from the
>   * free_inc list to the free list.
>   *
> - * There is another freelist, because sometimes we have buckets that we know
> - * have nothing pointing into them - these we can reuse without waiting for
> - * priorities to be rewritten. These come from freed btree nodes and buckets
> - * that garbage collection discovered no longer had valid keys pointing into
> - * them (because they were overwritten). That's the unused list - buckets on the
> - * unused list move to the free list, optionally being discarded in the process.
> - *
It seems the above comments can still be applied to free_inc list (if
s/freelist/free_inc list), am I right ?

>   * It's also important to ensure that gens don't wrap around - with respect to
>   * either the oldest gen in the btree or the gen on disk. This is quite
>   * difficult to do in practice, but we explicitly guard against it anyways - if
> @@ -323,9 +316,9 @@ static int bch_allocator_thread(void *arg)
>  
>  	while (1) {
>  		/*
> -		 * First, we pull buckets off of the unused and free_inc lists,
> -		 * possibly issue discards to them, then we add the bucket to
> -		 * the free list:
> +		 * First, we pull buckets off of the free_inc list, possibly
> +		 * issue discards to them, then we add the bucket to the free
> +		 * list:
>  		 */

I am OK with this.

>  		while (1) {
>  			long bucket;
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 26e374f..eba38aa 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -544,9 +544,6 @@ void bch_prio_write(struct cache *ca)
>  	atomic_long_add(ca->sb.bucket_size * prio_buckets(ca),
>  			&ca->meta_sectors_written);
>  
> -	//pr_debug("free %zu, free_inc %zu, unused %zu", fifo_used(&ca->free),
> -	//	 fifo_used(&ca->free_inc), fifo_used(&ca->unused));
> -

There is no freelist in the above code, I suggest to not include the
above change into this patch.


>  	for (i = prio_buckets(ca) - 1; i >= 0; --i) {
>  		long bucket;
>  		struct prio_set *p = ca->disk_buckets;
> 

Thanks.

-- 

Coly Li
