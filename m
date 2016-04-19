From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [PATCH] bcache: bch_writeback_thread() is not freezable
Date: Tue, 19 Apr 2016 20:55:01 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1604192050290.16630@mail.ewheeler.net>
References: <alpine.LNX.2.00.1604191421130.27368@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [66.155.3.69] ([66.155.3.69]:39407 "EHLO mail.ewheeler.net"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932913AbcDSUzV (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 19 Apr 2016 16:55:21 -0400
In-Reply-To: <alpine.LNX.2.00.1604191421130.27368@cbobk.fhfr.pm>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jiri Kosina <jikos@kernel.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, Maciej Piechotka <uzytkownik2@gmail.com>


On Tue, 19 Apr 2016, Jiri Kosina wrote:

> From: Jiri Kosina <jkosina@suse.cz>
> 
> bch_writeback_thread() is calling try_to_freeze(), but that's just an 
> expensive no-op given the fact that the thread is not marked freezable.
> 
> I/O helper kthreads, exactly such as the bcache writeback thread, actually 
> shouldn't be freezable, because they are potentially necessary for 
> finalizing the image write-out.

This is good timing, as Maciej Piechotka just reported a hang when 
suspending his system.

What is the proper way to safely support suspend?  Assuming the 
try_to_freeze() calls are in the right place, should we simply 
set_freezable() on these kthreads?


--
Eric Wheeler


> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
>  drivers/md/bcache/writeback.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index b9346cd..6012367 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -12,7 +12,6 @@
>  #include "writeback.h"
>  
>  #include <linux/delay.h>
> -#include <linux/freezer.h>
>  #include <linux/kthread.h>
>  #include <trace/events/bcache.h>
>  
> @@ -228,7 +227,6 @@ static void read_dirty(struct cached_dev *dc)
>  	 */
>  
>  	while (!kthread_should_stop()) {
> -		try_to_freeze();
>  
>  		w = bch_keybuf_next(&dc->writeback_keys);
>  		if (!w)
> @@ -433,7 +431,6 @@ static int bch_writeback_thread(void *arg)
>  			if (kthread_should_stop())
>  				return 0;
>  
> -			try_to_freeze();
>  			schedule();
>  			continue;
>  		}
> -- 
> Jiri Kosina
> SUSE Labs
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
