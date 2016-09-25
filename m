From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: bcache on shared storage
Date: Sun, 25 Sep 2016 15:47:55 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1609251543210.29933@mail.ewheeler.net>
References: <ns990l$c9$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:47595 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755661AbcIYWr5 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 25 Sep 2016 18:47:57 -0400
In-Reply-To: <ns990l$c9$1@blaine.gmane.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michele <mik.linux@gmail.com>
Cc: linux-bcache@vger.kernel.org

On Sun, 25 Sep 2016, Michele wrote:

> Hello everybody,
> 
> I have a KVM virtualization cluster (3 nodes) which shares the same 
> storage. It would be possible to attach a caching device on each node to 
> that storage?
> 
> Let me explain better: I intend to create a raid-0 with two SSDs on each 
> node as WT caching devices, then initialize the shared storage as bcache 
> backing device, and then attach the caching device on each node to it.
>
> Is this going to work?

No.  Even in writethrough mode, remote writes of one node would hit the 
lower layer creating stale writethrough caches on the other nodes---that 
is unless you would like to implement distributed cache coherency using 
 DLM.  That would be quite interesting!

You could share bcache0 to multiple nodes if you control its export via 
iSCSI or AoE and place a shared filesystem (gfs, ocfs, cLVM, etc) atop of 
the exported volume.  I'm not sure if it has been tested, but it would be 
neat to get feadback on the subject.

--
Eric Wheeler


> 
> 
> Thanks,
> Michele
> 
> 
> --
> Newsy for iOS
> Download on the App Store:
> https://itunes.apple.com/app/newsy/id598711199
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
