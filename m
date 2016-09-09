From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [bcachefs] time of mounting filesystem with high number of dirs
Date: Fri, 9 Sep 2016 01:00:49 -0800
Message-ID: <20160909090049.o45khhwy5t52icch@kmo-pixel>
References: <5c0639691edb57d1b63b06effb5283d1@mejor.pl>
 <20160907211212.6pvxo7p5z3v2nvhf@kmo-pixel>
 <20160909015629.356sy3q4gg35szbn@kmo-pixel>
 <6720d1e4-29f9-28a2-18ba-63c7380a3ee8@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:36581 "EHLO
        mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750908AbcIIJAx (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 9 Sep 2016 05:00:53 -0400
Received: by mail-pa0-f47.google.com with SMTP id id6so26514185pad.3
        for <linux-bcache@vger.kernel.org>; Fri, 09 Sep 2016 02:00:53 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <6720d1e4-29f9-28a2-18ba-63c7380a3ee8@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marcin =?utf-8?B?TWlyb3PFgmF3?= <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org

On Fri, Sep 09, 2016 at 09:52:56AM +0200, Marcin Mirosław wrote:
> I'm using defaults from bcache format, knobs don't have description
> aboutwneh I should change some options or when I should don't touch it.
> On this, particular filesystem btree_node_size=128k according to sysfs.

Yeah, documentation needs work. Next time you format maybe try 256k, I'd like to
know if that helps.

> > Mounting taking 12 minutes (and the amount of IO you were seeing) implies to me
> > that a metadata isn't being cached as well as it should be though, which is odd
> > considering outside of journal replay we aren't doing random access, all the
> > metadata access is inorder scans. So yeah, definitely want that timing
> > information...
> As I mentioned in emai, box has 1GB of RAM, maybe this is bottleneck?

Yeah, but with fsck off we'll be down to one pass over the dirents btree, so it
won't matter then.

> Timing from dmesg:
> 
> [  375.537762] bcache (sde1): starting mark and sweep:
> [  376.220196] bcache (sde1): mark and sweep done
> [  376.220489] bcache (sde1): starting journal replay:
> [  376.220493] bcache (sde1): journal replay done, 0 keys in 1 entries,
> seq 133015
> [  376.220496] bcache (sde1): journal replay done
> [  376.220498] bcache (sde1): starting fs gc:
> [  575.205355] bcache (sde1): fs gc done
> [  575.205362] bcache (sde1): starting fsck:
> [  822.522269] bcache (sde1): fsck done

Initial mark and sweep (walking the extents btree) is fast - that's really good
to know.

So there's no actual need to run the fsck on every mount - I just left it that
way out of an abundance of caution and because on SSD it's cheap.  I just add a
mount option to skip the fsck - use mount -o nofsck. That'll cut another few
minutes off your mount time.

> >> # time find /mnt/test/ -type d |wc -l
> >> 10564259
> 
> >> real    10m30.305s
> >> user    1m6.080s
> >> sys     3m43.770s
> 
> >> # time find /mnt/test/ -type f |wc -l
> >> 9145093
> 
> >> real    6m28.812s
> >> user    1m3.940s
> >> sys     3m46.210s

Do you know around how long those find operations take on ext4 with similar
hardware/filesystem contents? I hope we don't just suck at walking directories.
