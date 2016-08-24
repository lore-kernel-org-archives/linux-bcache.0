From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: How to create bcachefs?
Date: Wed, 24 Aug 2016 15:50:21 -0800
Message-ID: <20160824235021.xtqva4eb4tomghw6@kmo-pixel>
References: <e6d5ceae4a7dd53daf2667e25b76539b@mejor.pl>
 <20160824065212.fzs2nk3rg7z7iudb@kmo-pixel>
 <f92c1177-565d-47a1-b3ad-1876774003d4@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:36593 "EHLO
        mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753118AbcHYFUz (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 25 Aug 2016 01:20:55 -0400
Received: by mail-pa0-f47.google.com with SMTP id di2so13442299pad.3
        for <linux-bcache@vger.kernel.org>; Wed, 24 Aug 2016 22:20:54 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <f92c1177-565d-47a1-b3ad-1876774003d4@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: marcin@mejor.pl
Cc: linux-bcache@vger.kernel.org

On Wed, Aug 24, 2016 at 11:21:02PM +0200, marcin@mejor.pl wrote:
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
> > were passed to bcache format was a holdover from old style make-bcache,
> > and
> > didn't make much sense for bcachefs - -C was used for all devices, and
> > --tier
> > specifies fast devices and slow devices.
> > 
> > I finally got around to redoing the option parsing so we don't need the
> > -C
> > argument today - update your bcache tools, and the command you want is
> > now:
> > 
> > bcache format --tier 0 /dev/sde1 --tier 1 /dev/sdd1
> > 
> > (assuming sde1 is your fast device and sdd1 is your slow device).
> 
> Does it means that cache is unavailable and only tiering will be in
> bcachefs?
> And... How to mount tiered FS? When I pass one device in mount I'm getting:
>  bcache: bch_open_as_blockdevs() register_cache_set err insufficient devices

you should be able to do
mount -t bcache /dev/sde1:/dev/sdd1 /mnt

or, there's incremental assembly - that's going to be handled by the bcache tool
eventually, but for now you can register each device via
/sys/fs/bcache/register, and then mount one of the block devices.

> > Replication is not yet supported (it's around 90% implemented, but I
> > haven't
> > worked on it in ages and the tests haven't been covering it so you'll
> > likely hit
> > bugs if you try it).
> 
> If you tell me how to turn it on I'll try it. In latest bcache-tools
> this option disappeared. Turning on using `echo 2 >
> /sys/fs/bcache/<uid>/options/{data_replicas,metadata_replicas}` doesn't
> work.

Wouldn't be any point, you'd undoubtedly hit bugs that I don't have time to work
on yet. Current priorities are finishing encryption and compression...

> > Compression still isn't _quite_ done, I reverted the accounting until I
> > fix an
> > issue with copygc. You can enable it and nothing will break, but it
> > won't
> > actually let you store more data in your fs than if it was uncompressed.
> 
> 
> What means option in /sys/fs/..../options/posix_acl? I've got zero value but
> setfacl and getfacl shows that acl works (in theory, I didn't check if ACL
> really works).

hmm, option must be buggered. I'll have a look.

> I also have feature request: it would be nice to see which file (with path)
> has
> checksum error, now it looks like this:
> Aug 24 17:15:23 localhost kernel: [ 4692.929060] bcache (dm-10): IO
> error on dm-10 for checksum error

that's a good idea - though it'd take some plumbing to get a path, and we don't
even always have a path (may have just an inode number). I'll make a note to
have a look.

> I can't help with writing code but I can try to help testing bcachefs. I'm
> especially interested in using:
> - cache
> - tiering
> - compression
> - erasure encoding (I know that it isn't started)

I am thinking about working on replication and erasure coding after I finish
what's currently lined up, erasure coding should be a fun project.

Lots to do...
