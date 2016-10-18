From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: Re: [bcachefs] time of mounting filesystem with high number of dirs
 aka ageing filesystem
Date: Tue, 18 Oct 2016 14:51:11 +0200
Message-ID: <5b822456-33cf-f373-2cf3-abea7e0cfb64@mejor.pl>
References: <5c0639691edb57d1b63b06effb5283d1@mejor.pl>
 <20160907211212.6pvxo7p5z3v2nvhf@kmo-pixel>
 <20160909015629.356sy3q4gg35szbn@kmo-pixel>
 <6720d1e4-29f9-28a2-18ba-63c7380a3ee8@mejor.pl>
 <20160909090049.o45khhwy5t52icch@kmo-pixel>
 <2427b898-586a-d176-e2c2-34ec0fc1cd55@mejor.pl>
 <20161018124519.thhcgopwaf5g5lg5@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:57662 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754595AbcJRMvg (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 18 Oct 2016 08:51:36 -0400
In-Reply-To: <20161018124519.thhcgopwaf5g5lg5@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

W dniu 18.10.2016 o 14:45, Kent Overstreet pisze:
> The issue is that right now btree node coalescing is only run as a batch pass
> when mark and sweep GC runs (it has nothing to do with GC, it just runs at the
> same time in the current code). At some point we need to come up with a good way
> of triggering it as needed.
> 
> Try triggering a gc, and then check mount time:
> 
> echo 1 > /sys/fs/bcache/<uuid>/internal/trigger_gc

No change:
[ 8417.101640] bcache (dm-12): starting mark and sweep:
[ 8433.795575] bcache (dm-12): mark and sweep done
[ 8433.795842] bcache (dm-12): starting journal replay:
[ 8433.796064] bcache (dm-12): journal replay done, 129 keys in 90
entries, seq 28581
[ 8433.796075] bcache (dm-12): journal replay done
[ 8433.796076] bcache (dm-12): starting fs gc:
[ 8433.799493] bcache (dm-12): fs gc done
[ 8433.799495] bcache (dm-12): starting fsck:
[ 8433.800613] bcache (dm-12): fsck done


/dev/mapper/system10-bcache  9,8G  421M  9,4G   5% /mnt/test
