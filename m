From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Bcachefs status update, current work
Date: Sat, 1 Dec 2018 18:23:46 -0500
Message-ID: <20181201232346.GA3571@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

So, since I've been pretty quiet since LSF I thought I ought to give an update
on where bcachefs is at - and in particular talk about what sorts of problems
and improvements are currently being worked on.

As of last LSF, there was still a lot of work to be done before we had fast
mount times that don't require walking all metadata. There were two main work
items:
 - atomicity of filesystem operations. Any filesystem operation that had
   anything to do with i_nlink wasn't atomic (but they were ordered so that
   filesystem consistency wasn't an issue) - on startup we'd have to scan and
   recalculate i_nlink and also delete no longer referenced inodes.
 - allocation information wasn't persisted (per bucket sector counts) - so on
   startup we have to walk all the extents and recalculate all the disk space
   accounting.

#1 is done. For those curious about the details, if you've seen how bcachefs
implements rename (with multiple linked btree iterators), it's based off of
that. Basically, there's a new btree transaction context widget for allocating
btree iterators out of, and queuing up updates to be done at transaction commit
- so that different code paths (e.g. inode create, dirent create, xattr create)
can be used together without having to manually write code to keep track of all
the iterators that need to be used and kept locked, etc. I think it's pretty
neat how clean it turned out.

So basically, everything's fully atomic now except for fallocate/fcollapse/etc. -
and after unclean shutdown we do have to scan just the inodes btree for inodes
that have been deleted. Eventually we'll have to implement a linked list of
deleted inodes like xfs does (or perhaps fake hidden directory), but inodes are
small in bcachefs, < 100 bytes, so it's a low priority.

Erasure coding is about 80% done now. I'm quite happy with how erasure coding
turned out - there's no write hole (we never update existing stripes in place),
and we also don't fragment writes like zfs does. Instead, foreground writes are
replicated (raid10 style), and as soon as we have a stripe of new data we write
out p/q blocks and then update the extents with a pointer to the stripe and drop
the now unneeded replicas. Right now it's just reed solomon (raid5/6), but
weaver codes or something else could be added in the future if anyone wants to.
The part that still needs to be implemented before it'll be useful is stripe
level compaction - when we have stripes with some empty blocks (all the data in
them was overwritten), we need to use the remaining data blocks when creating
new stripes so that we can drop the old stripe (and stop pinning the empty
blocks). I'm leaving that off until later though because that won't impact the
on disk format at all, and there's other stuff I want to get done first.

My current priority is reflink - as that will be highly useful to the company
that's funding bcachefs development. That's more or less requiring me to do
persistent allocation information first though, so that's become my current
project (the reflinked extent refcounts will be much too big to keep in memory
like I am now for bucket sector counts, so they'll have to be kept in a btree
and updated whenever doing extent updates - and the infrastructure I need to
make that happen is also what I need for making all the other disk space
accounting persistent).

So, bcachefs will have fast mounts (including after unclean shutdown) soon.

At the very moment what I'm working on (leading up to fast mounts after clean
shutdowns, first) is some improvements to disk space accounting for multi device
filesystems.

The background to this is that in order to know whether you can safely mount in
degraded mode, you have to store a list of all the combinations of disks that
have data replicated across them (or are in an erasure coded stripe) - this is
assuming you don't have any kind of fixed layout, like regular RAID does. That
is, if you've got 8 disks in your filesystem, and you're running with
replicas=2, and two of your disks are offline, you need to know whether you have
any data that's replicated across those two particular disks.

bcachefs has such a table kept in the superblock, but entries in it aren't
refcounted - we create new entries if necessary when inserting new extents into
the extents btree, but we need a gc pass to delete them, generally triggered by
device removal. That's kind of lame, since it means we might fail mounts that
are actually safe.

So, before writing the code to persist the filesystem level sector counts I'm
changing it to track them broken out by replicas entry - i.e. per unique
combination of disks the data lies on. Which also means you'll be able to see in
a multi device filesystem how your data is laid out in a really fine grained
way.

Re: upstreaming - my current thinking is that since so much of the current
development involves on disk format changes/additions it probably make sense to
hold off until reflink is done, which I'm expecting to be in the next 3-6
months. That said, nothing has required any breaking disk format changes -
writing compat code where necessary has been easy enough, so there haven't been
any breaking changes except for one accidental dirent cockup in quite awhile
(~2 years, I think) and one or two changes in features that weren't considered
stable yet (e.g. there was a change to fix extent nonces when encryption was
still new, and I'm still making one or two breaking changes to erasure coding as
it can't actually be used yet without stripe compaction).

That sums up all the big stuff I can think of, the todo list continues to get
shorter and bugs continue to get fixed...
