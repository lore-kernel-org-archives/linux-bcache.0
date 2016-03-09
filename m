From: Marc MERLIN <marc@merlins.org>
Subject: Re: Bcache still unstable for me (memory problems)
Date: Wed, 9 Mar 2016 12:55:26 -0800
Message-ID: <20160309205526.GJ27437@merlins.org>
References: <20160308235252.GB27437@merlins.org>
 <alpine.LRH.2.11.1603090337300.15354@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:47800 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934154AbcCIUza (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 9 Mar 2016 15:55:30 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1603090337300.15354@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org

On Wed, Mar 09, 2016 at 03:59:30AM +0000, Eric Wheeler wrote:
> > gargamel:/mnt/mnt# cat /proc/sys/vm/min_free_kbytes
> > 19712
> 
> Ours is set to 256mb (256*1024) and I've never had a problem.  
> 
> > Should I change it?
> 
> Could try it, shrug.

Done :)

> > So clearly on this boot too, it got registered late (20h-ish after boot)
> 
> I find it interesting that it re-registered md5 within 5 minutes of 24 
> hours after initial registration: (86242-102)/3600 = 23:55:40
 
Oh, I didn't do the math, but yeah, that looks very suspicous :)

> Is there some kind of cron.daily thing going on?  If you have timestamps 
> for that kernel log, maybe check cron for logs too.

I don't have any cronjobs that do anything with bcache, but I have
cronjobs that scan all drives and save all partitions plus other related
stuff.
That said, if I recall correctly, it died just when I restarted a copy
to that filesystem (but my memory of that event is getting hazy now).

I checked syslog around that time though 
Mar  6 06:29:50 gargamel kernel: [204255.678548] bcache-register: page allocation failure: order:7, mode:0x24080c0
and found nothing related to a cronjob or /dev/sdl disappearing and
coming back.

> Are there any intevening non-bcache lines indicating a disk was removed 
> (eg, bad usb cable) and re-added?  

Good question, none that I can find.
 
> > > Do you have this patch?
> > > https://bitbucket.org/ewheelerinc/linux/commits/a7044848050ac60e178798d20ea8a3ef2be36bc7?at=master
> >  
> > I got the other patches you sent me last time, but didn't end up with
> > this one, sorry if you sent it to me and I dropped it.
> > I'll apply it now, thanks.
> 
> All of the patches related to troubleshooting with you are here:
> 
>   https://bitbucket.org/ewheelerinc/linux/branch/v4.5-rc6-bcache-fixes
> and here:
>   https://bitbucket.org/ewheelerinc/linux/branch/v4.5-rc7-bcache-fixes
> 
> so make sure all 3 are applied.  It might still OOM, but it shouldn't 
> crash if we got it all.

Thanks. I just checked that I have all those paatches now.

I will report back if I get more interesting output :)

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
