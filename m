From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [bcachefs] problem with `bcache fsck`
Date: Thu, 16 Mar 2017 12:34:55 -0800
Message-ID: <20170316203455.jgl6ovsrve55fnxi@moria.home.lan>
References: <6aaaad468dd77840265bcd9f31f1878a@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:33461 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752122AbdCPUfT (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 16 Mar 2017 16:35:19 -0400
Received: by mail-pg0-f43.google.com with SMTP id n190so30502991pga.0
        for <linux-bcache@vger.kernel.org>; Thu, 16 Mar 2017 13:35:19 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <6aaaad468dd77840265bcd9f31f1878a@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marcin <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org

On Thu, Mar 16, 2017 at 04:16:29PM +0100, Marcin wrote:
> Hi!
> It's good to hear that silence on mailinglist doesn't mean that there is no
> changes in developing bcachefs!

Join the irc channel! It's pretty active.

> I found some problems with bcache tools.
> bcache fsck errors:
> 
> a) if I creat4e filesystem and run fsck before first mount I'm getting:
> # bcache fsck /dev/sdd1
> initializing new filesystem
> error opening /dev/sdd1: cannot allocate new btree root
>
> b) After first mount%umount fsck still doesn't work:
> # bcache fsck /dev/sdd1
> no journal entries found
> filesystem contains errors, but repair impossible
> error opening /dev/sdd1: fsck error

Man, you have a talent for finding bugs :) I've reproduced it, working on it
now.

> Is bcache fsck able to do fsck on tiered devices?

Yes - just pass it all the devices, e.g.
bcache fsck /dev/sdb /dev/sdc

Also, keep in mind fsck is still run by default at mount time, there's normally
no need to use userspace fsck (and running fsck in userspace and then mounting
will be slower than just mounting and running fsck then, due to mount still
having to scan all the metadata which will be cache cold).

> I know that there is some stability problem with tiered devices because when
> I mounted tiered fs and started to copy files on it the host rebooted after
> some time. I have to run netconsole to catch what kernel says, then I post
> it on ML.

You might have been hitting a bug in a recent patch to improve readpages
performance - I backed it out last night after I discovered it.

> And I'm still missing compression saves free space on disk:)

Yeah, that's something I've been wanting to get to, but people have been
badgering me for replication more :)
