From: Marc MERLIN <marc@merlins.org>
Subject: Re: 4.11: ida_remove called for id=16 which is not allocated.
Date: Sun, 4 Jun 2017 19:07:51 -0700
Message-ID: <20170605020751.mkemzje27hebpkcm@merlins.org>
References: <20170514152522.u5kejltr3nz4ogmz@merlins.org>
 <alpine.LRH.2.11.1705181707030.19359@mail.ewheeler.net>
 <20170605015509.nxs6kvokwk4nn5wt@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:46033 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751189AbdFECHz (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 4 Jun 2017 22:07:55 -0400
Content-Disposition: inline
In-Reply-To: <20170605015509.nxs6kvokwk4nn5wt@merlins.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org

On Sun, Jun 04, 2017 at 06:55:09PM -0700, Marc MERLIN wrote:
> gargamel:/sys/block/bcache1/bcache# echo 1 > stop
> returned nothing.
> Actually I was kind of expecting a note in my logs that the cache had
> been stopped, but eh, at least no errors :)

Right, but now how do I re-enable my cache?
I can't seem to.

gargamel:/sys/block/md8# ls bcache
ls: cannot access 'bcache': No such file or directory

gargamel:/sys/block/bcache1# l
total 0
drwxr-xr-x  8 root root    0 Jun  4 18:53 ./
drwxr-xr-x 15 root root    0 Jun  4 18:53 ../
-r--r--r--  1 root root 4096 Jun  4 18:53 alignment_offset
-rw-r--r--  1 root root 4096 Jun  4 18:53 badblocks
lrwxrwxrwx  1 root root    0 Jun  4 18:53 bcache -> ../md8/bcache
lrwxrwxrwx  1 root root    0 Jun  4 18:53 bdi -> ../../bdi/252:16/

gargamel:/sys/block/bcache1# l ../md8/bcache
ls: cannot access '../md8/bcache': No such file or directory

 echo /dev/md8 > 4a46e74d-0376-41e7-aff4-0a0497b9e3c5/unregister 
gargamel:/sys/block/bcache1/bcache# echo /dev/md8 >  /sys/fs/bcache/register 
bcache: register_bcache() error opening /dev/md8: device already registered

Looks like stop doesn't unregister the device, I can't re-register it,
nor restart it.

Or am I missing something?
I'd love not to have to reboot to recover :)

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
