From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: bcachefs status update (it's done cooking; let's get this sucker merged)
Date: Mon, 10 Jun 2019 10:46:35 -1000
Message-ID: <CAHk-=wi0iMHcO5nsYug06fV3-8s8fz7GDQWCuanefEGq6mHH1Q@mail.gmail.com>
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190610191420.27007-1-kent.overstreet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-bcache@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Zach Brown <zach.brown@ni.com>, Peter Zijlstra <peterz@infradead.org>, Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-bcache@vger.kernel.org

On Mon, Jun 10, 2019 at 9:14 AM Kent Overstreet
<kent.overstreet@gmail.com> wrote:
>
> So. Here's my bcachefs-for-review branch - this has the minimal set of patches
> outside of fs/bcachefs/. My master branch has some performance optimizations for
> the core buffered IO paths, but those are fairly tricky and invasive so I want
> to hold off on those for now - this branch is intended to be more or less
> suitable for merging as is.

Honestly, it really isn't.

There are obvious things wrong with it - like the fact that you've
rebased it so that the original history is gone, yet you've not
actually *fixed* the history, so you find things like reverts of
commits that should simply have been removed, and fixes for things
that should just have been fixed in the original commit the fix is
for.

And this isn't just "if you rebase, just fix things". You have actual
bogus commit messages as a result of this all.

So to point at the revert, for example. The commit message is

    This reverts commit 36f389604294dfc953e6f5624ceb683818d32f28.

which is wrong to begin with - you should always explain *why* the
revert was done, not just state that it's a revert.

But since you rebased things, that commit 36f3896042 doesn't exist any
more to begin with.  So now you have a revert commit that doesn't
explain why it reverts things, but the only thing it *does* say is
simply wrong and pointless.

Some of the "fixes" commits have the exact same issue - they say things like

    gc lock must be held while invalidating buckets - fixes
    "1f7a95698e bcachefs: Invalidate buckets when writing to alloc btree"

and

    fixes b0f3e786995cb3b12975503f963e469db5a4f09b

both of which are dead and stale git object pointers since the commits
in question got rebased and have some other hash these days.

But note that the cleanup should go further than just fix those kinds
of technical issues. If you rebase, and you have fixes in your tree
for things you rebase, just fix things as you rewrite history anyway
(there are cases where the fix may be informative in itself and it's
worth leaving around, but that's rare).

Anyway, aside from that, I only looked at the non-bcachefs parts. Some
of those are not acceptable either, like

    struct pagecache_lock add_lock
        ____cacheline_aligned_in_smp; /* protects adding new pages */

in 'struct address_space', which is completely bogus, since that
forces not only a potentially huge amount of padding, it also requires
alignment that that struct simply fundamentally does not have, and
_will_ not have.

You can only use ____cacheline_aligned_in_smp for top-level objects,
and honestly, it's almost never a win. That lock shouldn't be so hot.

That lock is somewhat questionable in the first place, and no, we
don't do those hacky recursive things anyway. A recursive lock is
almost always a buggy and mis-designed one.

Why does the regular page lock (at a finer granularity) not suffice?

And no, nobody has ever cared. The dio people just don't care about
page cache anyway. They have their own thing going.

Similarly, no, we're not starting to do vmalloc in non-process context. Stop it.

And the commit comments are very sparse. And not always signed off.

I also get the feeling that the "intent" part of the six-locks could
just be done as a slight extension of the rwsem, where an "intent" is
the same as a write-lock, but without waiting for existing readers,
and then the write-lock part is just the "wait for readers to be
done".

Have you talked to Waiman Long about that?

                    Linus
