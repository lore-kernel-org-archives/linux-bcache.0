From: Dave Chinner <david@fromorbit.com>
Subject: Re: bcachefs status update (it's done cooking; let's get this sucker
 merged)
Date: Tue, 11 Jun 2019 14:33:36 +1000
Message-ID: <20190611043336.GB14363@dread.disaster.area>
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
 <CAHk-=wi0iMHcO5nsYug06fV3-8s8fz7GDQWCuanefEGq6mHH1Q@mail.gmail.com>
 <20190611011737.GA28701@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190611011737.GA28701@kmo-pixel>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <dchinner@redhat.com>, Waiman Long <longman@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-bcache@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, Zach Brown <zach.brown@ni.com>, Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-bcache@vger.kernel.org

On Mon, Jun 10, 2019 at 09:17:37PM -0400, Kent Overstreet wrote:
> On Mon, Jun 10, 2019 at 10:46:35AM -1000, Linus Torvalds wrote:
> > On Mon, Jun 10, 2019 at 9:14 AM Kent Overstreet
> > <kent.overstreet@gmail.com> wrote:
> > That lock is somewhat questionable in the first place, and no, we
> > don't do those hacky recursive things anyway. A recursive lock is
> > almost always a buggy and mis-designed one.
> 
> You're preaching to the choir there, I still feel dirty about that code and I'd
> love nothing more than for someone else to come along and point out how stupid
> I've been with a much better way of doing it. 
> 
> > Why does the regular page lock (at a finer granularity) not suffice?
> 
> Because the lock needs to prevent pages from being _added_ to the page cache -
> to do it with a page granularity lock it'd have to be part of the radix tree, 
> 
> > And no, nobody has ever cared. The dio people just don't care about
> > page cache anyway. They have their own thing going.
> 
> It's not just dio, it's even worse with the various fallocate operations. And
> the xfs people care, but IIRC even they don't have locking for pages being
> faulted in. This is an issue I've talked to other filesystem people quite a bit
> about - especially Dave Chinner, maybe we can get him to weigh in here.
> 
> And this inconsistency does result in _real_ bugs. It goes something like this:
>  - dio write shoots down the range of the page cache for the file it's writing
>    to, using invalidate_inode_pages_range2
>  - After the page cache shoot down, but before the write actually happens,
>    another process pulls those pages back in to the page cache
>  - Now the write happens: if that write was e.g. an allocating write, you're
>    going to have page cache state (buffer heads) that say that page doesn't have
>    anything on disk backing it, but it actually does because of the dio write.
> 
> xfs has additional locking (that the vfs does _not_ do) around both the buffered
> and dio IO paths to prevent this happening because of a buffered read pulling
> the pages back in, but no one has a solution for pages getting _faulted_ back in
> - either because of mmap or gup().
> 
> And there are some filesystem people who do know about this race, because at
> some point the dio code has been changed to shoot down the page cache _again_
> after the write completes. But that doesn't eliminate the race, it just makes it
> harder to trigger.
> 
> And dio writes actually aren't the worst of it, it's even worse with fallocate
> FALLOC_FL_INSERT_RANGE/COLLAPSE_RANGE. Last time I looked at the ext4 fallocate
> code, it looked _completely_ broken to me - the code seemed to think it was
> using the same mechanism truncate uses for shooting down the page cache and
> keeping pages from being readded - but that only works for truncate because it's
> changing i_size and shooting down pages above i_size. Fallocate needs to shoot
> down pages that are still within i_size, so... yeah...

Yes, that ext4 code is broken, and Jan Kara is trying to work out
how to fix it. His recent patchset fell foul of taking the same lock
either side of the mmap_sem in this path:

> The recursiveness is needed because otherwise, if you mmap a file, then do a dio
> write where you pass the address you mmapped to pwrite(), gup() from the dio
> write path will be trying to fault in the exact pages it's blocking from being
> added.
> 
> A better solution would be for gup() to detect that and return an error, so we
> can just fall back to buffered writes. Or just return an error to userspace
> because fuck anyone who would actually do that.

I just recently said this with reference to the range lock stuff I'm
working on in the background:

	FWIW, it's to avoid problems with stupid userspace stuff
	that nobody really should be doing that I want range locks
	for the XFS inode locks.  If userspace overlaps the ranges
	and deadlocks in that case, they they get to keep all the
	broken bits because, IMO, they are doing something
	monumentally stupid. I'd probably be making it return
	EDEADLOCK back out to userspace in the case rather than
	deadlocking but, fundamentally, I think it's broken
	behaviour that we should be rejecting with an error rather
	than adding complexity trying to handle it.

So I think this recusive locking across a page fault case should
just fail, not add yet more complexity to try to handle a rare
corner case that exists more in theory than in reality. i.e put the
lock context in the current task, then if the page fault requires a
conflicting lock context to be taken, we terminate the page fault,
back out of the IO and return EDEADLOCK out to userspace. This works
for all types of lock contexts - only the filesystem itself needs to
know what the lock context pointer contains....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
