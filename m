From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [bcachefs] time of mounting filesystem with high number of dirs
 aka ageing filesystem
Date: Tue, 18 Oct 2016 04:45:19 -0800
Message-ID: <20161018124519.thhcgopwaf5g5lg5@kmo-pixel>
References: <5c0639691edb57d1b63b06effb5283d1@mejor.pl>
 <20160907211212.6pvxo7p5z3v2nvhf@kmo-pixel>
 <20160909015629.356sy3q4gg35szbn@kmo-pixel>
 <6720d1e4-29f9-28a2-18ba-63c7380a3ee8@mejor.pl>
 <20160909090049.o45khhwy5t52icch@kmo-pixel>
 <2427b898-586a-d176-e2c2-34ec0fc1cd55@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:34491 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758926AbcJRMpY (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 18 Oct 2016 08:45:24 -0400
Received: by mail-pf0-f180.google.com with SMTP id r16so70761166pfg.1
        for <linux-bcache@vger.kernel.org>; Tue, 18 Oct 2016 05:45:23 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <2427b898-586a-d176-e2c2-34ec0fc1cd55@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marcin =?utf-8?B?TWlyb3PFgmF3?= <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org

On Tue, Oct 18, 2016 at 02:14:47PM +0200, Marcin Mirosław wrote:
> W dniu 09.09.2016 o 11:00, Kent Overstreet pisze:
> > On Fri, Sep 09, 2016 at 09:52:56AM +0200, Marcin Mirosław wrote:
> >> I'm using defaults from bcache format, knobs don't have description
> >> aboutwneh I should change some options or when I should don't touch it.
> >> On this, particular filesystem btree_node_size=128k according to sysfs.
> > 
> > Yeah, documentation needs work. Next time you format maybe try 256k, I'd like to
> > know if that helps.
> 
> Hi!
> 
> # bcache format --help
> bcache format - create a new bcache filesystem on one or more devices
> Usage: bcache format [OPTION]... <devices>
> 
> Options:
>   -b, --block=size
>       --btree_node=size       Btree node size, default 256k
>                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ it's not true

It is if your bucket size is big enough - btree node size can't be bigger than
bucket size.

> # bcache format  /dev/mapper/system10-bcache
> /dev/mapper/system10-bcache contains a bcache filesystem
> Proceed anyway? (y,n) y
> External UUID:                  1a064a62-fb61-42c8-8f0e-68961ad37d4c
> Internal UUID:                  c2802bef-fbc4-414a-9fb0-e071943582c8
> Label:
> Version:                        6
> Block_size:                     512
> Btree node size:                128.0K
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> 
> I see another problem, I observed it due to long mount time.
> I'm creating many dirs:
> # for x in {0..31}; do eatmydata \
> mkdir -p /mnt/test/a/${x}/{0..255}/{0..255}; done
> 
> # find /mnt/test|wc -l
> 2105378
> 
> df -h shows:
> /dev/mapper/system10-bcache          9,8G  421M  9,4G   5% /mnt/test
> 
> next I removing all those dirs. Umount, mount:
> [ 6172.131784] bcache (dm-12): starting mark and sweep:
> [ 6189.113714] bcache (dm-12): mark and sweep done
> [ 6189.113979] bcache (dm-12): starting journal replay:
> [ 6189.114201] bcache (dm-12): journal replay done, 129 keys in 88
> entries, seq 28579
> [ 6189.114214] bcache (dm-12): journal replay done
> [ 6189.114214] bcache (dm-12): starting fs gc:
> [ 6189.118244] bcache (dm-12): fs gc done
> [ 6189.118246] bcache (dm-12): starting fsck:
> [ 6189.119220] bcache (dm-12): fsck done
> 
> So mount time is still long, even with empty fileystem.
> df shows:
> /dev/mapper/system10-bcache  9,8G  421M  9,4G   5% /mnt/test
> 
> # find /mnt/test|wc -l
> 1
> 
> It looks that creating and removing dirs doesn't clean some internal
> structures.

The issue is that right now btree node coalescing is only run as a batch pass
when mark and sweep GC runs (it has nothing to do with GC, it just runs at the
same time in the current code). At some point we need to come up with a good way
of triggering it as needed.

Try triggering a gc, and then check mount time:

echo 1 > /sys/fs/bcache/<uuid>/internal/trigger_gc
