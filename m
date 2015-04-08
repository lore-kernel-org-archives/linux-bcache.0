From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: bcache fails after reboot if discard is enabled
Date: Wed, 8 Apr 2015 12:31:47 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1504081228581.2587@ware.dreamhost.com>
References: <54A66945.6030403@profihost.ag> <54A66C44.6070505@profihost.ag> <54A819A0.9010501@rolffokkens.nl> <54A843BC.608@profihost.ag> <loom.20150105T010336-763@post.gmane.org> <tcfnqb-u59.ln1@hurikhan77.spdns.de> <CAPL5yKf4Tz1oUDNTEz20+CXh-UEeZaNBZCD9pevg47kGnWmDQQ@mail.gmail.com>
 <alpine.DEB.2.02.1504081115550.2587@ware.dreamhost.com> <55257303.8020008@profihost.ag>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from homie.mail.dreamhost.com ([208.97.132.208]:43541 "EHLO
	homiemail-a61.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752083AbbDHTbt (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 8 Apr 2015 15:31:49 -0400
In-Reply-To: <55257303.8020008@profihost.ag>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: Dan Merillat <dan.merillat@gmail.com>, linux-bcache@vger.kernel.org

> Am 08.04.2015 um 20:17 schrieb Eric Wheeler:
> > Anecdotally, I seem to remember someone else on the list having trouble
> > using bcache when the backing device(s?) have TRIM enabled.
> 
> Me. Wasn't able to fix it. Trim just results in complete data loss with bcache
> if you reboot.
> 
> Stefan

Should bcache TRIM handling be disabled by default?

Kai reports success with TRIM on his Crucial SSD, so perhaps this is not a 
problem for everyone---but data integrity should be a priority and TRIM 
should only be enabled by those who understand the risks and wish to test.

Of course if the underlying problem could be found and fixed in code, that 
would be even better.

-Eric

 
> > 
> > -Eric
> > 
> > --
> > Eric Wheeler, President           eWheeler, Inc. dba Global Linux Security
> > 888-LINUX26 (888-546-8926)        Fax: 503-716-3878           PO Box 25107
> > www.GlobalLinuxSecurity.pro       Linux since 1996!     Portland, OR 97298
> > 
> > On Tue, 7 Apr 2015, Dan Merillat wrote:
> > 
> > > > It works perfectly fine here with latest 3.18. My setup is backing a
> > > > btrfs
> > > > filesystem in write-back mode. I can reboot cleanly, hard-reset upon
> > > > freezes, I had no issues yet and no data loss. Even after hard-reset the
> > > > kernel logs of both bcache and btrfs were clean, the filesystem was
> > > > clean,
> > > > just the usual btrfs recovery messages after an unclean shutdown.
> > > > 
> > > > I wonder if the SSD and/or the block layer in use may be part of the
> > > > problem:
> > > > 
> > > >    * if putting bcache on LVM, discards may not be handled well
> > > >    * if putting bcache or the backing fs on LVM, barriers may not be
> > > > handled
> > > >      well (bcache relies on perfectly working barriers)
> > > >    * does the SSD support powerloss protection? (IOW, use capacitors)
> > > >    * latest firmware applied? read the changelogs of it?
> > > > 
> > > > I'd try to first figure out these differences before looking further
> > > > into
> > > > debugging. I guess that most consumer-grade drives at least lack a few
> > > > of
> > > > the important features to use write-back mode, or use bcache at all.
> > > > 
> > > > So, to start the list: My SSD is a Crucial MX100 128GB with discards
> > > > enabled
> > > > (for both bcache and btrfs), using plain raw devices (no LVM or MD
> > > > involved). It supports TRIM (as my chipset does), and it supports
> > > > powerloss-
> > > > protection and maybe even some internal RAID-like data protection layer
> > > > (whatever that is, it's in the papers).
> > > > 
> > > > I'm not sure what a hard-reset technically means to the SSD but I guess
> > > > it
> > > > is handled as some sort of short powerloss. Reading through different
> > > > SSD
> > > > firmware update descriptions, I also see a lot words around power-off
> > > > and
> > > > reset problems being fixed that could lead to data-loss otherwise. That
> > > > could be pretty fatal to bcache as it considers it storage as always
> > > > unclean
> > > > (probably even in write-through mode). Having damaged data blocks out of
> > > > expected write order (barriers!) could be pretty bad when bcache
> > > > recovers
> > > > from last shutdown and replays logs.
> > > 
> > > Samsung 840-EVO 256GB here, running 4.0-rc7 (was 3.18)
> > > 
> > > There's no known issues with TRIM on an 840-EVO, and no powerloss or
> > > anything of the sort occurred.  I was seeing excessive write
> > > amplification on my SSD, and enabled discard - then my machine
> > > promptly started lagging, eventually disk access locked up and after a
> > > reboot I was confronted with:
> > > 
> > > [  276.558692] bcache: journal_read_bucket() 157: too big, 552 bytes,
> > > offset 2047
> > > [  276.571448] bcache: prio_read() bad csum reading priorities
> > > [  276.571528] bcache: prio_read() bad magic reading priorities
> > > [  276.576807] bcache: error on 804d6906-fa80-40ac-9081-a71a4d595378:
> > > bad btree header at bucket 65638, block 0, 0 keys, disabling caching
> > > [  276.577457] bcache: register_cache() registered cache device sda4
> > > [  276.577632] bcache: cache_set_free() Cache set
> > > 804d6906-fa80-40ac-9081-a71a4d595378 unregistered
> > > 
> > > Attempting to check the backingstore (echo 1 > bcache/running):
> > > 
> > > [  687.912987] BTRFS (device bcache0): parent transid verify failed on
> > > 7567956930560 wanted 613690 found 613681
> > > [  687.913192] BTRFS (device bcache0): parent transid verify failed on
> > > 7567956930560 wanted 613690 found 613681
> > > [  687.913231] BTRFS: failed to read tree root on bcache0
> > > [  687.936073] BTRFS: open_ctree failed
> > > 
> > > The cache device is not going through LVM or anything of the sort, so
> > > this is a direct failure of bcache.  Perhaps due to eraseblock
> > > alignment and assumptions about sizes?  Either way, I've got a ton of
> > > data to recover/restore now and I'm unhappy about it.
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
