From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PATCHv2] bcache: option for allow stale data on read failure
Date: Wed, 20 Sep 2017 18:07:35 +0200
Message-ID: <20170920160735.jp4riq7x3qc472px@kmo-pixel>
References: <20170919222433.24336-1-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170919222433.24336-1-colyli@suse.de>
Sender: stable-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Nix <nix@esperi.org.uk>, Kai Krakow <hurikhan77@gmail.com>, Eric Wheeler <bcache@lists.ewheeler.net>, Junhui Tang <tang.junhui@zte.com.cn>, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On Wed, Sep 20, 2017 at 06:24:33AM +0800, Coly Li wrote:
> When bcache does read I/Os, for example in writeback or writethrough mode,
> if a read request on cache device is failed, bcache will try to recovery
> the request by reading from cached device. If the data on cached device is
> not synced with cache device, then requester will get a stale data.
> 
> For critical storage system like database, providing stale data from
> recovery may result an application level data corruption, which is
> unacceptible. But for some other situation like multi-media stream cache,
> continuous service may be more important and it is acceptible to fetch
> a chunk of stale data.
> 
> This patch tries to solve the above conflict by adding a sysfs option
> 	/sys/block/bcache<idx>/bcache/allow_stale_data_on_failure
> which is defaultly cleared (to 0) as disabled. Now people can make choices
> for different situations.

IMO this is just a bug, I'd rather not have an option to keep the buggy
behaviour. How about this patch:

commit 2746f9c1f962288d8c5d7dabe698bf7b3fddd405
Author: Kent Overstreet <kent.overstreet@gmail.com>
Date:   Wed Sep 20 18:06:37 2017 +0200

    bcache: Don't recover from IO errors when reading dirty data
    
    Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 382397772a..c2d57ef953 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -532,8 +532,10 @@ static int cache_lookup_fn(struct btree_op *op, struct btree *b, struct bkey *k)
 
 	PTR_BUCKET(b->c, k, ptr)->prio = INITIAL_PRIO;
 
-	if (KEY_DIRTY(k))
+	if (KEY_DIRTY(k)) {
 		s->read_dirty_data = true;
+		s->recoverable = false;
+	}
 
 	n = bio_next_split(bio, min_t(uint64_t, INT_MAX,
 				      KEY_OFFSET(k) - bio->bi_iter.bi_sector),
