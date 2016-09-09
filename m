From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: Re: [bcachefs] time of mounting filesystem with high number of dirs
Date: Fri, 9 Sep 2016 09:52:56 +0200
Message-ID: <6720d1e4-29f9-28a2-18ba-63c7380a3ee8@mejor.pl>
References: <5c0639691edb57d1b63b06effb5283d1@mejor.pl>
 <20160907211212.6pvxo7p5z3v2nvhf@kmo-pixel>
 <20160909015629.356sy3q4gg35szbn@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:21890 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752436AbcIIHx4 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 9 Sep 2016 03:53:56 -0400
In-Reply-To: <20160909015629.356sy3q4gg35szbn@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

W dniu 09.09.2016 o 03:56, Kent Overstreet pisze:
Hi!

> On Wed, Sep 07, 2016 at 01:12:12PM -0800, Kent Overstreet wrote:
>> So, right now we're checking i_nlinks on every mount - mainly the dirents
>> implementation predates the transactional machinery we have now. That's almost
>> definitely what's taking so long, but I'll send you a patch to confirm later.
> 
> I just pushed a patch to add printks for the various stages of recovery: use
> mount -o verbose_recovery to enable.
> 
> How many files does this filesystem have? (df -i will tell you).

>> # time find /mnt/test/ -type d |wc -l
>> 10564259

>> real    10m30.305s
>> user    1m6.080s
>> sys     3m43.770s

>> # time find /mnt/test/ -type f |wc -l
>> 9145093

>> real    6m28.812s
>> user    1m3.940s
>> sys     3m46.210s




> As another data point, on my laptop mounting takes half a second - smallish
> filesystem though, 47 gb of data and 711k inodes (and it's on an SSD). My
> expectation is that mount times with the current code will be good enough as
> long as you're using SSDs (or tiering, where tier 0 is SSD) - but I could use
> more data points.
> 
> Also, increasing the btree node size may help, if you're not already using max
> size btree nodes (256k). I may readd prefetching to metadata scans too, that
> should help a good bit on rotating disks...

I'm using defaults from bcache format, knobs don't have description
aboutwneh I should change some options or when I should don't touch it.
On this, particular filesystem btree_node_size=128k according to sysfs.


> Mounting taking 12 minutes (and the amount of IO you were seeing) implies to me
> that a metadata isn't being cached as well as it should be though, which is odd
> considering outside of journal replay we aren't doing random access, all the
> metadata access is inorder scans. So yeah, definitely want that timing
> information...
As I mentioned in emai, box has 1GB of RAM, maybe this is bottleneck?

Timing from dmesg:

[  375.537762] bcache (sde1): starting mark and sweep:
[  376.220196] bcache (sde1): mark and sweep done
[  376.220489] bcache (sde1): starting journal replay:
[  376.220493] bcache (sde1): journal replay done, 0 keys in 1 entries,
seq 133015
[  376.220496] bcache (sde1): journal replay done
[  376.220498] bcache (sde1): starting fs gc:
[  575.205355] bcache (sde1): fs gc done
[  575.205362] bcache (sde1): starting fsck:
[  822.522269] bcache (sde1): fsck done



Marcin
