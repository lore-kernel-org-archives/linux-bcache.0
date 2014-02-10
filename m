From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: bcache and memory at boot. Bug?
Date: Mon, 10 Feb 2014 14:46:48 -0800
Message-ID: <20140210224648.GC2362@kmo>
References: <CAPBO7TbEAf7Bhb-kTFQ00CmBih5CdsXRHeOSf4STxQ+ndy66dQ@mail.gmail.com>
 <ldadrd$4a2$1@ger.gmane.org>
 <CAPBO7TZBgfa2CftYZYv2+dTteyBYJYyXD8vuw7KQNN5xexFjpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:43773 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbaBJWqv (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 10 Feb 2014 17:46:51 -0500
Received: by mail-pd0-f179.google.com with SMTP id fp1so6287845pdb.24
        for <linux-bcache@vger.kernel.org>; Mon, 10 Feb 2014 14:46:51 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAPBO7TZBgfa2CftYZYv2+dTteyBYJYyXD8vuw7KQNN5xexFjpQ@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Josep Lladonosa <jlladono@gmail.com>
Cc: Gabriel de Perthuis <g2p.code@gmail.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On Mon, Feb 10, 2014 at 02:15:14PM +0100, Josep Lladonosa wrote:
> On 10 February 2014 12:40, Gabriel de Perthuis <g2p.code@gmail.com> wrote:
> >> Hello,
> >>
> >> I am using bcache in my laptop (RAM 32 GiB). I have been using it
> >> perfectly for a month. ext4 + bcache.
> >>
> >> Yesterday, system did not want do to a normal startup. Messages where
> >> from udev out of memory (and udevadm killed?) and system was not
> >> mounting / (/dev/bcache0).
> >>
> >> [    6.823222] bcache-register invoked oom-killer: gfp_mask=0x82d2,
> >> order=0, oom_score_adj=0
> >
> > Build your kernel with CONFIG_COMPACTION.  I've added it to the FAQ:
> > http://bcache.evilpiepirate.org/~kent/bcache/FAQ/
> 
> 
> Hello Gabriel,
> 
> Thanks for your reply.
> 
> My .config file has already:
> ...
> CONFIG_COMPACTION=y

I looked at the allocations done in bcache_device_init(), those aren't high
order page allocations (they're vmalloc allocations) so compaction won't help
here.

> ...
> 
> I have been digging around to find information and sometimes bugs come
> related to unsigned variables and their operations when storing large
> numbers (reserved memory?). Kernel is 64 bits. Memory is 32 GiB.
> Perhaps it could happen that the allocated memory is not totally
> freed.
> 
> When kernel has been able to boot with 32 GiB (having bcache0 messed
> up and bcache1 mountable), it seems that bcache has more than 16 GiB
> allocated and kept.

Woah, really? If so that's bad - I don't see how that follows (or am I
misreading) from your numbers, can you show a before and after when you bring
bcache up?

> 
> -Free memory with kernel 3.11.0-rc7 with 32GiB and bcache0 (halved?)
> and bcache1 (mounted)
> 
> $ head -2 /proc/meminfo
> MemTotal:       32913872 kB
> MemFree:        12376640 kB
> 
> 
> - Free memory with kernel 3.12.9 with mem=16G and bcache0 (mounted)
> 
> $ head -2 /proc/meminfo
> MemTotal:       15602144 kB
> MemFree:        14005372 kB
> 
> 
> 
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> -- 
> --
> Salutacions...Josep
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
