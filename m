From: Nix <nix@esperi.org.uk>
Subject: 4.11.4: failure at boot with spontaneously corrupted bcache: cache device still available for analysis
Date: Wed, 07 Jun 2017 23:17:48 +0100
Message-ID: <87poeftpbn.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:35696 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751433AbdFGWRv (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 7 Jun 2017 18:17:51 -0400
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.15.2/8.15.2) with ESMTP id v57MHmia001038
        for <linux-bcache@vger.kernel.org>; Wed, 7 Jun 2017 23:17:48 +0100
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

So this is my first reboot in anger of my new writearound bcache (not my
first reboot, but my first reboot after letting the cache populate
itself: it's still 85% empty and has never needed to GC). As usual, I
get a timeout error from bcache on restart, right before rebooting, but
then, at boot...

# Register all bcaches.
if [ -f /sys/fs/bcache/register_quiet ]; then
    for name in /dev/sd*[0-9]* /dev/md/*; do
        echo $name > /sys/fs/bcache/register_quiet 2>&1
    done
    # New devices registered: create them, after a short delay
    # to let the registration happen.
    sleep 1
    /sbin/mdev -s
fi

... does *this* (including the messages showing that the md array it's
caching is happy):

[   11.281907] md: md125 stopped.
[   11.294948] md/raid:md125: device sda3 operational as raid disk 0
[   11.305620] md/raid:md125: device sdf3 operational as raid disk 4
[   11.315899] md/raid:md125: device sdd3 operational as raid disk 3
[   11.325770] md/raid:md125: device sdc3 operational as raid disk 2
[   11.335245] md/raid:md125: device sdb3 operational as raid disk 1
[   11.344688] md/raid:md125: raid level 6 active with 5 out of 5 devices, algorithm 2
[   11.353810] md125: detected capacity change from 0 to 15761089757184

[   11.468956] bcache: prio_read() bad csum reading priorities
[   11.478010] bcache: prio_read() bad magic reading priorities
[   11.497911] bcache: error on 314dcdd2-9869-4110-99cc-9cd3a861afa6: 
[   11.497914] bad checksum at bucket 28262, block 0, 36185 keys
[   11.507021] , disabling caching
[   11.529823] bcache: register_cache() registered cache device sde2
[   11.539054] bcache: cache_set_free() Cache set 314dcdd2-9869-4110-99cc-9cd3a861afa6 unregistered
[   11.558596] bcache: register_bdev() registered backing device md125

This then leaves me without a rootfs until I thrash around and figure
out how to detach the cache and leave me with a working backing device
again. The machine has ECCRAM, and the SSD is one of the Intel DC ones
with supercapacitors etc, so I don't think we can blame either of those
parts. This is software killing itself with no assistance needed from
hardware, I think.

This is writearound, without most of the horrible complexities of
writeback cache invalidation: all the cache has to note is that a given
block has been written and should be invalidated on next read. So I
don't think we can blame that machinery, either. This is just the bcache
failing to do its job writing on shutdown, presumably because it
spontaneously times out instead. (Why?!)

The machine has heaps of RAM (128GiB) so you can't rely on memory
pressure writing stuff out -- much of the time, there is none. I suspect
that's the problem here... if it's doing any writing at all, two seconds
is not remotely long enough -- at the rated 480MiB/s (yeah right), my
SSD might take up to *250 seconds* to finish its writeout. Two seconds
is not remotely long enough if it's trying to let a writeout finish.

Several points spring to mind:

 - Why does it time out on reboot, rather than, say, trying to write
   enough out that it does not crash on restart? Why does it only wait
   for a fixed, very short, timespan?

 - Bad checksums are all very well, but in writearound mode it should
   come up *anyway*, sans cache, since the cache is devoid of dirty data

 - Bad checksums are all very well, but in writearound mode it should
   discard the minimum possible -- in this case, one bucket -- and keep
   going with 99% of the cache intact.

I still have the cache in question sitting there on the block device if
anyone wants a look at it. (Some of what it contains is an ordinary xfs
fs: the rest is cryptsetup stuff.)

Anyone know what could be wrong here, and how I can prevent it happening
again? One presumes I can get an empty cache back by just wipefsing and
re-make_bcaching the cache device, but I'd rather not do that until I
know if anyone wants to take a look at it.
