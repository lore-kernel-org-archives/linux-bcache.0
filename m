From: Marc MERLIN <marc@merlins.org>
Subject: Re: Bcache still unstable for me (memory problems)
Date: Tue, 8 Mar 2016 15:52:52 -0800
Message-ID: <20160308235252.GB27437@merlins.org>
References: <alpine.LRH.2.11.1603072014250.11530@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:35009 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbcCHXwy (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 8 Mar 2016 18:52:54 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1603072014250.11530@mail.ewheeler.net>
 <alpine.LRH.2.11.1603071926171.11530@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org, kent.overstreet@gmail.com

On Mon, Mar 07, 2016 at 07:56:56PM +0000, Eric Wheeler wrote:
> Strange about memory allocation issues.  Do you have 
> /proc/sys/vm/min_free_kbytes set to something like $((256*1024)) ? Is this 
> a multi-socket machine with all memory plugged into only one CPU?
 
gargamel:/mnt/mnt# cat /proc/sys/vm/min_free_kbytes
19712

Should I change it?

> I'm curious though, why was registration called a second time? Was the 
> drive external?  Could udev be re-registering the device?

Yeah, this puzzled me.
The filesystem was already mounted, I made a long copy via btrfs send,
it failed before the end, I came back a day or so later, so the copy
failed, restarted it, and then the kernel crashed.
It seems that accessing the filesystem (that was already mounted) caused
bcache to register the cache device then?
I have no idea why though.

This is kind of weird:
[   86.612756] bcache: register_bdev() registered backing device md5
[  102.097299] bcache: bch_journal_replay() journal replay done, 41 keys in 4 entries, seq 22200
[  102.124135] bcache: register_cache() registered cache device dm-4
[  102.151653] bcache: register_bdev() registered backing device dm-1
[  102.221977] bcache: bch_cached_dev_attach() Caching dm-1 as bcache1 on set 0226553a-37cf-41d5-b3ce-8b1e944543a8
[  102.253183] bcache: register_bcache() error opening /dev/md5: device already registered
[86240.547242] bcache: bch_journal_replay() journal replay done, 0 keys in 2 entries, seq 215862
[86242.109874] bcache: bch_cached_dev_attach() Caching md5 as bcache0 on set 5bc072a8-ab17-446d-9744-e247949913c1
[86242.141648] bcache: register_cache() registered cache device sdh2
[86253.186416] bcache: register_bcache() error opening /dev/sdh2: device already registered

So clearly on this boot too, it got registered late (20h-ish after boot)

> You might find where the registration is being done and prevent it from 
> running automatically.  At least that might solve the re-registration 
> problem.

Right.

> As for the memory allocation issue, the backtrace indicates that this is a 
> registration-time problem, not a runtime issue.  I'm guessing it is one of 
> the threads attempting to proceed after a memory allocation error similar 
> to the writeback thread issue you had last time which was fixed by adding 
> some locking around the initialization.

Makes snese.

On Mon, Mar 07, 2016 at 08:35:00PM +0000, Eric Wheeler wrote:
> Looking at the stack trace, bch_cache_set_alloc() appears to fail doing a 
> kzalloc() and returns NULL.  This causes register_cache_set() to return 
> "cannot allocate memory" but that error path isn't handled without my 
> upstream commit that went to Jens.  
> 
> Marc,
> 
> Do you have this patch?
> https://bitbucket.org/ewheelerinc/linux/commits/a7044848050ac60e178798d20ea8a3ef2be36bc7?at=master
 
I got the other patches you sent me last time, but didn't end up with
this one, sorry if you sent it to me and I dropped it.
I'll apply it now, thanks.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
