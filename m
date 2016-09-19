From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [bcachefs] bcache: bch_open_as_blockdevs() register_cache_set
 err Bad checksum
Date: Sun, 18 Sep 2016 17:05:48 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1609181704590.5413@mail.ewheeler.net>
References: <18fba014-c2d9-2685-cf6d-b1ee0de35bda@mejor.pl> <20160909091548.j5h4axfpghzznux2@kmo-pixel> <281a2205-9a59-ac55-a5a8-7ebe66d52d03@mejor.pl> <20160909100158.gz6rcogyqoi2zu5t@kmo-pixel>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1641074820-71008799-1474243548=:5413"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:48402 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755407AbcISAFt (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 18 Sep 2016 20:05:49 -0400
In-Reply-To: <20160909100158.gz6rcogyqoi2zu5t@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: =?ISO-8859-2?Q?Marcin_Miros=B3aw?= <marcin@mejor.pl>, linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1641074820-71008799-1474243548=:5413
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Fri, 9 Sep 2016, Kent Overstreet wrote:

> On Fri, Sep 09, 2016 at 11:30:06AM +0200, Marcin Mirosław wrote:
> > W dniu 09.09.2016 o 11:15, Kent Overstreet pisze:
> > > On Fri, Sep 09, 2016 at 09:36:59AM +0200, Marcin Mirosław wrote:
> > >> Hi!
> > >> Today I launched host at my job. When I tried to mount bcachefs I got:
> > >> bcache: bch_open_as_blockdevs() register_cache_set err Bad checksum
> > >>
> > >> This is simple, not tieres fs. I don't have idea what to do next to help
> > >> debug this. Data on this fs are completely unimportant.
> > > 
> > > The superblock checksum is bad (I'm going to improve that error message)... what
> > > in the heck...
> > > 
> > > Anything remotely unusual about the machine or how you were using it?
> > 
> > 
> > It's a desktop with KDE, I used this fs for keeping portage tree & i put
> > compilation tmp dir on it (with lz4 compression). Stack is:
> > lvm->raid10->4 x HDD
> 
> That is the kind of setup that would make torn writes much more likely.
> 
> > This is physical machine, I turned it off gracefully. Does image of
> > block device be usefull for you?
> 
> I don't think so. Regardless of what it is, I'm gonna need to work on some kind
> of logged superblock or backup superblocks.
> 
> Assuming it is just a torn write (which I think is pretty likely), you should be
> able to just disable that check and it should work fine - a torn write would
> mostl likely only cause a superblock that's actually invalid if the size of the
> superblock was changing (which is pretty much just when we're allocating the
> journal, or when we're adding or removing devices).


Might it be a good idea to include an "ignore_super_checksum" mount flag?


--
Eric Wheeler


> 
> The check is on super.c line 415 - just change the goto err to a printk and try
> it, I bet it'll work.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--1641074820-71008799-1474243548=:5413--
