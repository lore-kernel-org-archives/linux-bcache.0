From: tang.junhui@zte.com.cn
Subject: Re: [PATCH 1/5] bcache: don't write back data if reading it failed
Date: Wed, 27 Sep 2017 11:27:54 +0800
Message-ID: <1506482874-6530-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: mlyle@lyle.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Tang Junhui <tang.junhui@zte.com.cn>
List-Id: linux-bcache@vger.kernel.org

From: Tang Junhui <tang.junhui@zte.com.cn>

It looks good to me,
I have noted this issue before.
Thanks.

-------
Tang Junhui

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
>  		 struct dirty_io *io = container_of(cl, struct dirty_io, cl);
>  		 struct keybuf_key *w = io->bio.bi_private;
>  
> -		 dirty_init(w);
> -		 bio_set_op_attrs(&io->bio, REQ_OP_WRITE, 0);
> -		 io->bio.bi_iter.bi_sector = KEY_START(&w->key);
> -		 bio_set_dev(&io->bio, io->dc->bdev);
> -		 io->bio.bi_end_io		 = dirty_endio;
> +		 /* IO errors are signalled using the dirty bit on the key.
> +		  * If we failed to read, we should not attempt to write to the
> +		  * backing device.  Instead, immediately go to write_dirty_finish
> +		  * to clean up.
> +		  */
> +		 if (KEY_DIRTY(&w->key)) {
> +		 		 dirty_init(w);
> +		 		 bio_set_op_attrs(&io->bio, REQ_OP_WRITE, 0);
> +		 		 io->bio.bi_iter.bi_sector = KEY_START(&w->key);
> +		 		 bio_set_dev(&io->bio, io->dc->bdev);
> +		 		 io->bio.bi_end_io		 = dirty_endio;
>  
> -		 closure_bio_submit(&io->bio, cl);
> +		 		 closure_bio_submit(&io->bio, cl);
> +		 }
>  
>  		 continue_at(cl, write_dirty_finish, io->dc->writeback_write_wq);
>  }
> -- 
