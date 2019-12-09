From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] [PATCH] bcache: __write_super to handle page sizes
 other than 4k
Date: Sun, 8 Dec 2019 23:37:44 -0800
Message-ID: <20191209073744.GB3852@infradead.org>
References: <1575622543-22470-1-git-send-email-liangchen.linux@gmail.com>
 <1575622543-22470-2-git-send-email-liangchen.linux@gmail.com>
 <e44b8bd9-470d-08af-be7f-a0808504772e@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e44b8bd9-470d-08af-be7f-a0808504772e@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: Liang Chen <liangchen.linux@gmail.com>, kent.overstreet@gmail.com, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On Fri, Dec 06, 2019 at 05:44:38PM +0800, Coly Li wrote:
> >  {
> > -	struct cache_sb *out = page_address(bio_first_page_all(bio));
> > +	struct cache_sb *out;
> >  	unsigned int i;
> > +	struct buffer_head *bh;
> > +
> > +	/*
> > +	 * The page is held since read_super, this __bread * should not
> > +	 * cause an extra io read.
> > +	 */
> > +	bh = __bread(bdev, 1, SB_SIZE);
> > +	if (!bh)
> > +		goto out_bh;
> > +
> > +	out = (struct cache_sb *) bh->b_data;
> 
> This is quite tricky here. Could you please to move this code piece into
> an inline function and add code comments to explain why a read is
> necessary for a write.

A read is not nessecary.  He only added it because he was too fearful
of calculating the data offset directly.  But calculating it directly
is almost trivial and should just be done here.  Alternatively if that
is still to hard just keep a pointer to the cache_sb around, which is
how most file systems do it.
