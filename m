From: Dave Chinner <david@fromorbit.com>
Subject: Re: bcachefs status update (it's done cooking; let's get this sucker
 merged)
Date: Tue, 11 Jun 2019 14:10:45 +1000
Message-ID: <20190611041045.GA14363@dread.disaster.area>
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
 <CAHk-=wi0iMHcO5nsYug06fV3-8s8fz7GDQWCuanefEGq6mHH1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=wi0iMHcO5nsYug06fV3-8s8fz7GDQWCuanefEGq6mHH1Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-bcache@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Zach Brown <zach.brown@ni.com>, Peter Zijlstra <peterz@infradead.org>, Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-bcache@vger.kernel.org

On Mon, Jun 10, 2019 at 10:46:35AM -1000, Linus Torvalds wrote:
> I also get the feeling that the "intent" part of the six-locks could
> just be done as a slight extension of the rwsem, where an "intent" is
> the same as a write-lock, but without waiting for existing readers,
> and then the write-lock part is just the "wait for readers to be
> done".

Please, no, let's not make the rwsems even more fragile than they
already are. I'm tired of the ongoing XFS customer escalations that
end up being root caused to yet another rwsem memory barrier bug.

> Have you talked to Waiman Long about that?

Unfortunately, Waiman has been unable to find/debug multiple rwsem
exclusion violations we've seen in XFS bug reports over the past 2-3
years. Those memory barrier bugs have all been fixed by other people
long after Waiman has said "I can't reproduce any problems in my
testing" and essentially walked away from the problem. We've been
left multiple times wondering how the hell we even prove it's a
rwsem bug because there's no way to reproduce the inconsistent rwsem
state we see in the kernel crash dumps.

Hence, as a downstream rwsem user, I have relatively little
confidence in upstream's ability to integrate new functionality into
rwsems without introducing yet more subtle regressions that are only
exposed by heavy rwsem users like XFS. As such, I consider rwsems to
be extremely fragile and are now a prime suspect whenever see some
one-off memory corruption in a structure protected by a rwsem.

As such, please keep SIX locks separate to rwsems to minimise the
merge risk of bcachefs.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
