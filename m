From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH -next 1/3] bcache: Add missing #include
 <linux/prefetch.h>
Date: Sun, 7 Apr 2013 14:15:49 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1304071415220.3441@chino.kir.corp.google.com>
References: <1364406990-20541-1-git-send-email-geert@linux-m68k.org> <20130327182150.GB25906@google.com> <51533A2E.2000501@infradead.org> <20130327195050.GB22232@google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20130327195050.GB22232@google.com>
Sender: linux-next-owner@vger.kernel.org
To: Kent Overstreet <koverstreet@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, Geert Uytterhoeven <geert@linux-m68k.org>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On Wed, 27 Mar 2013, Kent Overstreet wrote:

> Nope - looks like __WARN() doesn't exist if CONFIG_BUG=n, whoops.
> 
> Adding this to the queue:
> 
> commit 796c213186b850b3e6e8d5fd5799b0fd74721ea3
> Author: Kent Overstreet <koverstreet@google.com>
> Date:   Wed Mar 27 12:47:45 2013 -0700
> 
>     bcache: Use WARN_ONCE() instead of __WARN()
>     
>     Signed-off-by: Kent Overstreet <koverstreet@google.com>
> 
> diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
> index d4f2164..cb4578a 100644
> --- a/drivers/md/bcache/bset.c
> +++ b/drivers/md/bcache/bset.c
> @@ -883,7 +883,7 @@ struct bkey *bch_btree_iter_next(struct btree_iter *iter)
>  		iter->data->k = bkey_next(iter->data->k);
>  
>  		if (iter->data->k > iter->data->end) {
> -			__WARN();
> +			WARN_ONCE(1, "bset was corrupt!\n");
>  			iter->data->k = iter->data->end;
>  		}
>  

This problem still persists in linux-next as of today, how is this fix 
being pushed?
