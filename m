From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: size limit for backing store? block sizes? ("[sdx] Bad block
 number requested")
Date: Thu, 9 Feb 2017 13:37:46 -0800 (PST)
Message-ID: <alpine.LRH.2.11.1702091335000.5783@mail.ewheeler.net>
References: <20170207133558.Horde.vMEQ46joRTaI1D7afBcEmGv@www3.nde.ag>        <20170207205855.3d9c0985@jupiter.sol.kaishome.de>        <20170208002843.Horde.s0-rn8GSuWk8FVkt60OB6Yb@www3.nde.ag> <20170208005732.207098f6@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:34364 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751030AbdBIVhr (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 9 Feb 2017 16:37:47 -0500
In-Reply-To: <20170208005732.207098f6@jupiter.sol.kaishome.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: kent.overstreet@gmail.com
Cc: linux-bcache@vger.kernel.org, Kai Krakow <hurikhan77@gmail.com>

On Wed, 8 Feb 2017, Kai Krakow wrote:

> Am Wed, 08 Feb 2017 00:28:43 +0100
> schrieb "Jens-U. Mozdzen" <jmozdzen@nde.ag>:
> 
> > Hello Kai,
> > 
> > Zitat von Kai Krakow <hurikhan77@gmail.com>:
> > > Am Tue, 07 Feb 2017 13:35:58 +0100
> > > schrieb "Jens-U. Mozdzen" <jmozdzen@nde.ag>:
> > >  
> > >> Hi *,
> > >> [...]
> > >> If it is about block sizes, questions pile up: Are the "dos" and
> > >> "don'ts" documented anywhere? It's a rather common situation for us
> > >> to run multiple backing devices on a single cache set, with both
> > >> complete HDDs and logical volumes as backing stores. So it's very
> > >> easy to come into a situation where we see either different block
> > >> sizes between backing store and caching device or even differing
> > >> block sizes between the various backing stores.
> > >>
> > >> - using 512b for cache and 4k for backing device seems not to work,
> > >> unless above is purely a size limit problem
> > >>
> > >> - 512b for cache and 512b for backing store seems to work
> > >>
> > >> - 4k for cache and 4k for backing store will probably work as well
> > >>
> > >> - will 4k for cache and 512b for backing store work (sounds likely,
> > >> as there will be no alignment problem in the backing store. OTOH,
> > >> will bcache try to write 4k data (cache block) into 512b blocks
> > >> (backing store) or will it write 8 blocks then, mapping the block
> > >> size differences?)
> > >>
> > >> - if the latter works, will using both 4k and 512b backing stores
> > >> in parallel work if using a 4k cache?
> > >>
> > >> Any insight and/or help tracking down the error are most welcome!  
> > >
> > > Hmm, I think for me it refused to attach backend and cache if block
> > > sizes differ. So I think the bug is there...
> > >
> > > Once I created backing store and cache store in two separate steps.
> > > During attaching, it complained that block sizes don't match and the
> > > cacheset cannot be attached.  
> > 
> > hm, I believe to have created the backing store and cache set in a  
> > common call to make-bcache for the mentioned server 2 and 3 -
> > usually, I only attach separately when creating additional backing
> > stores for an existing cache set. Currently I have no server to test,
> > though. Attaching differingly block-sized cache sets definitely works
> > for me, both kernel 4.1.36 and 4.9.8.
> > 
> > So you're saying that block sizes need to match? Then I'm in
> > trouble, as I have SAS SSDs with 512b and HDDs with 4k block size
> > that build the main storage for the environment in question.
> 
> The hardware block size (aka sector size) is not what is meant here...
> You should use the biggest value. 8x512b fits into 4k. So bcache would
> simply use 4k as the block size and it just works despite the sectors
> being 512b.
> 
> What I meant is "make-bcacke --block X". It defaults to X=512b. I think
> you may want to force it to 4k and see if your problem persists.

Maybe --block 4096 should be default in make-bcache?

Kent, is there any reason this wouldn't be a good idea?


--
Eric Wheeler




> 
> Have a look at bcache-super-show and compare backing and caching dev.
> For all involved devices it shows for me:
> 
> dev.sectors_per_block   8
> 
> All my devices are 512b sector mode. So it is set to 4k for all my
> devices (8x 512b = 4k). I did this to support migrating easily to 4k
> sector devices later.
> 
> If you have different sector sizes (check information from [1]), it
> should say 1 for 4k devices and 8 for 512b devices to use a common
> block size of 4k for the complete set.
> 
> If this didn't match for me, I couldn't attach cache and backing.
> 
> Maybe we are talking different here. I understood you mean these
> values. If blocksize differs (not sectorsize!), it shouldn't be
> attachable. If it is, you're seeing a bug, I guess.
> 
> [1]: grep ^ /sys/block/sd?/queue/hw_sector_size
> 
> PS: Some devices emulate 512b sectors although they use 4k internally.
> In that case you have to force 4k accesses for maximum performance! One
> other reason why I forced 4k blocks on bcache - just to be sure. ;-)
> 
> -- 
> Regards,
> Kai
> 
> Replies to list-only preferred.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
