From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: Hard to delete/unregister caching device
Date: Wed, 24 Feb 2016 19:13:18 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1602241911490.32077@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([71.19.153.34]:37702 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751305AbcBXTNY (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 24 Feb 2016 14:13:24 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org


On Sun, 21 Feb 2016, Marc MERLIN wrote:

> On Sat, Feb 20, 2016 at 07:17:53PM -0900, Kent Overstreet wrote:
> > > bcache0 is fine
> > > bcache1 ended up in a bad state, I'm not sure how.
> > > No biggie, right, just delete/recreate/re-register sda6, except how?
> > > 
> > > https://www.kernel.org/doc/Documentation/bcache.txt
> > > SYSFS - CACHE DEVICE:
> > > says nothing about how I can free/release sda6
> > > 
> > > saruman:~# echo /dev/sda6 > /sys/fs/bcache/unregister
> > > -su: /sys/fs/bcache/unregister: Permission denied
> > > is not helpful, nothing in kern.log
> > 
> > echo 1 > /sys/fs/bcache/<uuid>/unregister
> 
> If you look lower down in my Email, I did do almost the same:
> saruman:/sys/fs/bcache/f419195d-184e-44b7-9f88-a834a5458f8c# echo 1 > stop
> 
> I was pointing out that for a newcomer, it's not all super obvious how
> all the pieces fit together.
> 
> Is https://www.kernel.org/doc/Documentation/bcache.txt still considered
> the canonical documentation?
> I could try writing some kind of howto update for it if so.

It is, or at least it would be ideal to have up to date.  By all means, 
write a patch and submit it!  Documentation patches are some of the most 
important to support the userbase.

-Eric

> 
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
