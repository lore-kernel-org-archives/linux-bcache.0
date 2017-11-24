From: Vojtech Pavlik <vojtech@suse.com>
Subject: Re: [PATCH v2] bcache: check return value of register_shrinker
Date: Fri, 24 Nov 2017 23:35:18 +0100
Message-ID: <20171124223518.GA2892@suse.com>
References: <20171124201814.26173-1-mlyle@lyle.org>
 <20171124220250.400-1-mlyle@lyle.org>
 <a1831d01-b327-1e0b-b802-38892931e56e@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jablonecka.jablonka.cz ([91.219.244.36]:34646 "EHLO
        jablonecka.jablonka.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753730AbdKXXBl (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 24 Nov 2017 18:01:41 -0500
Content-Disposition: inline
In-Reply-To: <a1831d01-b327-1e0b-b802-38892931e56e@lyle.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: linux-bcache@vger.kernel.org

On Fri, Nov 24, 2017 at 02:24:42PM -0800, Michael Lyle wrote:
> Just a note to everyone-- a quick Reviewed-by: would be appreciated from
> someone here on the bcache list because I'm hoping to get this sent off
> with a couple other things to Jens soon.  -mpl
> 
> On 11/24/2017 02:02 PM, Michael Lyle wrote:
> > register_shrinker is now __must_check, so check it to kill a warning.
> > Caller of bch_btree_cache_alloc in super.c appropriately checks return
> > value so this is fully plumbed through.
> > 
> > This V2 fixes checkpatch warnings and improves the commit description,
> > as I was too hasty getting the previous version out.
> > 
> > Signed-off-by: Michael Lyle <mlyle@lyle.org>
> > ---
> >  drivers/md/bcache/btree.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> > index 11c5503d31dc..81e8dc3dbe5e 100644
> > --- a/drivers/md/bcache/btree.c
> > +++ b/drivers/md/bcache/btree.c
> > @@ -807,7 +807,10 @@ int bch_btree_cache_alloc(struct cache_set *c)
> >  	c->shrink.scan_objects = bch_mca_scan;
> >  	c->shrink.seeks = 4;
> >  	c->shrink.batch = c->btree_pages * 2;
> > -	register_shrinker(&c->shrink);
> > +
> > +	if (register_shrinker(&c->shrink))
> > +		pr_warn("bcache: %s: could not register shrinker",
> > +				__func__);
> >  
> >  	return 0;
> >  }

Reviewed-by: Vojtech Pavlik <vojtech@suse.com>

-- 
Vojtech Pavlik
Director SuSE Labs
