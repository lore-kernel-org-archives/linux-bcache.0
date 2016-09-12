From: Marcin <marcin@mejor.pl>
Subject: Re: [bcachefs] time of mounting filesystem with high number of dirs
Date: Mon, 12 Sep 2016 14:59:35 +0200
Message-ID: <9c9e7ab6-a654-635f-a695-033221093dd0@mejor.pl>
References: <5c0639691edb57d1b63b06effb5283d1@mejor.pl>
 <20160907211212.6pvxo7p5z3v2nvhf@kmo-pixel>
 <20160909015629.356sy3q4gg35szbn@kmo-pixel>
 <6720d1e4-29f9-28a2-18ba-63c7380a3ee8@mejor.pl>
 <20160909090049.o45khhwy5t52icch@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:45408 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755843AbcILNAf (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 12 Sep 2016 09:00:35 -0400
In-Reply-To: <20160909090049.o45khhwy5t52icch@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

W dniu 2016-09-09 11:00, Kent Overstreet napisał(a):
Hi!

> On Fri, Sep 09, 2016 at 09:52:56AM +0200, Marcin Mirosław wrote:
>> I'm using defaults from bcache format, knobs don't have description
>> aboutwneh I should change some options or when I should don't touch 
>> it.
>> On this, particular filesystem btree_node_size=128k according to 
>> sysfs.
> 
> Yeah, documentation needs work. Next time you format maybe try 256k, 
> I'd like to
> know if that helps.
> 
>> > Mounting taking 12 minutes (and the amount of IO you were seeing) implies to me
>> > that a metadata isn't being cached as well as it should be though, which is odd
>> > considering outside of journal replay we aren't doing random access, all the
>> > metadata access is inorder scans. So yeah, definitely want that timing
>> > information...
>> As I mentioned in emai, box has 1GB of RAM, maybe this is bottleneck?
> 
> Yeah, but with fsck off we'll be down to one pass over the dirents 
> btree, so it
> won't matter then.


>> Timing from dmesg:
>> 
>> [  375.537762] bcache (sde1): starting mark and sweep:
>> [  376.220196] bcache (sde1): mark and sweep done
>> [  376.220489] bcache (sde1): starting journal replay:
>> [  376.220493] bcache (sde1): journal replay done, 0 keys in 1 
>> entries,
>> seq 133015
>> [  376.220496] bcache (sde1): journal replay done
>> [  376.220498] bcache (sde1): starting fs gc:
>> [  575.205355] bcache (sde1): fs gc done
>> [  575.205362] bcache (sde1): starting fsck:
>> [  822.522269] bcache (sde1): fsck done
> 
> Initial mark and sweep (walking the extents btree) is fast - that's 
> really good
> to know.
> 
> So there's no actual need to run the fsck on every mount - I just left 
> it that
> way out of an abundance of caution and because on SSD it's cheap.  I 
> just add a
> mount option to skip the fsck - use mount -o nofsck. That'll cut 
> another few
> minutes off your mount time.

<zfs mode on> Why do I ever need fsck?;) <zfs mode off>
Maybe, near final version of bcachefs, fsck should be started only after
unclean shutdown?
HDD won't die in the next year or two, are you concerned especially on
SSD support in bcachefs?

>> >> # time find /mnt/test/ -type d |wc -l
>> >> 10564259
>> 
>> >> real    10m30.305s
>> >> user    1m6.080s
>> >> sys     3m43.770s
>> 
>> >> # time find /mnt/test/ -type f |wc -l
>> >> 9145093
>> 
>> >> real    6m28.812s
>> >> user    1m3.940s
>> >> sys     3m46.210s
> 
> Do you know around how long those find operations take on ext4 with 
> similar
> hardware/filesystem contents? I hope we don't just suck at walking 
> directories.


ext4 with default, 4kB sector size needs at least one hour (I didn't
wait to the end of test). I think that such comparision with ext4 or
testing with other btree_node_size needs simple bash script. I'll wait
with it until OOM fixes will be available in bcache-dev. I've often got
problems with allocation failure when I played with bcachefs,ext4 and
milions of directories.

I noticed that bcachefs needs a lot lot of less space for keeping info
about inodes. Are metadata compressed? If yes then I should do
comparison of filesystems with and without compression.

Additional question:
Should be https://github.com/koverstreet/linux-bcache/issues using?

Thanks,
Marcin
