From: Coly Li <i@coly.li>
Subject: Re: [PATCH v3 33/49] bcache: convert to bio_for_each_segment_all_sp()
Date: Tue, 8 Aug 2017 20:35:14 +0800
Message-ID: <f3b2bce7-53c2-7381-aaca-3d5e66b70d1d@coly.li>
References: <20170808084548.18963-1-ming.lei@redhat.com>
 <20170808084548.18963-34-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170808084548.18963-34-ming.lei@redhat.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@infradead.org>, Huang Ying <ying.huang@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2017/8/8 下午4:45, Ming Lei wrote:
> Cc: linux-bcache@vger.kernel.org
> Signed-off-by: Ming Lei <ming.lei@redhat.com>

The patch is good to me. Thanks.

Acked-by: Coly Li <colyli@suse.de>

> ---
>  drivers/md/bcache/btree.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 3da595ae565b..74cbb7387dc5 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -422,8 +422,9 @@ static void do_btree_node_write(struct btree *b)
>  		int j;
>  		struct bio_vec *bv;
>  		void *base = (void *) ((unsigned long) i & ~(PAGE_SIZE - 1));
> +		struct bvec_iter_all bia;
>  
> -		bio_for_each_segment_all(bv, b->bio, j)
> +		bio_for_each_segment_all_sp(bv, b->bio, j, bia)
>  			memcpy(page_address(bv->bv_page),
>  			       base + j * PAGE_SIZE, PAGE_SIZE);
>  
> 


-- 
Coly Li
