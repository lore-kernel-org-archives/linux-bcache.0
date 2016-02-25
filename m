From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: BUG: drivers/md/bcache/writeback.c:237
Date: Thu, 25 Feb 2016 07:36:45 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1602250729570.3635@mail.ewheeler.net>
References: <20160224204530.GA13079@merlins.org> <alpine.LRH.2.11.1602250052530.2131@mail.ewheeler.net> <alpine.LRH.2.11.1602250612440.3635@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([71.19.153.34]:39121 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758638AbcBYHgr (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 25 Feb 2016 02:36:47 -0500
In-Reply-To: <alpine.LRH.2.11.1602250612440.3635@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: kent.overstreet@gmail.com, Christoph Nelles <evilazrael@evilazrael.de>, linux-bcache@vger.kernel.org

On Thu, 25 Feb 2016, Eric Wheeler wrote:

> On Thu, 25 Feb 2016, Eric Wheeler wrote:
> 
> > [ +cc: kent ]
> > 
> > On Wed, 24 Feb 2016, Marc MERLIN wrote:
> > 
> > > On Wed, Feb 24, 2016 at 06:53:05AM +0000, Eric Wheeler wrote:
> > > > Be sure to cherry-pick these from linux 4.5-rc1:
> > > > 	git cherry-pick 2ef9ccbf~1..627ccd20
> > > > or use one of the 4.1 or 3.18 longterm kernels.
> > >  
> > > So, I added these patches to my 4.4.2 kernel, but it still crashes when
> > > seeing one cache device at boot.
> > > 
> > > Crash:
> > > https://goo.gl/photos/8H1DtYjSijK4ngFv6
> > > 
> > 
> > > static void read_dirty(struct cached_dev *dc)
> > > [...]
> > > 	while (!kthread_should_stop()) {
> > > 		try_to_freeze();
> > > 
> > > 		w = bch_keybuf_next(&dc->writeback_keys);
> > > 		if (!w)
> > > 			break;
> > > 
> > > >>>>>		BUG_ON(ptr_stale(dc->disk.c, &w->key, 0));
> > > 
> > > 		if (KEY_START(&w->key) != dc->last_read ||
> > 
> > Kent, any idea whats going on here?  What is this BUG_ON checking?
> > 
> > It looks like dirty data is being read immediately after register, 
> > possibly due to a crash.
> 
> The calltrace in the image [https://goo.gl/photos/8H1DtYjSijK4ngFv6] 
> indicates something about kthread_parkme.  Is our thread being woken 
> unexpectedly by kthread_park?
> 
> If so, maybe we can do a better job handling the BUG condition.  
> 
> What would happen if we did something like this:
> 
> 	+if (kthread_should_park()) {
> 	+	kthread_parkme();
> 	+	break;
> 	+}
> 
> 	BUG_ON(ptr_stale(dc->disk.c, &w->key, 0));
> 
> 
> /* and maybe this too: */
> 	-BUG_ON(ptr_stale(dc->disk.c, &w->key, 0));
> 	+if (ptr_stale(dc->disk.c, &w->key, 0))
> 	+	break;
> 
> Or would `continue` be more appropriate?  I don't think anything is lost 
> at the point we break because the writeback thread will continue to 
> iterate and retry the call to read_dirty().  It hasn't kzalloc'ed yet, so 
> no cleanup necessary.
> 
> Cleary there is a condition that isn't being handled gracfully enough, and 
> clearly it cannot continue if the BUG condition is met---but its in a loop 
> so can we safely iterate to retry instead of BUGing??  
> 
> 
> Kent,
> 
> Do you think this patch would solve the BUG_ON condition in this case?
> 
> 
> ==============================================
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index ca38362..529310a 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -234,7 +234,8 @@ static void read_dirty(struct cached_dev *dc)
> 		if (!w)
> 			break;
>  
> -	       BUG_ON(ptr_stale(dc->disk.c, &w->key, 0));
> +	       if (ptr_stale(dc->disk.c, &w->key, 0))
> +		       goto err;
>  
> 		if (KEY_START(&w->key) != dc->last_read ||
> 		    jiffies_to_msecs(delay) > 50)
> @@ -282,6 +283,10 @@ err:
> 	 * freed) before refilling again
> 	 */
> 	closure_sync(&cl);
> +
> +       if (kthread_should_park())
> +	       kthread_parkme();
> +
>  }

It looks like I can't call kthread_park* functions, perhaps those are 
handled internally:

	WARNING: "kthread_should_park" [drivers/md/bcache//bcache.ko] undefined!
	WARNING: "kthread_parkme" [drivers/md/bcache//bcache.ko] undefined!

I think it would still work if the kthread_*park* function calls were 
removed from the earlier patch based on the code flow.  It should just 
iterate and retry---assuming that it can retry.  At least it 
wouldn't BUG.

If this happens at cache registration, is it a race between writeback 
running too soon and the datastructures not being fully populated?

Can anyone else comment here?  

-Eric

  
>  /* Scan for dirty data */
> ==============================================
> 
> 
> -Eric
> 
> > 
> > -Eric
> > 
> > > 
> > > I have to remove the partition for my system to boot.
> > > 
> > > Before I destroy it, any other patches I should try?
> > > 
> > > And to be fair, it's a huge pain to deal with this, there should be an
> > > easier way to just turn bcache off from the kernel command line. In this
> > > case it was really a lot of work to get back to even a booting system.
> > > 
> > > You also said:
> > > > 4.1.18 has the patches, so unless there is something specific in 4.4 that
> > > > you need, I recommend 4.1.  We've been running 4.1.17 with patches in
> > > > production for a while and it works great.  Haven't tried vanilla 4.1.18
> > > > yet, but I plan to soon.
> > > 
> > > Sadly, I run btrfs, I can't just go to random old kernels like this.
> > > Is bcache not stable in up to date kernels?
> > > 
> > > Thanks,
> > > Marc
> > > -- 
> > > "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> > > Microsoft is to operating systems ....
> > >                                       .... what McDonalds is to gourmet cooking
> > > Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
