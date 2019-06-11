From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: bcachefs status update (it's done cooking; let's get this sucker merged)
Date: Mon, 10 Jun 2019 18:39:00 -1000
Message-ID: <CAHk-=whDmeozRHUO0qM+2OeGw+=dkcjwGdsvms-x5Dz4y7Tzcw@mail.gmail.com>
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
 <CAHk-=wi0iMHcO5nsYug06fV3-8s8fz7GDQWCuanefEGq6mHH1Q@mail.gmail.com> <20190611041045.GA14363@dread.disaster.area>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190611041045.GA14363@dread.disaster.area>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-bcache@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Zach Brown <zach.brown@ni.com>, Peter Zijlstra <peterz@infradead.org>, Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-bcache@vger.kernel.org

On Mon, Jun 10, 2019 at 6:11 PM Dave Chinner <david@fromorbit.com> wrote:
>
> Please, no, let's not make the rwsems even more fragile than they
> already are. I'm tired of the ongoing XFS customer escalations that
> end up being root caused to yet another rwsem memory barrier bug.
>
> > Have you talked to Waiman Long about that?
>
> Unfortunately, Waiman has been unable to find/debug multiple rwsem
> exclusion violations we've seen in XFS bug reports over the past 2-3
> years.

Inside xfs you can do whatever you want.

But in generic code, no, we're not saying "we don't trust the generic
locking, so we cook our own random locking".

If tghere really are exclusion issues, they should be fairly easy to
try to find with a generic test-suite. Have a bunch of readers that
assert that some shared variable has a particular value, and a bund of
writers that then modify the value and set it back. Add some random
timing and "yield" to them all, and show that the serialization is
wrong.

Some kind of "XFS load Y shows problems" is undebuggable, and not
necessarily due to locking.

Because if the locking issues are real (and we did fix one bug
recently in a9e9bcb45b15: "locking/rwsem: Prevent decrement of reader
count before increment") it needs to be fixed. Some kind of "let's do
something else entirely" is simply not acceptable.

                  Linus
