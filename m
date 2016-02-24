From: Marc MERLIN <marc@merlins.org>
Subject: Re: BUG: drivers/md/bcache/writeback.c:237
Date: Wed, 24 Feb 2016 12:45:30 -0800
Message-ID: <20160224204530.GA13079@merlins.org>
References: <alpine.LRH.2.11.1602240403300.32077@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:34073 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758579AbcBXUpi (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 24 Feb 2016 15:45:38 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1602240403300.32077@mail.ewheeler.net>
 <56C1F2A4.4090208@evilazrael.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Christoph Nelles <evilazrael@evilazrael.de>, Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org

On Wed, Feb 24, 2016 at 06:53:05AM +0000, Eric Wheeler wrote:
> Be sure to cherry-pick these from linux 4.5-rc1:
> 	git cherry-pick 2ef9ccbf~1..627ccd20
> or use one of the 4.1 or 3.18 longterm kernels.
 
So, I added these patches to my 4.4.2 kernel, but it still crashes when
seeing one cache device at boot.

Crash:
https://goo.gl/photos/8H1DtYjSijK4ngFv6

	while (!kthread_should_stop()) {
		try_to_freeze();

		w = bch_keybuf_next(&dc->writeback_keys);
		if (!w)
			break;

>>>>>		BUG_ON(ptr_stale(dc->disk.c, &w->key, 0));

		if (KEY_START(&w->key) != dc->last_read ||

I have to remove the partition for my system to boot.

Before I destroy it, any other patches I should try?

And to be fair, it's a huge pain to deal with this, there should be an
easier way to just turn bcache off from the kernel command line. In this
case it was really a lot of work to get back to even a booting system.

You also said:
> 4.1.18 has the patches, so unless there is something specific in 4.4 that
> you need, I recommend 4.1.  We've been running 4.1.17 with patches in
> production for a while and it works great.  Haven't tried vanilla 4.1.18
> yet, but I plan to soon.

Sadly, I run btrfs, I can't just go to random old kernels like this.
Is bcache not stable in up to date kernels?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
