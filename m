From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [bcachefs] time of mounting filesystem with high number of dirs
 aka ageing filesystem
Date: Tue, 18 Oct 2016 05:19:00 -0800
Message-ID: <20161018131900.qq7uokypa5ig6qvd@kmo-pixel>
References: <5c0639691edb57d1b63b06effb5283d1@mejor.pl>
 <20160907211212.6pvxo7p5z3v2nvhf@kmo-pixel>
 <20160909015629.356sy3q4gg35szbn@kmo-pixel>
 <6720d1e4-29f9-28a2-18ba-63c7380a3ee8@mejor.pl>
 <20160909090049.o45khhwy5t52icch@kmo-pixel>
 <2427b898-586a-d176-e2c2-34ec0fc1cd55@mejor.pl>
 <20161018124519.thhcgopwaf5g5lg5@kmo-pixel>
 <5b822456-33cf-f373-2cf3-abea7e0cfb64@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:35295 "EHLO
        mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755617AbcJRNTE (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 18 Oct 2016 09:19:04 -0400
Received: by mail-pf0-f169.google.com with SMTP id s8so94772079pfj.2
        for <linux-bcache@vger.kernel.org>; Tue, 18 Oct 2016 06:19:04 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <5b822456-33cf-f373-2cf3-abea7e0cfb64@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marcin =?utf-8?B?TWlyb3PFgmF3?= <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org

On Tue, Oct 18, 2016 at 02:51:11PM +0200, Marcin Mirosław wrote:
> W dniu 18.10.2016 o 14:45, Kent Overstreet pisze:
> > The issue is that right now btree node coalescing is only run as a batch pass
> > when mark and sweep GC runs (it has nothing to do with GC, it just runs at the
> > same time in the current code). At some point we need to come up with a good way
> > of triggering it as needed.
> > 
> > Try triggering a gc, and then check mount time:
> > 
> > echo 1 > /sys/fs/bcache/<uuid>/internal/trigger_gc
> 
> No change:
> [ 8417.101640] bcache (dm-12): starting mark and sweep:
> [ 8433.795575] bcache (dm-12): mark and sweep done
> [ 8433.795842] bcache (dm-12): starting journal replay:
> [ 8433.796064] bcache (dm-12): journal replay done, 129 keys in 90
> entries, seq 28581
> [ 8433.796075] bcache (dm-12): journal replay done
> [ 8433.796076] bcache (dm-12): starting fs gc:
> [ 8433.799493] bcache (dm-12): fs gc done
> [ 8433.799495] bcache (dm-12): starting fsck:
> [ 8433.800613] bcache (dm-12): fsck done
> 
> 
> /dev/mapper/system10-bcache  9,8G  421M  9,4G   5% /mnt/test

well that's odd.

I'll work on getting some more information out of coalescing tomorrow.
