From: Coly Li <i@coly.li>
Subject: Re: [PATCH 1/5] bcache: don't write back data if reading it failed
Date: Wed, 27 Sep 2017 16:22:59 +0800
Message-ID: <5831212f-a002-42f5-6aa5-9dc13e2c90ba@coly.li>
References: <20170926192423.10665-1-mlyle@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:58960 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751887AbdI0IX1 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 Sep 2017 04:23:27 -0400
In-Reply-To: <20170926192423.10665-1-mlyle@lyle.org>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: linux-bcache@vger.kernel.org

On 2017/9/27 上午3:24, Michael Lyle wrote:
> If an IO operation fails, and we didn't successfully read data from the
> cache, don't writeback invalid/partial data to the backing disk.
> 
> Signed-off-by: Michael Lyle <mlyle@lyle.org>
> ---
>  drivers/md/bcache/writeback.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index e663ca082183..eea49bf36401 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -179,13 +179,20 @@ static void write_dirty(struct closure *cl)
>  	struct dirty_io *io = container_of(cl, struct dirty_io, cl);
>  	struct keybuf_key *w = io->bio.bi_private;
>  
> -	dirty_init(w);
> -	bio_set_op_attrs(&io->bio, REQ_OP_WRITE, 0);
> -	io->bio.bi_iter.bi_sector = KEY_START(&w->key);
> -	bio_set_dev(&io->bio, io->dc->bdev);
> -	io->bio.bi_end_io	= dirty_endio;
> +	/* IO errors are signalled using the dirty bit on the key.
> +	 * If we failed to read, we should not attempt to write to the
> +	 * backing device.  Instead, immediately go to write_dirty_finish
> +	 * to clean up.
> +	 */
> +	if (KEY_DIRTY(&w->key)) {
Maybe it should be "if (!KEY_DIRTY(&w->key))" ? In dirty_endio(),
SET_KEY_DIRTY() is called only when bio->bi_status is not 0.


> +		dirty_init(w);
> +		bio_set_op_attrs(&io->bio, REQ_OP_WRITE, 0);
> +		io->bio.bi_iter.bi_sector = KEY_START(&w->key);
> +		bio_set_dev(&io->bio, io->dc->bdev);
> +		io->bio.bi_end_io	= dirty_endio;
>  
> -	closure_bio_submit(&io->bio, cl);
> +		closure_bio_submit(&io->bio, cl);
> +	}
>  
>  	continue_at(cl, write_dirty_finish, io->dc->writeback_write_wq);
>  }
> 


-- 
Coly Li
