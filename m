From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: BUG: drivers/md/bcache/writeback.c:237
Date: Thu, 25 Feb 2016 00:58:23 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1602250052530.2131@mail.ewheeler.net>
References: <20160224204530.GA13079@merlins.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([71.19.153.34]:38504 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752579AbcBYA63 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 24 Feb 2016 19:58:29 -0500
In-Reply-To: <20160224204530.GA13079@merlins.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: kent.overstreet@gmail.com
Cc: Christoph Nelles <evilazrael@evilazrael.de>, linux-bcache@vger.kernel.org, Marc MERLIN <marc@merlins.org>

[ +cc: kent ]

On Wed, 24 Feb 2016, Marc MERLIN wrote:

> On Wed, Feb 24, 2016 at 06:53:05AM +0000, Eric Wheeler wrote:
> > Be sure to cherry-pick these from linux 4.5-rc1:
> > 	git cherry-pick 2ef9ccbf~1..627ccd20
> > or use one of the 4.1 or 3.18 longterm kernels.
>  
> So, I added these patches to my 4.4.2 kernel, but it still crashes when
> seeing one cache device at boot.
> 
> Crash:
> https://goo.gl/photos/8H1DtYjSijK4ngFv6
> 

> static void read_dirty(struct cached_dev *dc)
> [...]
> 	while (!kthread_should_stop()) {
> 		try_to_freeze();
> 
> 		w = bch_keybuf_next(&dc->writeback_keys);
> 		if (!w)
> 			break;
> 
> >>>>>		BUG_ON(ptr_stale(dc->disk.c, &w->key, 0));
> 
> 		if (KEY_START(&w->key) != dc->last_read ||

Kent, any idea whats going on here?  What is this BUG_ON checking?

It looks like dirty data is being read immediately after register, 
possibly due to a crash.

-Eric

> 
> I have to remove the partition for my system to boot.
> 
> Before I destroy it, any other patches I should try?
> 
> And to be fair, it's a huge pain to deal with this, there should be an
> easier way to just turn bcache off from the kernel command line. In this
> case it was really a lot of work to get back to even a booting system.
> 
> You also said:
> > 4.1.18 has the patches, so unless there is something specific in 4.4 that
> > you need, I recommend 4.1.  We've been running 4.1.17 with patches in
> > production for a while and it works great.  Haven't tried vanilla 4.1.18
> > yet, but I plan to soon.
> 
> Sadly, I run btrfs, I can't just go to random old kernels like this.
> Is bcache not stable in up to date kernels?
> 
> Thanks,
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
