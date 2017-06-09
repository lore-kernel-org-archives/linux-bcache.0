From: Marc MERLIN <marc@merlins.org>
Subject: Re: 4.11: ida_remove called for id=16 which is not allocated.
Date: Thu, 8 Jun 2017 19:39:34 -0700
Message-ID: <20170609023934.rxjug74gppc6opfz@merlins.org>
References: <20170514152522.u5kejltr3nz4ogmz@merlins.org>
 <alpine.LRH.2.11.1705181707030.19359@mail.ewheeler.net>
 <20170605015509.nxs6kvokwk4nn5wt@merlins.org>
 <20170605020751.mkemzje27hebpkcm@merlins.org>
 <alpine.LRH.2.11.1706090147150.19359@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:35498 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751481AbdFICjj (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 8 Jun 2017 22:39:39 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1706090147150.19359@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org

On Fri, Jun 09, 2017 at 01:53:01AM +0000, Eric Wheeler wrote:
> > gargamel:/sys/block/bcache1# l ../md8/bcache
> > ls: cannot access '../md8/bcache': No such file or directory
> 
> Don't trust ../ to link correctly with so many symlinks floating around.  
> Sometimes ../ will be interpreted correctly via a link path, other times 
> it will use the '..' inode's content which may not be the way you came in.  
> I'm not saying thats the problem, but perhaps...
 
Right, but basically it wasn't an issue here, it was just making cut and
paste shorter.

> >  echo /dev/md8 > 4a46e74d-0376-41e7-aff4-0a0497b9e3c5/unregister 
> 
> Try echo 1 > uuid/unregister

I'll try next time if there is one.
Sadly, I couldn't wait anymore and have already rebooted.

> > gargamel:/sys/block/bcache1/bcache# echo /dev/md8 >  /sys/fs/bcache/register 
> > bcache: register_bcache() error opening /dev/md8: device already registered
> > 
> > Looks like stop doesn't unregister the device, I can't re-register it,
> > nor restart it.
> > 
> > Or am I missing something?
> > I'd love not to have to reboot to recover :)
> 
> Is /dev/md8 the cache or bdev?
 
It was the cache. I pasted:
lrwxrwxrwx  1 root root    0 Jun  4 18:53 bcache -> ../md8/bcache
lrwxrwxrwx  1 root root    0 Jun  4 18:53 bdi -> ../../bdi/252:16/

> Did you stop the cache, too, in /sys/fs/bcache/uuid/stop? 
> 
> Stopping via /sys/block/bcache0/bcache/stop doesn't stop the cache IIRC.

I wasn't trying to stop the cache, just to re-assign it to the backing
device it had just been removed from for testing as per your request.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
