From: Marc MERLIN <marc@merlins.org>
Subject: Re: BUG: drivers/md/bcache/writeback.c:237
Date: Thu, 25 Feb 2016 19:19:21 -0800
Message-ID: <20160226031921.GG29543@merlins.org>
References: <20160224204530.GA13079@merlins.org> <alpine.LRH.2.11.1602250052530.2131@mail.ewheeler.net> <alpine.LRH.2.11.1602250612440.3635@mail.ewheeler.net> <alpine.LRH.2.11.1602250729570.3635@mail.ewheeler.net> <CAC8teKVFASYjf1U+Y3JHCXREC3WwfO=2GR+=-8kYcNh+ugsMxw@mail.gmail.com> <alpine.LRH.2.11.1602252330290.3635@mail.ewheeler.net> <20160226024633.GF29543@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:49146 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbcBZDTX (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 25 Feb 2016 22:19:23 -0500
Content-Disposition: inline
In-Reply-To: <20160226024633.GF29543@merlins.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Zhu Yanhai <zhu.yanhai@gmail.com>, Kent Overstreet <kent.overstreet@gmail.com>, Christoph Nelles <evilazrael@evilazrael.de>, linux-bcache@vger.kernel.org

On Thu, Feb 25, 2016 at 06:46:33PM -0800, Marc MERLIN wrote:
> Given that, I'm happy to run code that spits out diagostics, but probably
> not something that will attempt to write an outdated cache on a filesytem
> that's already ahead.
> Or does bcache understand that the backing device is ahead already and the
> cache should just be discarded?

Yeah, sorry, I did forget to mention that I did a force run on the backing
device so that I could get to its data.
In doing so, I probably invalidated options to try and reply the cache to
see if things would crash, or not, sorry about that.

Now, if I try to make the cache available again, will the code be smart and
not try to reapply a stale cache (never mind that it's probably corrupted in
addition to being old?)

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
