From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: journal replay at each boot problematic?
Date: Wed, 29 Mar 2017 19:59:51 +0200
Message-ID: <20170329195951.604ad133@jupiter.sol.kaishome.de>
References: <CAFvQSYSTFPu9yPj-i2E+G53V_Auet8WTQk9q1vAUFQZe=VUWjQ@mail.gmail.com>
        <20170327225133.4aa977dd@jupiter.sol.kaishome.de>
        <CAFvQSYT4Jy9tPJx5CxkLew05AUMMuLFKc0Z2KnARXh4fJf95+w@mail.gmail.com>
        <20170329195257.0e11c5e9@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:57888 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751717AbdC2SAN (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 29 Mar 2017 14:00:13 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <glbd-linux-bcache@m.gmane.org>)
        id 1ctHt2-0000lV-S8
        for linux-bcache@vger.kernel.org; Wed, 29 Mar 2017 20:00:00 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Am Wed, 29 Mar 2017 19:52:57 +0200
schrieb Kai Krakow <hurikhan77@gmail.com>:

> Am Wed, 29 Mar 2017 14:27:11 +0200
> schrieb Clemens Eisserer <linuxhippy@gmail.com>:
> 
> > Hi Kai,
> >   
> > > As far as the docs tell, bcache is designed to shut down unclean.
> > > So this is expected behavior in write-back mode.    
> > 
> > Yes, I also read it - but since I got a few btrfs fs errors when
> > running btrfs check (mostly space-cache related) I became a bit
> > alarmed.
> > As all csums are ok, so I don't think the backing/caching devices
> > are corrupt in any way.  
> 
> This is probably related to btrfs not closed properly or some bug in
> an older kernel. Space cache problems can usually be safely ignored as
> long as the kernel detects them. But maybe ask about this in the btrfs
> list. I'm pretty sure that is related to your shutdown procedure and
> not to bcache. I don't see such messages here without special
> workarounds in the shutdown procedure, however, I'm using initramfs
> created by dracut. It properly unmounts btrfs.
> 
> > > To cleanly detach a bcache, you would need to first put it in
> > > write-through or write-around mode and wait for write-back to
> > > finish. In turn, this mode should also avoid these messages at
> > > boot.    
> > 
> > This is exactly what I do now before each shutdown: switch to
> > writethrough and wait in a bash-loop until state="clean" -
> > sorrounded by two calls to sync.  
> 
> I don't think this is necessary. Just ensure that the FS is umounted
> or at least RO mounted, sync, and ensure that all storage buffers are
> flushed (SCSI, SATA, whatever). Btrfs may lazily still write data even
> in the RO mounted mode. This may be your problem. Bcache may even
> prevent further evil here because of its always-unclean writeback
> behavior.

Addendum: Maybe try "btrfs sync"...

> > However, I still get the journal replay messages at bootup:
> > 
> > [    2.590615] bcache: bch_journal_replay() journal replay done, 827
> > keys in 37 entries, seq 145717  
> 
> Do you properly close the FS before shutting down, i.e. unmount (and
> not only remount RO), and flush the storage layer?
> 



-- 
Regards,
Kai

Replies to list-only preferred.
