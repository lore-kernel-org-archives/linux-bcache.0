From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: Bcache still unstable for me (memory problems)
Date: Wed, 9 Mar 2016 03:59:30 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1603090337300.15354@mail.ewheeler.net>
References: <20160308235252.GB27437@merlins.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([71.19.153.34]:47652 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750867AbcCID7d (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 8 Mar 2016 22:59:33 -0500
In-Reply-To: <20160308235252.GB27437@merlins.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: linux-bcache@vger.kernel.org

On Tue, 8 Mar 2016, Marc MERLIN wrote:

> On Mon, Mar 07, 2016 at 07:56:56PM +0000, Eric Wheeler wrote:
> > Strange about memory allocation issues.  Do you have 
> > /proc/sys/vm/min_free_kbytes set to something like $((256*1024)) ? Is this 
> > a multi-socket machine with all memory plugged into only one CPU?
>  
> gargamel:/mnt/mnt# cat /proc/sys/vm/min_free_kbytes
> 19712

Ours is set to 256mb (256*1024) and I've never had a problem.  

> Should I change it?

Could try it, shrug.

> 
> > I'm curious though, why was registration called a second time? Was the 
> > drive external?  Could udev be re-registering the device?
> 
> Yeah, this puzzled me.
> The filesystem was already mounted, I made a long copy via btrfs send,
> it failed before the end, I came back a day or so later, so the copy
> failed, restarted it, and then the kernel crashed.
> It seems that accessing the filesystem (that was already mounted) caused
> bcache to register the cache device then?
> I have no idea why though.
> 
> This is kind of weird:
> [   86.612756] bcache: register_bdev() registered backing device md5
> [  102.097299] bcache: bch_journal_replay() journal replay done, 41 keys in 4 entries, seq 22200
> [  102.124135] bcache: register_cache() registered cache device dm-4
> [  102.151653] bcache: register_bdev() registered backing device dm-1
> [  102.221977] bcache: bch_cached_dev_attach() Caching dm-1 as bcache1 on set 0226553a-37cf-41d5-b3ce-8b1e944543a8
> [  102.253183] bcache: register_bcache() error opening /dev/md5: device already registered
> [86240.547242] bcache: bch_journal_replay() journal replay done, 0 keys in 2 entries, seq 215862
> [86242.109874] bcache: bch_cached_dev_attach() Caching md5 as bcache0 on set 5bc072a8-ab17-446d-9744-e247949913c1
> [86242.141648] bcache: register_cache() registered cache device sdh2
> [86253.186416] bcache: register_bcache() error opening /dev/sdh2: device already registered
> 
> So clearly on this boot too, it got registered late (20h-ish after boot)

I find it interesting that it re-registered md5 within 5 minutes of 24 
hours after initial registration: (86242-102)/3600 = 23:55:40

Is there some kind of cron.daily thing going on?  If you have timestamps 
for that kernel log, maybe check cron for logs too.

Are there any intevening non-bcache lines indicating a disk was removed 
(eg, bad usb cable) and re-added?  

> > Do you have this patch?
> > https://bitbucket.org/ewheelerinc/linux/commits/a7044848050ac60e178798d20ea8a3ef2be36bc7?at=master
>  
> I got the other patches you sent me last time, but didn't end up with
> this one, sorry if you sent it to me and I dropped it.
> I'll apply it now, thanks.

All of the patches related to troubleshooting with you are here:

  https://bitbucket.org/ewheelerinc/linux/branch/v4.5-rc6-bcache-fixes
and here:
  https://bitbucket.org/ewheelerinc/linux/branch/v4.5-rc7-bcache-fixes

so make sure all 3 are applied.  It might still OOM, but it shouldn't 
crash if we got it all.

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
