From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: How to create bcachefs?
Date: Wed, 24 Aug 2016 16:12:22 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1608241611270.10662@mail.ewheeler.net>
References: <e6d5ceae4a7dd53daf2667e25b76539b@mejor.pl> <20160824065212.fzs2nk3rg7z7iudb@kmo-pixel> <f92c1177-565d-47a1-b3ad-1876774003d4@mejor.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:43221 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752215AbcHXXMZ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 24 Aug 2016 19:12:25 -0400
In-Reply-To: <f92c1177-565d-47a1-b3ad-1876774003d4@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: marcin@mejor.pl
Cc: linux-bcache@vger.kernel.org

On Wed, 24 Aug 2016, marcin@mejor.pl wrote:

> W dniu 24.08.2016 o 08:52, Kent Overstreet pisze:
> [...]
> 
> Hi!
> > Hey, sorry for the long delay, been sick past several days.
> 
> I was afraid that I'm asking to easy question:) And I hope everything is
> fine with you now!
> 
> 
> > The way arguments
> > were passed to bcache format was a holdover from old style make-bcache, and
> > didn't make much sense for bcachefs - -C was used for all devices, and
> > --tier
> > specifies fast devices and slow devices.
> > 
> > I finally got around to redoing the option parsing so we don't need the -C
> > argument today - update your bcache tools, and the command you want is now:
> > 
> > bcache format --tier 0 /dev/sde1 --tier 1 /dev/sdd1

Neat!  How many performance tiers are (will be) supported?  Arbitrary?

--
Eric Wheeler



> > 
> > (assuming sde1 is your fast device and sdd1 is your slow device).
> 
> Does it means that cache is unavailable and only tiering will be in bcachefs?
> And... How to mount tiered FS? When I pass one device in mount I'm getting:
>  bcache: bch_open_as_blockdevs() register_cache_set err insufficient devices
> 
> 
> > Replication is not yet supported (it's around 90% implemented, but I haven't
> > worked on it in ages and the tests haven't been covering it so you'll likely
> > hit
> > bugs if you try it).
> 
> If you tell me how to turn it on I'll try it. In latest bcache-tools
> this option disappeared. Turning on using `echo 2 >
> /sys/fs/bcache/<uid>/options/{data_replicas,metadata_replicas}` doesn't work.
> 
> > Compression still isn't _quite_ done, I reverted the accounting until I fix
> > an
> > issue with copygc. You can enable it and nothing will break, but it won't
> > actually let you store more data in your fs than if it was uncompressed.
> 
> 
> What means option in /sys/fs/..../options/posix_acl? I've got zero value but
> setfacl and getfacl shows that acl works (in theory, I didn't check if ACL
> really works).
> 
> I also have feature request: it would be nice to see which file (with path)
> has
> checksum error, now it looks like this:
> Aug 24 17:15:23 localhost kernel: [ 4692.929060] bcache (dm-10): IO
> error on dm-10 for checksum error
> 
> I can't help with writing code but I can try to help testing bcachefs. I'm
> especially interested in using:
> - cache
> - tiering
> - compression
> - erasure encoding (I know that it isn't started)
> 
> 
> 
> Thank you,
> Marcin
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
