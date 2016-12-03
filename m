From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: bcachefs: metadata IO improvements in bcachefs-testing
Date: Fri, 2 Dec 2016 19:04:02 -0900
Message-ID: <20161203040402.cb4buidtgrclsn2v@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:32778 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751937AbcLCEEG (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 2 Dec 2016 23:04:06 -0500
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-fsdevel@vger.kernel.org

TL;DR: New performance improvements up in the bcachefs-testing branch at
https://evilpiepirate.org/git/linux-bcache.git/

The writeup below is also the patreon page, https://www.patreon.com/posts/7395461

As usual, I still need more funding, so please chip in on Patreon if you can.
Or, if your company is interested in bcachefs, shoot me an email...

---------------------------------------

First off, some background on where we're at currently, regarding metadata IO:

- A userspace process will never block on IO - i.e., wait for a journal write
or a btree node write - unnecessarily. Never ever.  The only reason your
userspace proccess will end up blocked waiting for a metadata write to complete
is either: you asked to (fsync), or resource exhaustion (either the journal
filling up, or we don't have enough memory to allocate a new btree node without
flushing some other dirty btree node). Not even indirectly - if there's a lock
we need to take to handle some syscall (e.g. btree node locks for a
create/rename/etc.), then that lock is never held while we're blocking on IO.

This really is bragging rights all on its own - it means our tail latency is
significantly better than other filesystems. If you're a programmer who's ever
gotten annoyed by vim hanging when you go to save (probably after you've been
compiling your code and generating a bunch of dirty pages) - if you're using
bcachefs, that never ever happens. The system just plain feels more responsive
and faster - something I hadn't noticed until a user complained about it on IRC
when he temporarily had to go back to ext4, because I've been using bcachefs on
my development laptop for quite awhile now and it's one of the things you don't
think about when it's no longer an annoyance...

So: that part is good, but that doesn't mean there aren't things to improve
with respect to metadata writes.

Where we really want to be is to not be _issuing_ any metadata writes, unless
we need to to avoid resource exhaustion - that is, ideally btree node writes
should only happen when triggered by journal reclaim.

In current bcache-dev, this isn't the case: we'll only buffer up to 4k of dirty
data in a btree node before writing it out, and since the default btree node
size is 256k for a typical filesystem size that's not very much. Most btree
node IO is triggered by hitting that 4k limit, not by journal reclaim.

This is a real issue for performance, for a couple reasons:

- If we buffered up more before writing, we'd end up writing less data overall.
Most btree node updates are overwriting an existing key (e.g. updating access
times on an inode), so if we buffer up more we'd end up writing out only the
latest version of that inode, not all the versions that were overwritten since
the previous write.

- More importantly: btree node writes are always issued as FUA writes (forced
unit access, i.e. with write caching disabled). If your device doesn't support
FUA, the kernel has to emulate it with an expensive flush - and we really don't
want to be issuing more flushes than we have to.

- Lastly, since our btree nodes are so big if we buffer up more we can issue
much larger writes, which is significantly more efficient than issuing lots of
little writes. With our large btree nodes, we should be able to flush metadata
drastically more efficiently than any existing filesystem, in fact.

So, this is what I was working on for quite awhile.

The first issue relates to how we manage btree nodes: as mentioned, btree nodes
are log structured, with multiple sorted sets of keys. In memory, we
sort/compact as needed so that we never have more than three different sets of
keys: the lookup and iterator code has to search through and maintain pointers
into each sorted set of keys, so we don't want to deal with too many. Having
multiple sorted sets of keys ends up being a performance win, since the result
is that only the newest and smallest is being modified at any given time, and
the rest are constant - we can construct lookup tables for the constant sets of
keys that are drastically more efficient for lookup, but wouldn't be possible
to update without regenerating the entire lookup table.

The reason we were issuing writes when we had 4k of dirty data buffered up is
that inserting into a sorted set of keys that's larger than that is too
expensive, mainly because of the memmove() - and the code all assumed that all
sets of keys except for the last one were written, so to start a new set of
keys we had to write the existing one.

So, fixing that by allowing more than one set of keys to be unwritten was
straightforward enough, but as is often the case solving one issue creates
another.

The new issue was related to whiteouts. The need for whiteouts also arises from
the fact that btree nodes are log structured - if we delete a key that has been
written, we have to emit and write out a whiteout, so that when we read the
btree node back in we know that key was deleted.

We don't need or want whiteouts in the in memory btree node, so as soon as a
set of keys has been written we compact it and drop all the whiteouts. But if
we're buffering up a lot more dirty keys, then we're also buffering up a lot
more whiteouts - and whiteouts slow down the lookup code, which has to skip
past them to find the next live key.

The result of just doing the btree node write changes was that fsmark got quite
a bit faster - but rm -rfing all the files fsmark created got quite a bit
slower. Oops.

The whiteouts optimizations ended up being quite a bit more complicated -
there's a couple things going on in those patches.

Firstly, since we're now buffering up a lot more data before writing out btree
nodes, it becomes more worthwhile to make sure we only emit a whiteout when
actually needed: if we're deleting a key that was never written, we don't need
to emit a whiteout - unless that key was itself overwriting a key that had been
written, in which case we do. So tracking when we need to emit whiteouts has
some subtlety to it.

The other thing the whiteouts patches do is that when we compact whiteouts from
a btree node, the whiteouts that we need to write out are separated from the
live keys (where they won't affect the lookup code) and kept in a separate area
by themselves, until the btree node is written.

There were a fair number of other smaller optimizations related to whiteouts,
but those were the two main ideas.

The end result: on the fsmark benchmark I've been running, btree node writes
are reduced by about 80%. Journal writes now dominate, so total metadata IO is
cut a little less than in half in that benchmark - but since we'll buffer up to
256k per journal write (assuming nothing is doing a sync() or fsync() to force
a journal write), performance for metadata heavy, non sync heavy workloads
should be significantly improved.

We're still not optimal with respect to btree node writes: writes for new btree
nodes (e.g. from a split or merge) are kicked off immediately, even if the
journal won't need those keys to be written for quite some time. Fixing that
would be quite a bit more difficult though, and (as seen from the 80%
reduction) those are a significantly smaller fraction of metadata IO, so we'll
leave that for now.

As always, benchmarking and testing is greatly appreciated. These changes were
tricky enough that I really want them tested awhile before going into
bcache-dev, so please let me know if you test them and what the results were.
