From: Slava Pestov <sp@datera.io>
Subject: Re: Using vmalloc instead of get_free_pages?
Date: Sun, 28 Dec 2014 20:09:37 -0800
Message-ID: <CACHGV4LPBS1Y-9ciKBpPGeeF9yuF9zfPySYbBSM12m6s+8VmDw@mail.gmail.com>
References: <20141226142206.GA27239@cuci.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:62397 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbaL2EJi (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sun, 28 Dec 2014 23:09:38 -0500
Received: by mail-la0-f43.google.com with SMTP id s18so10748788lam.30
        for <linux-bcache@vger.kernel.org>; Sun, 28 Dec 2014 20:09:37 -0800 (PST)
In-Reply-To: <20141226142206.GA27239@cuci.nl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Stephen R. van den Berg" <srb@cuci.nl>
Cc: linux-bcache@vger.kernel.org

Hi Stephen,

On Sat, Dec 27, 2014 at 2:52 AM, Stephen R. van den Berg <srb@cuci.nl> wrote:
> I have a system with currently:
> 4 x 6TB HDD backing devices  (it will expand to 12 x 8TB HDD)
> 2 x 490GB SSD caching devices
> 16GB RAM
> 16GB Swap
>
> I intend to:
> a. Use BTRFS using ncopies=3 (three way mirroring) for data and metadata
>    on the backing devices.
> b. Use the two SSD caches as a non-redundant (striped) bcache for the
>    whole HDD set.
>
> In trying to do this I notice:
>
> - That the amount of memory being allocated for a single caching device
>   exceeds maximum the amount allocatable by get_free_pages(), so I changed
>   that to use vzalloc(), which seems to work (patch included).
>   Is there any direct io from that area which requires special handling?

As you've already noticed this is fixed in bcache-dev, but that brings
in a huge set of changes. I think this change can be upstreamed pretty
easily in isolation. Kent (and myself) has been busy with other work
stuff but I hope he can prepare another pull request soon. There are a
number of important bug fixes that need to get cherry-picked from
bcache-dev.

>
> - bcache does not allow more than one cache device per set.  Is simply
>   allowing this in make-bcache enough to get this working, or does it need
>   code changes in the driver to allow for this?

Support for multiple cache devices is in bcache-dev, it requires
changes to both make-bcache and the kernel. I'm not sure what the time
frame for upstreaming this is, since the changes are more involved.

>
> commit 65e977a48967804a63487273a47ad39e26f39970
> Author: Stephen R. van den Berg <srb@cuci.nl>
> Date:   Thu Dec 25 13:54:42 2014 +0100
>
>     Use vmalloc for alloc_bucket_pages.
>
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 4dd2bb7..cbba7ec 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1339,6 +1339,8 @@ void bch_cache_set_release(struct kobject *kobj)
>         module_put(THIS_MODULE);
>  }
>
> +#define free_bucket_pages(p, c)                (vfree((void*) (p)))
> +
>  static void cache_set_free(struct closure *cl)
>  {
>         struct cache_set *c = container_of(cl, struct cache_set, cl);
> @@ -1360,7 +1362,7 @@ static void cache_set_free(struct closure *cl)
>                 }
>
>         bch_bset_sort_state_free(&c->sort);
> -       free_pages((unsigned long) c->uuids, ilog2(bucket_pages(c)));
> +       free_bucket_pages(c->uuids, c);
>
>         if (c->moving_gc_wq)
>                 destroy_workqueue(c->moving_gc_wq);
> @@ -1462,7 +1464,7 @@ void bch_cache_set_unregister(struct cache_set *c)
>  }
>
>  #define alloc_bucket_pages(gfp, c)                     \
> -       ((void *) __get_free_pages(__GFP_ZERO|gfp, ilog2(bucket_pages(c))))
> +       ((void *) vzalloc(bucket_pages(c)<<PAGE_SHIFT))
>
>  struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
>  {
> @@ -1801,7 +1803,7 @@ void bch_cache_release(struct kobject *kobj)
>
>         bio_split_pool_free(&ca->bio_split_hook);
>
> -       free_pages((unsigned long) ca->disk_buckets, ilog2(bucket_pages(ca)));
> +       free_bucket_pages(ca->disk_buckets, ca);
>         kfree(ca->prio_buckets);
>         vfree(ca->buckets);
>
> --
> Stephen.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
