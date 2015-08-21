From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: [ANNOUNCE] bcachefs - a general purpose COW filesystem
Date: Thu, 20 Aug 2015 21:25:58 -0800
Message-ID: <20150821052558.GB23571@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:33501 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbbHUF0D (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 21 Aug 2015 01:26:03 -0400
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org
Cc: sviatoslavpestov@gmail.com, mrubin@google.com, zab@zabbo.net, bcrl@kvack.org, ric@redhat.com

For those who haven't kept up with bcache, the bcache codebase has been
evolving/metastasizing into a full blown, general purpose posix filesystem - a
modern COW filesystem with checksumming, compression, multiple devices, caching,
and eventually snapshots and all kinds of other nifty features.

"Yet another new filesystem? Why?"

Well, years ago (going back to when I was still at Google), I and the other
people working on bcache realized that what we were working on was, almost by
accident, a good chunk of the functionality of a full blown filesystem - and
there was a really clean and elegant design to be had there if we took it and
ran with it. And a fast one - the main goal of bcachefs to match ext4 and xfs on
performance and reliability, but with the features of btrfs/zfs.

It's taken a long time to get to this point - longer than I would have guessed
if you'd asked me back when we first started talking about it - but I'm pretty
damn proud of where it's at now.

CURRENT STATUS:

It's more or less feature complete - nothing critical should be missing. You can
try it out and play with it now, and I need more testers/users trying it out and
finding issues. It's in the bcache-dev branch, and you need the dev branch of
bcache-tools:

http://evilpiepirate.org/git/linux-bcache.git bcache-dev
http://evilpiepirate.org/git/bcache-tools.git dev

# bcacheadm format -C /dev/sda1
# mount -t bcache /dev/sda1 /mnt

(one annoyance: blkid recognizes the superblock when bcacheadm formats it, but
usually not after the first mount because it grows to over 4k after allocating
the journal, so after the first mount you need the -t bcache)

I've been focusing on stability and correctness for quite awhile now; xfstests
passes aside from a few relatively minor known issues. It probably won't eat
your data - but no promises.

Also note - the on disk format is NOT finalized yet, and won't be for awhile
though changes are infrequent at this point.

User documentation is still pretty sparse, but one thing I do want people to
look at is the internals documentation:
http://bcache.evilpiepirate.org/BcacheGuide/

FEATURES:
 - multiple devices
   (replication is like 80% done, but the recovery code still needs to be
   finished).

 - caching/tiering (naturally)
   you can format multiple devices at the same time with bcacheadm, and assign
   them to different tiers - right now only two tiers are supported, tier 0
   (default) is the fast tier and tier 1 is the slow tier. It'll effectively do
   writeback caching between tiers.

 - checksumming, compression: currently only zlib is supported for compression,
   and for checksumming there's crc32c and a 64 bit checksum. There's mount
   options for them:
   # mount -o data_checksum=crc32c,compression=gzip

   Caveat: don't try to use tiering and checksumming or compression at the same
   time yet, the read path needs to be reworked to handle both at the same time.

PLANNED FEATURES:
 - snapshots (might start on this soon)
 - erasure coding
 - native support for SMR drives, raw flash

PERFORMANCE:

I'm not really focusing on performance while there's still correctness issues to
work on - so there's lots of things that still need to be further optimized, but
the current performance numbers are still I think good enough to be interesting.

Here's some dbench numbers, running on a high end pcie flash device:

1 thread, O_SYNC:	Throughput		Max latency
bcache:			225.812 MB/sec		18.103 ms
ext4:			454.546 MB/sec		6.288 ms
xfs:			268.81 MB/sec		1.094 ms
btrfs:			271.065 MB/sec		74.266 ms

20 threads, O_SYNC:	Throughput		Max latency
bcache:			1050.03 MB/sec		6.614 ms
ext4:			2867.16 MB/sec		4.128 ms
xfs:			3051.55 MB/sec		10.004 ms
btrfs:			665.995 MB/sec		1640.045 ms

60 threads, O_SYNC:	Throughput		Max latency
bcache:			2143.45 MB/sec		15.315 ms
ext4:			2944.02 MB/sec		9.547 ms
xfs:			2862.54 MB/sec		14.323 ms
btrfs:			501.248 MB/sec		8470.539 ms

1 thread:		Throughput		Max latency
bcache:			992.008 MB/sec		2.379 ms
ext4:			974.282 MB/sec		0.527 ms
xfs:			715.219 MB/sec		0.527 ms
btrfs:			647.825 MB/sec		108.983 ms

20 threads:		Throughput		Max latency
bcache:			3270.8 MB/sec		16.075 ms
ext4:			4879.15 MB/sec		11.098 ms
xfs:			4904.26 MB/sec		20.290 ms
btrfs:			647.232 MB/sec		2679.483 ms

60 threads:		Throughput		Max latency
bcache:			4644.24 MB/sec		130.980 ms
ext4:			4405.16 MB/sec		69.741 ms
xfs:			4413.93 MB/sec		131.194 ms
btrfs:			803.926 MB/sec		12367.850 ms

DESIGN NOTES/CURRENT LIMITATIONS:

"Where'd that 20% of my space go?" - you'll notice the capacity shown by df is
lower than what it should be. Allocation in bcachefs (like in upstream bcache)
is done in terms of buckets, with copygc required if no buckets are empty, hence
we need copygc and a copygc reserve (much like the way SSD FTLs work).

It's quite conceivable at some point we'll add another allocator that doesn't
work in terms of buckets and doesn't require copygc (possibly for rotating
disks), but for a COW filesystem there are real advantages to doing it this way.
So for now just be aware - and the 20% reserve is probably excessive, at some
point I'll add a way to change it.

Mount times:
bcachefs is partially garbage collection based - we don't persist allocation
information. We no longer require doing mark and sweep at runtime to reclaim
space, but we do have to walk the extents btree when mounting to find out what's
free and what isn't.

(We do retain the ability to do a mark and sweep while the filesystem is in use
though - i.e. we have the ability to do a large chunk of what fsck does at
runtime).

Also, we currently have to walk the inodes and dirents on mount to clean up
leaked i_nlinks references, and this code is currently rather simple and dumb.

So with a large enough filesystem you might notice this, but both of these will
be addressed at some point in the future (they aren't issues that are inherent
to the core design).

WHAT NEXT?

My main priority is getting the code sufficiently stable and tested for
production use, probably the #2 priority is snapshots. Bcachefs won't be done in
a month (or a year), but I do want to see it out there and getting used.

PSA: Right now I'm not getting any kind of funding for working on bcachefs; I'm
working on it full time for now but that's only going to last as long as my
interest and my savings account hold out. So - this would be a wonderful time
both for other developers to jump in and get involved, and for potential users
to pony up some funding. If you think this is interesting and worthwhile and you
want to see it completed and upstream - especially if you're at a company that
might make use of it - talk to your $manager or whoever and nag them until they
send me a check :)

If you're an interested user or developer - by all means, get involved! There's
a mailing list, linux-bcache@vger.kernel.org and I'm on irc, OFTC #bcache.
