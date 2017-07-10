From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: [PATCH] bcache: only recovery I/O error for writethrough mode
Date: Mon, 10 Jul 2017 23:46:19 +0200
Message-ID: <20170710234619.7388fde2@jupiter.sol.kaishome.de>
References: <20170710111828.97918-1-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:49621 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1754536AbdGJVqj (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 10 Jul 2017 17:46:39 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <glbd-linux-bcache@m.gmane.org>)
        id 1dUgVf-0006KQ-If
        for linux-bcache@vger.kernel.org; Mon, 10 Jul 2017 23:46:27 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org

Am Mon, 10 Jul 2017 19:18:28 +0800
schrieb Coly Li <colyli@suse.de>:

> If a read bio to cache device gets failed, bcache will try to
> recovery it by forward the read bio to backing device. If backing
> device responses read request successfully then the bio contains data
> from backing device will be returned to uppper layer.
> 
> The recovery effort in cached_dev_read_error() is not correct, and
> there is report that corrupted data may returned when a dirty cache
> device goes offline during reading I/O.
> 
> For writeback cache mode, before dirty data are wrote back to backing
> device, data blocks on backing device are not updated and consistent.
> If a dirty cache device dropped and a read bio gets failed, bcache
> will return its stale version from backing device. This is mistaken
> behavior that applications don't expected, especially for data base
> workload.
> 
> This patch fixes the issue by only permit recoverable I/O when cached
> device is in writethough mode, and s->recoverable is set. For other
> cache mode, recovery I/O failure by reading backing device does not
> make sense, bache just simply returns -EIO immediately.

Shouldn't write-around mode be okay for the same reason, i.e. there's
no stale version on disk?

So the patch should read "mode != CACHE_MODE_WRITEBACK" (not sure about
the constant), that would also match your textual description.


> Reported-by: Arne Wolf <awolf@lenovo.com>
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>  drivers/md/bcache/request.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 019b3df9f1c6..6edacac9b00d 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -702,8 +702,11 @@ static void cached_dev_read_error(struct closure
> *cl) {
>  	struct search *s = container_of(cl, struct search, cl);
>  	struct bio *bio = &s->bio.bio;
> +	struct cached_dev *dc = container_of(s->d, struct
> cached_dev, disk);
> +	unsigned mode = cache_mode(dc, NULL);
>  
> -	if (s->recoverable) {
> +	if (s->recoverable &&
> +	    (mode == CACHE_MODE_WRITETHROUGH)) {
>  		/* Retry from the backing device: */
>  		trace_bcache_read_retry(s->orig_bio);
>  



-- 
Regards,
Kai

Replies to list-only preferred.
