From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] bcache: fix a livelock in btree lock
Date: Wed, 25 Feb 2015 20:11:15 +0800
Message-ID: <20150225121115.GA11562@gmail.com>
References: <1422962468-25011-1-git-send-email-jschmid@suse.com>
 <CAC8teKVatzjZS9RSixtXCxbKe52Ji9VYi_haO878ED_fhtBreA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36743 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbbBYL6J (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 25 Feb 2015 06:58:09 -0500
Received: by pabkq14 with SMTP id kq14so4789906pab.3
        for <linux-bcache@vger.kernel.org>; Wed, 25 Feb 2015 03:58:09 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAC8teKVatzjZS9RSixtXCxbKe52Ji9VYi_haO878ED_fhtBreA@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Zhu Yanhai <zhu.yanhai@gmail.com>
Cc: Joshua Schmid <jschmid@suse.com>, linux-bcache@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>

On Wed, Feb 04, 2015 at 11:00:40AM +0800, Zhu Yanhai wrote:
> Zheng,
> 
> It should be 'op->lock = b->level', not 'op->lock = b->c->root->level
> + 1', otherwise we will stop all concurrency writes unconditionally in
> the second round. Isn't it?

You're right.  I will fix this problem and re-send the patch that will
be rebased against the latest upstream kernel.

Thanks,
                                                - Zheng

> 
> -zyh
> 
> 2015-02-03 19:21 GMT+08:00 Joshua Schmid <jschmid@suse.com>:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> >
> > This commit tries to fix a livelock in bcache.  This livelock might
> > happen when we causes a huge number of cache misses simultaneously.
> >
> > When we get a cache miss, bcache will execute the following path.
> >
> > ->cached_dev_make_request()
> >   ->cached_dev_read()
> >     ->cached_lookup()
> >       ->bch->btree_map_keys()
> >         ->btree_root()  <------------------------
> >           ->bch_btree_map_keys_recurse()        |
> >             ->cache_lookup_fn()                 |
> >               ->cached_dev_cache_miss()         |
> >                 ->bch_btree_insert_check_key() -|
> >                   [If btree->seq is not equal to seq + 1, we should return
> >                    EINTR and traverse btree again.]
> >
> > In bch_btree_insert_check_key() function we first need to check upgrade
> > flag (op->lock == -1), and when this flag is true we need to release
> > read btree->lock and try to take write btree->lock.  During taking and
> > releasing this write lock, btree->seq will be monotone increased in
> > order to prevent other threads modify this in cache miss (see btree.h:74).
> > But if there are some cache misses caused by some requested, we could
> > meet a livelock because btree->seq is always changed by others.  Thus no
> > one can make progress.
> >
> > This commit will try to take write btree->lock if it encounters a race
> > when we traverse btree.  Although it sacrifice the scalability but we
> > can ensure that only one can modify the btree.
> >
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > Tested-by: Joshua Schmid <jschmid@suse.com>
> > ---
> >  drivers/md/bcache/btree.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> > index 218f21a..f1c224f 100644
> > --- a/drivers/md/bcache/btree.c
> > +++ b/drivers/md/bcache/btree.c
> > @@ -2163,8 +2163,10 @@ int bch_btree_insert_check_key(struct btree *b, struct btree_op *op,
> >                 rw_lock(true, b, b->level);
> >
> >                 if (b->key.ptr[0] != btree_ptr ||
> > -                   b->seq != seq + 1)
> > +                   b->seq != seq + 1) {
> > +                       op->lock = b->c->root->level + 1;
> >                         goto out;
> > +               }
> >         }
> >
> >         SET_KEY_PTRS(check_key, 1);
> > --
> > 2.1.2
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
