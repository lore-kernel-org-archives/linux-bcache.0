From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: bcachefs with cache device and backing device
Date: Tue, 17 May 2016 20:01:03 -0800
Message-ID: <20160518040103.GA13870@moria.home.lan>
References: <573532E2.1040201@gemtalksystems.com>
 <20160513043603.GA1407@kmo-pixel>
 <573BD789.9030406@gemtalksystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:32895 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbcEREBH (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 18 May 2016 00:01:07 -0400
Received: by mail-pa0-f48.google.com with SMTP id xk12so13307202pac.0
        for <linux-bcache@vger.kernel.org>; Tue, 17 May 2016 21:01:07 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <573BD789.9030406@gemtalksystems.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Martin McClure <martin.mcclure@gemtalksystems.com>, chris@cooperteam.net
Cc: linux-bcache@vger.kernel.org

On Tue, May 17, 2016 at 07:46:33PM -0700, Martin McClure wrote:
> On 05/12/2016 09:36 PM, Kent Overstreet wrote:
> > 
> > Yeah - tiering replaces cache/backing devices
> > 
> > IIRC,
> > 
> > bcache format --tier 0 -C <SSD> --tier 1 -C <spinning rust>
> > 
> > (the -C is going to go away at some point)
> > 
> 
> Had a chance to play with this some more, but still not getting it to
> work...
> 
> Formatting seems to work, and once I do this:
> 
>   echo /dev/sdd1 > /sys/fs/bcache/register
>   echo /dev/nvme0n1 > /sys/fs/bcache/register
>   echo 1 > /sys/fs/bcache/<set-uuid>/blockdev_volume_create
> 
> a /dev/bcache0 has been created. However, if I try to mount it:
> 
>   mount -t bcache /dev/bcache0 /mnt
> 
> it says:
> 
>   mount: No such file or directory
> 
> with a return code of 32, which is documented as "mount failure".
> 
> At this point I reach the limit of my current understanding, but would
> like to understand more.

The intended mount path for multi device filesystems is currently broken...
Chris got it working (to my surprise) by - I belive - registering all the
devices via /sys/fs/bcache/register, and then mounting just one of the block
devices - Chris, is that correct?

FYI though: tiering mode is _not_ as well tested currently, and Chris managed to
hit a bug when he completely filled up tier 0 and it then wouldn't mount,
because the btree updates journal replay was doing wouldn't fit on tier 0 - and
I haven't merged the fix I sent him because it was kind of a hack.

But I just got back from vacation so I should be able to start working through
these issues...
