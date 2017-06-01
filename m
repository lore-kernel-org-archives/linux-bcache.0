From: Coly Li <i@coly.li>
Subject: Re: [PATCH] bcache: initialize stripe_sectors_dirty correctly for
 thin flash device
Date: Thu, 1 Jun 2017 19:45:39 +0800
Message-ID: <8df0e7d9-9ac2-0620-08cd-e56dcc982bfe@coly.li>
References: <1496306884-7808-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:42046 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750952AbdFALpq (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 1 Jun 2017 07:45:46 -0400
In-Reply-To: <1496306884-7808-1-git-send-email-tang.junhui@zte.com.cn>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn, kent.overstreet@gmail.com, bcache@lists.ewheeler.net
Cc: linux-bcache@vger.kernel.org

On 2017/6/1 下午4:48, tang.junhui@zte.com.cn wrote:
> From: Tang Junhui <tang.junhui@zte.com.cn>
> 
> Thin flash device does not initialize stripe_sectors_dirty correctly, this
> patch fixes this issue.
> 

Junhui,

Please, please, could you please provide more patch comments, why this
is a bug and how things go wrong without your patch, and get fixed with
you patch.

I do appreciate for your informative patch comment :-)

Coly

> Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
> ---
>  drivers/md/bcache/super.c     | 3 ++-
>  drivers/md/bcache/writeback.c | 8 ++++----
>  drivers/md/bcache/writeback.h | 2 +-
>  3 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 3a19cbc..cccd686 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1028,7 +1028,7 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c)
>  	}
>  
>  	if (BDEV_STATE(&dc->sb) == BDEV_STATE_DIRTY) {
> -		bch_sectors_dirty_init(dc);
> +		bch_sectors_dirty_init(&dc->disk);
>  		atomic_set(&dc->has_dirty, 1);
>  		atomic_inc(&dc->count);
>  		bch_writeback_queue(dc);
> @@ -1230,6 +1230,7 @@ static int flash_dev_run(struct cache_set *c, struct uuid_entry *u)
>  		goto err;
>  
>  	bcache_device_attach(d, c, u - c->uuids);
> +	bch_sectors_dirty_init(d);
>  	bch_flash_dev_request_init(d);
>  	add_disk(d->disk);
>  
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index 69e1ae5..8d77403 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -481,17 +481,17 @@ static int sectors_dirty_init_fn(struct btree_op *_op, struct btree *b,
>  	return MAP_CONTINUE;
>  }
>  
> -void bch_sectors_dirty_init(struct cached_dev *dc)
> +void bch_sectors_dirty_init(struct bcache_device *d)
>  {
>  	struct sectors_dirty_init op;
>  
>  	bch_btree_op_init(&op.op, -1);
> -	op.inode = dc->disk.id;
> +	op.inode = d->id;
>  
> -	bch_btree_map_keys(&op.op, dc->disk.c, &KEY(op.inode, 0, 0),
> +	bch_btree_map_keys(&op.op, d->c, &KEY(op.inode, 0, 0),
>  			   sectors_dirty_init_fn, 0);
>  
> -	dc->disk.sectors_dirty_last = bcache_dev_sectors_dirty(&dc->disk);
> +	d->sectors_dirty_last = bcache_dev_sectors_dirty(d);
>  }
>  
>  void bch_cached_dev_writeback_init(struct cached_dev *dc)
> diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
> index 629bd1a..c992f06 100644
> --- a/drivers/md/bcache/writeback.h
> +++ b/drivers/md/bcache/writeback.h
> @@ -84,7 +84,7 @@ static inline void bch_writeback_add(struct cached_dev *dc)
>  
>  void bcache_dev_sectors_dirty_add(struct cache_set *, unsigned, uint64_t, int);
>  
> -void bch_sectors_dirty_init(struct cached_dev *dc);
> +void bch_sectors_dirty_init(struct bcache_device *);
>  void bch_cached_dev_writeback_init(struct cached_dev *);
>  int bch_cached_dev_writeback_start(struct cached_dev *);
>  
> 


-- 
Coly Li
