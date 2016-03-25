From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: Bug - bcache: "unable to handle kernel NULL pointer dereference"
 when trying to add a md caching device
Date: Fri, 25 Mar 2016 04:18:05 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1603250416030.13440@mail.ewheeler.net>
References: <56F4058B.1030309@roesner-online.de> <alpine.LRH.2.11.1603250126110.13440@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([71.19.153.34]:34881 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750797AbcCYEST (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Fri, 25 Mar 2016 00:18:19 -0400
In-Reply-To: <alpine.LRH.2.11.1603250126110.13440@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Sebastian Roesner <sroesner-kernelorg@roesner-online.de>
Cc: linux-bcache@vger.kernel.org

On Fri, 25 Mar 2016, Eric Wheeler wrote:
> On Thu, 24 Mar 2016, Sebastian Roesner wrote:
> > I experienced a bug after upgrading to a recent kernel (4.5.0).
> > 
> > # echo /dev/md2 > /sys/fs/bcache/register
> > 
> > gives me a stack trace.
> > 
> > I created a bug in the kernel bugtracker but I'm not sure if it has been
> > noticed by the bcache developers:
> > 
> > <https://bugzilla.kernel.org/show_bug.cgi?id=114871>
> 
> The dereference appears to happen inside of bio_trim which is core block 
> code.  In this case, it looks like bio_trim is being passed a null pointer 
> to *bio, but by whom?  
> 
> Please send this output:
> 
> tail /sys/block/md2/queue/discard_*
> 
> > Could somebody have a look?
> 
> It could be an allocation failure in bcache that gets pushed down the 
> stack at registration.  If that is the case, please pull these two fixes 
> branches which may have missed 4.5:
> 
> git pull https://bitbucket.org/ewheelerinc/linux v4.5-rc6-bcache-fixes
> git pull https://bitbucket.org/ewheelerinc/linux v4.5-rc7-bcache-fixes

Sebastian,

Try this patch and see if it BUGs:

diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
index 86a0bb8..f6bbbce 100644
--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -24,6 +24,9 @@ struct bio *bch_bbio_alloc(struct cache_set *c)
 	struct bbio *b = mempool_alloc(c->bio_meta, GFP_NOIO);
 	struct bio *bio = &b->bio;
 
+	BUG_ON(!b);
+	BUG_ON(!bio);
+
 	bio_init(bio);
 	bio->bi_flags		|= BIO_POOL_NONE << BIO_POOL_OFFSET;
 	bio->bi_max_vecs	 = bucket_pages(c);
