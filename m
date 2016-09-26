From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: bcache on shared storage
Date: Mon, 26 Sep 2016 14:33:30 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1609261426190.29933@mail.ewheeler.net>
References: <ns990l$c9$1@blaine.gmane.org> <alpine.LRH.2.11.1609251543210.29933@mail.ewheeler.net> <D0761DB0-DCF7-400D-AA08-0E966C2D6E0C@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:54369 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S965507AbcIZVdc (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 26 Sep 2016 17:33:32 -0400
In-Reply-To: <D0761DB0-DCF7-400D-AA08-0E966C2D6E0C@gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michele Brodoloni <mik.linux@gmail.com>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On Mon, 26 Sep 2016, Michele Brodoloni wrote:

> Hi Eric,
> thank you for your reply.
> 
> The shared storage will have LVM on top and each node will have RW 
> access only to its own LVs (actually, these will be the virtual disks of 
> the vms running on each node), this is meant to say that each node is 
> likely going to access different data -- unless a vm is migrated between 
> nodes (??). Does this change anything?

You will still have cache coherency issues between nodes.  This is 
possible if you never migrate and keep per-node volumes isolated, but you 
would need to detach the cache on both sides before migrating (if 
writeback) or at least on the destination node (if write-through) and 
re-attach after migration.

If you do need to migrate (or if a node fails and you must boot from 
another), that could be rather inconvenient and may affect other VMs as 
well.
 
> Unfortunately, exporting luns via iSCSI/AoE is not an option since I'm 
> going to use a DELL VRTX and the storage is provided by a DAS, where 
> there will be both rotational and solid-state disks.

It sounds like you need some kind of distributed coherency layer atop of 
your backend storage.

-Eric



> 
> Regards,
> Michele
> 
> 
> 
> > Il giorno 26/set/2016, alle ore 00:47, Eric Wheeler <bcache@lists.ewheeler.net> ha scritto:
> > 
> >> On Sun, 25 Sep 2016, Michele wrote:
> >> 
> >> Hello everybody,
> >> 
> >> I have a KVM virtualization cluster (3 nodes) which shares the same 
> >> storage. It would be possible to attach a caching device on each node to 
> >> that storage?
> >> 
> >> Let me explain better: I intend to create a raid-0 with two SSDs on each 
> >> node as WT caching devices, then initialize the shared storage as bcache 
> >> backing device, and then attach the caching device on each node to it.
> >> 
> >> Is this going to work?
> > 
> > No.  Even in writethrough mode, remote writes of one node would hit the 
> > lower layer creating stale writethrough caches on the other nodes---that 
> > is unless you would like to implement distributed cache coherency using 
> > DLM.  That would be quite interesting!
> > 
> > You could share bcache0 to multiple nodes if you control its export via 
> > iSCSI or AoE and place a shared filesystem (gfs, ocfs, cLVM, etc) atop of 
> > the exported volume.  I'm not sure if it has been tested, but it would be 
> > neat to get feadback on the subject.
> > 
> > --
> > Eric Wheeler
> > 
> > 
> >> 
> >> 
> >> Thanks,
> >> Michele
> >> 
> >> 
> >> --
> >> Newsy for iOS
> >> Download on the App Store:
> >> https://itunes.apple.com/app/newsy/id598711199
> >> 
> >> 
> >> 
> >> 
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
