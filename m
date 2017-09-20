From: Coly Li <colyli@suse.de>
Subject: Re: [PATCHv2] bcache: option for allow stale data on read failure
Date: Wed, 20 Sep 2017 21:38:59 +0200
Message-ID: <eaeaf505-92b1-7d45-9b42-64f9d3f05e0b@suse.de>
References: <20170919222433.24336-1-colyli@suse.de>
 <20170920160735.jp4riq7x3qc472px@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170920160735.jp4riq7x3qc472px@kmo-pixel>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Nix <nix@esperi.org.uk>, Kai Krakow <hurikhan77@gmail.com>, Eric Wheeler <bcache@lists.ewheeler.net>, Junhui Tang <tang.junhui@zte.com.cn>, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2017/9/20 下午6:07, Kent Overstreet wrote:
> On Wed, Sep 20, 2017 at 06:24:33AM +0800, Coly Li wrote:
>> When bcache does read I/Os, for example in writeback or writethrough mode,
>> if a read request on cache device is failed, bcache will try to recovery
>> the request by reading from cached device. If the data on cached device is
>> not synced with cache device, then requester will get a stale data.
>>
>> For critical storage system like database, providing stale data from
>> recovery may result an application level data corruption, which is
>> unacceptible. But for some other situation like multi-media stream cache,
>> continuous service may be more important and it is acceptible to fetch
>> a chunk of stale data.
>>
>> This patch tries to solve the above conflict by adding a sysfs option
>> 	/sys/block/bcache<idx>/bcache/allow_stale_data_on_failure
>> which is defaultly cleared (to 0) as disabled. Now people can make choices
>> for different situations.
> 
> IMO this is just a bug, I'd rather not have an option to keep the buggy
> behaviour. How about this patch:
> 

Hi Kent,

OK, last time when I discuss with other bcache developers, people wanted
to keep this behavior, then I modify it as an option in this version
patch. I support fix it without an option, because there are too many
options already. Good to know you have similar decision :-)


> commit 2746f9c1f962288d8c5d7dabe698bf7b3fddd405
> Author: Kent Overstreet <kent.overstreet@gmail.com>
> Date:   Wed Sep 20 18:06:37 2017 +0200
> 
>     bcache: Don't recover from IO errors when reading dirty data
>     
>     Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
> 
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 382397772a..c2d57ef953 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -532,8 +532,10 @@ static int cache_lookup_fn(struct btree_op *op, struct btree *b, struct bkey *k)
>  
>  	PTR_BUCKET(b->c, k, ptr)->prio = INITIAL_PRIO;
>  
> -	if (KEY_DIRTY(k))
> +	if (KEY_DIRTY(k)) {
>  		s->read_dirty_data = true;
> +		s->recoverable = false;
> +	}
>  

I though of fixing here, the reason I gave up to modify here was,
cache_lookup_fn() is called for keys in leaf nodes (b->level == 0),
bch_btree_map_keys_recurse() needs to do I/O to fetch upper level nodes
before accessing leaf node. When a SSD failed bch_btree_node_get() will
fail before cache_lookup_fn() is executed. So the your patch, there is
no chance to set s->recoverable to false, recovery still happens.

If you don't like an option, the following modification should be much
simpler,

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 681b4f12b05a..f397785d9c38 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -697,8 +697,10 @@ static void cached_dev_read_error(struct closure *cl)
 {
        struct search *s = container_of(cl, struct search, cl);
        struct bio *bio = &s->bio.bio;
+       struct cached_dev *dc = container_of(s->d, struct cached_dev, disk);

-       if (s->recoverable) {
+       if (s->recoverable &&
+           (dc && !atomic_read(&dc->has_dirty)) {
                /* Retry from the backing device: */
                trace_bcache_read_retry(s->orig_bio);

This might be the simplest way I know for now.

Thanks.

Coly Li
