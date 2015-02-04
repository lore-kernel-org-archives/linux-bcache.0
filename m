From: Zhu Yanhai <zhu.yanhai@gmail.com>
Subject: Re: [PATCH] bcache: fix a livelock in btree lock
Date: Wed, 4 Feb 2015 11:00:40 +0800
Message-ID: <CAC8teKVatzjZS9RSixtXCxbKe52Ji9VYi_haO878ED_fhtBreA@mail.gmail.com>
References: <1422962468-25011-1-git-send-email-jschmid@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:57099 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbbBDDBL (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 3 Feb 2015 22:01:11 -0500
Received: by mail-qc0-f180.google.com with SMTP id r5so38545701qcx.11
        for <linux-bcache@vger.kernel.org>; Tue, 03 Feb 2015 19:01:10 -0800 (PST)
In-Reply-To: <1422962468-25011-1-git-send-email-jschmid@suse.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Joshua Schmid <jschmid@suse.com>
Cc: linux-bcache@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>

Zheng,

It should be 'op->lock = b->level', not 'op->lock = b->c->root->level
+ 1', otherwise we will stop all concurrency writes unconditionally in
the second round. Isn't it?

-zyh

2015-02-03 19:21 GMT+08:00 Joshua Schmid <jschmid@suse.com>:
> From: Zheng Liu <wenqing.lz@taobao.com>
>
> This commit tries to fix a livelock in bcache.  This livelock might
> happen when we causes a huge number of cache misses simultaneously.
>
> When we get a cache miss, bcache will execute the following path.
>
> ->cached_dev_make_request()
>   ->cached_dev_read()
>     ->cached_lookup()
>       ->bch->btree_map_keys()
>         ->btree_root()  <------------------------
>           ->bch_btree_map_keys_recurse()        |
>             ->cache_lookup_fn()                 |
>               ->cached_dev_cache_miss()         |
>                 ->bch_btree_insert_check_key() -|
>                   [If btree->seq is not equal to seq + 1, we should return
>                    EINTR and traverse btree again.]
>
> In bch_btree_insert_check_key() function we first need to check upgrade
> flag (op->lock == -1), and when this flag is true we need to release
> read btree->lock and try to take write btree->lock.  During taking and
> releasing this write lock, btree->seq will be monotone increased in
> order to prevent other threads modify this in cache miss (see btree.h:74).
> But if there are some cache misses caused by some requested, we could
> meet a livelock because btree->seq is always changed by others.  Thus no
> one can make progress.
>
> This commit will try to take write btree->lock if it encounters a race
> when we traverse btree.  Although it sacrifice the scalability but we
> can ensure that only one can modify the btree.
>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> Tested-by: Joshua Schmid <jschmid@suse.com>
> ---
>  drivers/md/bcache/btree.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 218f21a..f1c224f 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -2163,8 +2163,10 @@ int bch_btree_insert_check_key(struct btree *b, struct btree_op *op,
>                 rw_lock(true, b, b->level);
>
>                 if (b->key.ptr[0] != btree_ptr ||
> -                   b->seq != seq + 1)
> +                   b->seq != seq + 1) {
> +                       op->lock = b->c->root->level + 1;
>                         goto out;
> +               }
>         }
>
>         SET_KEY_PTRS(check_key, 1);
> --
> 2.1.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
