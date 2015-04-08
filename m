From: Dan Merillat <dan.merillat@gmail.com>
Subject: Re: bcache fails after reboot if discard is enabled
Date: Tue, 7 Apr 2015 20:06:01 -0400
Message-ID: <CAPL5yKf4Tz1oUDNTEz20+CXh-UEeZaNBZCD9pevg47kGnWmDQQ@mail.gmail.com>
References: <54A66945.6030403@profihost.ag>
	<54A66C44.6070505@profihost.ag>
	<54A819A0.9010501@rolffokkens.nl>
	<54A843BC.608@profihost.ag>
	<loom.20150105T010336-763@post.gmane.org>
	<tcfnqb-u59.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:35374 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbbDHAGD (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 7 Apr 2015 20:06:03 -0400
Received: by ierf6 with SMTP id f6so61138995ier.2
        for <linux-bcache@vger.kernel.org>; Tue, 07 Apr 2015 17:06:02 -0700 (PDT)
In-Reply-To: <tcfnqb-u59.ln1@hurikhan77.spdns.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

> It works perfectly fine here with latest 3.18. My setup is backing a btrfs
> filesystem in write-back mode. I can reboot cleanly, hard-reset upon
> freezes, I had no issues yet and no data loss. Even after hard-reset the
> kernel logs of both bcache and btrfs were clean, the filesystem was clean,
> just the usual btrfs recovery messages after an unclean shutdown.
>
> I wonder if the SSD and/or the block layer in use may be part of the
> problem:
>
>   * if putting bcache on LVM, discards may not be handled well
>   * if putting bcache or the backing fs on LVM, barriers may not be handled
>     well (bcache relies on perfectly working barriers)
>   * does the SSD support powerloss protection? (IOW, use capacitors)
>   * latest firmware applied? read the changelogs of it?
>
> I'd try to first figure out these differences before looking further into
> debugging. I guess that most consumer-grade drives at least lack a few of
> the important features to use write-back mode, or use bcache at all.
>
> So, to start the list: My SSD is a Crucial MX100 128GB with discards enabled
> (for both bcache and btrfs), using plain raw devices (no LVM or MD
> involved). It supports TRIM (as my chipset does), and it supports powerloss-
> protection and maybe even some internal RAID-like data protection layer
> (whatever that is, it's in the papers).
>
> I'm not sure what a hard-reset technically means to the SSD but I guess it
> is handled as some sort of short powerloss. Reading through different SSD
> firmware update descriptions, I also see a lot words around power-off and
> reset problems being fixed that could lead to data-loss otherwise. That
> could be pretty fatal to bcache as it considers it storage as always unclean
> (probably even in write-through mode). Having damaged data blocks out of
> expected write order (barriers!) could be pretty bad when bcache recovers
> from last shutdown and replays logs.

Samsung 840-EVO 256GB here, running 4.0-rc7 (was 3.18)

There's no known issues with TRIM on an 840-EVO, and no powerloss or
anything of the sort occurred.  I was seeing excessive write
amplification on my SSD, and enabled discard - then my machine
promptly started lagging, eventually disk access locked up and after a
reboot I was confronted with:

[  276.558692] bcache: journal_read_bucket() 157: too big, 552 bytes,
offset 2047
[  276.571448] bcache: prio_read() bad csum reading priorities
[  276.571528] bcache: prio_read() bad magic reading priorities
[  276.576807] bcache: error on 804d6906-fa80-40ac-9081-a71a4d595378:
bad btree header at bucket 65638, block 0, 0 keys, disabling caching
[  276.577457] bcache: register_cache() registered cache device sda4
[  276.577632] bcache: cache_set_free() Cache set
804d6906-fa80-40ac-9081-a71a4d595378 unregistered

Attempting to check the backingstore (echo 1 > bcache/running):

[  687.912987] BTRFS (device bcache0): parent transid verify failed on
7567956930560 wanted 613690 found 613681
[  687.913192] BTRFS (device bcache0): parent transid verify failed on
7567956930560 wanted 613690 found 613681
[  687.913231] BTRFS: failed to read tree root on bcache0
[  687.936073] BTRFS: open_ctree failed

The cache device is not going through LVM or anything of the sort, so
this is a direct failure of bcache.  Perhaps due to eraseblock
alignment and assumptions about sizes?  Either way, I've got a ton of
data to recover/restore now and I'm unhappy about it.
