From: Marc MERLIN <marc@merlins.org>
Subject: Re: Hard to delete/unregister caching device
Date: Sun, 21 Feb 2016 13:22:05 -0800
Message-ID: <20160221212205.GB5512@merlins.org>
References: <20160219064857.GA29411@merlins.org>
 <20160221041753.GB24735@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:45920 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbcBUVWK (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sun, 21 Feb 2016 16:22:10 -0500
Content-Disposition: inline
In-Reply-To: <20160221041753.GB24735@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

On Sat, Feb 20, 2016 at 07:17:53PM -0900, Kent Overstreet wrote:
> > bcache0 is fine
> > bcache1 ended up in a bad state, I'm not sure how.
> > No biggie, right, just delete/recreate/re-register sda6, except how?
> > 
> > https://www.kernel.org/doc/Documentation/bcache.txt
> > SYSFS - CACHE DEVICE:
> > says nothing about how I can free/release sda6
> > 
> > saruman:~# echo /dev/sda6 > /sys/fs/bcache/unregister
> > -su: /sys/fs/bcache/unregister: Permission denied
> > is not helpful, nothing in kern.log
> 
> echo 1 > /sys/fs/bcache/<uuid>/unregister

If you look lower down in my Email, I did do almost the same:
saruman:/sys/fs/bcache/f419195d-184e-44b7-9f88-a834a5458f8c# echo 1 > stop

I was pointing out that for a newcomer, it's not all super obvious how
all the pieces fit together.

Is https://www.kernel.org/doc/Documentation/bcache.txt still considered
the canonical documentation?
I could try writing some kind of howto update for it if so.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
