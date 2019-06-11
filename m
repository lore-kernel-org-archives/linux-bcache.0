From: Dave Chinner <david@fromorbit.com>
Subject: Re: bcachefs status update (it's done cooking; let's get this sucker
 merged)
Date: Tue, 11 Jun 2019 17:10:38 +1000
Message-ID: <20190611071038.GC14363@dread.disaster.area>
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
 <CAHk-=wi0iMHcO5nsYug06fV3-8s8fz7GDQWCuanefEGq6mHH1Q@mail.gmail.com>
 <20190611041045.GA14363@dread.disaster.area>
 <CAHk-=whDmeozRHUO0qM+2OeGw+=dkcjwGdsvms-x5Dz4y7Tzcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=whDmeozRHUO0qM+2OeGw+=dkcjwGdsvms-x5Dz4y7Tzcw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-bcache@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Zach Brown <zach.brown@ni.com>, Peter Zijlstra <peterz@infradead.org>, Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-bcache@vger.kernel.org

On Mon, Jun 10, 2019 at 06:39:00PM -1000, Linus Torvalds wrote:
> On Mon, Jun 10, 2019 at 6:11 PM Dave Chinner <david@fromorbit.com> wrote:
> >
> > Please, no, let's not make the rwsems even more fragile than they
> > already are. I'm tired of the ongoing XFS customer escalations that
> > end up being root caused to yet another rwsem memory barrier bug.
> >
> > > Have you talked to Waiman Long about that?
> >
> > Unfortunately, Waiman has been unable to find/debug multiple rwsem
> > exclusion violations we've seen in XFS bug reports over the past 2-3
> > years.
> 
> Inside xfs you can do whatever you want.
>
> But in generic code, no, we're not saying "we don't trust the generic
> locking, so we cook our own random locking".

We use the generic rwsems in XFS, too, and it's the generic
rwsems that have been the cause of the problems I'm talking about.

The same rwsem issues were seen on the mmap_sem, the shrinker rwsem,
in a couple of device drivers, and so on. i.e. This isn't an XFS
issue I'm raising here - I'm raising a concern about the lack of
validation of core infrastructure and it's suitability for
functionality extensions.

> If tghere really are exclusion issues, they should be fairly easy to
> try to find with a generic test-suite.  Have a bunch of readers that
> assert that some shared variable has a particular value, and a bund of
> writers that then modify the value and set it back. Add some random
> timing and "yield" to them all, and show that the serialization is
> wrong.

Writing such a test suite would be the responsibility of the rwsem
maintainers, yes?

> Some kind of "XFS load Y shows problems" is undebuggable, and not
> necessarily due to locking.

Sure, but this wasn't isolated to XFS, and it wasn't one workload.

We had a growing pile of kernel crash dumps all with the same
signatures across multiple subsystems. When this happens, it falls
to the maintainer of that common element to more deeply analyse the
issue. One of the rwsem maintainers was unable to reproduce or find
the root cause of the pile of rwsem state corruptions, and so we've
been left hanging telling people "we think it's rwsems because the
state is valid right up to the rwsem state going bad, but we can't
prove it's a rwsem problem because the debug we've added to the
rwsem code makes the problem go away". Sometime later, a bug has
been found in the upstream rwsem code....

This has played out several times over the past couple of years. No
locking bugs have been found in XFS, with the mmap_sem, the shrinker
rwsem, etc, but 4 or 5 bugs have been found in the rwsem code and
backports of those commits have been proven to solve _all_ the
issues that were reported.

That's the painful reality I'm telling you about here - that poor
upstream core infrastructure quality has had quite severe downstream
knock-on effects that cost a lot of time, resources, money and
stress to diagnose and rectify.  I don't want those same mistakes to
be made again for many reasons, not the least that the stress of
these situations has a direct and adverse impact on my mental
health....

> Because if the locking issues are real (and we did fix one bug
> recently in a9e9bcb45b15: "locking/rwsem: Prevent decrement of reader
> count before increment") it needs to be fixed.

That's just one of the bugs we've tripped over. There's been a
couple of missed wakeups bugs that caused rwsem state hangs (e.g.
readers waiting with no holder), there was a power arch specific
memory barrier bug that caused read/write exclusion bugs, the
optimistic spinning caused some severe performance degradations on
the mmap_sem with some highly threaded workloads, the rwsem bias
changed from read biased to write biased (might be the other way
around, can't remember) some time around 4.10 causing a complete
inversion in mixed read-write IO characteristics, there was a
botched RHEL7 backport that had memory barrier bugs in it that
upstream didn't have that occurred because of the complexity of the
code, etc.

But this is all off-topic for bcachefs review - all we need to do
here is keep the SIX locking in a separate module and everything
rwsem related will be just fine.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
