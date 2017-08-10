From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 07/49] bcache: comment on direct access to bvec table
Date: Thu, 10 Aug 2017 04:26:03 -0700
Message-ID: <20170810112603.GD20308@infradead.org>
References: <20170808084548.18963-1-ming.lei@redhat.com>
 <20170808084548.18963-8-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170808084548.18963-8-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@infradead.org>, Huang Ying <ying.huang@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

I think all this bcache code needs bigger attention.  For one
bio_alloc_pages is only used in bcache, so we should move it in there.

Second the way  bio_alloc_pages is currently written looks potentially
dangerous for multi-page biovecs, so we should think about a better
calling convention.  The way bcache seems to generally use it is by
allocating a bio, then calling bch_bio_map on it and then calling
bio_alloc_pages.  I think it just needs a new bio_alloc_pages calling
convention that passes the size to be allocated and stop looking into
the segment count.

Second bch_bio_map isn't something we should be doing in a driver,
it should be rewritten using bio_add_page.

> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 866dcf78ff8e..3da595ae565b 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -431,6 +431,7 @@ static void do_btree_node_write(struct btree *b)
>  
>  		continue_at(cl, btree_node_write_done, NULL);
>  	} else {
> +		/* No harm for multipage bvec since the new is just allocated */
>  		b->bio->bi_vcnt = 0;

This should go away - bio_alloc_pages or it's replacement should not
modify bi_vcnt on failure.

> +	/* single page bio, safe for multipage bvec */
>  	dc->sb_bio.bi_io_vec[0].bv_page = sb_page;

needs to use bio_add_page.

> +	/* single page bio, safe for multipage bvec */
>  	ca->sb_bio.bi_io_vec[0].bv_page = sb_page;

needs to use bio_add_page.
