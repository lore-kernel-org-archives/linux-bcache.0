From: Hubert Kempkensteffen <hubert-39zlLzowylnAQEp6PLVxx6xOck334EZe@public.gmane.org>
Subject: Re: [PATCH] bcache: Possible flush fix
Date: Wed, 18 Sep 2013 13:57:21 +0000 (UTC)
Message-ID: <loom.20130918T134845-142@post.gmane.org>
References: <loom.20130916T150548-751@post.gmane.org> <20130917020316.GC10907@kmo-pixel> <loom.20130917T122135-908@post.gmane.org> <20130917203741.GA32037@kmo-pixel> <loom.20130917T224603-574@post.gmane.org> <20130917214043.GF32037@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Kent Overstreet <kmo@...> writes:

> 
> Jens suggested that cloning the bio to issue a bare flush might be
> copying some flags we don't want, and at least allocating a new bio
> would be more correct. Worth a shot...
> 
> Signed-off-by: Kent Overstreet <kmo@...>
> ---
> 
> On Tue, Sep 17, 2013 at 08:54:57PM +0000, Hubert Kempkensteffen wrote:
> > Kent Overstreet <kmo <at> ...> writes:
> > Sorry, my english.
> > I have no raid and no LVM. There are both ordinary machines.
> > And I just want to speed up the data disk!
> > 
> > > 
> > > I think this bug requires something else in the stack to trigger, I'm
> > > trying to figure out what the common factor is.
> 
> Can you give this patch a try?
> 
>  drivers/md/bcache/request.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index afb9a99..c06840b 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
>  <at>  <at>  -1053,19 +1053,21  <at>  <at>  static void
request_write(struct cached_dev *dc, struct search *s)
>  		trace_bcache_writethrough(s->orig_bio);
>  		closure_bio_submit(bio, cl, s->d);
>  	} else {
> +		s->op.cache_bio = bio;
>  		trace_bcache_writeback(s->orig_bio);
>  		bch_writeback_add(dc, bio_sectors(bio));
> 
> -		if (s->op.flush_journal) {
> +		if (bio->bi_rw & REQ_FLUSH) {
>  			/* Also need to send a flush to the backing device */
> -			s->op.cache_bio = bio_clone_bioset(bio, GFP_NOIO,
> -							   dc->disk.bio_split);
> -
> -			bio->bi_size = 0;
> -			bio->bi_vcnt = 0;
> -			closure_bio_submit(bio, cl, s->d);
> -		} else {
> -			s->op.cache_bio = bio;
> +			struct bio *flush = bio_alloc_bioset(0, GFP_NOIO,
> +							     dc->disk.bio_split);
> +
> +			flush->bi_rw	= WRITE_FLUSH;
> +			flush->bi_bdev	= bio->bi_bdev;
> +			flush->bi_end_io = request_endio;
> +			flush->bi_private = cl;
> +
> +			closure_bio_submit(flush, cl, s->d);
>  		}
>  	}
>  out:

I am currently testing the patch. (writethrough)
The kernel is: git clone http://evilpiepirate.org/git/linux-bcache.git

I think it's a little bit better.
Up to 7 GB it goes very quickly (less than 10 minutes).
From there he slows down.
But he does not stop.
It looks as if the process sometimes stagnate and then run at once again
quickly.
Now it all already 2 hours for a total of 14 GB and it is not finished yet!

The command "sync" but I have not yet entered.

After the sync will copy even slower, but it goes on.
Only the sync command is not coming back.
I simply wait times is rsync is done or stops.
And then look at me again to sync.
He now has about 13 GB copied after 3 hours.
