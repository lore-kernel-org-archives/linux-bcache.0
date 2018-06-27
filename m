From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH V7 20/24] bcache: avoid to use bio_for_each_segment_all()
 in bch_bio_alloc_pages()
Date: Wed, 27 Jun 2018 23:55:33 +0800
Message-ID: <e1499d87-62b8-40a8-75a5-d9d1d81ce9c5@suse.de>
References: <20180627124548.3456-1-ming.lei@redhat.com>
 <20180627124548.3456-21-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180627124548.3456-21-ming.lei@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@infradead.org>, Kent Overstreet <kent.overstreet@gmail.com>, David Sterba <dsterba@suse.cz>, Huang Ying <ying.huang@intel.com>, Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>, "Darrick J . Wong" <darrick.wong@oracle.com>, Filipe Manana <fdmanana@gmail.com>, Randy Dunlap <rdunlap@infradead.org>, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2018/6/27 8:45 PM, Ming Lei wrote:
> bch_bio_alloc_pages() is always called on one new bio, so it is safe
> to access the bvec table directly. Given it is the only kind of this
> case, open code the bvec table access since bio_for_each_segment_all()
> will be changed to support for iterating over multipage bvec.
> 
> Cc: Coly Li <colyli@suse.de>
> Cc: linux-bcache@vger.kernel.org
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/md/bcache/util.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
> index fc479b026d6d..9f2a6fd5dfc9 100644
> --- a/drivers/md/bcache/util.c
> +++ b/drivers/md/bcache/util.c
> @@ -268,7 +268,7 @@ int bch_bio_alloc_pages(struct bio *bio, gfp_t gfp_mask)
>  	int i;
>  	struct bio_vec *bv;
> 

Hi Ming,

> -	bio_for_each_segment_all(bv, bio, i) {
> +	for (i = 0, bv = bio->bi_io_vec; i < bio->bi_vcnt; bv++) {


Is it possible to treat this as a special condition of
bio_for_each_segement_all() ? I mean only iterate one time in
bvec_for_each_segment(). I hope the above change is not our last choice
before I reply an Acked-by :-)

Thanks.

Coly Li

>  		bv->bv_page = alloc_page(gfp_mask);
>  		if (!bv->bv_page) {
>  			while (--bv >= bio->bi_io_vec)
> 
