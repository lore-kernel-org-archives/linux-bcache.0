From: Dave Chinner <david@fromorbit.com>
Subject: Re: bcachefs status update (it's done cooking; let's get this sucker
 merged)
Date: Thu, 13 Jun 2019 09:02:24 +1000
Message-ID: <20190612230224.GJ14308@dread.disaster.area>
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
 <CAHk-=wi0iMHcO5nsYug06fV3-8s8fz7GDQWCuanefEGq6mHH1Q@mail.gmail.com>
 <20190611011737.GA28701@kmo-pixel>
 <20190611043336.GB14363@dread.disaster.area>
 <20190612162144.GA7619@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190612162144.GA7619@kmo-pixel>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <dchinner@redhat.com>, Waiman Long <longman@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-bcache@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, Zach Brown <zach.brown@ni.com>, Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-bcache@vger.kernel.org

On Wed, Jun 12, 2019 at 12:21:44PM -0400, Kent Overstreet wrote:
> On Tue, Jun 11, 2019 at 02:33:36PM +1000, Dave Chinner wrote:
> > I just recently said this with reference to the range lock stuff I'm
> > working on in the background:
> > 
> > 	FWIW, it's to avoid problems with stupid userspace stuff
> > 	that nobody really should be doing that I want range locks
> > 	for the XFS inode locks.  If userspace overlaps the ranges
> > 	and deadlocks in that case, they they get to keep all the
> > 	broken bits because, IMO, they are doing something
> > 	monumentally stupid. I'd probably be making it return
> > 	EDEADLOCK back out to userspace in the case rather than
> > 	deadlocking but, fundamentally, I think it's broken
> > 	behaviour that we should be rejecting with an error rather
> > 	than adding complexity trying to handle it.
> > 
> > So I think this recusive locking across a page fault case should
> > just fail, not add yet more complexity to try to handle a rare
> > corner case that exists more in theory than in reality. i.e put the
> > lock context in the current task, then if the page fault requires a
> > conflicting lock context to be taken, we terminate the page fault,
> > back out of the IO and return EDEADLOCK out to userspace. This works
> > for all types of lock contexts - only the filesystem itself needs to
> > know what the lock context pointer contains....
> 
> Ok, I'm totally on board with returning EDEADLOCK.
> 
> Question: Would we be ok with returning EDEADLOCK for any IO where the buffer is
> in the same address space as the file being read/written to, even if the buffer
> and the IO don't technically overlap?

I'd say that depends on the lock granularity. For a range lock,
we'd be able to do the IO for non-overlapping ranges. For a normal
mutex or rwsem, then we risk deadlock if the page fault triggers on
the same address space host as we already have locked for IO. That's
the case we currently handle with the second IO lock in XFS, ext4,
btrfs, etc (XFS_MMAPLOCK_* in XFS).

One of the reasons I'm looking at range locks for XFS is to get rid
of the need for this second mmap lock, as there is no reason for it
existing if we can lock ranges and EDEADLOCK inside page faults and
return errors.

> This would simplify things a lot and eliminate a really nasty corner case - page
> faults trigger readahead. Even if the buffer and the direct IO don't overlap,
> readahead can pull in pages that do overlap with the dio.

Page cache readahead needs to be moved under the filesystem IO
locks. There was a recent thread about how readahead can race with
hole punching and other fallocate() operations because page cache
readahead bypasses the filesystem IO locks used to serialise page
cache invalidation.

e.g. Readahead can be directed by userspace via fadvise, so we now
have file->f_op->fadvise() so that filesystems can lock the inode
before calling generic_fadvise() such that page cache instantiation
and readahead dispatch can be serialised against page cache
invalidation. I have a patch for XFS sitting around somewhere that
implements the ->fadvise method.

I think there are some other patches floating around to address the
other readahead mechanisms to only be done under filesytem IO locks,
but I haven't had time to dig into it any further. Readahead from
page faults most definitely needs to be under the MMAPLOCK at
least so it serialises against fallocate()...

> And on getting EDEADLOCK we could fall back to buffered IO, so
> userspace would never know....

Yup, that's a choice that individual filesystems can make.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
