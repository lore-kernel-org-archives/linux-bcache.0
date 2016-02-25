From: Marc MERLIN <marc@merlins.org>
Subject: Re: bcache: register_cache() error opening sdh2: cannot allocate
 memory => BUG NULL pointer
Date: Thu, 25 Feb 2016 08:44:39 -0800
Message-ID: <20160225164439.GA2290@merlins.org>
References: <20160225061821.GB15421@merlins.org>
 <alpine.LRH.2.11.1602250727120.3635@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:43271 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932381AbcBYQoo (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 25 Feb 2016 11:44:44 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1602250727120.3635@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org

On Thu, Feb 25, 2016 at 07:29:36AM +0000, Eric Wheeler wrote:
> Try this patch.  It adds some error handling:

Thanks, applied. I'll report back if I get output from it.

I think one reason I'm having problem on that server is that I run
zoneminder which requires a lot of shared memory:
kernel.shmall = 234217728
kernel.shmmax = 234217728

Is there a chance that's putting memory pressure in the wrong memory
pool on the system?

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
