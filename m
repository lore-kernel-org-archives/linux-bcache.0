From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/7] Use exported call to up/down read
Date: Sat, 10 Sep 2011 14:39:34 -0700
Message-ID: <20110910213933.GB32536@moria>
References: <1109101110320.2733@stax.localdomain>
 <1315662339-3115-1-git-send-email-mark@pogo.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1315662339-3115-1-git-send-email-mark-UrrBsZIrrsb10XsdtD+oqA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Hills <mark-UrrBsZIrrsb10XsdtD+oqA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Sat, Sep 10, 2011 at 02:45:33PM +0100, Mark Hills wrote:
> When building bcache as a module, the following errors are silenced
> by this patch:
> 
>   ERROR: "call_rwsem_down_read_failed" [block/bcache.ko] undefined!
>   ERROR: "call_rwsem_wake" [block/bcache.ko] undefined!
> 
> There may be implications of the extra code introduced by this, but
> I am not familiar with these functions. Though I can confirm that
> the resulting build seems to work.

Yeah, lockdep is going to complain loudly about that. The reason for the
__ versions is we release the lock in a different thread than we acquire
it in. There used to be down_read_non_owner() and up_read_non_owner(),
but those went away... I'll have to investigate further.

> ---
>  block/bcache.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/block/bcache.c b/block/bcache.c
> index a2dbd1e..faaf75e 100644
> --- a/block/bcache.c
> +++ b/block/bcache.c
> @@ -5561,7 +5561,7 @@ static void bio_complete(struct closure *cl)
>  	keylist_free(&s->op.keys);
>  
>  	if (s->op.insert_type & INSERT_WRITE)
> -		__up_read(&d->writeback_lock);
> +		up_read(&d->writeback_lock);
>  
>  	if (s->cache_bio) {
>  		int i;
> @@ -5911,7 +5911,7 @@ static void request_write(struct search *s)
>  	s->cl.fn		= bio_complete;
>  	s->op.insert_type	= INSERT_WRITE;
>  	check_should_skip(s);
> -	__down_read(&s->op.d->writeback_lock);
> +	down_read(&s->op.d->writeback_lock);
>  
>  	if (in_writeback(s->op.d, bio->bi_sector, bio_sectors(bio))) {
>  		s->skip = false;
> -- 
> 1.7.4.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
