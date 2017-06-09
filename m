From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: 4.11: ida_remove called for id=16 which is not allocated.
Date: Fri, 9 Jun 2017 01:53:01 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1706090147150.19359@mail.ewheeler.net>
References: <20170514152522.u5kejltr3nz4ogmz@merlins.org> <alpine.LRH.2.11.1705181707030.19359@mail.ewheeler.net> <20170605015509.nxs6kvokwk4nn5wt@merlins.org> <20170605020751.mkemzje27hebpkcm@merlins.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:35420 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751445AbdFIBxC (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 8 Jun 2017 21:53:02 -0400
In-Reply-To: <20170605020751.mkemzje27hebpkcm@merlins.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: linux-bcache@vger.kernel.org

On Sun, 4 Jun 2017, Marc MERLIN wrote:
> On Sun, Jun 04, 2017 at 06:55:09PM -0700, Marc MERLIN wrote:
> > gargamel:/sys/block/bcache1/bcache# echo 1 > stop
> > returned nothing.
> > Actually I was kind of expecting a note in my logs that the cache had
> > been stopped, but eh, at least no errors :)
> 
> Right, but now how do I re-enable my cache?
> I can't seem to.
> 
> gargamel:/sys/block/md8# ls bcache
> ls: cannot access 'bcache': No such file or directory
> 
> gargamel:/sys/block/bcache1# l
> total 0
> drwxr-xr-x  8 root root    0 Jun  4 18:53 ./
> drwxr-xr-x 15 root root    0 Jun  4 18:53 ../
> -r--r--r--  1 root root 4096 Jun  4 18:53 alignment_offset
> -rw-r--r--  1 root root 4096 Jun  4 18:53 badblocks
> lrwxrwxrwx  1 root root    0 Jun  4 18:53 bcache -> ../md8/bcache
> lrwxrwxrwx  1 root root    0 Jun  4 18:53 bdi -> ../../bdi/252:16/
> 
> gargamel:/sys/block/bcache1# l ../md8/bcache
> ls: cannot access '../md8/bcache': No such file or directory

Don't trust ../ to link correctly with so many symlinks floating around.  
Sometimes ../ will be interpreted correctly via a link path, other times 
it will use the '..' inode's content which may not be the way you came in.  
I'm not saying thats the problem, but perhaps...

>  echo /dev/md8 > 4a46e74d-0376-41e7-aff4-0a0497b9e3c5/unregister 

Try echo 1 > uuid/unregister

> gargamel:/sys/block/bcache1/bcache# echo /dev/md8 >  /sys/fs/bcache/register 
> bcache: register_bcache() error opening /dev/md8: device already registered
> 
> Looks like stop doesn't unregister the device, I can't re-register it,
> nor restart it.
> 
> Or am I missing something?
> I'd love not to have to reboot to recover :)

Is /dev/md8 the cache or bdev?

Did you stop the cache, too, in /sys/fs/bcache/uuid/stop? 

Stopping via /sys/block/bcache0/bcache/stop doesn't stop the cache IIRC.


--
Eric Wheeler


> 
> Thanks,
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
> 
