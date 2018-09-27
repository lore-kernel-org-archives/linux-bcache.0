From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PATCH] bug fix in function check_should_bypass
Date: Thu, 27 Sep 2018 04:33:13 -0400
Message-ID: <20180927083313.GA29959@kmo-pixel>
References: <20180927082749.2243-1-cdbdyx@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180927082749.2243-1-cdbdyx@163.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dongbo Cao <cdbdyx@163.com>
Cc: colyli@suse.de, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On Thu, Sep 27, 2018 at 04:27:49PM +0800, Dongbo Cao wrote:
> bio->bi_iter.bi_sector is the sector index of current request, no need to be aligned.
> instead, bio->bi_iter.bi_size should be aligned to block_bytes-1, not block_size-1.
> and bio_sectors is the number of sectors of current request, also no need to be aligned, just remove it.

this isn't a bug fix, please don't label things as bug fixes that aren't.

also, it's wrong. an unaligned IO that overlaps with data already in the cache
will result in an extent in the cache with misaligned size, which will result in
misaligned IOs when reading from it.

> 
> Signed-off-by: Dongbo Cao <cdbdyx@163.com>
> ---
>  drivers/md/bcache/request.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 13d3355a..fb3502da 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -398,8 +398,7 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
>  	    !(bio->bi_opf & REQ_PRIO))
>  		goto skip;
>  
> -	if (bio->bi_iter.bi_sector & (c->sb.block_size - 1) ||
> -	    bio_sectors(bio) & (c->sb.block_size - 1)) {
> +	if (bio->bi_iter.bi_size & (block_bytes(c) - 1)) {
>  		pr_debug("skipping unaligned io");
>  		goto skip;
>  	}
> -- 
> 2.17.1
> 
> 
