From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [bcachefs] bcache: bch_open_as_blockdevs() register_cache_set
 err Bad checksum
Date: Fri, 9 Sep 2016 02:01:58 -0800
Message-ID: <20160909100158.gz6rcogyqoi2zu5t@kmo-pixel>
References: <18fba014-c2d9-2685-cf6d-b1ee0de35bda@mejor.pl>
 <20160909091548.j5h4axfpghzznux2@kmo-pixel>
 <281a2205-9a59-ac55-a5a8-7ebe66d52d03@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34780 "EHLO
        mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750839AbcIIKCC (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 9 Sep 2016 06:02:02 -0400
Received: by mail-pa0-f44.google.com with SMTP id to9so27005648pac.1
        for <linux-bcache@vger.kernel.org>; Fri, 09 Sep 2016 03:02:02 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <281a2205-9a59-ac55-a5a8-7ebe66d52d03@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marcin =?utf-8?B?TWlyb3PFgmF3?= <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org

On Fri, Sep 09, 2016 at 11:30:06AM +0200, Marcin Mirosław wrote:
> W dniu 09.09.2016 o 11:15, Kent Overstreet pisze:
> > On Fri, Sep 09, 2016 at 09:36:59AM +0200, Marcin Mirosław wrote:
> >> Hi!
> >> Today I launched host at my job. When I tried to mount bcachefs I got:
> >> bcache: bch_open_as_blockdevs() register_cache_set err Bad checksum
> >>
> >> This is simple, not tieres fs. I don't have idea what to do next to help
> >> debug this. Data on this fs are completely unimportant.
> > 
> > The superblock checksum is bad (I'm going to improve that error message)... what
> > in the heck...
> > 
> > Anything remotely unusual about the machine or how you were using it?
> 
> 
> It's a desktop with KDE, I used this fs for keeping portage tree & i put
> compilation tmp dir on it (with lz4 compression). Stack is:
> lvm->raid10->4 x HDD

That is the kind of setup that would make torn writes much more likely.

> This is physical machine, I turned it off gracefully. Does image of
> block device be usefull for you?

I don't think so. Regardless of what it is, I'm gonna need to work on some kind
of logged superblock or backup superblocks.

Assuming it is just a torn write (which I think is pretty likely), you should be
able to just disable that check and it should work fine - a torn write would
mostl likely only cause a superblock that's actually invalid if the size of the
superblock was changing (which is pretty much just when we're allocating the
journal, or when we're adding or removing devices).

The check is on super.c line 415 - just change the goto err to a printk and try
it, I bet it'll work.
