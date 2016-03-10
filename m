From: Marc MERLIN <marc@merlins.org>
Subject: Re: Bcache still unstable for me (memory problems)
Date: Thu, 10 Mar 2016 07:47:06 -0800
Message-ID: <20160310154706.GS14112@merlins.org>
References: <CA+nZN+i0fmEc0Uz1X5k0DJaNB_sNu2EP0dEUy32_ipsW66MFmA@mail.gmail.com>
 <alpine.LRH.2.11.1603090344040.15354@mail.ewheeler.net>
 <alpine.LRH.2.11.1603100125110.13488@mail.ewheeler.net>
 <20160310021516.GM14112@merlins.org>
 <20160310152958.GR14112@merlins.org>
 <56E19595.5010208@evilazrael.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:59150 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbcCJPrM (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 10 Mar 2016 10:47:12 -0500
Content-Disposition: inline
In-Reply-To: <56E19595.5010208@evilazrael.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Christoph Nelles <evilazrael@evilazrael.de>
Cc: linux-bcache@vger.kernel.org

On Thu, Mar 10, 2016 at 04:41:09PM +0100, Christoph Nelles wrote:
> >gargamel:~# cat /proc/meminfo
> >MemTotal:       24392440 kB
> >Mlocked:        120259089404 kB
> >VmallocTotal:   34359738367 kB
> >
> >Thanks,
> >Marc
> 
> Just out of curiosity, how can 112TB be in the state mlocked on a 24GB
> machine?

That's a very good question. Sadly I'm not knowledgeable about the
different kinds of memory pools and their exactly meaning/use, so I have
no idea.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
